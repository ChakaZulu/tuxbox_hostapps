unit TeFiFo;

interface

uses
  Windows,
  Classes, SysUtils,
  TeBase,
  JclSynch;

const
  DefaultPageSize             = 0;
  NoPageCountLimit            = 0;
  NoWaitLimit                 = 0;

type
  ETeFiFoError = class(ETeError);

  TTeFiFoBuffer = class;

  TTeBufferPageState = (bpsUnassigned, bpsCurrentWritePage, bpsQueued, bpsRecycled);
  TTeBufferMarker = (bmNone, bmLastBuffer, bmNextFile);

  TTeBufferPageClass = class of TTeBufferPage;
  TTeBufferPage = class(TStream)
  private
    bpMemory: Pointer;
    bpPosition: Integer;
    bpRealSize: Integer;
    bpSize: Integer;
    bpWriteUntil: Int64;

    bpFiFo: TTeFiFoBuffer;
    bpState: TTeBufferPageState;
    bpNext: TTeBufferPage;
    bpMarker: TTeBufferMarker;
    function bpGetTimeRemaining: Integer;
  protected
    constructor Create(aFiFo: TTeFiFoBuffer; aSize: LongWord); virtual;
    procedure SetSize(NewSize: Longint); override;
  public
    destructor Destroy; override;

    function Next(aWaitForData: Boolean): TTeBufferPage;
    procedure Finished;                                     //returns this and all preceding page to the fifo

    procedure Clear;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;

    property Memory: Pointer read bpMemory;
    property FiFo: TTeFiFoBuffer read bpFiFo;
    property State: TTeBufferPageState read bpState;
    property Marker: TTeBufferMarker read bpMarker write bpMarker;

    property TimeRemaining: Integer read bpGetTimeRemaining;
  end;

  TTeFiFoBuffer = class(TObject)
  private
    ffbPageCount: Integer;
    ffbMinKeepCount: Integer;
    ffbMaxPageCount: Integer;
    ffbMaxWriteTime: Integer;

    ffbLock: TJclCriticalSection;
    ffbPageSize: Integer;

    ffbUsedListHead: TTeBufferPage;
    ffbUsedListTail: TTeBufferPage;
    ffbRecycleListHead: TTeBufferPage;

    ffbCurrentWritePage: TTeBufferPage;

    ffbDataAvailable: TJclEvent;
    ffbCanWrite: TJclEvent;

    ffbShuttingDown: Boolean;
  protected
    function GetPageClass: TTeBufferPageClass; virtual;
  public
    constructor Create(aPageSize: LongWord; aMinKeepCount: Integer; aMaxPageCount: Integer = NoPageCountLimit; aMaxWriteTime: Integer = NoWaitLimit);
    destructor Destroy; override;

    function GetWritePage(aSize: LongWord = DefaultPageSize; aNoWait: Boolean = False): TTeBufferPage;
    function GetReadPage(aWaitForData: Boolean): TTeBufferPage;

    procedure Shutdown;

    property DataAvailable: TJclEvent read ffbDataAvailable;
    property PageSize: Integer read ffbPageSize;
    property ShuttingDown: Boolean read ffbShuttingDown;
  end;

implementation

uses
  Math;

{ TTeFiFoBuffer }

constructor TTeFiFoBuffer.Create(aPageSize: LongWord; aMinKeepCount: Integer; aMaxPageCount: Integer; aMaxWriteTime: Integer);
begin
  ffbLock := TJclCriticalSection.Create;
  ffbDataAvailable := TJclEvent.Create(nil, true, false, '');
  ffbCanWrite := TJclEvent.Create(nil, true, false, '');
  ffbPageSize := aPageSize;
  ffbMinKeepCount := aMinKeepCount;
  ffbMaxPageCount := aMaxPageCount;
  ffbMaxWriteTime := aMaxWriteTime;
end;

destructor TTeFiFoBuffer.Destroy;
var
  Page                        : TTeBufferPage;
begin
  FreeAndNil(ffbCurrentWritePage);

  while Assigned(ffbUsedListHead) do begin
    Page := ffbUsedListHead;
    ffbUsedListHead := ffbUsedListHead.bpNext;
    Page.Free;
  end;

  while Assigned(ffbRecycleListHead) do begin
    Page := ffbRecycleListHead;
    ffbRecycleListHead := ffbRecycleListHead.bpNext;
    Page.Free;
  end;

  FreeAndNil(ffbLock);
  FreeAndNil(ffbDataAvailable);
  FreeAndNil(ffbCanWrite);
end;

function TTeFiFoBuffer.GetPageClass: TTeBufferPageClass;
begin
  Result := TTeBufferPage;
end;

function TTeFiFoBuffer.GetReadPage(aWaitForData: Boolean): TTeBufferPage;
begin
  repeat
    ffbLock.Enter;
    try
      if Assigned(ffbUsedListHead) then begin
        Assert(ffbUsedListHead.bpState = bpsQueued);
        Result := ffbUsedListHead;
      end else begin
        ffbDataAvailable.ResetEvent;
        Result := nil;
      end;
    finally
      ffbLock.Leave;
    end;
    if Assigned(Result) then
      Exit;
    if not aWaitForData then
      Exit;
    if ffbShuttingDown then
      raise EAbort.Create('FiFo is shutting down');
    if ffbDataAvailable.WaitForever <> wrSignaled then
      raise ETeFiFoError.Create('Error waiting for DataAvailable event');
  until false;
end;

function TTeFiFoBuffer.GetWritePage(aSize: LongWord = DefaultPageSize; aNoWait: Boolean = False): TTeBufferPage;
begin
  repeat
    if ffbShuttingDown then
      raise EAbort.Create('FiFo is shutting down');
    ffbLock.Enter;
    try
      if Assigned(ffbCurrentWritePage) then
        raise ETeFiFoError.Create('WritePage already opened');

      if (aSize = DefaultPageSize) and Assigned(ffbRecycleListHead) then begin
        Assert(ffbRecycleListHead.bpState = bpsRecycled);
        ffbCurrentWritePage := ffbRecycleListHead;
        ffbRecycleListHead := ffbRecycleListHead.bpNext;
        ffbCurrentWritePage.bpNext := nil;
        ffbCurrentWritePage.Position := 0;
      end else
        if (ffbMaxPageCount < 1) or (ffbMaxPageCount > ffbPageCount) then
          ffbCurrentWritePage := GetPageClass.Create(Self, aSize);

      if Assigned(ffbCurrentWritePage) then
        ffbCurrentWritePage.bpState := bpsCurrentWritePage;
      Result := ffbCurrentWritePage;
      if not Assigned(ffbCurrentWritePage) then
        ffbCanWrite.ResetEvent
      else begin
        if ffbMaxWriteTime > 0 then
          Result.bpWriteUntil := GetTickCount + ffbMaxWriteTime
        else
          Result.bpWriteUntil := 0;
        Exit;
      end;
    finally
      ffbLock.Leave;
    end;
    if aNoWait then begin
      Result := nil;
      exit;
    end;
    if ffbCanWrite.WaitForever <> wrSignaled then
      raise ETeFiFoError.Create('Error waiting for CanWrite event');
  until false;
end;

procedure TTeFiFoBuffer.Shutdown;
begin
  ffbLock.Enter;
  try
    if not Assigned(ffbCurrentWritePage) then
      if Assigned(ffbUsedListTail) then
        ffbUsedListTail.bpMarker := bmLastBuffer;
    ffbShuttingDown := true;
    ffbDataAvailable.SetEvent;
    ffbCanWrite.SetEvent;
  finally
    ffbLock.Leave;
  end;
end;

{ TTeBufferPage }

procedure TTeBufferPage.Clear;
begin
  bpPosition := 0;
  FillChar(bpMemory^, bpRealSize, 0);
end;

constructor TTeBufferPage.Create(aFiFo: TTeFiFoBuffer; aSize: LongWord);
begin
  inherited Create;
  bpFiFo := aFiFo;
  if aSize = DefaultPageSize then
    bpRealSize := bpFiFo.ffbPageSize
  else
    bpRealSize := aSize;
  GetMem(bpMemory, bpRealSize);
  bpSize := bpRealSize;
  bpFiFo.ffbLock.Enter;
  try
    Inc(bpFiFo.ffbPageCount);
  finally
    bpFiFo.ffbLock.Leave;
  end;
end;

destructor TTeBufferPage.Destroy;
begin
  bpFiFo.ffbLock.Enter;
  try
    Dec(bpFiFo.ffbPageCount);
    if bpFiFo.ffbPageCount <= bpFiFo.ffbMaxPageCount then
      bpFiFo.ffbCanWrite.SetEvent;
  finally
    bpFiFo.ffbLock.Leave;
  end;
  FreeMem(bpMemory);
  inherited;
end;

procedure TTeBufferPage.Finished;
var
  FiFo                        : TTeFiFoBuffer;
begin
  if not Assigned(Self) then
    Exit;

  FiFo := bpFiFo;                                           // local variable is used because instance variable is not available after Free
  case bpState of
    bpsQueued: begin
        FiFo.ffbLock.Enter;
        try
          while Assigned(FiFo.ffbUsedListHead) and (FiFo.ffbUsedListHead <> Self) do
            FiFo.ffbUsedListHead.Finished;

          Assert(FiFo.ffbUsedListHead = Self);
          FiFo.ffbUsedListHead := bpNext;
          if FiFo.ffbUsedListTail = Self then begin
            Assert(FiFo.ffbUsedListHead = nil);
            FiFo.ffbUsedListTail := nil;
            FiFo.ffbDataAvailable.ResetEvent;
          end;

          if (bpRealSize <> FiFo.ffbPageSize) or (FiFo.ffbPageCount > FiFo.ffbMinKeepCount) then
            Free
          else begin
            bpSize := bpRealSize;
            bpMarker := bmNone;
            bpNext := FiFo.ffbRecycleListHead;
            FiFo.ffbRecycleListHead := Self;
            bpState := bpsRecycled;
            bpFiFo.ffbCanWrite.SetEvent;
          end;
        finally
          FiFo.ffbLock.Leave;
        end;
      end;
    bpsCurrentWritePage: begin
        FiFo.ffbLock.Enter;
        try
          Assert(FiFo.ffbCurrentWritePage = Self);
          Assert(not Assigned(bpNext));

          FiFo.ffbCurrentWritePage := nil;

          if Assigned(FiFo.ffbUsedListTail) then begin
            Assert(not Assigned(FiFo.ffbUsedListTail.bpNext));
            FiFo.ffbUsedListTail.bpNext := Self;
          end;
          FiFo.ffbUsedListTail := Self;

          if not Assigned(FiFo.ffbUsedListHead) then
            FiFo.ffbUsedListHead := Self;
          FiFo.ffbDataAvailable.SetEvent;
          bpState := bpsQueued;

          if bpMarker = bmLastBuffer then
            FiFo.Shutdown;
          if FiFo.ffbShuttingDown then
            bpMarker := bmLastBuffer;
        finally
          FiFo.ffbLock.Leave;
        end;
      end;
  else
    raise ETeFiFoError.Create('Invalid page state');
  end;
end;

function TTeBufferPage.bpGetTimeRemaining: Integer;
begin
  if (bpState = bpsCurrentWritePage) and (bpWriteUntil <> 0) then
    Result := Max(0, bpWriteUntil - GetTickCount)
  else
    Result := High(Integer);
end;

function TTeBufferPage.Next(aWaitForData: Boolean): TTeBufferPage;
begin
  repeat
    bpFiFo.ffbLock.Enter;
    try
      if Assigned(bpNext) then begin
        Assert(bpNext.bpState = bpsQueued);
        Result := bpNext;
      end else begin
        bpFiFo.ffbDataAvailable.ResetEvent;
        Result := nil;
      end;
    finally
      bpFiFo.ffbLock.Leave;
    end;
    if Assigned(Result) then
      Exit;
    if not aWaitForData then
      Exit;
    if bpFiFo.ffbShuttingDown then
      raise EAbort.Create('FiFo is shutting down');
    if bpFiFo.ffbDataAvailable.WaitForever <> wrSignaled then
      raise ETeFiFoError.Create('Error waiting for DataAvailable event');
  until false;
end;

function TTeBufferPage.Read(var Buffer; Count: Integer): Longint;
begin
  if (bpPosition >= 0) and (Count > 0) then begin
    Result := bpSize - bpPosition;
    if Result > 0 then begin
      if Result > Count then Result := Count;
      Move(Pointer(Longint(bpMemory) + bpPosition)^, Buffer, Result);
      Inc(bpPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;

function TTeBufferPage.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: bpPosition := Offset;
    soFromCurrent: Inc(bpPosition, Offset);
    soFromEnd: bpPosition := bpSize + Offset;
  end;
  Result := bpPosition;
end;

procedure TTeBufferPage.SetSize(NewSize: Integer);
begin
  bpSize := Max(0, Min(bpSize, NewSize));
end;

function TTeBufferPage.Write(const Buffer; Count: Integer): Longint;
begin
  if (bpPosition >= 0) and (Count > 0) then begin
    if bpPosition + Count > bpRealSize then
      Count := bpRealSize - bpPosition;
    if Count > 0 then begin
      System.Move(Buffer, Pointer(Longint(bpMemory) + bpPosition)^, Count);
      Inc(bpPosition, Count);
      if bpPosition > bpSize then
        bpPosition := bpSize;
      Result := Count;
      Exit;
    end;
  end;
  Result := 0;
end;

end.

