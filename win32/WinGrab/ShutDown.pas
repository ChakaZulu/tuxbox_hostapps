////////////////////////////////////////////////////////////////////////////////
//
// $Log: ShutDown.pas,v $
// Revision 1.1  2004/07/02 13:59:41  thotto
// initial
//
//

unit ShutDown;

{#####################################################################}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

{#####################################################################}

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
    m_iCountDown : Integer;

    procedure System_Shutdown;

  public
    { Public declarations }

  end;

{#####################################################################}

PROCEDURE DoShutdownDialog;

var
  FrmShutdown: TFrmShutdown;

{#####################################################################}

implementation

{$R *.dfm}

{#####################################################################}

PROCEDURE DoShutdownDialog;
var
  OldCur : TCursor;
begin
  OldCur:= Screen.Cursor;
  try
    Screen.Cursor:= crDefault;
    Application.CreateForm(TFrmShutdown, FrmShutdown);
//    FrmShutdown.FormInit( TheParameter );
    FrmShutdown.ShowModal;
  finally
    Result:= TRUE;
    FrmShutdown.FormDone;
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

  except
  end;
end;

{#####################################################################}

procedure TFrmShutdown.FormCreate(Sender: TObject);
begin
  try
    m_iCountDown := 30;
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

      ExitWindowsEx(EWX_POWEROFF + EWX_FORCE, 0);
    end else
    begin
      ExitWindowsEx(EWX_SHUTDOWN, 0);
	  end;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'System_Shutdown '+ E.Message );
  end;
end;

{#####################################################################}

end.
