////////////////////////////////////////////////////////////////////////////////
//
// $Log: DoRecordDlg.pas,v $
// Revision 1.2  2005/05/25 11:23:44  thotto
// *** empty log message ***
//
// Revision 1.1  2004/12/03 16:17:53  thotto
// - Bugfixes
// - EPG suchen überarbeitet
// - Timerverwaltung geändert
// - Ruhezustand / Standby gefixt
// - neuer Dlg zum Setzten von Timern
//
//
unit DoRecordDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,
  JclWin32,
  JclSysInfo,
  JclDateTime,
  DateUtils,
  IdGlobal,
  VcrDbHandling,
  MyTrace,
  DelTools, HTMLLite;

type
  TFrmDoRecord = class(TForm)
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    htmlEPG: ThtmlLite;
    lblTitel: TLabel;
    lblDauer: TLabel;
    cb_Zielformat: TCheckBox;
    lblHinweis: TLabel;
    lblHinweisTitel: TLabel;
    cb_FreeTV: TCheckBox;
    lblStartZeit: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
    m_coVcrDb            : TVcrDb;
    m_Trace              : TTrace;
    m_dbConnectionString : String;
    m_sChannelId         : String;
    m_sEventId           : String;
    m_sEndZeit           : String;
    m_sStartZeit         : String;
    m_sEPG               : String;
    m_sTitel             : String;
    m_sSubTitel          : String;
    m_sDauer             : String;
    m_sTimerCommand      : String;
    m_sSleepCommand      : String;

  public
    { Public declarations }

  end;

Function DoRecordDialog(sChannelId, sEventId : String;
                        sdbConnectionString  : String;
                        var sSleepCommand    : String) : String;

var
  FrmDoRecord: TFrmDoRecord;

implementation

{$R *.dfm}

Function DoRecordDialog(sChannelId, sEventId : String;
                        sdbConnectionString  : String;
                        var sSleepCommand    : String) : String;
var
  OldCur : TCursor;
begin
  OldCur:= Screen.Cursor;
  try
    Screen.Cursor:= crDefault;
    Application.CreateForm(TFrmDoRecord, FrmDoRecord);
    FrmDoRecord.m_dbConnectionString := sdbConnectionString;
    FrmDoRecord.m_sChannelId         := sChannelId;
    FrmDoRecord.m_sEventId           := sEventId;
    FrmDoRecord.ShowModal;
  finally
    Result       := FrmDoRecord.m_sTimerCommand;
    sSleepCommand:= FrmDoRecord.m_sSleepCommand;
    FrmDoRecord.Free;
    Screen.Cursor:= OldCur;
  end;
end;

procedure TFrmDoRecord.FormCreate(Sender: TObject);
begin
  try
    m_Trace := TTrace.Create();
    m_Trace.DBMSG_INIT('',
                       'TuxBox',
                       '1.0',
                       '',
                       'WinGrab');

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FormCreate '+ E.Message );
  end;
end;

procedure TFrmDoRecord.FormDestroy(Sender: TObject);
begin
  try
    m_Trace.DBMSG_DONE;
    m_coVcrDb.Free;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FormDestroy '+ E.Message );
  end;
end;

procedure TFrmDoRecord.BtnOkClick(Sender: TObject);
var
  sTmp      : String;
  EpgId,
  iOutFormat: Integer;
  AYear,
  AMonth,
  ADay,
  AHour,
  AMinute,
  ASecond,
  AMilliSecond: Word;
begin
  try
    if cb_Zielformat.Checked then iOutFormat := 1
                             else iOutFormat := 0;
    if cb_FreeTV.Checked     then m_sEndZeit := IntToStr( StrToIntDef(m_sEndZeit,0) + 300 );

    EpgId:= m_coVcrDb.InsertEpg(m_sTitel, m_sSubTitel, m_sEpg);
    m_coVcrDb.UpdateTimerInDb( m_sChannelId,
                               m_sEventId,
                               m_sStartZeit,
                               m_sEndZeit,
                               m_sTitel,
                               EpgId,
                               1,   //Timer Aktiv setzen...
                               iOutFormat ); //Zielformat

    sTmp := '/fb/timer.dbox2?action=new&type=5';
    sTmp := sTmp + '&alarm='      + m_sStartZeit;
    sTmp := sTmp + '&stop='       + m_sEndZeit;
    sTmp := sTmp + '&channel_id=' + m_sChannelId + '&rs=1';
    m_sTimerCommand := sTmp;

    m_sEndZeit:= IntToStr( StrToIntDef(m_sEndZeit,0) + 300 );
    DecodeDateTime(UnixToDateTime(StrToInt64Def(m_sEndZeit,0)) + OffsetFromUTC,
                   AYear,
                   AMonth,
                   ADay,
                   AHour,
                   AMinute,
                   ASecond,
                   AMilliSecond);
    m_Trace.DBMSG(TRACE_DETAIL, 'SleepTimer Hour='+ IntToStr(AHour) );
    if((AHour > 22) OR
       (AHour < 09))then
    begin
//      if m_coVcrDb.IsTimerAt(m_sEndZeit) = 0 then
      begin
        sTmp := '/fb/timer.dbox2?action=new&type=1';
        sTmp := sTmp + '&alarm=' + m_sEndZeit;
        sTmp := sTmp + '&sbon=1&rep=0&rs=1';
        m_sSleepCommand := sTmp;
//      end else
//      begin
//        m_Trace.DBMSG(TRACE_DETAIL, 'SleepTimer IsTimerAt('+m_sEndZeit+')');
      end;
    end;
    m_Trace.DBMSG(TRACE_DETAIL, 'RecordTimer Timer=['+m_sTimerCommand+'] ');
    m_Trace.DBMSG(TRACE_DETAIL, 'SleepTimer  Sleep=['+m_sSleepCommand+'] ');
    Sleep(0);
    FrmDoRecord.Close;
    Application.HandleMessage;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'BtnOkClick '+ E.Message );
  end;
end;

procedure TFrmDoRecord.BtnCancelClick(Sender: TObject);
begin
  try
    m_sTimerCommand:= '';
    Sleep(0);
    FrmDoRecord.Close;
    Application.HandleMessage;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'BtnCancelClick '+ E.Message );
  end;
end;

procedure TFrmDoRecord.FormActivate(Sender: TObject);
var
  Datum  : TDateTime;
  sDatum : String;
  iOverlapped : Integer;
begin
  try
    m_sSleepCommand:= '';
    m_sTimerCommand:= '';

    m_coVcrDb  := TVcrDb.Create(m_dbConnectionString);

    m_sEPG     := m_coVcrDb.GetDbEvent(m_sChannelId,
                                       m_sEventId,
                                       m_sTitel,
                                       m_sSubTitel,
                                       m_sStartZeit,
                                       m_sDauer);
    m_sEndZeit := IntToStr( StrToIntDef(m_sStartZeit,0) + (StrToIntDef(m_sDauer,0)) );

    Datum     := UnixToDateTime(StrToInt64Def(m_sStartZeit,0)) + OffsetFromUTC;
    DateTimeToString(sDatum, 'dd.mm.yyyy hh:nn', Datum);

    lblTitel.Caption:= m_coVcrDb.GetDbChannelName(m_sChannelId);
    lblDauer.Caption:= IntToStr(StrToIntDef(m_sDauer,0) div 60) + ' min';

    lblStartZeit.Caption := sDatum;

    lblHinweis.Caption:= '';
    if (m_coVcrDb.IsInRecordedList(m_sTitel, m_sSubTitel) > 0) then
    begin
      lblHinweisTitel.Visible:= true;
      lblHinweis.Visible:= true;
      lblHinweis.Caption:= 'Titel wurde bereits aufgenommen ! '+#13#10;
    end;
    iOverlapped:= m_coVcrDb.IsTimerAt(m_sStartZeit, m_sEndZeit);
    if iOverlapped > 0 then
    begin
      lblHinweisTitel.Visible:= true;
      lblHinweis.Visible:= true;
      lblHinweis.Caption:= lblHinweis.Caption + 'Titel überschneidet sich mit einer anderen Aufnahme ';
    end else
    begin
      iOverlapped:= m_coVcrDb.IsTimerAt(m_sStartZeit,IntToStr(DatetimeToUnix(IncMinute(UnixToDatetime(StrToInt64(m_sStartZeit)),15))));
      if iOverlapped > 0 then
      begin
        lblHinweisTitel.Visible:= true;
        lblHinweis.Visible:= true;
        lblHinweis.Caption:= lblHinweis.Caption + 'Titel überschneidet sich mit einer anderen Aufnahme am Anfang ! '+#13#10;
      end else
      begin
        iOverlapped:= m_coVcrDb.IsTimerAt(IntToStr(DatetimeToUnix(IncMinute(UnixToDatetime(StrToInt64(m_sEndZeit)),-15))),m_sEndZeit);
        if iOverlapped > 0 then
        begin
          lblHinweisTitel.Visible:= true;
          lblHinweis.Visible:= true;
          lblHinweis.Caption:= lblHinweis.Caption + 'Titel überschneidet sich mit einer anderen Aufnahme am Ende ! '+#13#10;
        end;
      end;
    end;

    htmlEPG.LoadFromString( m_sEpg, '' );
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FormActivate '+ E.Message );
  end;
end;

end.
