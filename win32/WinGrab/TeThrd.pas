unit TeThrd;

interface

uses
  Windows, Messages,
  Classes, SysUtils,
  TeBase,
  JclSynch;

resourcestring
  rsFailureWaitingForThread        = 'Failure waiting for thread';
  rsTlsCannotAlloc                 = 'Cannot allocate TLS';

type
  PLongBool = ^LongBool;

  ETeTlsBuffer = class(ETeError);

  { TTeTlsBuffer }
  TTeTlsBuffer = class(TObject)
  protected                                                 {private}
    tbBlocks: TList;
    tbSize: Integer;
    tbTlsIndex: Integer;
    function GetMemory: Pointer;
    function GetTlsValue: Pointer;
    class procedure AddTlsBuffer(aTlsBuffer: TTeTlsBuffer);
    class procedure RemoveTlsBuffer(aTlsBuffer: TTeTlsBuffer);
  protected
    function AllocMemory(aSize: Integer): Pointer;
    procedure DoDetachThreadInternal;
    procedure FreeMemory(p: Pointer);
    procedure InitializeMem(p: Pointer); virtual;
    procedure FinalizeMem(p: Pointer); virtual;
    function IsNeeded(Memory: Pointer): Boolean; virtual;
    property TlsValue: Pointer read GetTlsValue;
  public
    constructor Create(aSize: Integer);
    destructor Destroy; override;
    procedure Clear;
    procedure CheckNeeded;
    class procedure DoDetachThread;
    property Memory: Pointer read GetMemory;
    property Size: Integer read tbSize;
    property TlsIndex: Integer read tbTlsIndex;
  end;

  ETeThread = class(EThread);

  TTeThread = class(TThread)
  protected
    procedure DoExecute; virtual;
    procedure DoHandleException(Sender: TObject); virtual;
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; aThreadPriority: TThreadPriority = tpNormal);
  end;

  ETeInitThread = class(ETeThread);

  TTeInitThread = class(TTeThread)
  protected                                                 {private}
    itInitSemaphore: THandle;
    itInitException: TObject;
    procedure WaitForInit;
  protected
    procedure DoBeforeExecute; virtual;
    procedure DoAfterExecute; virtual;

    procedure DoExecute; override;
    procedure InnerExecute; virtual;
  public
    constructor Create(aThreadPriority: TThreadPriority);
    destructor Destroy; override;
  end;

  ETeWaitThread = class(ETeInitThread);

  TTeWaitThread = class(TTeInitThread)
  protected                                                 {private}
    wtWaiting: Boolean;
    wtWaitSemaphore: THandle;
    procedure WaitForExit;
  protected
    procedure DoAfterExecute; override;
  public
    constructor Create(aThreadPriority: TThreadPriority);
    destructor Destroy; override;
    procedure AllowExit;
    property Waiting: Boolean read wtWaiting;
  end;

  ETeMessageThread = class(ETeInitThread);

  TTeMessageThread = class(TTeInitThread)
  protected                                                 {private}
    mtHandle: THandle;

    function ProcessMessage(var Msg: TMsg): Boolean;
    procedure Idle(const Msg: TMsg);
    procedure HandleMessage;
  protected
    procedure WndProc(var Message: TMessage); virtual;

    procedure DoAfterMessage(const Msg: TMsg; const RetValue: Integer); virtual;
    procedure DoBeforeMessage(var Msg: TMsg; var Handled: Boolean); virtual;
    procedure DoIdle(const Msg: TMsg; var Done: Boolean); virtual;

    procedure DoExecute; override;
    procedure InnerExecute; override;
  public
    destructor Destroy; override;

    procedure DefaultHandler(var Message); override;

    function PerformSend(Msg: Cardinal; wParam, lParam: LongInt): LongInt;
    procedure PerformPost(Msg: Cardinal; wParam, lParam: LongInt);

    procedure PostThreadMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
    procedure PostQuitMessage;
    procedure WaitForQuit;

    property Handle: THandle read mtHandle;
  end;

procedure TeProcessThreaded(aSender: TObject; aEvent: TNotifyEvent;
  aThreadPriority: TThreadPriority);

implementation

uses
  Forms, RTLConsts;

var
  _TlsBuffers                      : TList;
  _TlsLock                         : TRTLCriticalSection;

function ListAdd(var List: TList; Item: Pointer): Pointer;
begin
  if List = nil then List := TList.Create;
  List.Add(Item);
  Result := Item;
end;

procedure ListError(Index: Integer);
begin
  raise EListError.Create(SListIndexError);
end;

function ListItem(List: TList; Index: Integer): Pointer;
begin
  if Assigned(List) then
    Result := List[Index]
  else begin
    Result := nil;
    ListError(Index);
  end;
end;

procedure ListDestroy(var List: TList);
begin
  if Assigned(List) then begin
    List.Free;
    List := nil;
  end;
end;

function ListDelete(var List: TList; Index: Integer): Pointer;
begin
  Result := ListItem(List, Index);
  List.Delete(Index);
  if List.Count = 0 then ListDestroy(List);
end;

function ListRemove(var List: TList; Item: Pointer): Pointer;
var
  i                                : Integer;
begin
  if Assigned(List) then begin
    i := List.IndexOf(Item);
    if i >= 0 then begin
      Result := ListDelete(List, i);
      Exit;
    end;
  end;
  Result := nil;
end;

{ TTeTlsBuffer }

constructor TTeTlsBuffer.Create(aSize: Integer);
begin
  inherited Create;
  AddTlsBuffer(Self);
  tbSize := aSize;
  tbTlsIndex := TlsAlloc;
  if tbTlsIndex < 0 then
    raise ETeTlsBuffer.Create(rsTlsCannotAlloc);
end;

destructor TTeTlsBuffer.Destroy;
begin
  EnterCriticalSection(_TlsLock);
  try
    while Assigned(tbBlocks) and (tbBlocks.Count > 0) do
      FreeMemory(tbBlocks[0]);
  finally
    LeaveCriticalSection(_TlsLock);
  end;

  if (tbTlsIndex >= 0) then TlsFree(tbTlsIndex);
  RemoveTlsBuffer(Self);
  inherited;
end;

procedure TTeTlsBuffer.DoDetachThreadInternal;
begin
  FreeMemory(GetTlsValue);
end;

class procedure TTeTlsBuffer.DoDetachThread;
var
  i                                : Integer;
begin
  if Assigned(_TlsBuffers) then begin
    EnterCriticalSection(_TlsLock);
    try
      for i := 0 to _TlsBuffers.Count - 1 do
        TTeTlsBuffer(_TlsBuffers.Items[i]).DoDetachThreadInternal;
    finally
      LeaveCriticalSection(_TlsLock);
    end;
  end;
end;

function TTeTlsBuffer.GetMemory: Pointer;
var
  Init                             : PLongBool;
begin
  EnterCriticalSection(_TlsLock);
  try
    Result := GetTlsValue;
    if not Assigned(Result) then begin
      Result := AllocMemory(Size);
      try
        ListAdd(tbBlocks, Result);
      except
        FreeMemory(Result);
        raise;
      end;
      TlsSetValue(tbTlsIndex, Result);
    end
    else begin
      Init := Result;
      Dec(Init);
      if not Init^ then
        InitializeMem(Result);
    end;
  finally
    LeaveCriticalSection(_TlsLock);
  end;
end;

function TTeTlsBuffer.GetTlsValue: Pointer;
begin
  Result := TlsGetValue(tbTlsIndex);
end;

function TTeTlsBuffer.AllocMemory(aSize: Integer): Pointer;
begin
  Result := AllocMem(aSize + SizeOf(LongBool));
  Inc(PLongBool(Result));
  InitializeMem(Result);
end;

procedure TTeTlsBuffer.FreeMemory(p: Pointer);
var
  Init                             : PLongBool;
begin
  if Assigned(p) then begin
    EnterCriticalSection(_TlsLock);
    try
      ListRemove(tbBlocks, p);
      Init := p;
      Dec(Init);
      if Init^ then
        FinalizeMem(p);
      Dec(PLongBool(p));
      FreeMem(p);
    finally
      LeaveCriticalSection(_TlsLock);
    end;
  end;
end;

class procedure TTeTlsBuffer.AddTlsBuffer(aTlsBuffer: TTeTlsBuffer);
begin
  ListAdd(_TlsBuffers, aTlsBuffer);
  if _TlsBuffers.Count = 1 then
    InitializeCriticalSection(_TlsLock);
end;

class procedure TTeTlsBuffer.RemoveTlsBuffer(aTlsBuffer: TTeTlsBuffer);
begin
  ListRemove(_TlsBuffers, aTlsBuffer);
  if not Assigned(_TlsBuffers) then
    DeleteCriticalSection(_TlsLock);
end;

procedure TTeTlsBuffer.FinalizeMem(p: Pointer);
var
  Init                             : PLongBool;
begin
  Init := p;
  Dec(Init);
  Init^ := False;
end;

procedure TTeTlsBuffer.InitializeMem(p: Pointer);
var
  Init                             : PLongBool;
begin
  Init := p;
  Dec(Init);
  Init^ := True;
end;

procedure TTeTlsBuffer.Clear;
var
  i                                : Integer;
begin
  EnterCriticalSection(_TlsLock);
  try
    if Assigned(tbBlocks) then
      for i := 0 to Pred(tbBlocks.Count) do
        if Assigned(tbBlocks[i]) then
          FinalizeMem(tbBlocks[i]);
  finally
    LeaveCriticalSection(_TlsLock);
  end;
end;

procedure TTeTlsBuffer.CheckNeeded;
var
  p                                : Pointer;
  Init                             : PLongBool;
begin
  EnterCriticalSection(_TlsLock);
  try
    p := TlsValue;
    if not Assigned(p) then Exit;
    Init := p;
    Dec(Init);
    if not Init^ then Exit;
    if not IsNeeded(p) then
      FinalizeMem(p);
  finally
    LeaveCriticalSection(_TlsLock);
  end;
end;

function TTeTlsBuffer.IsNeeded(Memory: Pointer): Boolean;
begin
  Result := True;
end;

{ TTeThread }

constructor TTeThread.Create(CreateSuspended: Boolean;
  aThreadPriority: TThreadPriority);
begin
  inherited Create(True);
  Priority := aThreadPriority;
  if not CreateSuspended then
    Resume;
end;

procedure TTeThread.DoExecute;
begin

end;

procedure TTeThread.DoHandleException(Sender: TObject);
begin

end;

procedure TTeThread.Execute;
begin
  try
    DoExecute;
  except
    DoHandleException(Self);
  end;
  TTeTlsBuffer.DoDetachThread;
end;

{ TTeMessageThread }

procedure TTeMessageThread.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(mtHandle, Msg, wParam, lParam);
end;

destructor TTeMessageThread.Destroy;
begin
  WaitForQuit;
  inherited;
end;

procedure TTeMessageThread.DoAfterMessage(const Msg: TMsg;
  const RetValue: Integer);
begin

end;

procedure TTeMessageThread.DoBeforeMessage(var Msg: TMsg;
  var Handled: Boolean);
begin

end;

type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;

procedure TTeMessageThread.DoExecute;
begin
  mtHandle := AllocateHWnd(WndProc);
  try
    inherited;
  finally
    DeallocateHWnd(mtHandle);
  end;
end;

procedure TTeMessageThread.DoIdle(const Msg: TMsg; var Done: Boolean);
begin

end;

procedure TTeMessageThread.HandleMessage;
var
  Msg                              : TMsg;
begin
  if not ProcessMessage(Msg) then Idle(Msg);
end;

procedure TTeMessageThread.Idle(const Msg: TMsg);
var
  Done                             : Boolean;
begin
  Done := true;
  try
    DoIdle(Msg, Done);
  except
    DoHandleException(Self);
    Done := true;
  end;
  if Done then WaitMessage;
end;

function TTeMessageThread.PerformSend(Msg: Cardinal; wParam,
  lParam: Integer): LongInt;
begin
  Result := 0;
  if Assigned(Self) then Result := SendMessage(mtHandle, Msg, wParam, lParam);
end;

procedure TTeMessageThread.PerformPost(Msg: Cardinal; wParam,
  lParam: Integer);
begin
  if Assigned(Self) then PostMessage(mtHandle, Msg, wParam, lParam);
end;

procedure TTeMessageThread.PostQuitMessage;
begin
  Self.PostThreadMessage(WM_QUIT, 0, 0);
end;

procedure TTeMessageThread.PostThreadMessage(Msg: UINT; wParam: WPARAM;
  lParam: LPARAM);
begin
  Windows.PostThreadMessage(ThreadID, Msg, wParam, lParam);
end;

function TTeMessageThread.ProcessMessage(var Msg: TMsg): Boolean;
var
  Handled                          : Boolean;
  RetValue                         : LongInt;
begin
  Result := false;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then begin
    Result := true;
    if Msg.Message <> WM_QUIT then begin
      Handled := false;
      try
        DoBeforeMessage(Msg, Handled);
      except
        DoHandleException(Self);
      end;
      if not Handled then begin
        TranslateMessage(Msg);                              // do we need this ?!
        RetValue := DispatchMessage(Msg);
        try
          DoAfterMessage(Msg, RetValue);
        except
          DoHandleException(Self);
        end;
      end;
    end
    else
      Terminate;
  end;
end;

procedure TTeMessageThread.WaitForQuit;
begin
  if not (Terminated or Suspended) then begin
    PostQuitMessage;
    Terminate;
    WaitFor;
  end;
end;

procedure TTeMessageThread.WndProc(var Message: TMessage);
begin
  Dispatch(Message);
end;

procedure TTeMessageThread.InnerExecute;
begin
  while not Terminated do
    HandleMessage;
end;

{ TTeInitThread }

constructor TTeInitThread.Create(aThreadPriority: TThreadPriority);
begin
  itInitSemaphore := CreateSemaphore(nil, 0, 1, nil);
  inherited Create(False, aThreadPriority);
  WaitForInit;
end;

destructor TTeInitThread.Destroy;
begin
  inherited;
end;

procedure TTeInitThread.DoAfterExecute;
begin

end;

procedure TTeInitThread.DoBeforeExecute;
begin

end;

procedure TTeInitThread.DoExecute;
begin
  try
    DoBeforeExecute;
  except
    Terminate;
    if RaiseList <> nil then begin
      itInitException := PRaiseFrame(RaiseList)^.ExceptObject;
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end;
  end;
  ReleaseSemaphore(itInitSemaphore, 1, nil);
  if not Terminated then try
    InnerExecute;
  finally
    DoAfterExecute;
  end;
end;

procedure TTeInitThread.InnerExecute;
begin

end;

procedure TTeInitThread.WaitForInit;
var
  E                                : TObject;
  Msg                              : TMsg;
begin
  try
    // the use of MsgWaitForMultipleObjects prevents the message queue from blocking...
    if GetCurrentThreadID = MainThreadID then
      while MsgWaitForMultipleObjects(1, itInitSemaphore, False, INFINITE,
        QS_SENDMESSAGE) = WAIT_OBJECT_0 + 1 do PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE)
    else WaitForSingleObject(itInitSemaphore, INFINITE);
    if Assigned(itInitException) then begin
      E := itInitException;
      itInitException := nil;
      raise E;
    end;
  finally
    CloseHandle(itInitSemaphore);                           // don't need it after this point
  end;
end;

{ TTeWaitThread }

procedure TTeWaitThread.AllowExit;
begin
  ReleaseSemaphore(wtWaitSemaphore, 1, nil);
end;

constructor TTeWaitThread.Create(aThreadPriority: TThreadPriority);
begin
  wtWaitSemaphore := CreateSemaphore(nil, 0, 1, nil);
  inherited Create(aThreadPriority);
end;

destructor TTeWaitThread.Destroy;
begin
  AllowExit;
  inherited;
  CloseHandle(wtWaitSemaphore);                             // can't release before the thread has really exited
end;

procedure TTeWaitThread.DoAfterExecute;
begin
  WaitForExit;
end;

procedure TTeWaitThread.WaitForExit;
var
  Msg                              : TMsg;
begin
  wtWaiting := True;
  // the use of MsgWaitForMultipleObjects prevents the message queue from blocking...
  while MsgWaitForMultipleObjects(1, wtWaitSemaphore, False, INFINITE,
    QS_SENDMESSAGE) = WAIT_OBJECT_0 + 1 do PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
end;

type
  TTeWorkerThread = class(TTeThread)
  private
    wtSender: TObject;
    wtEvent: TNotifyEvent;
  protected
    procedure DoExecute; override;
  public
    constructor Create(aSender: TObject; aEvent: TNotifyEvent; aThreadPriority: TThreadPriority);
  end;

  { TTeWorkerThread }

constructor TTeWorkerThread.Create(aSender: TObject; aEvent: TNotifyEvent;
  aThreadPriority: TThreadPriority);
begin
  wtSender := aSender;
  wtEvent := aEvent;
  FreeOnTerminate := True;
  inherited Create(False, aThreadPriority);
end;

procedure TTeWorkerThread.DoExecute;
begin
  wtEvent(wtSender);
end;

procedure TeProcessThreaded(aSender: TObject; aEvent: TNotifyEvent;
  aThreadPriority: TThreadPriority);
begin
  TTeWorkerThread.Create(aSender, aEvent, aThreadPriority);
end;

end.

