unit TeVideoParser;

interface

uses
  Classes, SysUtils, TeLogableThread, TePesParser;

type
  TTeVideoParser = class(TObject)
  public
    OutputBuffer: array[0..MMAX_PLENGTH - 1] of Byte;

    PTS: Int64;
    DTS: Int64;

    OutputPos: Integer;
    StartCode: Byte;
    OutputLength: Integer;
    OutputOffset: Integer;

    NextOutputPos: Integer;
    NextStartCode: Byte;

    SequenceStarts: array of LongWord;
    GroupStarts: array of LongWord;
    PictureStarts: array of LongWord;

    OnFrameFound: TNotifyEvent;
    Log: ILog;

    procedure FindVideoFrames(InputBuffer: PLongByteArray; Count: Integer; aPTS, aDTS: Int64);
  end;

implementation

uses
  Winsock2;

type
  PWord = ^Word;

procedure TTeVideoParser.FindVideoFrames(InputBuffer: PLongByteArray; Count: Integer; aPTS, aDTS: Int64);
var
  Current                     : Integer;
begin
  Current := 0;
  while Current < Count do
  begin
    while (Current < Count) and (OutputPos < 4) do
    begin
      case OutputPos of
        0, 1: begin
            if InputBuffer[Current] = 0 then
              Inc(OutputPos)
            else
              OutputPos := 0;
            Inc(Current);
          end;
        2: begin
            case InputBuffer[Current] of
              0: ;                                          //OutputPos:=2;
              1: Inc(OutputPos);
            else
              OutputPos := 0;
            end;
            Inc(Current);
          end;
        3: begin
            StartCode := 0;
            case InputBuffer[Current] of
              VS_PICTURE, VS_SEQUENCE, {VS_SEQUENCE_END,} VS_GROUP: begin
                  Inc(OutputPos);
                  StartCode := InputBuffer[Current];
                  Inc(Current);
                end;
            else
              OutputPos := 0;
            end;
          end;
      end;
    end;

    if OutputPos = 4 then begin
      if OutputOffset = 0 then begin
        PTS := aPTS;
        aPTS := -1;
        DTS := aDTS;
        aDTS := -1;
      end;
      OutputBuffer[0 + OutputOffset] := 0;
      OutputBuffer[1 + OutputOffset] := 0;
      OutputBuffer[2 + OutputOffset] := 1;
      OutputBuffer[3 + OutputOffset] := StartCode;
    end;

    // try to find the next packet header
    while (Current < Count) and (OutputLength = 0) do begin
      case NextOutputPos of
        0, 1: begin
            if InputBuffer[Current] = 0 then
              Inc(NextOutputPos)
            else
              NextOutputPos := 0;
            OutputBuffer[OutputPos + OutputOffset] := InputBuffer[Current];
            Inc(OutputPos);
            Inc(Current);
          end;
        2: begin
            case InputBuffer[Current] of
              0: ;                                          //NextOutputPos:=2;
              1: Inc(NextOutputPos);
            else
              NextOutputPos := 0;
            end;
            OutputBuffer[OutputPos + OutputOffset] := InputBuffer[Current];
            Inc(OutputPos);
            Inc(Current);
          end;
        3: begin
            NextStartCode := 0;
            case InputBuffer[Current] of
              VS_PICTURE, VS_SEQUENCE, {VS_SEQUENCE_END,} VS_GROUP: begin
                  Inc(NextOutputPos);
                  NextStartCode := InputBuffer[Current];
                  Inc(Current);
                end;
            else
              NextOutputPos := 0;
            end;
            if NextOutputPos = 4 then begin
              // we have OutputPos a new packet header!
              Dec(OutputPos, 3);                            //we have copied 3 bytes to much into OutputBuffer (-> $00 $00 $01)
              OutputLength := OutputPos;                    //set the frame length
            end;
          end;
      end;
    end;
    if Current = Count then Exit;

    if OutputPos = OutputLength then begin                  // we completed a packet...
      case StartCode of
        VS_PICTURE: begin
            SetLength(PictureStarts, Length(PictureStarts) + 1);
            PictureStarts[High(PictureStarts)] := OutputOffset;
          end;
        VS_SEQUENCE: begin
            SetLength(SequenceStarts, Length(SequenceStarts) + 1);
            SequenceStarts[High(SequenceStarts)] := OutputOffset;
          end;
        VS_GROUP: begin
            SetLength(GroupStarts, Length(GroupStarts) + 1);
            GroupStarts[High(GroupStarts)] := OutputOffset;
          end;
      end;

      if StartCode = VS_PICTURE then begin
        if Assigned(OnFrameFound) then
          OnFrameFound(Self);                               //inform our client...
        OutputOffset := 0;
      end else begin
        Inc(OutputOffset, OutputPos);
      end;

      OutputPos := NextOutputPos;
      StartCode := NextStartCode;
      OutputLength := 0;
      NextOutputPos := 0;
      NextStartCode := 0;

      if OutputOffset > 0 then
        Continue;

      PTS := -1;
      DTS := -1;
      //FillChar(OutputBuffer, SizeOf(OutputBuffer), 0);
      SequenceStarts := nil;
      GroupStarts := nil;
      PictureStarts := nil;
    end;
  end;
end;

end.

