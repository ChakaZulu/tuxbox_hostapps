////////////////////////////////////////////////////////////////////////////////
//
// $Log: ShutDownDlg.pas,v $
// Revision 1.4  2004/12/03 16:09:49  thotto
// - Bugfixes
// - EPG suchen überarbeitet
// - Timerverwaltung geändert
// - Ruhezustand / Standby gefixt
//
// Revision 1.3  2004/10/15 13:39:16  thotto
// neue Db-Klasse
//
// Revision 1.2  2004/10/11 15:33:39  thotto
// Bugfixes
//
// Revision 1.1  2004/07/02 13:59:41  thotto
// initial
//
//

unit ShutDownDlg;

{#####################################################################}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,
  JclWin32,
  JclSysInfo,
  JclDateTime,
  MyTrace,
  DelTools;

{#####################################################################}

type e_ShutdownMode = (  Shutdown_PcOff      = 0,
                         Shutdown_Standby    = 1,
                         Shutdown_Hibernate  = 2 );

type
  TFrmShutdown = class(TForm)
    CountDown: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel_CountDown: TPanel;
    Panel4: TPanel;
    btn_Cancel: TBitBtn;
    procedure CountDownTimer(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    m_Trace        : TTrace;

    m_iCountDown   : Integer;
    m_ShutdownMode : e_ShutdownMode;

    function  SetSuspendState(Hibernate, ForceCritical, DisableWeakEvent: Boolean): Boolean;
    procedure System_Shutdown;

  public
    { Public declarations }

  end;

{#####################################################################}

PROCEDURE DoShutdownDialog(ShutdownMode : e_ShutdownMode);

var
  FrmShutdown : TFrmShutdown;
  bProcessing : Boolean;

{#####################################################################}

implementation

{$R *.dfm}

{#####################################################################}

PROCEDURE DoShutdownDialog(ShutdownMode : e_ShutdownMode);
var
  OldCur : TCursor;
begin
  OldCur:= Screen.Cursor;
  try
    Screen.Cursor:= crDefault;
    Application.CreateForm(TFrmShutdown, FrmShutdown);
    FrmShutdown.m_ShutdownMode := ShutdownMode;
    FrmShutdown.ShowModal;
  finally
    FrmShutdown.Free;
    Screen.Cursor:= OldCur;
  end;
end;

{#####################################################################}

procedure TFrmShutdown.CountDownTimer(Sender: TObject);
begin
  try
    if bProcessing then exit;

    bProcessing := true;
    Panel_CountDown.Caption := IntToStr(m_iCountDown);
    m_iCountDown := m_iCountDown - 1;
    if m_iCountDown <= 0 then
    begin
      CountDown.Enabled:= false;
      System_Shutdown;
      FrmShutdown.Close;
    end;
    Sleep(0);
    Application.HandleMessage;
  except
  end;
  bProcessing := false;
end;

{#####################################################################}

procedure TFrmShutdown.btn_CancelClick(Sender: TObject);
begin
  try
    Sleep(0);
    FrmShutdown.Close;
    Application.HandleMessage;
  except
  end;
end;

{#####################################################################}

procedure TFrmShutdown.FormCreate(Sender: TObject);
begin
  try
    m_Trace := TTrace.Create();
    m_Trace.DBMSG_INIT('',
                       'TuxBox',
                       '1.0',
                       '',
                       'WinGrab');
    case m_ShutdownMode of
      Shutdown_PcOff    : Panel2.Caption:= 'Shutdown'; //shutdown
      Shutdown_Standby  : Panel2.Caption:= 'Standby';  //standby
      Shutdown_Hibernate: Panel2.Caption:= 'Hibernate';//hibernate
    end;
    m_iCountDown := 30;
    CountDown.Enabled:= true;
  except
  end;
end;

procedure TFrmShutdown.FormClose(Sender: TObject;
                                 var Action: TCloseAction);
begin
  m_Trace.DBMSG_DONE;
end;


{#####################################################################}

function TFrmShutdown.SetSuspendState(Hibernate, ForceCritical, DisableWeakEvent: Boolean): Boolean;
var
  _SetSuspendState: function(Hibernate, ForceCritical, DisableWeakEvent: BOOL):BOOL; stdcall;
  LibMod: HMODULE;
begin
  Result:= false;
  LibMod := LoadLibrary('POWRPROF.DLL');
  try
    if LibMod <> 0 then
    begin
      _SetSuspendState:= GetProcAddress(LibMod, 'SetSuspendState');
      if Assigned(_SetSuspendState) then
      begin
        Result := _SetSuspendState(Hibernate, ForceCritical, DisableWeakEvent);
      end;
    end;
  finally
    FreeLibrary(LibMod);
  end;

end;

procedure TFrmShutdown.System_Shutdown;
var
  pOSversion : POSVersionInfoEx;
	hToken     : Cardinal;
	DebugValue : Int64;
	tkp        : TOKEN_PRIVILEGES ;
begin
  try
{
	  pOSversion.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
	  GetVersionEx(pOSversion);
	  if pOSversion.dwPlatformId = VER_PLATFORM_WIN32_NT then // Windows NT
	  begin
	    //
	    // Retrieve a handle of the access token
	    //
	    if not OpenProcessToken( GetCurrentProcess(),
                               TOKEN_ADJUST_PRIVILEGES + TOKEN_QUERY,
                               hToken) then
      begin
		    exit;
	    end;

	    //
	    // Enable the SE_SHUTDOWN_NAME privilege
	    //
      if not LookupPrivilegeValue( NIL,
		                               SE_SHUTDOWN_NAME,
		                               DebugValue) then
      begin
		    exit;
	    end;

	    tkp.PrivilegeCount           := 1;
	    tkp.Privileges[0].Luid       := DebugValue;
	    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
	    AdjustTokenPrivileges(hToken,
                            FALSE,
                            tkp,
                            sizeof(TOKEN_PRIVILEGES),
                            NIL,
                            NIL);
	    //
	    // The return value of AdjustTokenPrivileges can't be tested
	    //
	  end;
}
    m_Trace.DBMSG(TRACE_MIN, 'SHUTDOWN NOW');
    case m_ShutdownMode of
      Shutdown_PcOff    : ExitWindowsEx(EWX_POWEROFF + EWX_FORCEIFHUNG, 0); //shutdown
      Shutdown_Standby  : SetSuspendState(FALSE,FALSE,FALSE);  //standby
      Shutdown_Hibernate: SetSuspendState(TRUE, TRUE, TRUE);  //hibernate
    end;
    Sleep(3000);
    Application.HandleMessage;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'System_Shutdown '+ E.Message );
  end;
end;

{#####################################################################}

end.
