unit TeAudioFrameProcessorThread;

interface

uses
  Windows,
  Classes, SysUtils, MPGTools,
  TeBase, TeThrd, TeSocket, TeFiFo, TePesFiFo, TePesParser, TeLogableThread;

const
  MpegSamplesPerFrame         : array[1..3] of Integer = (384, 1152, 1152);

  Ac3SamplesPerFrame          = 1536;
  Ac3SampleRate               : array[0..2] of Word = (48000, 44100, 32000);
  Ac3BitRate                  : array[0..37] of Word = (32, 32, 40, 40, 48, 48,
    56, 56, 64, 64, 80, 80, 96, 96, 112, 112, 128, 128, 160, 160, 192, 192, 224,
    224, 256, 256, 320, 320, 384, 384, 448, 448, 512, 512, 576, 576, 640, 640);
  Ac3FrameLength              : array[0..37, 0..2] of Word =
    ((96, 69, 64),
    (96, 70, 64),
    (120, 87, 80),
    (120, 88, 80),
    (144, 104, 96),
    (144, 105, 96),
    (168, 121, 112),
    (168, 122, 112),
    (192, 139, 128),
    (192, 140, 128),
    (240, 174, 160),
    (240, 175, 160),
    (288, 208, 192),
    (288, 209, 192),
    (336, 243, 224),
    (336, 244, 224),
    (384, 278, 256),
    (384, 279, 256),
    (480, 348, 320),
    (480, 349, 320),
    (576, 417, 384),
    (576, 418, 384),
    (672, 487, 448),
    (672, 488, 448),
    (768, 557, 512),
    (768, 558, 512),
    (960, 696, 640),
    (960, 697, 640),
    (1152, 835, 768),
    (1152, 836, 768),
    (1344, 975, 896),
    (1344, 976, 896),
    (1536, 1114, 1024),
    (1536, 1115, 1024),
    (1728, 1253, 1152),
    (1728, 1254, 1152),
    (1920, 1393, 1280),
    (1920, 1394, 1280));

type
  TAc3Header = record
    fscod: Byte;
    frmsizecod: Byte;

    FrameLength: Word;
    BitRate: Word;
    SampleRate: Word;
  end;

  TTeAudioFrameProcessorThread = class(TTeLogableThread)
  private
    afpInput: TTePesAudioFiFoBuffer;
    afpOutput: TTePesAudioFiFoBuffer;
  protected
    Pes: TTePesAudioBufferPage;
    NewPes: Boolean;
    Buffer: array[0..8 * 1024 - 1] of Byte;
    Current: Integer;
    PTSLength: Integer;
    LastPTSLength: Integer;
    PTS: Int64;
    FrameCount: Integer;
    StartCode: Byte;

    {mpeg only}
    MpegHeaderCount: Integer;
    MpegHeader: packed array[0..3] of Byte;
    MpegHeaderData: TMPEGData1v2;
    MpegNextHeaderData: TMPEGData1v2;

    {ac3 only}
    Ac3HeaderCount: Integer;
    Ac3Header: packed array[0..4] of Byte;
    Ac3HeaderData: TAc3Header;
    Ac3NextHeaderData: TAc3Header;

    procedure ProcessMpegAudio;
    procedure ProcessAc3Audio;

    procedure InnerExecute; override;
    procedure DoAfterExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTePesAudioFiFoBuffer; aOutput: TTePesAudioFiFoBuffer);
    destructor Destroy; override;
  end;

implementation

uses
  Math, Winsock2;

const
  PSHeaderSize                : Integer = 14;

  { TTeAudioFrameProcessorThread }

constructor TTeAudioFrameProcessorThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTePesAudioFiFoBuffer; aOutput: TTePesAudioFiFoBuffer);
begin
  afpInput := aInput;
  afpOutput := aOutput;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeAudioFrameProcessorThread.Destroy;
begin
  afpInput.Shutdown;
  afpOutput.Shutdown;
  inherited;
end;

procedure TTeAudioFrameProcessorThread.DoAfterExecute;
begin
  afpInput.Shutdown;
  afpOutput.Shutdown;
  inherited;
end;

procedure TTeAudioFrameProcessorThread.InnerExecute;
begin
  SetState('waiting for first data');
  PTS := -1;
  LastPTSLength := -1;
  MpegHeaderCount := 4;
  MpegHeaderData.FileLength := 6;
  MpegHeaderData.FileDateTime := 1;
  MpegNextHeaderData.FileLength := 6;
  MpegNextHeaderData.FileDateTime := 1;
  Ac3HeaderCount := 5;
  while not Terminated do begin
    Pes := afpInput.GetReadPage(True);
    if StartCode = 0 then begin
      if Pes.StartCode in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END, SS_PRIVATE_STREAM1] then begin
        StartCode := Pes.StartCode;
        LogMessage('locked on stream id ' + IntToStr(StartCode));
      end else begin
        LogMessage('pes packet skipped! ' + IntToStr(Pes.StartCode) + ' is not a valid audio stream id!');
        Pes.Finished;
        Continue;
      end;
    end else if StartCode <> Pes.StartCode then begin
      LogMessage('pes packet skipped! expected id: ' + IntToStr(StartCode) + ' found id: ' + IntToStr(Pes.StartCode));
      Pes.Finished;
      Continue;
    end;

    if (PTS = -1) and (Pes.PTS = -1) then begin
      LogMessage('pes packet skipped! no pts in packet. must wait for the first packet with pts');
      Pes.Finished;
      Continue;
    end;

    NewPes := True;

    if StartCode in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END] then
      ProcessMpegAudio
    else
      ProcessAc3Audio;

    Pes.Finished;
  end;
end;

procedure TTeAudioFrameProcessorThread.ProcessAc3Audio;

  function DecodeHeader(var Ac3HeaderData: TAc3Header): Boolean;
  begin
    Result := (Ac3Header[0] = $0B) and (Ac3Header[1] = $77);
    if not Result then exit;
    Ac3HeaderData.fscod := (Ac3Header[4] and $C0) shr 6;
    Ac3HeaderData.frmsizecod := (Ac3Header[4] and $3F);
    result := (Ac3HeaderData.fscod in [0, 1, 2]) and (Ac3HeaderData.frmsizecod in [0..37]);
    if not Result then exit;
    Ac3HeaderData.SampleRate := Ac3SampleRate[Ac3HeaderData.fscod];
    Ac3HeaderData.BitRate := Ac3BitRate[Ac3HeaderData.frmsizecod];
    Ac3HeaderData.FrameLength := Ac3FrameLength[Ac3HeaderData.frmsizecod, 2 - Ac3HeaderData.fscod] * 2;
  end;

var
  i                           : Integer;
  FrameOut                    : TTePesAudioBufferPage;
begin
  for i := Pes.PayloadStart to Pred(Pes.Size) do begin
    if Ac3HeaderCount = 0 then begin
      Buffer[Current] := Ac3Header[0];
      Inc(Current);
    end else
      Dec(Ac3HeaderCount);
    Move(Ac3Header[1], Ac3Header[0], 4);
    Ac3Header[4] := PLongByteArray(Pes.Memory)^[i];

    if DecodeHeader(Ac3NextHeaderData) then begin
      if Current >= Ac3HeaderData.FrameLength then begin
        if (Current > 0) then begin
          PTSLength := Round(Ac3SamplesPerFrame / Ac3HeaderData.SampleRate * 90000);
          if (LastPTSLength <> -1) and (PTSLength <> LastPTSLength) then
            LogMessage('warning: pts length of audio frame changed from ' + IntToStr(LastPTSLength) + ' to ' + IntToStr(PTSLength) + ' pts cycles');
          LastPTSLength := PTSLength;

          Inc(FrameCount);

          FrameOut := afpOutput.GetWritePage(Current);
          try
            FrameOut.StartCode := StartCode;
            if PTS <> -1 then
              FrameOut.PTS := PTS
            else
              FrameOut.PTS := Pes.PTS;
            FrameOut.DTS := -1;
            FrameOut.OffsetPTSDTS(0);
            FrameOut.StripPesHeader := true;
            FrameOut.Write(Buffer, Current);
            FrameOut.PTSLength := PTSLength;
          finally
            FrameOut.Finished;
          end;

          if PTS <> -1 then
            Inc(PTS, PTSLength);

          if NewPes then begin
            NewPes := False;
            //LogMessage('new pes packet: ' + IntToStr(Pes.PTS));
            if Pes.PTS <> -1 then
              if PTS = -1 then
                PTS := Pes.PTS + PTSLength
              else if PTS <> Pes.PTS then begin
                if Abs(PTS - Pes.PTS) > MaxPtsJitter then

                  if Abs(PTS - Pes.PTS) <> High(Longword) then // pts turnover... ist erlaubt...
                    LogMessage('warning: pts discontinuity detected [' + IntToStr(PTS - Pes.PTS) + ' pts cycles]');
                PTS := Pes.PTS;
              end;
          end;

          //LogMessage('audio frame ' + IntToStr(FrameCount) + ' found. next pts: ' + IntToStr(PTS));
          Current := 0;
        end;
        Ac3HeaderData := Ac3NextHeaderData;
      end else if Current = 0 then
        Ac3HeaderData := Ac3NextHeaderData;
    end;

    if Current = High(Buffer) then begin
      LogMessage('buffer overflow! input is most likely not a valid Ac3 pes audio stream');
      Current := 0;
    end;
  end;

  if FrameCount > 0 then
    SetState(
      'streamid: ' + IntToStr(StartCode) + ' ' +
      'AC3 ' +
      IntToStr(Ac3HeaderData.Bitrate) + ' kBit/s ' +
      IntToStr(Ac3HeaderData.SampleRate) + ' Hz ' +
      'frames: ' + IntToStr(FrameCount)
      );
end;

procedure TTeAudioFrameProcessorThread.ProcessMpegAudio;
var
  i                           : Integer;
  MpegHeaderInt               : PInteger;
  FrameOut                    : TTePesAudioBufferPage;
begin
  MpegHeaderInt := @MpegHeader;
  for i := Pes.PayloadStart to Pred(Pes.Size) do begin
    if MpegHeaderCount = 0 then begin
      Buffer[Current] := MpegHeader[3];
      Inc(Current);
    end else
      Dec(MpegHeaderCount);
    Move(MpegHeader[0], MpegHeader[1], 3);
    MpegHeader[0] := PLongByteArray(Pes.Memory)^[i];
    if DecodeHeader(MpegHeaderInt^, MpegNextHeaderData) then begin
      if Current >= MpegHeaderData.FrameLength then begin
        if (Current > 0) then begin
          if MpegHeaderData.Layer in [1, 2] then begin
            PTSLength := Round(MpegSamplesPerFrame[MpegHeaderData.Layer] / MpegHeaderData.SampleRate * 90000);
            if (LastPTSLength <> -1) and (PTSLength <> LastPTSLength) then
              LogMessage('warning: pts length of audio frame changed from ' + IntToStr(LastPTSLength) + ' to ' + IntToStr(PTSLength) + ' pts cycles');
            LastPTSLength := PTSLength;

            Inc(FrameCount);

            FrameOut := afpOutput.GetWritePage(Current);
            try
              FrameOut.StartCode := StartCode;
              if PTS <> -1 then
                FrameOut.PTS := PTS
              else
                FrameOut.PTS := Pes.PTS;
              FrameOut.DTS := -1;
              FrameOut.OffsetPTSDTS(0);
              FrameOut.StripPesHeader := true;
              FrameOut.Write(Buffer, Current);
              FrameOut.PTSLength := PTSLength;
            finally
              FrameOut.Finished;
            end;

            if PTS <> -1 then
              Inc(PTS, PTSLength);

            if NewPes then begin
              NewPes := False;
              //LogMessage('new pes packet: ' + IntToStr(Pes.PTS));
              if Pes.PTS <> -1 then
                if PTS = -1 then
                  PTS := Pes.PTS + PTSLength
                else if PTS <> Pes.PTS then begin
                  if Abs(PTS - Pes.PTS) > MaxPtsJitter then
                    LogMessage('warning: pts discontinuity detected [' + IntToStr(PTS - Pes.PTS) + ' pts cycles]');
                  PTS := Pes.PTS;
                end;
            end;

            //LogMessage('audio frame ' + IntToStr(FrameCount) + ' found. next pts: ' + IntToStr(PTS));
          end
          else
            LogMessage('invalid audio frame: not a layer I or layer II frame');
          Current := 0;
        end;
        MpegHeaderData := MpegNextHeaderData;
      end else if Current = 0 then
        MpegHeaderData := MpegNextHeaderData;
    end;
    if Current = High(Buffer) then begin
      LogMessage('buffer overflow! input is most likely not a valid mpeg2 pes audio stream');
      Current := 0;
    end;
  end;

  if FrameCount > 0 then
    SetState(
      'streamid: ' + IntToStr(StartCode) + ' ' +
      'mpeg ' + MPEG_VERSIONS[MpegHeaderData.Version] + ' ' +
      'layer ' + MPEG_LAYERS[MpegHeaderData.Layer] + ' ' +
      IntToStr(MpegHeaderData.Bitrate) + ' kBit/s ' +
      IntToStr(MpegHeaderData.SampleRate) + ' Hz ' +
      MPEG_MODES[MpegHeaderData.Mode] + ' ' +
      'frames: ' + IntToStr(FrameCount)
      );
end;

end.

