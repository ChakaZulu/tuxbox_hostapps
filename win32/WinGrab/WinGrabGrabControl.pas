unit WinGrabGrabControl;

interface

uses
  ComObj, ActiveX, WinGrabEngine_TLB, StdVcl, TeProcessManager;

type
  TWinGrabCallbackHandler = class(TObject)
  private
    chCallback: IWinGrabProcessCallback;
  public
    constructor Create(aCallback: IWinGrabProcessCallback);
    procedure OnMessage(aSender: TTeProcessManager; const aMessage: string);
    procedure OnStateChange(aSender: TTeProcessManager; const aName, aState: string);
  end;

  TWinGrabGrabControl = class(TAutoObject, IWinGrabGrabControl)
  private
    gcProcessManager: TTeProcessManager;
    gcCallbackHandler: TWinGrabCallbackHandler;
  protected
    procedure Stop; safecall;
    function CreateReader: IWinGrabReader; safecall;
    { Protected-Deklarationen }
  public
    constructor Create(aProcessManager: TTeProcessManager; aCallbackHandler: TWinGrabCallbackHandler);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  ComServ,
  WinGrabReader;

constructor TWinGrabGrabControl.Create(aProcessManager: TTeProcessManager; aCallbackHandler: TWinGrabCallbackHandler);
begin
  gcProcessManager := aProcessManager;
  gcCallbackHandler := aCallbackHandler;
  inherited Create;
end;

destructor TWinGrabGrabControl.Destroy;
begin
  Stop;
  inherited;
end;

procedure TWinGrabGrabControl.Stop;
begin
  FreeAndNil(gcProcessManager);
  FreeAndNil(gcCallbackHandler);
end;

{ TWinGrabCallbackHandler }

constructor TWinGrabCallbackHandler.Create(
  aCallback: IWinGrabProcessCallback);
begin
  chCallback := aCallback;
  inherited Create;
end;

procedure TWinGrabCallbackHandler.OnMessage(aSender: TTeProcessManager;
  const aMessage: string);
begin
  chCallback.OnMessage(aMessage);
end;

procedure TWinGrabCallbackHandler.OnStateChange(aSender: TTeProcessManager;
  const aName, aState: string);
begin
  chCallback.OnStateChange(aName, aState);
end;

function TWinGrabGrabControl.CreateReader: IWinGrabReader;
begin
  Result := TWinGrabReader.Create;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWinGrabGrabControl, Class_WinGrabGrabControl,
    ciInternal, tmApartment);
end.

