unit TimerFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeButtons, TeControls, ExtCtrls;

type
  TfrmTimer = class(TForm)
    plTop: TTePanel;
    plBottom: TTePanel;
    bnAbort: TTeBitBtn;
    lblTimer: TLabel;
    Label1: TLabel;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    WaitUntil: TDateTime;
  public
  end;

function TimerWaitUntil(aTime: TDateTime): Boolean;

implementation

{$R *.DFM}

function TimerWaitUntil(aTime: TDateTime): Boolean;
begin
  with TfrmTimer.Create(nil) do try
    WaitUntil := aTime;
    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

procedure TfrmTimer.TimerTimer(Sender: TObject);
var
  TimeRemainging                   : TDateTime;
begin
  TimeRemainging := WaitUntil - Now;
  if TimeRemainging < 0 then
    ModalResult := mrOK
  else
    lblTimer.Caption := TimeToStr(TimeRemainging);
end;

end.

