unit TeLogableThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeThrd, TeSocket, TeFiFo;

type
  ILog = interface(IUnknown)
    ['{D19A571F-98CF-48F3-A960-EEAC2C71D1D9}']
    procedure LogMessage(aMsg: string);
    procedure SetState(aState: string);
  end;

  TTeLogableThread = class(TTeInitThread)
  protected
    ltLog: ILog;
    procedure LogMessage(aMsg: string);
    procedure SetState(aState: string);

    procedure Execute; override;
    procedure DoHandleException(Sender: TObject); override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority);
  end;

implementation

{ TTeLogableThread }

constructor TTeLogableThread.Create(aLog: ILog;
  aThreadPriority: TThreadPriority);
begin
  ltLog := aLog;
  inherited Create(aThreadPriority);
end;

procedure TTeLogableThread.DoHandleException(Sender: TObject);
begin
  if ExceptObject is EAbort then
    Exit;
  if ExceptObject is Exception then
    with Exception(ExceptObject) do
      LogMessage(Format('abnormal thread termination (%s: %s)', [ClassName, Message]));
end;

procedure TTeLogableThread.Execute;
begin
  LogMessage('started');
  SetState('started');
  try
    inherited;
  finally
    SetState('terminated');
    LogMessage('terminated');
  end;
end;

procedure TTeLogableThread.LogMessage(aMsg: string);
begin
  if Assigned(ltLog) then
    ltLog.LogMessage(aMsg);
end;

procedure TTeLogableThread.SetState(aState: string);
begin
  if Assigned(ltLog) then
    ltLog.SetState(aState);
end;

end.

