unit TePesParser;

interface

uses
  Classes, SysUtils, TeLogableThread;

const
  MaxPtsJitter                = 10;

const
  MAX_PLENGTH                 = $FFFF;
  MMAX_PLENGTH                = 32 * MAX_PLENGTH;

  VS_PICTURE                  = $00;
  VS_USER_DATA                = $B2;
  VS_SEQUENCE                 = $B3;
  VS_SEQUENCE_ERROR           = $B4;
  VS_EXTENSION                = $B5;
  VS_SEQUENCE_END             = $B7;
  VS_GROUP                    = $B8;

  PS_HEADER                   = $BA;
  PS_SYSTEMHEADER             = $BB;
  PS_END                      = $B9;

  SS_PROG_STREAM_MAP          = $BC;
  SS_PRIVATE_STREAM1          = $BD;
  SS_PADDING_STREAM           = $BE;
  SS_PRIVATE_STREAM2          = $BF;
  SS_AUDIO_STREAM_START       = $C0;
  SS_AUDIO_STREAM_END         = $DF;
  SS_VIDEO_STREAM_START       = $E0;
  SS_VIDEO_STREAM_END         = $EF;
  SS_ECM_STREAM               = $F0;
  SS_EMM_STREAM               = $F1;
  SS_DSM_CC_STREAM            = $F2;
  SS_ISO13522_STREAM          = $F3;
  SS_PROG_STREAM_DIR          = $FF;

  // Flags2
  PTS_DTS_FLAGS               = $C0;
  ESCR_FLAG                   = $20;
  ES_RATE_FLAG                = $10;
  DSM_TRICK_FLAG              = $08;
  ADD_CPY_FLAG                = $04;
  PES_CRC_FLAG                = $02;
  PES_EXT_FLAG                = $01;

  // PTS_DTS_FLAGS
  PTS_ONLY                    = $80;
  PTS_DTS                     = $C0;

type
  PLongByteArray = ^TLongByteArray;
  TLongByteArray = array[0..High(Integer) - 1] of Byte;

  TPesParser = class(TObject)
  public
    OutputBuffer: array[0..MMAX_PLENGTH - 1] of Byte;
    PacketPos: Integer;
    StartCode: Byte;
    PacketLength: Integer;
    CodedPacketLength: array[0..1] of Byte;
    Flag1: Byte;
    Flag2: Byte;
    HeaderLength: Byte;
    HeaderCopied: Byte;
    CodedPTS: array[0..4] of Byte;
    CodedDTS: array[0..4] of Byte;
    MpegType: Byte;
    Check: Byte;
    HeaderParseState: Integer;
    IgnorePacket: Boolean;
    PayloadStart: Integer;
    NextPacketPos: Integer;
    NextStartCode: Byte;
    NextIgnorePacket: Boolean;

    StartsParsed: Boolean;
    SequenceStarts: array of LongWord;
    GroupStarts: array of LongWord;
    PictureStarts: array of LongWord;

    OnPacketFound: TNotifyEvent;
    Log: ILog;

    PacketsFound: Integer;
    PacketsIgnored: Integer;

    StripPesHeader: Boolean;

    procedure FindPesPackets(InputBuffer: PLongByteArray; Count: Integer);
  end;

implementation

uses
  Winsock2;

type
  PWord = ^Word;

procedure TPesParser.FindPesPackets(InputBuffer: PLongByteArray; Count: Integer);
var
  Len                         : Integer;
  Current                     : Integer;
  PTS                         : Int64;
  Time                        : TDateTime;
const
  HeaderBytes                 : array[0..2] of Byte = ($00, $00, $01);
begin
  Time := 0;
  Current := 0;
  while Current < Count do begin
    while
      (Current < Count) and
      (
      (MpegType = 0) or
      ((MpegType = 1) and (PacketPos < 7)) or
      ((MpegType = 2) and (PacketPos < 9))
      ) and
      ((PacketPos < 6) or (not IgnorePacket)) do begin
      case PacketPos of
        0, 1: begin
            if InputBuffer[Current] = 0 then
              Inc(PacketPos)
            else
              PacketPos := 0;
            Inc(Current);
          end;
        2: begin
            case InputBuffer[Current] of
              0: ;                                          //PacketPos:=2;
              1: Inc(PacketPos);
            else
              PacketPos := 0;
            end;
            Inc(Current);
          end;
        3: begin
            StartCode := 0;
            case InputBuffer[Current] of
              SS_PROG_STREAM_MAP, SS_PRIVATE_STREAM2, SS_PROG_STREAM_DIR, SS_ECM_STREAM,
                SS_EMM_STREAM, SS_PADDING_STREAM, SS_DSM_CC_STREAM, SS_ISO13522_STREAM: begin
                  Inc(PacketPos);
                  StartCode := InputBuffer[Current];
                  Inc(Current);
                  IgnorePacket := true;
                end;
              SS_PRIVATE_STREAM1, SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END, SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END: begin
                  Inc(PacketPos);
                  StartCode := InputBuffer[Current];
                  Inc(Current);
                end;
              PS_HEADER, PS_SYSTEMHEADER, PS_END: begin
                  PacketPos := 0;
                end;
            else
              PacketPos := 0;
            end;
          end;
        4: begin
            if (Count - Current) > 1 then begin
              PacketLength := ntohs(PWord(@InputBuffer[Current])^);
              CodedPacketLength[0] := InputBuffer[Current];
              Inc(Current);
              CodedPacketLength[1] := InputBuffer[Current];
              Inc(Current);
              Inc(PacketPos, 2);
            end else begin
              CodedPacketLength[0] := InputBuffer[Current];
              Inc(PacketPos);
              Exit;
            end;
          end;
        5: begin
            CodedPacketLength[1] := InputBuffer[Current];
            Inc(Current);
            PacketLength := ntohs(PWord(@InputBuffer[Current])^);
            Inc(PacketPos);
          end;
        6: if not IgnorePacket then begin
            Flag1 := InputBuffer[Current];
            Inc(Current);
            Inc(PacketPos);
            if (Flag1 and $C0) = $80 then
              MpegType := 2
            else begin
              HeaderLength := 0;
              HeaderParseState := 0;
              MpegType := 1;
              Flag2 := 0;
            end;
          end;
        7: if (not IgnorePacket) and (MpegType = 2) then begin
            Flag2 := InputBuffer[Current];
            Inc(Current);
            Inc(PacketPos);
          end;
        8: if (not IgnorePacket) and (MpegType = 2) then begin
            HeaderLength := InputBuffer[Current];
            Inc(Current);
            Inc(PacketPos);
          end;
      end;
    end;

    if IgnorePacket or
      ((MpegType = 2) and (PacketPos >= 9)) or
      ((MpegType = 1) and (PacketPos >= 7)) then begin
      case StartCode of
        SS_PRIVATE_STREAM1, SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END, SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END: begin
            Move(HeaderBytes, OutputBuffer[0], 3);
            OutputBuffer[3] := StartCode;
            Move(CodedPacketLength[0], OutputBuffer[4], 2);

            case MpegType of
              2: if PacketPos = 9 then begin
                  OutputBuffer[6] := Flag1;
                  OutputBuffer[7] := Flag2;
                  OutputBuffer[8] := HeaderLength;
                end;
              1: if PacketPos = 7 then
                  OutputBuffer[6] := Flag1;
            end;

            if (MpegType = 2) and ((Flag2 and PTS_ONLY) <> 0) and (PacketPos < 14) then begin
              while (Current < Count) and (PacketPos < 14) do begin
                CodedPTS[PacketPos - 9] := InputBuffer[Current];
                OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(Current);
                Inc(PacketPos);
                Inc(HeaderCopied);
              end;
              if Current = Count then
                Exit;
            end;

            if (MpegType = 2) and ((Flag2 and PTS_DTS_FLAGS) = PTS_DTS) and (PacketPos < 19) then begin
              while (Current < Count) and (PacketPos < 19) do begin
                CodedDTS[PacketPos - 14] := InputBuffer[Current];
                OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(Current);
                Inc(PacketPos);
                Inc(HeaderCopied);
              end;
              if Current = Count then
                Exit;
            end;

            if (MpegType = 1) and (HeaderParseState < 2000) then begin
              if PacketPos = 7 then begin
                Check := Flag1;
                HeaderLength := 1;
              end;
              while (HeaderParseState = 0) and (Current < Count) and (Check = $FF) do begin
                Check := InputBuffer[Current];
                OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(Current);
                Inc(PacketPos);
                Inc(HeaderLength);
                Inc(HeaderCopied);
              end;
              if Current = Count then
                Exit;
              if ((Check and $C0) = $40) and (HeaderParseState = 0) then begin
                Check := InputBuffer[Current];
                OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(Current);
                Inc(PacketPos);
                Inc(HeaderLength);
                Inc(HeaderCopied);
                HeaderParseState := 1;
                if Current = Count then Exit;
              end;

              if HeaderParseState = 1 then begin
                Check := InputBuffer[Current];
                OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(Current);
                Inc(PacketPos);
                Inc(HeaderLength);
                Inc(HeaderCopied);
                HeaderParseState := 2;
                if Current = Count then Exit;
              end;

              if ((Check and $30) <> 0) and (Check <> $FF) then begin
                Flag2 := (Check and $F0) shl 2;
                CodedPTS[0] := Check;
                HeaderParseState := 3;
              end;

              if HeaderParseState > 2 then begin
                case Flag2 and PTS_DTS_FLAGS of
                  PTS_ONLY:
                    while (Current < Count) and (HeaderParseState < 7) do begin
                      CodedPTS[HeaderParseState - 2] := InputBuffer[Current];
                      OutputBuffer[PacketPos] := InputBuffer[Current];
                      Inc(Current);
                      Inc(PacketPos);
                      Inc(HeaderParseState);
                      Inc(HeaderLength);
                      Inc(HeaderCopied);
                    end;
                  PTS_DTS:
                    while (Current < Count) and (HeaderParseState < 12) do begin
                      if HeaderParseState < 7 then
                        CodedPTS[HeaderParseState - 2] := InputBuffer[Current];
                      OutputBuffer[PacketPos] := InputBuffer[Current];
                      Inc(Current);
                      Inc(PacketPos);
                      Inc(HeaderParseState);
                      Inc(HeaderLength);
                      Inc(HeaderCopied);
                    end;
                end;
                if Current = Count then Exit;
                HeaderParseState := 2000;
              end;
            end;

            // copy any remainging header bytes..
            while (Current < Count) and (HeaderCopied < HeaderLength) do begin
              OutputBuffer[PacketPos] := InputBuffer[Current];
              Inc(Current);
              Inc(PacketPos);
              Inc(HeaderCopied);
            end;
            if Current = Count then Exit;
          end;
      end;

      //remove all fancy stuff from the packet header...
      if (PayloadStart = 0) and not IgnorePacket then begin
        if OutputBuffer[7] and PTS_DTS_FLAGS <> 0 then begin
          //          OutputBuffer[7] := PTS_ONLY;                           //Flag2: only PTS present
          //          Flag2 := PTS_ONLY;
          //          OutputBuffer[8] := 5;                             //headerlength: PTS is 5 byte long...
          //          HeaderLength := 5;
          //          HeaderCopied := 5;
          //          PacketPos := 14;
        end else begin
          OutputBuffer[6] := $80;                           //Flag1: marker bit
          Flag1 := $80;
          OutputBuffer[7] := $00;                           //Flag2: PTS not present
          Flag2 := $0;
          OutputBuffer[8] := 0;                             //headerlength: not extended header present
          HeaderLength := 0;
          HeaderCopied := 0;
          PacketPos := 9;
          FillChar(CodedPTS, SizeOf(CodedPTS), 0);
          FillChar(CodedDTS, SizeOf(CodedDTS), 0);
        end;
        PayloadStart := PacketPos;
      end;

      if PacketLength = 0 then begin                        //we have a packet without length...
        StartsParsed := True;                               // the packet will be parsed for sequence, group and picture headers

        // try to find the next packet header
        while (Current < Count) and (PacketLength = 0) do begin

          if not IgnorePacket and (NextPacketPos = 0) and (PacketPos >= 1024 * 1024) then begin
            PacketLength := PacketPos - 6;                  //set the packet length

            PWord(@CodedPacketLength[0])^ := htons(PacketLength); //switch to network byte order
            Move(CodedPacketLength[0], OutputBuffer[4], 2); //put in the header...

            if Assigned(OnPacketFound) then
              OnPacketFound(Self);                          //inform our client...

            //remove PTS from header...
            OutputBuffer[7] := $00;                         //Flag2: PTS not present
            Flag2 := $0;
            OutputBuffer[8] := 0;                           //headerlength: not extended header present
            HeaderLength := 0;
            HeaderCopied := 0;
            PacketPos := 9;
            FillChar(CodedPTS, SizeOf(CodedPTS), 0);
            FillChar(CodedDTS, SizeOf(CodedDTS), 0);
            PacketLength := 0;
            SequenceStarts := nil;
            GroupStarts := nil;
            PictureStarts := nil;
          end;

          case NextPacketPos of
            0, 1: begin
                if InputBuffer[Current] = 0 then
                  Inc(NextPacketPos)
                else
                  NextPacketPos := 0;
                if not IgnorePacket then                    //do we need the payload?
                  OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(PacketPos);
                Inc(Current);
              end;
            2: begin
                case InputBuffer[Current] of
                  0: ;                                      //NextPacketPos:=2;
                  1: Inc(NextPacketPos);
                else
                  NextPacketPos := 0;
                end;
                if not IgnorePacket then                    //do we need the payload?
                  OutputBuffer[PacketPos] := InputBuffer[Current];
                Inc(PacketPos);
                Inc(Current);
              end;
            3: begin
                NextStartCode := 0;
                case InputBuffer[Current] of
                  SS_PROG_STREAM_MAP, SS_PRIVATE_STREAM2, SS_PROG_STREAM_DIR, SS_ECM_STREAM,
                    SS_EMM_STREAM, SS_PADDING_STREAM, SS_DSM_CC_STREAM, SS_ISO13522_STREAM: begin
                      Inc(NextPacketPos);
                      NextStartCode := InputBuffer[Current];
                      Inc(Current);
                      NextIgnorePacket := true;
                    end;
                  SS_PRIVATE_STREAM1, SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END, SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END: begin
                      Inc(NextPacketPos);
                      NextStartCode := InputBuffer[Current];
                      Inc(Current);
                    end;
                else
                  NextPacketPos := 0;
                  case InputBuffer[Current] of
                    VS_SEQUENCE: begin
                        SetLength(SequenceStarts, Length(SequenceStarts) + 1);
                        SequenceStarts[High(SequenceStarts)] := PacketPos - PayloadStart - 3;
                      end;
                    VS_GROUP: begin
                        SetLength(GroupStarts, Length(GroupStarts) + 1);
                        GroupStarts[High(GroupStarts)] := PacketPos - PayloadStart - 3;
                      end;
                    VS_PICTURE: begin
                        SetLength(PictureStarts, Length(PictureStarts) + 1);
                        PictureStarts[High(PictureStarts)] := PacketPos - PayloadStart - 3;
                      end;
                  end;
                end;
                if NextPacketPos = 4 then begin
                  // we have PacketPos a new packet header!
                  Dec(PacketPos, 3);                        //we have copied 3 bytes to much into OutputBuffer (-> $00 $00 $01)
                  PacketLength := PacketPos - 6;            //set the packet length
                  if not IgnorePacket then                  //this is a packet we need.. correct the length in the header...
                    if PacketLength > High(Word) then begin
                      //                      if Assigned(Log) then
                      //                        Log.LogMessage(Format('PacketLength > High(Word): Length not set in header [%d]', [PacketLength]));
                    end else begin
                      PWord(@CodedPacketLength[0])^ := htons(PacketLength); //switch to network byte order
                      Move(CodedPacketLength[0], OutputBuffer[4], 2); //put in the header...
                    end;
                end;
              end;
          end;
        end;
        if Current = Count then Exit;
      end else                                              //we have a length...
        if IgnorePacket then begin                          //but we are not interrested in the payload
          if PacketPos + Count - Current < PacketLength + 6 then begin //not enough bytes remaining in buffer
            Inc(PacketPos, Count - Current);
            //end of buffer reached...
            Exit;
          end else begin                                    //enough bytes remaining
            //just skip ahead...
            Inc(Current, PacketLength + 6 - PacketPos);
            PacketPos := PacketLength + 6;
          end
        end else                                            //we need the payload
          while (Current < Count) and (PacketPos < PacketLength + 6) do begin
            //copy as much as we can
            Len := Count - Current;
            if Len + PacketPos > PacketLength + 6 then
              Len := PacketLength + 6 - PacketPos;          //enough bytes remaining
            Move(InputBuffer[Current], OutputBuffer[PacketPos], Len);
            Inc(PacketPos, Len);
            Inc(Current, Len);
          end;

      if PacketPos = PacketLength + 6 then begin            // we completed a packet...
        // do we need the payload?
        if not IgnorePacket then begin
          Inc(PacketsFound);
          if Assigned(OnPacketFound) then
            OnPacketFound(Self);                            //inform our client...
        end
        else
          Inc(PacketsIgnored);

        if Assigned(Log) then begin
          PTS := 0;
          if Flag2 and $80 <> 0 then begin
            PTS := PTS or ((CodedPTS[0] and $0E) shl 29);
            PTS := PTS or (CodedPTS[1] shl 22);
            PTS := PTS or ((CodedPTS[2] and $FE) shl 14);
            PTS := PTS or (CodedPTS[3] shl 7);
            PTS := PTS or ((CodedPTS[4] and $FE) shr 1);
            Time := PTS / 90000 / 24 / 60 / 60;
          end;

          Log.SetState('Found: ' + IntToStr(PacketsFound) + ' Ignored: ' + IntToStr(PacketsIgnored) +
            ' PTS: ' + IntToStr(Trunc(Time)) + ' days ' + FormatDateTime('hh:mm:ss.zzz', Frac(Time)));
        end;

        //get ready for the next packet
        //FillChar(OutputBuffer, SizeOf(OutputBuffer), 0);
        PacketPos := NextPacketPos;
        StartCode := NextStartCode;
        PacketLength := 0;
        FillChar(CodedPacketLength, SizeOf(CodedPacketLength), 0);
        Flag1 := 0;
        Flag2 := 0;
        HeaderLength := 0;
        HeaderCopied := 0;
        FillChar(CodedPTS, SizeOf(CodedPTS), 0);
        FillChar(CodedDTS, SizeOf(CodedDTS), 0);
        MpegType := 0;
        Check := 0;
        HeaderParseState := 0;
        IgnorePacket := NextIgnorePacket;
        PayloadStart := 0;
        NextPacketPos := 0;
        NextStartCode := 0;
        NextIgnorePacket := false;

        StartsParsed := false;
        SequenceStarts := nil;
        GroupStarts := nil;
        PictureStarts := nil;
      end;
    end;
  end;
end;

end.

