unit TeTCPStreamThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeThrd, TeSocket, TeFiFo, TeLogableThread;

type
  TTeTCPStreamThread = class(TTeLogableThread)
  private
    tstIp: string;
    tstPort: Word;
    tstFiFo: TTeFiFoBuffer;
    tstSocket: TTeClientSocket;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aFiFo: TTeFiFoBuffer);
    destructor Destroy; override;
  end;

implementation

uses
  Windows, Math;

{ TTeTCPStreamThread }

constructor TTeTCPStreamThread.Create(aLog: ILog;
  aThreadPriority: TThreadPriority; const aIp: string; aPort: Word; aFiFo: TTeFiFoBuffer);
begin
  tstIp := aIp;
  tstPort := aPort;
  tstFiFo := aFiFo;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeTCPStreamThread.Destroy;
begin
  tstFiFo.Shutdown;
  inherited;
end;

procedure TTeTCPStreamThread.DoAfterExecute;
begin
  tstFiFo.Shutdown;
  FreeAndNil(tstSocket);
end;

procedure TTeTCPStreamThread.DoBeforeExecute;
var
  s                           : string;
begin
  tstSocket := TTeClientSocket.Create;
  try
    tstSocket.Address := tstIp;
    tstSocket.Port := tstPort;
    tstSocket.Active := true;
    with TTeWinSocketStream.Create(tstSocket.Socket, 5000) do
      Free;
  except
    FreeAndNil(tstSocket);
    raise;
  end;
end;

procedure TTeTCPStreamThread.InnerExecute;
var
  BytesWritten                : Integer;
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
  Stream := TTeWinSocketStream.Create(tstSocket.Socket, -1);
  try
    while not Terminated do begin
      QueryPerformanceCounter(StartCounter);
      with tstFiFo.GetReadPage(True) do try
        PageSize := Size;
        WritePos := Memory;
        BytesRemaining := Size;
        while not Terminated and (BytesRemaining > 0) do begin
          BytesWritten := Stream.Write(WritePos^, BytesRemaining);
          if BytesWritten = 0 then
            raise ETeError.Create('Could not write to socket');
          Dec(BytesRemaining, BytesWritten);
          if BytesRemaining > 0 then
            Inc(WritePos, BytesWritten);
        end;
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

end.

