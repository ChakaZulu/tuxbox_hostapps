////////////////////////////////////////////////////////////////////////////////
//
// $Log: ShutDownDlg.pas,v $
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

  private
    m_iCountDown   : Integer;
    m_ShutdownMode : integer;

    procedure System_Shutdown;

  public
    { Public declarations }

  end;

{#####################################################################}

PROCEDURE DoShutdownDialog(ShutdownMode : e_ShutdownMode);

var
  FrmShutdown: TFrmShutdown;

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
    Panel_CountDown.Caption := IntToStr(m_iCountDown);
    m_iCountDown := m_iCountDown - 1;
    if m_iCountDown <= 0 then
    begin
      CountDown.Enabled:= false;
      System_Shutdown;
    end;
    Sleep(0);
    Application.HandleMessage;
  except
  end;
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
    m_iCountDown := 30;
    CountDown.Enabled:= true;
  except
  end;
end;

{#####################################################################}

procedure TFrmShutdown.System_Shutdown;
var
  pOSversion : POSVersionInfoEx;
	hToken     : Cardinal;
	DebugValue : Int64;
	tkp        : TOKEN_PRIVILEGES ;
begin
  try
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

    OutPutDebugString(PChar('SHUTDOWN NOW'));
    case m_ShutdownMode of
      Integer(Shutdown_PcOff)    : ExitWindowsEx(EWX_POWEROFF + EWX_FORCEIFHUNG, 0); //shutdown
      Integer(Shutdown_Standby)  : SetSystemPowerState(true,true);   //standby
      Integer(Shutdown_Hibernate): SetSystemPowerState(false,true);  //hibernate
    end;

  except
//    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'System_Shutdown '+ E.Message );
  end;
end;

{#####################################################################}

end.
