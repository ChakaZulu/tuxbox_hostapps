unit TeVideoFrameProcessorThread;

interface

uses
  Windows,
  Classes, SysUtils,
  TeBase, TeThrd, TeSocket, TeFiFo, TePesFiFo, TePesParser, TeLogableThread,
  TeVideoParser;

type
  TTeVideoFrameProcessorThread = class(TTeLogableThread)
  private
    vfpInput: TTePesVideoFiFoBuffer;
    vfpOutput: TTePesVideoFiFoBuffer;
    vfpParser: TTeVideoParser;
    vfpVideoStartOffset: Integer;
    vfpVideoEndOffset: Integer;
  protected
    StartCode: Integer;
    SeqCount: Integer;
    PicCount: Integer;
    procedure InnerExecute; override;
    procedure DoAfterExecute; override;
    procedure FrameFound(Sender: TObject);
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTePesVideoFiFoBuffer; aOutput: TTePesVideoFiFoBuffer; aVideoStartOffset, aVideoEndOffset: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  Math, Winsock2;

const
  PSHeaderSize                : Integer = 14;

  { TTeVideoFrameProcessorThread }

constructor TTeVideoFrameProcessorThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTePesVideoFiFoBuffer; aOutput: TTePesVideoFiFoBuffer; aVideoStartOffset, aVideoEndOffset: Integer);
begin
  vfpInput := aInput;
  vfpOutput := aOutput;
  vfpParser := TTeVideoParser.Create;
  vfpParser.OnFrameFound := FrameFound;
  vfpVideoStartOffset := aVideoStartOffset;
  vfpVideoEndOffset := aVideoEndOffset;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeVideoFrameProcessorThread.Destroy;
begin
  vfpInput.Shutdown;
  vfpOutput.Shutdown;
  inherited;
  FreeAndNil(vfpParser);
end;

procedure TTeVideoFrameProcessorThread.DoAfterExecute;
begin
  vfpInput.Shutdown;
  vfpOutput.Shutdown;
  inherited;
end;

procedure TTeVideoFrameProcessorThread.FrameFound(Sender: TObject);
var
  Output                      : TTePesVideoBufferPage;
begin
  if (vfpVideoStartOffset >= 0) and (PicCount < vfpVideoStartOffset) then begin
    if Length(vfpParser.SequenceStarts) > 0 then
      Inc(SeqCount);
    if Length(vfpParser.PictureStarts) > 0 then
      Inc(PicCount);
    SetState(
      'streamid: ' + IntToStr(StartCode) + ' ' +
      'skipping frames up to: ' + IntToStr(vfpVideoStartOffset) + ' ' +
      'sequences: ' + IntToStr(SeqCount) + ' ' +
      'pictures: ' + IntToStr(PicCount)
      );
    Exit;
  end;
  if (vfpVideoEndOffset >= 0) and (vfpVideoEndOffset < PicCount) then begin
    SetState(
      'streamid: ' + IntToStr(StartCode) + ' ' +
      'end offset (' + IntToStr(vfpVideoEndOffset) + ') reached [terminating]' +
      'sequences: ' + IntToStr(SeqCount) + ' ' +
      'pictures: ' + IntToStr(PicCount)
      );
    vfpInput.Shutdown;
    Exit;
  end;
  Output := vfpOutput.GetWritePage(vfpParser.OutputOffset + vfpParser.OutputPos);
  try
    Output.SequenceStarts := nil;
    Output.GroupStarts := nil;
    Output.PictureStarts := nil;

    Output.StartCode := StartCode;
    Output.PTS := vfpParser.PTS;
    Output.DTS := vfpParser.DTS;
    Output.StripPesHeader := True;
    Output.OffsetPTSDTS(0);

    if Length(vfpParser.SequenceStarts) > 0 then begin
      Inc(SeqCount);
      SetLength(Output.SequenceStarts, 1);
      Output.SequenceStarts[0] := vfpParser.SequenceStarts[0];
    end;

    if Length(vfpParser.GroupStarts) > 0 then begin
      SetLength(Output.GroupStarts, 1);
      Output.GroupStarts[0] := vfpParser.GroupStarts[0];
    end;

    if Length(vfpParser.PictureStarts) > 0 then begin
      Inc(PicCount);
      SetLength(Output.PictureStarts, 1);
      Output.PictureStarts[0] := vfpParser.PictureStarts[0];
    end;

    Output.Write(vfpParser.OutputBuffer, vfpParser.OutputOffset + vfpParser.OutputPos);

//    if Length(vfpParser.SequenceStarts) > 0 then
//      with TFileStream.Create('C:\iFrame.mpg2', fmCreate) do try
//        Write(Pointer(PChar(Output.Memory) + vfpParser.PictureStarts[0])^, Output.Size - vfpParser.PictureStarts[0]);
//        Abort;
//      finally
//        Free;
//      end;                                                  // with

    if Length(Output.SequenceStarts) > 0 then begin
      Output.DecodeSequenceHeader;
      SetState(
        'streamid: ' + IntToStr(StartCode) + ' ' +
        IntToStr(Output.sequence_header.horizontal_size_value) + 'x' +
        IntToStr(Output.sequence_header.vertical_size_value) + ' ' +
        IntToStr(Round(frame_rate[Output.sequence_header.frame_rate_code])) + 'fps ' +
        'sequences: ' + IntToStr(SeqCount) + ' ' +
        'pictures: ' + IntToStr(PicCount)
        );
    end;
    if Length(Output.PictureStarts) > 0 then
      Output.DecodePictureHeader;
  finally
    Output.Finished;
  end
end;

procedure TTeVideoFrameProcessorThread.InnerExecute;
var
  Picture                     : TTePesVideoBufferPage;
begin
  SetState('waiting for first data');
  SeqCount := 0;
  PicCount := 0;
  StartCode := 0;
  while not Terminated do begin
    Picture := vfpInput.GetReadPage(True);

    if not (Picture.StartCode in [SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END]) then begin
      LogMessage('packet skipped: not a valid video stream id');
      Picture.Finished;
      Continue;
    end;

    if StartCode = 0 then begin
      StartCode := Picture.StartCode;
      LogMessage('locked on stream id ' + IntToStr(StartCode));
    end;

    if Picture.StartCode <> StartCode then begin
      LogMessage('packet skipped: invalid start code ' + IntToStr(Picture.StartCode));
      Picture.Finished;
      Continue;
    end;

    vfpParser.FindVideoFrames(PLongByteArray(PChar(Picture.Memory) + Picture.PayloadStart),
      Picture.Size - Picture.PayloadStart,
      Picture.PTS, Picture.DTS);
    Picture.Finished;
  end;
end;

end.

