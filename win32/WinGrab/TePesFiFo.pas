unit TePesFiFo;

interface

uses
  Classes, SysUtils,
  TeBase, TeFiFo, TePesParser,
  JclSynch, TeLogableThread;

const
  picture_coding_I            = 1;
  picture_coding_P            = 2;
  picture_coding_B            = 3;

  frame_rate_23_976           = 1;
  frame_rate_24               = 2;
  frame_rate_25               = 3;
  frame_rate_29_97            = 4;
  frame_rate_30               = 5;
  frame_rate_50               = 6;
  frame_rate_59_94            = 7;
  frame_rate_60               = 8;

  frame_rate                  : array[frame_rate_23_976..frame_rate_60] of Double = (
    24000 / 1001, 24, 25, 30000 / 1001, 30, 50, 60000 / 1001, 60
    );

type
  TTePesBufferPage = class(TTeBufferPage)
  private
  protected
    procedure EncodePTS;
    procedure EncodeDTS;
  public
    StartCode: Byte;
    PacketLength: LongWord;
    Flag1: Byte;
    Flag2: Byte;
    HeaderLength: Byte;
    CodedPTS: array[0..4] of Byte;
    CodedDTS: array[0..4] of Byte;
    MpegType: Byte;
    PayloadStart: Integer;
    PTS: Int64;
    DTS: Int64;
    RealDTS: Int64;
    StripPesHeader: Boolean;

    procedure OffsetPTSDTS(aOffset: Int64);
    procedure SetStartCode(aStartCode: Byte);
    function Next(aWaitForData: Boolean): TTePesBufferPage;
    procedure InitFromParser(aParser: TPesParser); virtual;
    procedure DecodePTSDTS;

    function RequiredPackCount(aPackSize: Integer): Integer;
  end;

  TTePesFiFoBuffer = class(TTeFiFoBuffer)
  protected
    function GetPageClass: TTeBufferPageClass; override;
  public
    constructor Create(aMaxPageCount: Integer = NoPageCountLimit);
    function GetWritePage(aSize: LongWord): TTePesBufferPage;
    function GetReadPage(aWaitForData: Boolean): TTePesBufferPage;

    procedure PesPacketFound(Sender: TObject); virtual;
  end;

  TTePesAudioBufferPage = class(TTePesBufferPage)
  private
  protected
  public
    PTSLength: Integer;
    function Next(aWaitForData: Boolean): TTePesAudioBufferPage;
  end;

  TTePesAudioFiFoBuffer = class(TTePesFiFoBuffer)
  protected
    function GetPageClass: TTeBufferPageClass; override;
  public
    constructor Create(aMaxPageCount: Integer = NoPageCountLimit);
    function GetWritePage(aSize: LongWord): TTePesAudioBufferPage;
    function GetReadPage(aWaitForData: Boolean): TTePesAudioBufferPage;
  end;

  TTePesVideoBufferPage = class(TTePesBufferPage)
  private
  protected
  public
    SequenceStarts: array of LongWord;
    GroupStarts: array of LongWord;
    PictureStarts: array of LongWord;

    sequence_header: record
      horizontal_size_value: Word;                          //12	uimsbf
      vertical_size_value: Word;                            //12	uimsbf
      aspect_ratio_information: Byte;                       // 4	uimsbf
      frame_rate_code: Byte;                                // 4	uimsbf
      bit_rate_value: LongWord;                             //18	uimsbf
    end;

    picture_header: record
      temporal_reference: Word;
      picture_coding_type: Byte;
    end;

    function Next(aWaitForData: Boolean): TTePesVideoBufferPage;
    procedure InitFromParser(aParser: TPesParser); override;
    procedure DecodePictureHeader;
    procedure DecodeSequenceHeader;
  end;

  TTePesVideoFiFoBuffer = class(TTePesFiFoBuffer)
  protected
    function GetPageClass: TTeBufferPageClass; override;
  public
    constructor Create(aMaxPageCount: Integer = NoPageCountLimit);
    function GetWritePage(aSize: LongWord): TTePesVideoBufferPage;
    function GetReadPage(aWaitForData: Boolean): TTePesVideoBufferPage;
  end;

  TTePesMuxInSplitter = class(TTePesFiFoBuffer)
  protected
    mipsLog: ILog;

    mipsVideoStreamID: Byte;
    mipsAudioStreamID: Byte;

    mipsVideoFiFo: TTePesVideoFiFoBuffer;
    mipsAudioFiFo: TTePesAudioFiFoBuffer;
    function GetPageClass: TTeBufferPageClass; override;
  public
    constructor Create(aLog: ILog; aVideoFiFo: TTePesVideoFiFoBuffer; aAudioFiFo: TTePesAudioFiFoBuffer);
    procedure PesPacketFound(Sender: TObject); override;
  end;

implementation

{ TTePesFiFoBuffer }

constructor TTePesFiFoBuffer.Create(aMaxPageCount: Integer);
begin
  inherited Create(0, 0, aMaxPageCount);
end;

function TTePesFiFoBuffer.GetPageClass: TTeBufferPageClass;
begin
  Result := TTePesBufferPage;
end;

function TTePesFiFoBuffer.GetReadPage(
  aWaitForData: Boolean): TTePesBufferPage;
begin
  Result := TTePesBufferPage(inherited GetReadPage(aWaitForData));
end;

function TTePesFiFoBuffer.GetWritePage(aSize: LongWord): TTePesBufferPage;
begin
  Result := TTePesBufferPage(inherited GetWritePage(aSize));
end;

procedure TTePesFiFoBuffer.PesPacketFound(Sender: TObject);
begin
  Assert(Sender is TPesParser);
  if TPesParser(Sender).StripPesHeader then
    with GetWritePage((TPesParser(Sender).PacketLength + 6) - TPesParser(Sender).PayloadStart) do try
      InitFromParser(TPesParser(Sender));
    finally
      Finished;
    end else with GetWritePage(TPesParser(Sender).PacketLength + 6) do try
      InitFromParser(TPesParser(Sender));
    finally
      Finished;
    end;
end;

{ TTePesBufferPage }

procedure TTePesBufferPage.DecodePTSDTS;
//var
//  h, m, s, msec                    : Word;
begin
  if Flag2 and $80 <> 0 then begin
    PTS := 0;
    PTS := PTS or ((CodedPTS[0] and $0E) shl 29);
    PTS := PTS or (CodedPTS[1] shl 22);
    PTS := PTS or ((CodedPTS[2] and $FE) shl 14);
    PTS := PTS or (CodedPTS[3] shl 7);
    PTS := PTS or ((CodedPTS[4] and $FE) shr 1);
  end
  else
    PTS := -1;

  if Flag2 and $40 <> 0 then begin
    DTS := 0;
    DTS := DTS or ((CodedDTS[0] and $0E) shl 29);
    DTS := DTS or (CodedDTS[1] shl 22);
    DTS := DTS or ((CodedDTS[2] and $FE) shl 14);
    DTS := DTS or (CodedDTS[3] shl 7);
    DTS := DTS or ((CodedDTS[4] and $FE) shr 1);
    if DTS = 0 then
      DTS := -1;
  end
  else
    DTS := -1;
  //  h := (pts div 90000) div 3600;
  //  m := ((pts div 90000) mod 3600) div 60;
  //  s := ((pts div 90000) mod 3600) mod 60;
  //  msec := (((pts div 90) mod 3600000) mod 60000) mod 1000;
  if DTS <> -1 then
    RealDTS := DTS
  else
    RealDTS := PTS;
end;

procedure TTePesBufferPage.EncodePTS;
begin
  if PTS = -1 then
    FillChar(CodedPTS, SizeOf(CodedPTS), 0)
  else begin
    if DTS = -1 then
      Byte(CodedPTS[0]) := $20 or ((PTS and $1C0000000) shr 29) or $01
    else
      Byte(CodedPTS[0]) := $30 or ((PTS and $1C0000000) shr 29) or $01;
    Byte(CodedPTS[1]) := ((PTS and $03FC00000) shr 22);
    Byte(CodedPTS[2]) := ((PTS and $0003F8000) shr 14) or $01;
    Byte(CodedPTS[3]) := ((PTS and $000007F80) shr 7);
    Byte(CodedPTS[4]) := ((PTS and $00000007F) shl 1) or $01;
  end;
  if not StripPesHeader then
    Move(CodedPTS, PLongByteArray(Memory)^[9], 5);
end;

procedure TTePesBufferPage.EncodeDTS;
begin
  if DTS = -1 then
    FillChar(CodedDTS, SizeOf(CodedDTS), 0)
  else begin
    Byte(CodedDTS[0]) := $10 or ((DTS and $1C0000000) shr 29) or $01;
    Byte(CodedDTS[1]) := ((DTS and $03FC00000) shr 22);
    Byte(CodedDTS[2]) := ((DTS and $0003F8000) shr 14) or $01;
    Byte(CodedDTS[3]) := ((DTS and $000007F80) shr 7);
    Byte(CodedDTS[4]) := ((DTS and $00000007F) shl 1) or $01;
  end;
  if not StripPesHeader then
    Move(CodedDTS, PLongByteArray(Memory)^[14], 5);
end;

procedure TTePesBufferPage.InitFromParser(aParser: TPesParser);
begin
  StripPesHeader := aParser.StripPesHeader;
  if StripPesHeader then
    Move(aParser.OutputBuffer[aParser.PayloadStart], Memory^, Size)
  else
    Move(aParser.OutputBuffer[0], Memory^, Size);
  StartCode := aParser.StartCode;
  PacketLength := aParser.PacketLength;
  Flag1 := aParser.Flag1;
  Flag2 := aParser.Flag2;
  HeaderLength := aParser.HeaderLength;
  Move(aParser.CodedPTS, CodedPTS, SizeOf(CodedPTS));
  Move(aParser.CodedDTS, CodedDTS, SizeOf(CodedDTS));
  MpegType := aParser.MpegType;
  PayloadStart := aParser.PayloadStart;
  DecodePTSDTS;
end;

function TTePesBufferPage.Next(aWaitForData: Boolean): TTePesBufferPage;
begin
  Result := TTePesBufferPage(inherited Next(aWaitForData));
end;

procedure TTePesBufferPage.OffsetPTSDTS(aOffset: Int64);
begin
  Flag2 := 0;
  if PTS <> -1 then begin
    Flag2 := PTS_ONLY;
    PTS := PTS + aOffset;
    while PTS < 0 do
      Inc(PTS, High(LongWord));
    while PTS > High(Longword) do
      Dec(PTS, High(LongWord));
    EncodePTS;
    if DTS <> -1 then begin
      Flag2 := PTS_DTS;
      DTS := DTS + aOffset;
      while DTS < 0 do
        Inc(DTS, High(LongWord));
      while DTS > High(Longword) do
        Dec(DTS, High(LongWord));
      EncodeDTS;
    end;
  end;
  DecodePTSDTS;
end;

procedure TTePesBufferPage.SetStartCode(aStartCode: Byte);
begin
  StartCode := aStartCode;
  if not StripPesHeader then
    PLongByteArray(Memory)[3] := StartCode;
end;

function TTePesBufferPage.RequiredPackCount(aPackSize: Integer): Integer;
var
  PayloadSize                 : Integer;
const
  PSHeaderSize                = 14;
  MinPesHeaderSize            = 6 + 3;
  PackOverheadAll             = PSHeaderSize + MinPesHeaderSize;
var
  FirstPackOverhead           : Integer;
begin
  if StripPesHeader then
    PayloadSize := Size
  else
    PayloadSize := Size - PayloadStart;

  FirstPackOverhead := PackOverheadAll;
  if PTS <> -1 then
    Inc(FirstPackOverhead, 5);
  if DTS <> -1 then
    Inc(FirstPackOverhead, 5);

  Result := 1;
  Dec(PayloadSize, aPackSize - FirstPackOverhead);
  if PayloadSize > 0 then begin
    Inc(Result, PayloadSize div (aPackSize - PackOverheadAll));
    if PayloadSize mod (aPackSize - PackOverheadAll) > 0 then
      Inc(Result);
  end;
end;

{ TTePesAudioFiFoBuffer }

constructor TTePesAudioFiFoBuffer.Create(aMaxPageCount: Integer);
begin
  inherited Create(aMaxPageCount);
end;

function TTePesAudioFiFoBuffer.GetPageClass: TTeBufferPageClass;
begin
  Result := TTePesAudioBufferPage;
end;

function TTePesAudioFiFoBuffer.GetReadPage(
  aWaitForData: Boolean): TTePesAudioBufferPage;
begin
  Result := TTePesAudioBufferPage(inherited GetReadPage(aWaitForData));
end;

function TTePesAudioFiFoBuffer.GetWritePage(aSize: LongWord): TTePesAudioBufferPage;
begin
  Result := TTePesAudioBufferPage(inherited GetWritePage(aSize));
end;

{ TTePesAudioBufferPage }

function TTePesAudioBufferPage.Next(aWaitForData: Boolean): TTePesAudioBufferPage;
begin
  Result := TTePesAudioBufferPage(inherited Next(aWaitForData));
end;

{ TTePesVideoFiFoBuffer }

constructor TTePesVideoFiFoBuffer.Create(aMaxPageCount: Integer);
begin
  inherited Create(aMaxPageCount);
end;

function TTePesVideoFiFoBuffer.GetPageClass: TTeBufferPageClass;
begin
  Result := TTePesVideoBufferPage;
end;

function TTePesVideoFiFoBuffer.GetReadPage(
  aWaitForData: Boolean): TTePesVideoBufferPage;
begin
  Result := TTePesVideoBufferPage(inherited GetReadPage(aWaitForData));
end;

function TTePesVideoFiFoBuffer.GetWritePage(aSize: LongWord): TTePesVideoBufferPage;
begin
  Result := TTePesVideoBufferPage(inherited GetWritePage(aSize));
end;

{ TTePesVideoBufferPage }

procedure TTePesVideoBufferPage.DecodePictureHeader;
var
  PicBuffer                   : PLongByteArray;
begin
  with picture_header do begin
    if Length(PictureStarts) <> 1 then
      exit;

    PicBuffer := PLongByteArray(PChar(Memory) + PictureStarts[0]);
    temporal_reference := PicBuffer[4] shl 2;
    temporal_reference := temporal_reference or ((PicBuffer[5] and $C0) shr 6);
    picture_coding_type := (PicBuffer[5] and $38) shr 3;
  end;
end;

procedure TTePesVideoBufferPage.DecodeSequenceHeader;
var
  SeqBuffer                   : PLongByteArray;
begin
  with sequence_header do begin
    if Length(SequenceStarts) <> 1 then
      exit;

    SeqBuffer := PLongByteArray(PChar(Memory) + SequenceStarts[0]);

    horizontal_size_value := (SeqBuffer[4] shl 4) or ((SeqBuffer[5] and $F0) shr 4);
    vertical_size_value := ((SeqBuffer[5] and $0F) shl 8) or SeqBuffer[6];
    aspect_ratio_information := (SeqBuffer[7] and $F0) shr 4;
    frame_rate_code := SeqBuffer[7] and $0F;
    bit_rate_value := (SeqBuffer[8] shl 10) or (SeqBuffer[9] shl 2) or ((SeqBuffer[10] and $C0) shr 6);
  end;
end;

procedure TTePesVideoBufferPage.InitFromParser(aParser: TPesParser);
var
  Buffer                      : PLongByteArray;
  Count                       : Integer;
  Current                     : Integer;
  ParseState                  : Integer;
begin
  inherited;
  if aParser.StartsParsed then begin
    SetLength(SequenceStarts, Length(aParser.SequenceStarts));
    Move(aParser.SequenceStarts[0], SequenceStarts[0], Length(SequenceStarts) * SizeOf(LongWord));
    SetLength(GroupStarts, Length(aParser.GroupStarts));
    Move(aParser.GroupStarts[0], GroupStarts[0], Length(GroupStarts) * SizeOf(LongWord));
    SetLength(PictureStarts, Length(aParser.PictureStarts));
    Move(aParser.PictureStarts[0], PictureStarts[0], Length(PictureStarts) * SizeOf(LongWord));
  end else begin
    Buffer := PLongByteArray(PChar(Memory) + PayloadStart);
    Count := Size - PayloadStart;
    Current := 0;
    ParseState := 0;

    while Current < Count do
      case ParseState of
        0, 1: begin
            if Buffer[Current] = 0 then
              Inc(ParseState)
            else
              ParseState := 0;
            Inc(Current);
          end;
        2: begin
            case Buffer[Current] of
              0: ;                                          //ParseState:=2;
              1: Inc(ParseState);
            else
              ParseState := 0;
            end;
            Inc(Current);
          end;
        3: begin
            ParseState := 0;
            case Buffer[Current] of
              VS_SEQUENCE: begin
                  SetLength(SequenceStarts, Length(SequenceStarts) + 1);
                  SequenceStarts[High(SequenceStarts)] := Current - 3;
                end;
              VS_GROUP: begin
                  SetLength(GroupStarts, Length(GroupStarts) + 1);
                  GroupStarts[High(GroupStarts)] := Current - 3;
                end;
              VS_PICTURE: begin
                  SetLength(PictureStarts, Length(PictureStarts) + 1);
                  PictureStarts[High(PictureStarts)] := Current - 3;
                end;
            end;                                            {of case}
          end;
      end;                                                  {of case}
  end;
end;

function TTePesVideoBufferPage.Next(aWaitForData: Boolean): TTePesVideoBufferPage;
begin
  Result := TTePesVideoBufferPage(inherited Next(aWaitForData));
end;

{ TTePesMuxInSplitter }

constructor TTePesMuxInSplitter.Create(aLog: ILog; aVideoFiFo: TTePesVideoFiFoBuffer;
  aAudioFiFo: TTePesAudioFiFoBuffer);
begin
  mipsLog := aLog;
  mipsVideoFiFo := aVideoFiFo;
  mipsAudioFiFo := aAudioFiFo;
  inherited Create;
end;

function TTePesMuxInSplitter.GetPageClass: TTeBufferPageClass;
begin
  Result := nil;
end;

procedure TTePesMuxInSplitter.PesPacketFound(Sender: TObject);
begin
  if mipsVideoStreamID = 0 then begin
    if TPesParser(Sender).StartCode in [SS_VIDEO_STREAM_START..SS_VIDEO_STREAM_END] then
      mipsVideoStreamID := TPesParser(Sender).StartCode;
  end;
  if mipsAudioStreamID = 0 then begin
    if TPesParser(Sender).StartCode in [SS_AUDIO_STREAM_START..SS_AUDIO_STREAM_END] then
      mipsAudioStreamID := TPesParser(Sender).StartCode;
  end;

  if TPesParser(Sender).StartCode = mipsVideoStreamID then
    mipsVideoFiFo.PesPacketFound(Sender)
  else if TPesParser(Sender).StartCode = mipsAudioStreamID then
    mipsAudioFiFo.PesPacketFound(Sender)
  else if Assigned(mipsLog) then
    mipsLog.LogMessage(Format('Warning: unexpected start code: %x.2 [pes packet ignored] ', [TPesParser(Sender).StartCode]));
end;

end.

