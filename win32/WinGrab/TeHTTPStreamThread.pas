unit TeHTTPStreamThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeThrd, TeSocket, TeFiFo, TeLogableThread;

type
  TTeHTTPStreamThread = class(TTeLogableThread)
  private
    hstIp: string;
    hstPort: Word;
    hstDoc: string;
    hstFiFo: TTeFiFoBuffer;
    hstSocket: TTeClientSocket;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aDoc: string; aFiFo: TTeFiFoBuffer);
    destructor Destroy; override;
  end;

  TTeHTTPPesStreamThread = class(TTeHTTPStreamThread)
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aPid: Integer; aFiFo: TTeFiFoBuffer);
  end;

  TTeHTTPSecStreamThread = class(TTeHTTPStreamThread)
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aPid: Integer; aTable, aMask: Byte; aFiFo: TTeFiFoBuffer);
  end;

implementation

uses
  Windows, Math;

{ TTeHTTPStreamThread }

constructor TTeHTTPStreamThread.Create(aLog: ILog;
  aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aDoc: string; aFiFo: TTeFiFoBuffer);
begin
  hstIp := aIp;
  hstPort := aPort;
  hstDoc := aDoc;
  hstFiFo := aFiFo;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeHTTPStreamThread.Destroy;
begin
  hstFiFo.Shutdown;
  inherited;
end;

procedure TTeHTTPStreamThread.DoAfterExecute;
begin
  hstFiFo.Shutdown;
  FreeAndNil(hstSocket);
end;

procedure TTeHTTPStreamThread.DoBeforeExecute;
var
  s                           : string;
begin
  hstSocket := TTeClientSocket.Create;
  try
    hstSocket.Address := hstIp;
    hstSocket.Port := hstPort;
    hstSocket.Active := true;
    with TTeWinSocketStream.Create(hstSocket.Socket, 5000) do try
      WriteString(Format('GET /%s HTTP/1.0'#10#13#10#13, [hstDoc]));
      s := ReadString;
      if Pos('200', s) < 1 then
        raise ETeError.Create('Invalid reply from Server: ' + s);
      repeat s := ReadString;
      until s = '';
    finally
      Free;
    end;
  except
    FreeAndNil(hstSocket);
    raise;
  end;
end;

procedure TTeHTTPStreamThread.InnerExecute;
var
  BytesRead                   : Integer;
  BytesRemaining              : Integer;
  WritePos                    : PChar;
  Stream                      : TTeWinSocketStream;
  StartCounter                : Int64;
  EndCounter                  : Int64;
  CounterFreq                 : Int64;
  Time                        : Double;
  PageSize                    : Integer;
  DataRates                   : array[0..4] of Double;
  DataRate                    : Double;
  i, j                        : Integer;
begin
  FillChar(DataRates, SizeOf(DataRates), 0);
  QueryPerformanceFrequency(CounterFreq);
  SetState('waiting for first data');
  LogMessage('HTTP streaming started successfully');
  Stream := TTeWinSocketStream.Create(hstSocket.Socket, 5000);
  try
    while not Terminated do begin
      QueryPerformanceCounter(StartCounter);
      with hstFiFo.GetWritePage do try
        PageSize := Size;
        WritePos := Memory;
        BytesRemaining := Size;
        while not Terminated and (BytesRemaining > 0) and Stream.WaitForData(Min(5000, TimeRemaining)) do begin
          BytesRead := Stream.Read(WritePos^, BytesRemaining);
          if BytesRead = 0 then
            raise ETeError.Create('Could not read from socket');
          Dec(BytesRemaining, BytesRead);
          if BytesRemaining > 0 then
            Inc(WritePos, BytesRead);
          if TimeRemaining < 1 then
            break;
        end;
        PageSize := PageSize - BytesRemaining;
        Size := PageSize;
      finally
        Finished;
      end;
      QueryPerformanceCounter(EndCounter);

      Time := (EndCounter - StartCounter) / CounterFreq;

      Move(DataRates[1], DataRates[0], SizeOf(Double) * (Length(DataRates) - 1));
      DataRates[High(DataRates)] := PageSize / Time;

      DataRate := 0;
      j := 0;
      for i := High(DataRates) downto Low(DataRates) do begin
        if DataRates[i] = 0 then break;
        DataRate := DataRate + DataRates[i];
        Inc(j);
      end;

      if j > 0 then
        DataRate := ((DataRate / j) * 8) / 1024;

      SetState(IntToStr(Trunc(DataRate)) + ' kBit/s');
    end;
  finally
    FreeAndNil(Stream);
  end;
end;

{ TTeHTTPPesStreamThread }

constructor TTeHTTPPesStreamThread.Create(aLog: ILog;
  aThreadPriority: TThreadPriority; const aIp: string; aPort: Word;
  aPid: Integer; aFiFo: TTeFiFoBuffer);
begin
  inherited Create(aLog, aThreadPriority, aIp, aPort, Format('0x%x', [aPid]), aFiFo);
end;

{ TTeHTTPSecStreamThread }

constructor TTeHTTPSecStreamThread.Create(aLog: ILog;
  aThreadPriority: TThreadPriority; const aIp: string; aPort: Word;
  aPid: Integer; aTable, aMask: Byte; aFiFo: TTeFiFoBuffer);
begin
  inherited Create(aLog, aThreadPriority, aIp, aPort, Format('%04x %02x %02x', [aPid, aTable, aMask]), aFiFo);
end;

end.

