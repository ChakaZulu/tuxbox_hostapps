unit TePesMuxerThread;

interface

uses
  Windows,
  Classes, SysUtils, Contnrs,
  JclSynch,
  TeBase, TeThrd, TeSocket, TeFiFo, TePesFiFo, TePesParser, TeLogableThread;

type
  TTePesMuxerThread = class(TTeLogableThread)
  private
    pmtSplittSize: Word;
    pmtAudios: array of TTePesAudioFiFoBuffer;
    pmtVideo: TTePesVideoFiFoBuffer;
    pmtOutput: TTeFiFoBuffer;
  protected
    procedure InnerExecute; override;
    procedure DoAfterExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aAudios: array of TTePesAudioFiFoBuffer; aVideo: TTePesVideoFiFoBuffer; aOutput: TTeFiFoBuffer; aSplittSize: Word);
    destructor Destroy; override;
  end;

var
  _OutputStream               : TObjectList;
  _OutputStreamLock           : TJclCriticalSection;

  _NoMuxerPanic               : Boolean;

implementation

uses
  Math, Winsock2;

const
  PSHeaderSize                : Integer = 14;

  { TTePesMuxerThread }

constructor TTePesMuxerThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aAudios: array of TTePesAudioFiFoBuffer; aVideo: TTePesVideoFiFoBuffer; aOutput: TTeFiFoBuffer; aSplittSize: Word);
var
  i, j                        : Integer;
begin
  SetLength(pmtAudios, Length(aAudios));
  j := 0;
  for i := Low(aAudios) to High(aAudios) do
    if aAudios[i] <> nil then begin
      pmtAudios[j] := aAudios[i];
      Inc(j);
    end;
  SetLength(pmtAudios, j);

  pmtVideo := aVideo;
  pmtOutput := aOutput;
  pmtSplittSize := aSplittSize;
  inherited Create(aLog, aThreadPriority);
end;

function WritePackHeader(aBuffer: PLongByteArray; aSCR: Int64; aMuxRate: Integer): Integer;
begin
  Result := 14;

  aBuffer[0] := $00;
  aBuffer[1] := $00;
  aBuffer[2] := $01;
  aBuffer[3] := PS_HEADER;
  aBuffer[4] := $40 or ((aSCR and $1C0000000) shr 27) or $04 or ((aSCR and $030000000) shr 28);
  aBuffer[5] := ((aSCR and $00FF00000) shr 20);
  aBuffer[6] := ((aSCR and $0000F8000) shr 12) or $04 or ((aSCR and $000006000) shr 13);
  aBuffer[7] := ((aSCR and $000001FE0) shr 5);
  aBuffer[8] := ((aSCR and $00000001F) shl 3) or $04;
  aBuffer[9] := $01;
  aBuffer[10] := (aMuxRate and $3FC000) shr 14;
  aBuffer[11] := (aMuxRate and $003FC0) shr 6;
  aBuffer[12] := ((aMuxRate and $00003F) shl 2) or $03;
  aBuffer[13] := $00;
end;

function WritePesHeader(aBuffer: PLongByteArray; aStartCode: Byte; aPesLength: Word; aStuffingLength: Byte;
  aWriteTS: Boolean; aFrame: TTePesBufferPage): Integer;
begin
  aBuffer[0] := $00;
  aBuffer[1] := $00;
  aBuffer[2] := $01;
  aBuffer[3] := aStartCode;
  PWord(@aBuffer[4])^ := htons(aPesLength - 6);
  Result := 6;
  if not (aStartCode in [SS_PROG_STREAM_MAP, SS_PADDING_STREAM, SS_PRIVATE_STREAM1,
    SS_ECM_STREAM, SS_EMM_STREAM, SS_PROG_STREAM_DIR, SS_DSM_CC_STREAM,
      SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END, SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END]) then
    exit;

  aBuffer[6] := $80;
  if aStartCode in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END, SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END, SS_PRIVATE_STREAM1] then
    aBuffer[6] := aBuffer[6] or $04                         //data_alignment_indicator
  else
    aWriteTS := False;
  aWriteTS := aWriteTS and Assigned(aFrame) and (aFrame.PTS <> -1);

  if aWriteTS then
    if aFrame.DTS = -1 then
      aBuffer[7] := PTS_ONLY
    else
      aBuffer[7] := PTS_DTS
  else
    aBuffer[7] := 0;

  aBuffer[8] := aStuffingLength;
  if aWriteTS then begin
    Inc(aBuffer[8], SizeOf(aFrame.CodedPTS));
    if aFrame.DTS <> -1 then
      Inc(aBuffer[8], SizeOf(aFrame.CodedDTS));
  end;

  Result := 9;
  if aBuffer[8] = 0 then
    exit;

  if aBuffer[7] and PTS_ONLY = PTS_ONLY then begin
    Move(aFrame.CodedPTS, aBuffer[Result], SizeOf(aFrame.CodedPTS));
    Inc(Result, SizeOf(aFrame.CodedPTS));
    if aBuffer[7] and PTS_DTS = PTS_DTS then begin
      Move(aFrame.CodedDTS, aBuffer[Result], SizeOf(aFrame.CodedDTS));
      Inc(Result, SizeOf(aFrame.CodedDTS));
    end;
  end;

  if aStuffingLength > 0 then begin
    FillChar(aBuffer[Result], aStuffingLength, $FF);
    Inc(Result, aStuffingLength);
  end;

  if aWriteTS and (aStartCode = SS_PRIVATE_STREAM1) then begin
    aBuffer[Result] := $80;
    aBuffer[Result + 1] := $02;
    aBuffer[Result + 2] := $00;
    aBuffer[Result + 3] := $01;
    Inc(Result, 4);
  end;
end;

function WriteSytemHeader(aBuffer: PLongByteArray; aMuxRate: Integer; aVideoSID: Byte; aAudioSIDs: array of Byte): Integer;
const
  MaxVideoBuffer              : Cardinal = 512 * 1024 div 1024;
  MaxAudioBuffer              : Cardinal = 8 * 1024 div 128;
  MaxMuxRate                  : Cardinal = 10080000 div 200;
var
  i, j, k                     : Integer;
begin
  i := 0;
  for j := Low(aAudioSIDs) to High(aAudioSIDs) do
    if not (aAudioSIDs[j] in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END]) then
      aAudioSIDs[j] := 0
    else
      Inc(i);

  aBuffer[0] := $00;
  aBuffer[1] := $00;
  aBuffer[2] := $01;
  aBuffer[3] := PS_SYSTEMHEADER;

  k := i;
  i := i * 3 + 9;
  aBuffer[4] := ((i) shr 8) and $FF;                        // header length - 6
  aBuffer[5] := (i) and $FF;

  aBuffer[6] := $80 or (MaxMuxRate and $3F8000) shr 15;
  aBuffer[7] := (MaxMuxRate and $007F80) shr 7;
  aBuffer[8] := ((MaxMuxRate and $00007F) shl 1) or $01;
  aBuffer[9] := (k shl 2);
  aBuffer[10] := $E0 or 1;
  aBuffer[11] := $7F;                                       // bit 7 here is "rate restriction" flag... well... whatever that means..

  aBuffer[12] := aVideoSID;
  aBuffer[13] := SS_VIDEO_STREAM_START;
  aBuffer[14] := $E0;

  Result := 15;
  for j := Low(aAudioSIDs) to High(aAudioSIDs) do
    if aAudioSIDs[j] <> 0 then begin
      aBuffer[Result] := aAudioSIDs[j];
      aBuffer[Result + 1] := SS_AUDIO_STREAM_START;
      aBuffer[Result + 2] := $20;
      Inc(Result, 3);
    end;
end;

destructor TTePesMuxerThread.Destroy;
var
  i                           : Integer;
begin
  for i := Low(pmtAudios) to High(pmtAudios) do
    pmtAudios[i].Shutdown;
  pmtVideo.Shutdown;
  if assigned(pmtOutput) then
    pmtOutput.Shutdown;
  inherited;
end;

procedure TTePesMuxerThread.DoAfterExecute;
var
  i                           : Integer;
begin
  for i := Low(pmtAudios) to High(pmtAudios) do
    pmtAudios[i].Shutdown;
  pmtVideo.Shutdown;
  if assigned(pmtOutput) then
    pmtOutput.Shutdown;
  inherited;
end;

procedure TTePesMuxerThread.InnerExecute;
const
  PackSize                    = 2324;
  MaxSequenceSize             = 1 * 1024 * 1024;
  MaxPackCount                = MaxSequenceSize div PackSize;
  PTSTurnover                 = Int64(High(Longword));
type
  PPacks = ^TPacks;
  TPacks = packed array[0..Pred(MaxPackCount)] of packed array[0..Pred(PackSize)] of Byte;
var
  StartFound                  : Boolean;

  VideoStart                  : TTePesVideoBufferPage;
  NextVideoStart              : TTePesVideoBufferPage;
  TempVideoStart              : TTePesVideoBufferPage;
  VideoFrameCount             : Integer;
  VideoFrames                 : array[0..127] of TTePesVideoBufferPage;
  SeqPicPresent               : array of Integer;
  NextVideoDTS                : Int64;
  VideoDiscontinuityDetected  : Boolean;
  VideoDuration               : Int64;

  AudioStarts                 : array of TTePesAudioBufferPage;
  NextAudioStarts             : array of TTePesAudioBufferPage;
  TempAudioStarts             : array of TTePesAudioBufferPage;
  AudioFrameCounts            : array of Integer;
  AudioFramess                : array of array[0..127] of TTePesAudioBufferPage;
  NextAudioPTSs               : array of Int64;
  AudioDiscontinuityDetecteds : array of Boolean;
  AudioDurations              : array of Int64;

  Output                      : TTeBufferPage;

  Resync                      : Boolean;
  IgnoreSequence              : Boolean;
  Resyncs                     : Integer;

  Buffer                      : PLongByteArray;
  GoPClosed                   : Boolean;

  i, j                        : Integer;
  Found                       : Boolean;

  PictureDuration             : Integer;

  ExpectedPTS                 : Int64;
  ExpectedDTS                 : Int64;
  TempTS                      : Int64;

  Packs                       : PPacks;
  PackCount                   : Integer;
  PictureStartPack            : Integer;
  PicturePackCount            : Integer;
  FramePosition               : Integer;
  PackPosition                : Integer;
  PesPosition                 : Integer;
  PackRemaining               : Integer;
  FrameRemaining              : Integer;
  BytesToCopy                 : Integer;

  OutputVideoDTS              : Int64;
  OutputAudioPTSs             : array of Int64;
  OutputSCR                   : Int64;

  SCRDiv                      : Integer;
  SCRMod                      : Integer;
  MuxRate                     : Integer;

  OutputVideoDTSOffset        : Int64;
  OutputAudioPTSOffsets       : array of Int64;

  BytesWritten                : Int64;
  TotalSCR                    : Int64;

  AudioIDs                    : array of Byte;
const
  EndMarker                   : array[0..3] of Byte = ($00, $00, $01, $B9);
  UsedPackSize                = 2048;
begin
  SetLength(AudioStarts, Length(pmtAudios));
  SetLength(NextAudioStarts, Length(pmtAudios));
  SetLength(TempAudioStarts, Length(pmtAudios));
  SetLength(AudioFrameCounts, Length(pmtAudios));
  SetLength(AudioFramess, Length(pmtAudios));
  SetLength(NextAudioPTSs, Length(pmtAudios));
  SetLength(AudioDiscontinuityDetecteds, Length(pmtAudios));
  SetLength(AudioDurations, Length(pmtAudios));
  SetLength(OutputAudioPTSs, Length(pmtAudios));
  SetLength(OutputAudioPTSOffsets, Length(pmtAudios));
  SetLength(AudioIDs, Length(pmtAudios));

  BytesWritten := 0;
  TotalSCR := 0;
  New(Packs);
  OutputVideoDTS := -1;
  for j := Low(OutputAudioPTSs) to High(OutputAudioPTSs) do
    OutputAudioPTSs[j] := -1;
  OutputSCR := 0;
  NextVideoDTS := -1;
  for j := Low(NextAudioPTSs) to High(NextAudioPTSs) do
    NextAudioPTSs[j] := -1;
  SetState('waiting for first data');
  Resyncs := 0;
  Resync := true;
  IgnoreSequence := False;
  PackCount := MaxPackCount;
  try
    while not Terminated do begin

      // find a sequence start...
      StartFound := false;
      repeat
        VideoStart := pmtVideo.GetReadPage(true);
        if Length(VideoStart.SequenceStarts) > 0 then
          StartFound := true
        else begin
          VideoStart.Finished;                              // we can't use this packet...
          if not Resync then
            LogMessage('no sequence header found [video packet skipped]');
        end;
        if Terminated then
          Exit;
      until StartFound;

      if
        (Length(VideoStart.SequenceStarts) <> 1) or
        (Length(VideoStart.GroupStarts) > 1) or
        (Length(VideoStart.PictureStarts) <> 1) then begin
        LogMessage('invalid video packet: unexpected sequence header format [sequence skipped, need resync]');
        IgnoreSequence := true;
      end;

      if Resync and (Length(VideoStart.GroupStarts) = 1) then begin
        Buffer := PLongByteArray(PChar(VideoStart.Memory) + VideoStart.GroupStarts[0]);
        GoPClosed := Buffer[7] and $40 <> 0;
        if not GoPClosed then
          Buffer[7] := Buffer[7] or $20;
      end;

      // find the start of the next video sequence
      VideoFrameCount := 0;
      FillChar(VideoFrames, SizeOf(VideoFrames), 0);
      SeqPicPresent := nil;

      NextVideoStart := VideoStart;
      StartFound := false;
      while not StartFound do begin

        if Length(NextVideoStart.PictureStarts) > 1 then begin
          LogMessage('invalid video packet: more than on picture header found [sequence skipped, need resync]');
          IgnoreSequence := true;
        end else if Length(NextVideoStart.PictureStarts) < 1 then begin
          LogMessage('invalid video packet: no picture header found [sequence skipped, need resync]');
          IgnoreSequence := true;
        end;

        VideoFrames[VideoFrameCount] := NextVideoStart;
        Inc(VideoFrameCount, Length(NextVideoStart.PictureStarts));

        if VideoFrameCount > High(VideoFrames) then begin
          LogMessage('invalid video sequence: too many pictures in video sequence [sequence skipped, need resync]');
          IgnoreSequence := true;
          break;
        end;

        if Terminated then
          Exit;
        NextVideoStart := NextVideoStart.Next(true);
        if Length(NextVideoStart.SequenceStarts) > 0 then
          StartFound := true;
      end;

      if not IgnoreSequence then begin
        SetLength(SeqPicPresent, VideoFrameCount);
        for i := 0 to Pred(VideoFrameCount) do begin
          if VideoFrames[i].picture_header.temporal_reference > High(SeqPicPresent) then begin
            LogMessage('invalid video sequence: temporal_reference > picture count in sequence [sequence skipped, need resync]');
            IgnoreSequence := true;
            break;
          end;

          Inc(SeqPicPresent[VideoFrames[i].picture_header.temporal_reference]);
        end;
      end;

      Found := False;
      if not IgnoreSequence then
        for i := Low(SeqPicPresent) to High(SeqPicPresent) do begin
          if (SeqPicPresent[i] > 1) then begin
            LogMessage('invalid video sequence: more than 1 picture with same temporal_reference found [sequence skipped, need resync]');
            IgnoreSequence := true;
            break;
          end;
          if Found then begin
            if SeqPicPresent[i] > 0 then begin
              LogMessage('invalid video sequence: missing picture in sequence [sequence skipped, need resync]');
              IgnoreSequence := true;
              break;
            end
          end else
            if SeqPicPresent[i] = 0 then
              Found := True;
        end;

      PictureDuration := Round(90000 / frame_rate[VideoStart.sequence_header.frame_rate_code]);

      if not IgnoreSequence then
        if VideoStart.DTS = -1 then begin
          Found := False;
          for i := 0 to Pred(VideoFrameCount) do
            if VideoFrames[i].DTS <> -1 then begin
              Found := True;
              VideoStart.DTS := VideoFrames[i].DTS - (i * PictureDuration);
              break;
            end;
          if not Found then begin
            for i := 0 to Pred(VideoFrameCount) do
              if VideoFrames[i].PTS <> -1 then begin
                Found := True;
                VideoStart.DTS := VideoFrames[i].PTS - ((VideoFrames[i].picture_header.temporal_reference + 1) * PictureDuration);
                break;
              end;
          end;
          if not Found then begin
            if NextVideoDTS <> -1 then begin
              VideoStart.DTS := NextVideoDTS;
              if VideoStart.DTS <> VideoStart.PTS then
                LogMessage('warning: missing dts in video sequence header [corrected, sequence may be invalid]');
            end else begin
              LogMessage('invalid video sequence: couldn''t reconstruct the dts of the sequence header [sequence skipped, need resync]');
              IgnoreSequence := true;
            end;
          end else
            if VideoStart.DTS <> VideoStart.PTS then
              LogMessage('warning: missing dts in video sequence header [corrected, sequence may be invalid]');
        end;

      if VideoStart.DTS = VideoStart.PTS then
        VideoStart.DTS := -1;
      VideoStart.OffsetPTSDTS(0);

      if NextVideoDTS <> -1 then
        if VideoStart.RealDTS <> NextVideoDTS then
          if Abs(VideoStart.RealDTS - NextVideoDTS) < MaxPtsJitter then begin
            // jittercorrection...
            VideoStart.DTS := NextVideoDTS;
            if VideoStart.DTS = VideoStart.PTS then
              VideoStart.DTS := -1;
            VideoStart.OffsetPTSDTS(0);
          end;

      if not IgnoreSequence then begin
        for i := 0 to Pred(VideoFrameCount) do begin
          ExpectedPTS := (VideoStart.RealDTS + ((VideoFrames[i].picture_header.temporal_reference + 1) * PictureDuration)) mod PTSTurnover;
          ExpectedDTS := (VideoStart.RealDTS + (i * PictureDuration)) mod PTSTurnover;
          if ExpectedPTS = ExpectedDTS then
            ExpectedDTS := -1;

          if VideoFrames[i].PTS <> ExpectedPTS then begin
            if VideoFrames[i].PTS = -1 then
              //LogMessage('warning: missing pts in video frame [corrected, sequence may be invalid]')
            else
              if Abs(VideoFrames[i].PTS - ExpectedPTS) > MaxPtsJitter then //jitter
                LogMessage('warning: invalid pts in video frame [' + IntToStr(VideoFrames[i].PTS - ExpectedPTS) + ' pts cycles, corrected, sequence may be invalid]');
            VideoFrames[i].PTS := ExpectedPTS;
          end;

          if VideoFrames[i].DTS <> ExpectedDTS then begin
            if VideoFrames[i].DTS = -1 then
              //LogMessage('warning: missing dts in video frame [corrected, sequence may be invalid]')
            else
              if ExpectedDTS = -1 then
                LogMessage('warning: unexpected dts in video frame [corrected, sequence may be invalid]')
              else
                if Abs(VideoFrames[i].DTS - ExpectedDTS) > MaxPtsJitter then //jitter
                  LogMessage('warning: invalid dts in video frame [' + IntToStr(VideoFrames[i].DTS - ExpectedDTS) + ' pts cycles, corrected, sequence may be invalid]');
            VideoFrames[i].DTS := ExpectedDTS;
          end;
          VideoFrames[i].OffsetPTSDTS(0);
        end;
      end;

      if not IgnoreSequence then begin
        VideoDiscontinuityDetected := False;
        if NextVideoDTS <> -1 then
          if Abs(NextVideoDTS - VideoStart.RealDTS) > MaxPtsJitter then begin //jitter
            LogMessage('warning: video dts discontinuity detected [' + IntToStr(NextVideoDTS - VideoStart.RealDTS) + ' dts cycles]');
            VideoDiscontinuityDetected := true;
          end;
        NextVideoDTS := VideoFrames[Pred(VideoFrameCount)].RealDTS + PictureDuration;
      end;

      // At this point, if not IgnoreSequence we can be sure that:
      // - we have a complete sequence
      // - pictures in the sequence have a valid pts and dts

      for j := Low(AudioStarts) to High(AudioStarts) do begin
        AudioStarts[j] := nil;
        if not IgnoreSequence then begin
          // all audio packet that are older than our first video packet must be discarded
          StartFound := False;
          repeat
            AudioStarts[j] := pmtAudios[j].GetReadPage(true);
            if AudioStarts[j].RealDTS >= VideoStart.RealDTS then begin
              if (Abs(VideoStart.RealDTS - AudioStarts[j].RealDTS) > 90000 * 60) and
                (Abs((VideoStart.RealDTS + PTSTurnover) - AudioStarts[j].RealDTS) > 90000 * 60) then begin
                LogMessage('video audio (' + IntToStr(j + 1) + ') pts differece > 1min [' + IntToStr(AudioStarts[j].RealDTS - VideoStart.RealDTS) + ' pts cycles, sequence skipped, need resync]');
                IgnoreSequence := True;
                break;
              end
              else
                StartFound := true;
            end else begin
              if Abs(VideoStart.RealDTS - AudioStarts[j].RealDTS) > 90000 * 60 then
                if not Resync then
                  LogMessage('audio (' + IntToStr(j + 1) + ') video pts differece > 1min [' + IntToStr(AudioStarts[j].RealDTS - VideoStart.RealDTS) + ' pts cycles, audio frame skipped]');
              AudioStarts[j].Finished;                      // we can't use this packet...
              if not Resync then
                LogMessage('audio (' + IntToStr(j + 1) + ') pts < video pts [audio packet skipped]');
            end;
            if Terminated then
              Exit;
          until StartFound;
        end;

        // find the first audio packet that belongs to the next sequence
        NextAudioStarts[j] := AudioStarts[j];
        AudioFrameCounts[j] := 0;
        FillChar(AudioFramess[j], SizeOf(AudioFramess[j]), 0);
        if not IgnoreSequence then begin
          StartFound := False;
          while not StartFound do begin
            AudioFramess[j, AudioFrameCounts[j]] := NextAudioStarts[j];
            Inc(AudioFrameCounts[j]);

            if AudioFrameCounts[j] > High(AudioFramess[j]) then begin
              LogMessage('too many audio (' + IntToStr(j + 1) + ') frames in sequence [sequence skipped, need resync]');
              IgnoreSequence := true;
              break;
            end;

            if Terminated then
              Exit;

            NextAudioStarts[j] := NextAudioStarts[j].Next(true);
            TempTS := NextAudioStarts[j].RealDTS;
            StartFound := TempTS >= NextVideoDTS;
            if StartFound and (Abs(TempTS - NextVideoDTS) > 90000 * 60) then begin
              Dec(TempTS, PTSTurnover);
              if (TempTS < 0) and (TempTS > (-PictureDuration * 25)) then
                StartFound := False;
            end;
          end;
        end;

        if not IgnoreSequence then
          for i := 1 to Pred(AudioFrameCounts[j]) do begin
            TempTS := AudioFramess[j, i - 1].PTS + AudioFramess[j, i - 1].PTSLength;
            if TempTS > PTSTurnover then
              Dec(TempTS, PTSTurnover);
            if AudioFramess[j, i].PTS <> TempTS then begin
              if Abs(AudioFramess[j, i].PTS - (TempTS)) > MaxPtsJitter then begin //jitter
                LogMessage('invalid audio sequence: missing audio (' + IntToStr(j + 1) + ') frames in sequence [sequence skipped, need resync]');
                IgnoreSequence := true;
                break;
              end else
                AudioFramess[j, i].PTS := TempTS;
            end;
            AudioFramess[j, i].DTS := -1;
            AudioFramess[j, i].OffsetPTSDTS(0);
          end;

        if not IgnoreSequence then begin
          AudioDiscontinuityDetecteds[j] := False;
          if NextAudioPTSs[j] <> -1 then
            if Abs(NextAudioPTSs[j] - AudioStarts[j].PTS) > MaxPtsJitter then begin //jitter
              LogMessage('warning: audio (' + IntToStr(j + 1) + ') pts discontinuity detected [' + IntToStr(NextAudioPTSs[j] - AudioStarts[j].PTS) + ' pts cycles]');
              AudioDiscontinuityDetecteds[j] := true;
            end;
          with AudioFramess[j, Pred(AudioFrameCounts[j])] do
            NextAudioPTSs[j] := PTS + PTSLength;
        end;

        if not IgnoreSequence then begin
          VideoDuration := NextVideoDTS - VideoStart.DTS;
          if (VideoDuration < 0) then
            Inc(VideoDuration, PTSTurnover);
          AudioDurations[j] := NextAudioPTSs[j] - AudioStarts[j].PTS;
          if (AudioDurations[j] < 0) then
            Inc(AudioDurations[j], PTSTurnover);
          if Abs(AudioDurations[j] - VideoDuration) > AudioStarts[j].PTSLength then begin
            if not Resync then
              LogMessage('invalid sequence: diffrence between video and audio (' + IntToStr(j + 1) + ') duration too large [' + IntToStr(AudioDurations[j] - VideoDuration) + ' pts cycles, sequence skipped, need resync]');
            IgnoreSequence := true;
          end;
        end;
      end;

      if IgnoreSequence then begin
        //the sequence is invalid...

        //...discard...
        while VideoStart <> NextVideoStart do begin
          TempVideoStart := VideoStart;
          VideoStart := VideoStart.Next(true);
          TempVideoStart.Finished;
        end;

        for j := Low(AudioStarts) to High(AudioStarts) do
          while AudioStarts[j] <> NextAudioStarts[j] do begin
            TempAudioStarts[j] := AudioStarts[j];
            AudioStarts[j] := AudioStarts[j].Next(true);
            TempAudioStarts[j].Finished;
          end;

        //...and try the next sequence
        IgnoreSequence := False;
        Resync := true;
        SetState('need resync');
        Continue;
      end;

      FillChar(Packs[0, 0], PackCount * PackSize, $FF);
      PackCount := 0;

      if OutputSCR = 0 then begin
        OutputVideoDTS := Round(PictureDuration * 1.5);
        for j := Low(OutputAudioPTSs) to High(OutputAudioPTSs) do
          OutputAudioPTSs[j] := OutputVideoDTS { + (AudioStarts[j].RealDTS - VideoStart.RealDTS)};
      end;

      OutputVideoDTSOffset := OutputVideoDTS - VideoStart.RealDTS;
      for j := Low(OutputAudioPTSOffsets) to High(OutputAudioPTSOffsets) do
        OutputAudioPTSOffsets[j] := OutputAudioPTSs[j] - AudioStarts[j].RealDTS;

      for i := 0 to Pred(VideoFrameCount) do
        VideoFrames[i].OffsetPTSDTS(OutputVideoDTSOffset);

      for j := Low(AudioFramess) to High(AudioFramess) do
        for i := 0 to Pred(AudioFrameCounts[j]) do
          AudioFramess[j, i].OffsetPTSDTS(OutputAudioPTSOffsets[j]);

      i := SS_AUDIO_STREAM_START;
      Found := False;

      for j := Low(AudioStarts) to High(AudioStarts) do
        if AudioStarts[j].StartCode in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END] then begin
          AudioIDs[j] := i;
          Inc(i);
        end
        else begin
          if Found then begin
            LogMessage('muxer panic: only a single ac3 audio stream allowed! [muxer terminated]');
            if not _NoMuxerPanic then
              Abort;
          end;
          Found := True;
          AudioIDs[j] := SS_PRIVATE_STREAM1;
        end;

      while VideoStart <> NextVideoStart do begin
        if VideoStart.RealDTS <> OutputVideoDTS then begin
          LogMessage('muxer panic: video frame invalid. something must be wrong with the validation code. please inform Elmi on #dbox2. created stream will be invalid.')
        end else
          Inc(OutputVideoDTS, PictureDuration);

        PictureStartPack := PackCount;
        PackPosition := 0;
        PackRemaining := PackSize;
        if PackCount = 0 then begin
          Inc(PackPosition, WritePackHeader(@Packs[PackCount, PackPosition], 0, 0)); // will be filled later..
          Inc(PackPosition, WriteSytemHeader(@Packs[PackCount, PackPosition], 0, SS_VIDEO_STREAM_START, AudioIDs));
          PackRemaining := PackSize - PackPosition;
        end;

        FramePosition := 0;
        FrameRemaining := VideoStart.Size - FramePosition;
        while FrameRemaining > 0 do begin
          if PackPosition = 0 then begin
            Inc(PackPosition, WritePackHeader(@Packs[PackCount, PackPosition], 0, 0)); // will be filled later..
            PackRemaining := PackSize - PackPosition;
          end;
          if PackRemaining > 128 then begin
            PesPosition := PackPosition;
            Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_VIDEO_STREAM_START, PackSize - PesPosition, 0, FramePosition = 0, VideoStart));
            PackRemaining := PackSize - PackPosition;
            if PackRemaining > FrameRemaining then begin
              if PackRemaining - FrameRemaining > 32 then begin
                PackPosition := PesPosition;
                Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_VIDEO_STREAM_START, (PackSize - PesPosition) - (PackRemaining - FrameRemaining), 0, FramePosition = 0, VideoStart));
                Move((PChar(VideoStart.Memory) + FramePosition)^, Packs[PackCount, PackPosition], FrameRemaining);
              end else begin
                PackPosition := PesPosition;
                Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_VIDEO_STREAM_START, PackSize - PesPosition, PackRemaining - FrameRemaining, FramePosition = 0, VideoStart));
                PackRemaining := PackSize - PackPosition;
                if PackRemaining <> FrameRemaining then begin
                  LogMessage('muxer panic: internal error V01. please inform Elmi on #dbox2. [muxer terminated]');
                  if not _NoMuxerPanic then
                    Abort;
                end;
                Move((PChar(VideoStart.Memory) + FramePosition)^, Packs[PackCount, PackPosition], PackRemaining);
              end;
              Inc(FramePosition, FrameRemaining);
              Inc(PackPosition, FrameRemaining);
              FrameRemaining := VideoStart.Size - FramePosition;
              PackRemaining := PackSize - PackPosition;
            end else begin
              BytesToCopy := PackRemaining;
              for i := (FramePosition + PackRemaining) - 4 downto (FramePosition + PackRemaining) - 32 do begin
                Buffer := PLongByteArray(PChar(VideoStart.Memory) + i);
                if (Buffer[0] = 0) and (Buffer[1] = 0) and (Buffer[2] = 1) and (Buffer[3] in [$01..$AF]) then begin
                  BytesToCopy := i - FramePosition;
                  break;
                end;
              end;
              if BytesToCopy = 0 then
                BytesToCopy := PackRemaining;

              if (PackRemaining - BytesToCopy > 32) or (PackRemaining - BytesToCopy = 0) then begin
                PackPosition := PesPosition;
                Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_VIDEO_STREAM_START, (PackSize - PesPosition) - (PackRemaining - BytesToCopy), 0, FramePosition = 0, VideoStart));
                Move((PChar(VideoStart.Memory) + FramePosition)^, Packs[PackCount, PackPosition], BytesToCopy);
              end else begin
                PackPosition := PesPosition;
                Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_VIDEO_STREAM_START, PackSize - PesPosition, PackRemaining - BytesToCopy, FramePosition = 0, VideoStart));
                PackRemaining := PackSize - PackPosition;
                if PackRemaining <> BytesToCopy then begin
                  LogMessage('muxer panic: internal error V02. please inform Elmi on #dbox2. [muxer terminated]');
                  if not _NoMuxerPanic then
                    Abort;
                end;
                Move((PChar(VideoStart.Memory) + FramePosition)^, Packs[PackCount, PackPosition], PackRemaining);
              end;
              Inc(FramePosition, BytesToCopy);
              Inc(PackPosition, BytesToCopy);
              FrameRemaining := VideoStart.Size - FramePosition;
              PackRemaining := PackSize - PackPosition;
            end;
          end;

          if FrameRemaining > 0 then begin
            if (PackRemaining > 0) then begin
              if PackRemaining < 7 then begin
                LogMessage('muxer panic: internal error VPD01. please inform Elmi on #dbox2. [muxer terminated]');
                if not _NoMuxerPanic then
                  Abort;
              end;

              Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_PADDING_STREAM, PackRemaining, 0, False, nil));
              PackRemaining := PackSize - PackPosition;
              if PackRemaining < 1 then begin
                LogMessage('muxer panic: internal error VPD02. please inform Elmi on #dbox2. [muxer terminated]');
                if not _NoMuxerPanic then
                  Abort;
              end;
              FillChar(Packs[PackCount, PackPosition], PackRemaining, $FF);
            end;
            Inc(PackCount);
            PackPosition := 0;
            if PackCount >= MaxPackCount then begin
              LogMessage('muxer panic: internal error PC01. please inform Elmi on #dbox2. [muxer terminated]');
              if not _NoMuxerPanic then
                Abort;
            end;
          end;
        end;

        TempTS := VideoStart.RealDTS + PictureDuration;
        TempVideoStart := VideoStart;
        VideoStart := VideoStart.Next(true);
        TempVideoStart.Finished;

        for j := Low(AudioStarts) to High(AudioStarts) do
          while (AudioStarts[j] <> NextAudioStarts[j]) and (AudioStarts[j].RealDTS < TempTS) do begin
            if AudioStarts[j].RealDTS <> OutputAudioPTSs[j] then begin
              LogMessage('muxer panic: audio (' + IntToStr(j) + ') frame invalid. something must be wrong with the validation code. please inform Elmi on #dbox2. created stream will be invalid. [muxer terminated]');
              if not _NoMuxerPanic then
                Abort;
            end else
              Inc(OutputAudioPTSs[j], AudioStarts[j].PTSLength);

            FramePosition := 0;
            FrameRemaining := AudioStarts[j].Size - FramePosition;
            while FrameRemaining > 0 do begin
              if PackPosition = 0 then begin
                Inc(PackPosition, WritePackHeader(@Packs[PackCount, PackPosition], 0, 0)); // will be filled later..
                PackRemaining := PackSize - PackPosition;
              end;
              if PackRemaining > 128 then begin
                PesPosition := PackPosition;
                Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], AudioIDs[j], PackSize - PesPosition, 0, FramePosition = 0, AudioStarts[j]));
                PackRemaining := PackSize - PackPosition;
                if PackRemaining > FrameRemaining then begin
                  if PackRemaining - FrameRemaining > 32 then begin
                    PackPosition := PesPosition;
                    Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], AudioIDs[j], (PackSize - PesPosition) - (PackRemaining - FrameRemaining), 0, FramePosition = 0, AudioStarts[j]));
                    Move((PChar(AudioStarts[j].Memory) + FramePosition)^, Packs[PackCount, PackPosition], FrameRemaining);
                  end else begin
                    PackPosition := PesPosition;
                    Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], AudioIDs[j], PackSize - PesPosition, PackRemaining - FrameRemaining, FramePosition = 0, AudioStarts[j]));
                    PackRemaining := PackSize - PackPosition;
                    if PackRemaining <> FrameRemaining then begin
                      LogMessage('muxer panic: internal error A01 (' + IntToStr(j) + '). please inform Elmi on #dbox2. [muxer terminated]');
                      if not _NoMuxerPanic then
                        Abort;
                    end;
                    Move((PChar(AudioStarts[j].Memory) + FramePosition)^, Packs[PackCount, PackPosition], PackRemaining);
                  end;
                  Inc(FramePosition, FrameRemaining);
                  Inc(PackPosition, FrameRemaining);
                  FrameRemaining := AudioStarts[j].Size - FramePosition;
                  PackRemaining := PackSize - PackPosition;
                end else if PesPosition < 50 then begin
                  Move((PChar(AudioStarts[j].Memory) + FramePosition)^, Packs[PackCount, PackPosition], PackRemaining);
                  Inc(FramePosition, PackRemaining);
                  Inc(PackPosition, PackRemaining);
                  PackRemaining := PackSize - PackPosition;
                  FrameRemaining := AudioStarts[j].Size - FramePosition;
                end else begin
                  PackPosition := PesPosition;
                  PackRemaining := PackSize - PackPosition;
                end;
              end;

              if (FrameRemaining <> 0) or (PackRemaining < 128) then begin
                if (PackRemaining > 0) then begin
                  if PackRemaining < 7 then begin
                    LogMessage('muxer panic: internal error APD01. please inform Elmi on #dbox2. [muxer terminated]');
                    if not _NoMuxerPanic then
                      Abort;
                  end;

                  Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_PADDING_STREAM, PackRemaining, 0, False, nil));
                  PackRemaining := PackSize - PackPosition;
                  if PackRemaining < 1 then begin
                    LogMessage('muxer panic: internal error APD02. please inform Elmi on #dbox2. [muxer terminated]');
                    if not _NoMuxerPanic then
                      Abort;
                  end;
                  FillChar(Packs[PackCount, PackPosition], PackRemaining, $FF);
                end;
                Inc(PackCount);
                PackPosition := 0;
                if PackCount >= MaxPackCount then begin
                  LogMessage('muxer panic: internal error PC02. please inform Elmi on #dbox2. [muxer terminated]');
                  if not _NoMuxerPanic then
                    Abort;
                end;
              end;
            end;

            TempAudioStarts[j] := AudioStarts[j];
            AudioStarts[j] := AudioStarts[j].Next(true);
            TempAudioStarts[j].Finished;
          end;

        if PackPosition <> 0 then begin
          PackRemaining := PackSize - PackPosition;
          if (PackRemaining > 0) then begin
            if PackRemaining < 7 then begin
              LogMessage('muxer panic: internal error PPD01. please inform Elmi on #dbox2. [muxer terminated]');
              if not _NoMuxerPanic then
                Abort;
            end;

            Inc(PackPosition, WritePesHeader(@Packs[PackCount, PackPosition], SS_PADDING_STREAM, PackRemaining, 0, False, nil));
            PackRemaining := PackSize - PackPosition;
            if PackRemaining < 1 then begin
              LogMessage('muxer panic: internal error PPD02. please inform Elmi on #dbox2. [muxer terminated]');
              if not _NoMuxerPanic then
                Abort;
            end;
            FillChar(Packs[PackCount, PackPosition], PackRemaining, $FF);
          end;
          Inc(PackCount);
          if PackCount >= MaxPackCount then begin
            LogMessage('muxer panic: internal error PC03. please inform Elmi on #dbox2. [muxer terminated]');
            if not _NoMuxerPanic then
              Abort;
          end;
        end;

        PicturePackCount := PackCount - PictureStartPack;

        SCRDiv := PictureDuration div PicturePackCount;
        SCRMod := PictureDuration mod PicturePackCount;
        MuxRate := Round(((PicturePackCount * PackSize / PictureDuration) / 50) * 90000);

        for i := PictureStartPack to Pred(PackCount) do begin
          WritePackHeader(@Packs[i, 0], OutputSCR, MuxRate);
          Inc(OutputSCR, SCRDiv);
          if SCRMod > 0 then begin
            Inc(OutputSCR);
            Dec(SCRMod);
          end;
        end;
      end;

      for j := Low(OutputAudioPTSs) to High(OutputAudioPTSs) do
        if Abs(OutputAudioPTSs[j] - OutputVideoDTS) > Max(AudioStarts[j].PTSLength, PictureDuration) then begin
          LogMessage('muxer panic: audio (' + IntToStr(j) + ') video pts diffrence [' + IntToStr(OutputAudioPTSs[j] - OutputVideoDTS) + '] to big. something must be wrong with the validation code. please inform Elmi on #dbox2. created stream will be invalid. [muxer terminated]');
          if not _NoMuxerPanic then
            Abort;
        end;

      //...discard remainig bufferpages in case of a error...
      while VideoStart <> NextVideoStart do begin
        TempVideoStart := VideoStart;
        VideoStart := VideoStart.Next(true);
        TempVideoStart.Finished;
        LogMessage('muxer panic: video frame skipped AFTER writting sequence. something must be wrong with the validation code. please inform Elmi on #dbox2. created stream will be invalid. [muxer terminated]');
        if not _NoMuxerPanic then
          Abort;
      end;

      for j := Low(AudioStarts) to High(AudioStarts) do
        while AudioStarts[j] <> NextAudioStarts[j] do begin
          TempAudioStarts[j] := AudioStarts[j];
          AudioStarts[j] := AudioStarts[j].Next(true);
          TempAudioStarts[j].Finished;
          LogMessage('muxer panic: audio (' + IntToStr(j) + ') frame skipped AFTER writting sequence. something must be wrong with the validation code. please inform Elmi on #dbox2. created stream will be invalid. [muxer terminated]');
          if not _NoMuxerPanic then
            Abort;
        end;

      if assigned(pmtOutput) then begin
        Output := pmtOutput.GetWritePage(PackCount * PackSize);
        try
          Output.Position := 0;
          Output.WriteBuffer(Packs[0, 0], PackCount * PackSize);
        finally
          Output.Finished;
        end;
      end;

      if Assigned(_OutputStream) then begin
        _OutputStreamLock.Enter;
        try
          if Assigned(_OutputStream) then
            for i := 0 to Pred(_OutputStream.Count) do begin
              Output := TTeFiFoBuffer(_OutputStream[i]).GetWritePage(PackCount * PackSize, True);
              if Assigned(Output) then try
                Output.Position := 0;
                Output.WriteBuffer(Packs[0, 0], PackCount * PackSize);
              finally
                Output.Finished;
              end else
                LogMessage('http output streaming: buffer overflow, sequence skipped')
            end;
        finally
          _OutputStreamLock.Leave;
        end;
      end;

      Inc(BytesWritten, PackCount * PackSize);
      if assigned(pmtOutput) then
        if pmtSplittSize > 0 then
          if (BytesWritten div (1024 * 1024)) > pmtSplittSize then begin
            BytesWritten := 0;

            Inc(TotalSCR, OutputSCR);

            Resync := true;

            OutputVideoDTS := -1;
            for j := Low(OutputAudioPTSs) to High(OutputAudioPTSs) do
              OutputAudioPTSs[j] := -1;
            OutputSCR := 0;

            Output := pmtOutput.GetWritePage(SizeOf(EndMarker));
            try
              Output.WriteBuffer(EndMarker, SizeOf(EndMarker));
              Output.Marker := bmNextFile;
            finally
              Output.Finished;
            end;

            SetState('output splitted, need resync');
            LogMessage('splitt size reached... starting new file');
            Continue;
          end;

      if Resync then begin
        LogMessage('Resync successful');
        Inc(Resyncs);
      end;
      Resync := false;
      SetState('SCR: ' + FormatDateTime('hh:mm:ss.zzz', (TotalSCR + OutputSCR) / 90000 / 24 / 60 / 60) + ' Syncs: ' + IntToStr(Resyncs));
    end;
  except
    on E: EAbort do
      ;
  end;
  Dispose(Packs);
  if assigned(pmtOutput) then begin
    Output := pmtOutput.GetWritePage(SizeOf(EndMarker));
    try
      Output.WriteBuffer(EndMarker, SizeOf(EndMarker));
    finally
      Output.Finished;
    end;
  end;
end;

initialization
  _OutputStreamLock := TJclCriticalSection.Create;
finalization
  _OutputStreamLock.Enter;
  try
    FreeAndNil(_OutputStream);
  finally
    _OutputStreamLock.Leave;
  end;
  FreeAndNil(_OutputStreamLock);
end.

