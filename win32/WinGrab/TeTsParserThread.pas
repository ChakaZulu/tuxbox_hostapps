unit TeTsParserThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeFiFo, TeThrd, TeLogableThread;

type
  TTeTsPack = array[0..187] of Byte;

  TTeTsParserThread = class;

  TTePidHandler = class(TObject)
  protected
    phParser      : TTeTsParserThread;
    phPid         : Word;
    phOutput      : TTeFiFoBuffer;
    phOutputPage  : TTeBufferPage;
    phLastCounter : Shortint;
    phSynced      : Boolean;
  public
    constructor Create(aParser: TTeTsParserThread; aPid: Word; aOutput: TTeFiFoBuffer);
    destructor Destroy; override;

    procedure Shutdown;

    procedure Process(const aTsPack: TTeTsPack);
  end;

  TTeTsParserThread = class(TTeLogableThread)
  private
    pptInput: TTeFiFoBuffer;
    pptPidHandler: array of TTePidHandler;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;

    procedure Process(const aTsPack: TTeTsPack); virtual;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer; aVideoID: Integer; aVideoOutput: TTeFiFoBuffer; aAudioIDs: array of Integer; aAudioOutputs: array of TTeFiFoBuffer);
    destructor Destroy; override;
  end;

implementation

{ TTeTsParserThread }

constructor TTeTsParserThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer; aVideoID: Integer; aVideoOutput: TTeFiFoBuffer; aAudioIDs: array of Integer; aAudioOutputs: array of TTeFiFoBuffer);
var
  i: Integer;
begin
  pptInput := aInput;
  pptPidHandler := nil;
  if (aVideoID <> 0) and Assigned(aVideoOutput) then begin
    SetLength(pptPidHandler, Succ(Length(pptPidHandler)));
    pptPidHandler[High(pptPidHandler)] := TTePidHandler.Create(Self, aVideoID, aVideoOutput);
  end;

  for i:= Low(aAudioIDs) to High(aAudioIDs) do
    if (aAudioIDs[i] <> 0) and Assigned(aAudioOutputs[i]) then begin
      SetLength(pptPidHandler, Succ(Length(pptPidHandler)));
      pptPidHandler[High(pptPidHandler)] := TTePidHandler.Create(Self, aAudioIDs[i], aAudioOutputs[i]);
    end;

  inherited Create(aLog, aThreadPriority);
end;

destructor TTeTsParserThread.Destroy;
var
  i: Integer;
begin
  pptInput.Shutdown;
  for i := Low(pptPidHandler) to High(pptPidHandler) do
    pptPidHandler[i].Free;
  inherited;
end;

procedure TTeTsParserThread.DoAfterExecute;
var
  i: Integer;
begin
  pptInput.Shutdown;
  for i := Low(pptPidHandler) to High(pptPidHandler) do
    pptPidHandler[i].Shutdown;
  inherited;
end;

procedure TTeTsParserThread.DoBeforeExecute;
begin
  inherited;
end;

procedure TTeTsParserThread.InnerExecute;
var
  TsPack    : TTeTsPack;
  TsPos     : Byte;
begin
  TsPos:= 0;
  SetState('waiting for first data');
  while not Terminated do
    with pptInput.GetReadPage(true) do try
      repeat
        Inc(TsPos, Read(TsPack[TsPos], SizeOf(TsPack)-TsPos));
        if TsPos = SizeOf(TsPack) then begin
          Process(TsPack);
          TsPos := 0;
        end else
          break;
      until false;
    finally
      Finished;
    end;
end;

procedure TTeTsParserThread.Process(const aTsPack: TTeTsPack);
var
  Pid : Word;
  i   : Integer;
begin
  if aTsPack[0] <> $47 then begin
    LogMessage('sync_byte not found');
    pptInput.Shutdown;
    Abort;
  end;
  WordRec(Pid).Hi := aTsPack[1] and $1F;
  WordRec(Pid).Lo := aTsPack[2];
  for i:= Low(pptPidHandler) to High(pptPidHandler) do
    if pptPidHandler[i].phPid = Pid then begin
      pptPidHandler[i].Process(aTsPack);
      break;
  end;
end;

{ TTePidHandler }

constructor TTePidHandler.Create(aParser: TTeTsParserThread; aPid: Word; aOutput: TTeFiFoBuffer);
begin
  phParser := aParser;
  phPid := aPid;
  phOutput := aOutput;
end;

destructor TTePidHandler.Destroy;
begin
  Shutdown;
  inherited;
end;

procedure TTePidHandler.Process(const aTsPack: TTeTsPack);
var
  Counter      : Shortint;
  PayLoadStart : Byte;
begin
  if (aTSPack[3] and $10) = 0 then
    Exit;

  Counter := aTSPack[3] and $0F;
  if phLastCounter=Counter then begin
    phParser.LogMessage('PID[' + IntToHex(phPid, 4) + ']: duplicated pack, ignored');
    Exit;
  end;
  phLastCounter := Counter;

  if not phSynced then
    if aTSPack[1] and $40 = $40 then begin
      phParser.LogMessage('PID[' + IntToHex(phPid, 4) + ']: payload start found, synced');
      phSynced := True
    end else
      Exit;

  PayLoadStart := 4;
  if (aTSPack[3] and $20) = $20 then begin
    Inc(PayLoadStart);
    Inc(PayLoadStart, aTSPack[4]);
  end;

  while 188-PayLoadStart > 0 do begin
    if not assigned(phOutputPage) then
      phOutputPage := phOutput.GetWritePage;
    Inc(PayLoadStart, phOutputPage.Write(aTsPack[PayLoadStart], 188-PayLoadStart));
    if PayLoadStart < 188 then begin
      phOutputPage.Finished;
      phOutputPage := nil;
    end;
  end;
end;

procedure TTePidHandler.Shutdown;
begin
  if Assigned(phOutputPage) then begin
    phOutputPage.Finished;
    phOutputPage:= nil;
  end;
  phOutput.Shutdown;
end;

end.

