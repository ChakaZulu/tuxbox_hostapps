unit TeProcessManager;

interface

uses
  Windows, Messages,
  Classes, SysUtils, TeLogableThread;

const
  TE_MESSAGE                  = WM_USER + 1;
  TE_STATE                    = WM_USER + 2;

type
  TTeProcessManager = class;

  TMessageCallback = procedure(aSender: TTeProcessManager; const aMessage: string) of object;
  TStateCallback = procedure(aSender: TTeProcessManager; const aName, aState: string) of object;

  TTeProcessManager = class(TObject)
  private
    pmHandle: THandle;
    pmMessageCallback: TMessageCallback;
    pmStateCallback: TStateCallback;
    procedure TeMessage(var Message: TMessage); message TE_MESSAGE;
    procedure TeState(var Message: TMessage); message TE_STATE;
  protected
    procedure DoMessage(aMsg: string); virtual;
    procedure DoState(aName, aState: string); virtual;
    procedure WndProc(var Message: TMessage); virtual;
    function PerformSend(Msg: Cardinal; WParam, LParam: Longint): Longint;
    procedure PerformPost(Msg: Cardinal; WParam, LParam: Longint);
    function AllocateLog(aLogName: string): ILog;
  public
    constructor Create(aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;

    procedure DefaultHandler(var Message); override;
  end;

implementation

uses
  Forms;

type
  TLogImpl = class(TInterfacedObject, ILog)
  private
    liProcessManager: TTeProcessManager;
    liLogName: string;
  protected
    procedure LogMessage(aMsg: string);
    procedure SetState(aState: string);
  public
    constructor Create(aProcessManager: TTeProcessManager; aLogName: string);
  end;

  { TTeProcessManager }

function TTeProcessManager.AllocateLog(aLogName: string): ILog;
begin
  Result := TLogImpl.Create(Self, aLogName);
end;

constructor TTeProcessManager.Create(aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
begin
  pmMessageCallback := aMessageCallback;
  pmHandle := AllocateHWnd(WndProc);
  pmStateCallback := aStateCallback;
  inherited Create;
end;

procedure TTeProcessManager.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(pmHandle, Msg, wParam, lParam);
end;

destructor TTeProcessManager.Destroy;
begin
  inherited;
  if pmHandle <> 0 then
    DeallocateHWnd(pmHandle);
end;

procedure TTeProcessManager.DoMessage(aMsg: string);
begin
  PerformPost(TE_MESSAGE, Integer(StrPCopy(StrAlloc(Length(aMsg) + 1), aMsg)), 0);
end;

procedure TTeProcessManager.DoState(aName, aState: string);
begin
  PerformPost(TE_STATE, Integer(StrPCopy(StrAlloc(Length(aName) + 1), aName)), Integer(StrPCopy(StrAlloc(Length(aState) + 1), aState)));
end;

function TTeProcessManager.PerformSend(Msg: Cardinal; WParam,
  LParam: Integer): Longint;
begin
  Result := SendMessage(pmHandle, Msg, wParam, lParam);
end;

procedure TTeProcessManager.PerformPost(Msg: Cardinal; WParam,
  LParam: Integer);
begin
  if not PostMessage(pmHandle, Msg, wParam, lParam) then
    SendMessage(pmHandle, Msg, wParam, lParam);
end;

procedure TTeProcessManager.TeMessage(var Message: TMessage);
var
  hMsg                        : PChar;
begin
  if Assigned(pmMessageCallback) then begin
    hMsg := PChar(Message.wParam);
    if assigned(hMsg) then try
      pmMessageCallback(Self, hMsg);
    finally
      StrDispose(hMsg);
    end;
  end;
end;

procedure TTeProcessManager.TeState(var Message: TMessage);
var
  hName, hState               : PChar;
begin
  hName := PChar(Message.wParam);
  hState := PChar(Message.lParam);
  if assigned(hName) or assigned(hState) then try
    if assigned(pmStateCallback) then
      pmStateCallback(Self, hName, hState);
  finally
    StrDispose(hName);
    StrDispose(hState);
  end;
end;

procedure TTeProcessManager.WndProc(var Message: TMessage);
begin
  Dispatch(Message);
end;

{ TLogImpl }

constructor TLogImpl.Create(aProcessManager: TTeProcessManager;
  aLogName: string);
begin
  liProcessManager := aProcessManager;
  liLogName := aLogName;
  inherited Create;
end;

procedure TLogImpl.LogMessage(aMsg: string);
begin
  liProcessManager.DoMessage(Format('[%s] %s', [liLogName, aMsg]));
end;

procedure TLogImpl.SetState(aState: string);
begin
  liProcessManager.DoState(liLogName, aState);
end;

end.

