unit WinGrabReader;

interface

uses
  SysUtils,
  ComObj,
  ActiveX,
  WinGrabEngine_TLB,
  StdVcl,
  TeFiFo;

type
  TWinGrabReader = class(TAutoObject, IWinGrabReader)
  private
    wgrOutput: TTeBufferPage;
    wgrOutputStream: TTeFiFoBuffer;
  protected
    function ReadData(aDest, aMaxSize: Integer): Integer; safecall;
    procedure WaitForData; safecall;
    { Protected-Deklarationen }
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses
  ComServ,
  Contnrs,
  TePesMuxerThread;

destructor TWinGrabReader.Destroy;
begin
  inherited;
  _OutputStreamLock.Enter;
  try
    if Assigned(_OutputStream) then begin
      _OutputStream.Remove(wgrOutputStream);
      if _OutputStream.Count < 1 then
        FreeAndNil(_OutputStream);
    end;
  finally
    _OutputStreamLock.Leave;
  end;
  FreeAndNil(wgrOutputStream);
end;

procedure TWinGrabReader.Initialize;
begin
  inherited;
  _OutputStreamLock.Enter;
  try
    wgrOutputStream := TTeFiFoBuffer.Create(0, 0, 30);
    if not assigned(_OutputStream) then
      _OutputStream := TObjectList.Create;
    _OutputStream.Add(wgrOutputStream);
  finally
    _OutputStreamLock.Leave;
  end;
end;

function TWinGrabReader.ReadData(aDest, aMaxSize: Integer): Integer;
begin
  Result := 0;
  if not assigned(wgrOutput) then begin
    wgrOutput := wgrOutputStream.GetReadPage(False);
    if not assigned(wgrOutput) then
      exit;
    wgrOutput.Position := 0;
  end;

  Result := wgrOutput.Read(Pointer(aDest)^, aMaxSize);

  if wgrOutput.Position = wgrOutput.Size then begin
    wgrOutput.Finished;
    wgrOutput := nil;
  end;
end;

procedure TWinGrabReader.WaitForData;
begin
  if not assigned(wgrOutput) then begin
    wgrOutput := wgrOutputStream.GetReadPage(True);
    if assigned(wgrOutput) then
      wgrOutput.Position := 0;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWinGrabReader, Class_WinGrabReader,
    ciInternal, tmApartment);
end.

