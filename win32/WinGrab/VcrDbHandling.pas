////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrDbHandling.pas,v $
// Revision 1.2  2004/12/03 16:09:49  thotto
// - Bugfixes
// - EPG suchen überarbeitet
// - Timerverwaltung geändert
// - Ruhezustand / Standby gefixt
//
// Revision 1.1  2004/10/15 13:46:24  thotto
// neue Db-Klasse
//
//
unit VcrDbHandling;

interface

uses
  Classes,
  Windows,
  Messages,
  SysUtils,
  DateUtils,
  IdGlobal,
  MyTrace,
  DelTools,
  VcrTypes,
  ADODB,
  Variants;

////////////////////////////////////////////////////////////////////////////////
//
//
//
type
  TVcrDb = class(TObject)
  private
    m_Trace               : TTrace;
    m_coADOConnection     : TADOConnection;
    m_coWhishes_ADOQuery  : TADOQuery;
    m_coRecorded_ADOQuery : TADOQuery;
    m_coWork_ADOQuery     : TADOQuery;

    procedure ExecWorkQuery(sSQL: String);
    function  CheckDbString(sPathName: String): String;


  protected
    procedure InsertEventInDb(ChannelId : String;
                              sEventId  : String;
                              sZeit     : String;
                              sDauer    : String;
                              sTitel    : String;
                              sSubTitel : String;
                              sEpg      : String );
    procedure InsertChannelInDb( ChannelId : String;
                                 sName     : String );
    procedure SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg : String);
    procedure SaveWhishesToDb(sEpgTitle : String);
    function  FindTitleInRecordset(sEpgTitle : String): Integer;

  public
    constructor Create(strConnectString: String);
    destructor  Destroy; override;

    // ArchivListe
    function  IsInRecordedList(sTitel, sSubTitle : String): Integer;
    procedure UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg : String);

    // WhishesListe
    function  IsInWhishesList(sEpgTitle : String): Integer;

    // EventListe
    function  GetDbEventEpg(ChannelId            : String;
                            EventId              : String;
                            var sTitel, sSubTitel: String): String;
    function  GetDbEvent(   ChannelId            : String;
                            EventId              : String;
                            var sTitel, sSubTitel, sZeit, sDauer: String): String;
    procedure TruncDbEvent;
    function  GetCurrentEventId(ChannelId : String): String;
    procedure UpdateEventInDb(ChannelId : String;
                              sEventId  : String;
                              sZeit     : String;
                              sDauer    : String;
                              sTitel    : String;
                              sSubTitel : String;
                              sEpg      : String );

    // KanalListe
    procedure UpdateChannelInDb( ChannelId : String;
                                 sName     : String );
    function  GetDbChannelSwitchFlag( ChannelId : String ) : Integer;
    function  GetDbChannelEpgFlag( ChannelId : String ) : Integer;
    function  GetDbChannelId( sChannelName : String ) : String;
    function  GetDbChannelName( ChannelId : String ) : String;

    procedure UpdateTimerInDb( ChannelId  : String;
                               sEventId   : String;
                               sStartZeit : String;
                               sEndZeit   : String;
                               sTitel     : String;
                               sEPG       : String;
                               iStatus    : Integer;
                               iZielformat: Integer = 0 );

    procedure CheckTimerEvent(ChannelId  : String;
                              sStartZeit : String;
                              sEndZeit   : String );
    procedure CheckTimerStart;
    procedure CheckTimerEnd;
    function  IsTimerAt(sStartZeit: String; sEndZeit: String = ''): Integer;


    // .

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

constructor TVcrDb.Create(strConnectString: String);
begin
  try
    inherited Create();   // Initialize inherited parts
    m_Trace := TTrace.Create();
    m_Trace.DBMSG_INIT('',
                       'TuxBox',
                       '1.0',
                       '',
                       'WinGrab');

    m_coADOConnection     := TADOConnection.Create(nil);
    m_coWhishes_ADOQuery  := TADOQuery.Create(nil);
    m_coRecorded_ADOQuery := TADOQuery.Create(nil);
    m_coWork_ADOQuery     := TADOQuery.Create(nil);
    
    m_coADOConnection.ConnectionString := strConnectString;
    m_coADOConnection.LoginPrompt      := false;
    m_coADOConnection.Open;

    m_coWhishes_ADOQuery.Connection  := m_coADOConnection;
    m_coRecorded_ADOQuery.Connection := m_coADOConnection;
    m_coWork_ADOQuery.Connection     := m_coADOConnection;

    try
      m_coRecorded_ADOQuery.SQL.Clear;
      m_coRecorded_ADOQuery.SQL.Add('SELECT * FROM T_Recorded ORDER BY Titel;');
      m_coRecorded_ADOQuery.ExecSQL;
      m_coRecorded_ADOQuery.Active := true;
      m_coWhishes_ADOQuery.SQL.Clear;
      m_coWhishes_ADOQuery.SQL.Add('SELECT * FROM T_Whishes ORDER BY Titel;');
      m_coWhishes_ADOQuery.ExecSQL;
      m_coWhishes_ADOQuery.Active := true;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
    end;
    DoEvents;

  except
    on E: Exception do OutputDebugString(PChar( E.Message ));
  end;
end;

destructor TVcrDb.Destroy;
begin
  try
    m_coRecorded_ADOQuery.Close;
    m_coWhishes_ADOQuery.Close;
    m_coWhishes_ADOQuery.Close;
    m_coADOConnection.Close;
    DoEvents;

    m_Trace.DBMSG_DONE();
  except
    on E: Exception do OutputDebugString(PChar( E.Message ));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// PRIVATE
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//
procedure TVcrDb.ExecWorkQuery(sSQL: String);
begin
  try
    m_coWork_ADOQuery.Close;
    m_coWork_ADOQuery.SQL.Clear;
    m_coWork_ADOQuery.SQL.Add(sSQL);
    if Pos('SELECT ', UpperCase(sSQL))>0 then
    begin
      m_coWork_ADOQuery.Active := true;
    end else
    begin
      m_coWork_ADOQuery.ExecSQL;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_DETAIL,'ExecWorkQuery ['+E.Message+'] '+sSQL );
  end;
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.CheckDbString(sPathName: String): String;
var
  k        : Integer;
  sOutPath : String;
begin
  try
    sOutPath:= sPathName;
    for k:= 3 to Length(sOutPath) do
    begin
      if sOutPath[k] = '''' then sOutPath[k]:= '´';
      if sOutPath[k] = '"'  then sOutPath[k]:= '´';
      if sOutPath[k] = '_'  then sOutPath[k]:= ' ';
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckDbString ['+E.Message+']' );
  end;
  Result := sOutPath;
end;

////////////////////////////////////////////////////////////////////////////////
//
// PUBLIC
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//
procedure TVcrDb.SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg : String);
var
  sTmp    : String;
  Idn     : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> SaveEpgToDb');
  try
    Idn := 0;
    if not m_coRecorded_ADOQuery.Recordset.Eof then
    begin
      m_coRecorded_ADOQuery.Recordset.MoveFirst;
      try
        while not m_coRecorded_ADOQuery.Recordset.Eof do
        begin
          if sEpgTitle = VarToStr(m_coRecorded_ADOQuery.Recordset.Fields['Titel'].Value) then
          begin
            if sEpgSubTitle <> '' then
            begin
              if sEpgSubTitle = VarToStr(m_coRecorded_ADOQuery.Recordset.Fields['SubTitel'].Value) then
              begin
                Idn:= m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value;
                break;
              end;
            end else
            begin
              Idn:= m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value;
              break;
            end;
          end;
          m_coRecorded_ADOQuery.Recordset.MoveNext;
        end;
      finally
        m_coRecorded_ADOQuery.Recordset.MoveFirst;
      end;

      if Idn = 0 then
      begin
        try
          sTmp := m_coRecorded_ADOQuery.SQL.GetText;
          m_coRecorded_ADOQuery.Close;
          m_coRecorded_ADOQuery.SQL.Clear;
          m_coRecorded_ADOQuery.SQL.Add('INSERT INTO T_Recorded(Titel, SubTitel, EPG) VALUES(''' + CheckDbString(sEpgTitle) + ''', ''' + CheckDbString(sEpgSubTitle) + ''', ''' + CheckDbString(sEpg) + ''');');
          m_coRecorded_ADOQuery.ExecSQL;
          m_coRecorded_ADOQuery.Close;
        except
          on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb/Insert INTO T_RECORDED '+E.Message);
        end;
      end;
    end;

    Idn := IsInWhishesList(sEpgTitle);
    if Idn > 0 then
    begin
      try
        m_coWhishes_ADOQuery.Close;
        m_coWhishes_ADOQuery.SQL.Clear;
        m_coWhishes_ADOQuery.SQL.Add('DELETE FROM T_Whishes WHERE IDN='+IntToStr(Idn)+' AND Serie=0;');
        m_coWhishes_ADOQuery.ExecSQL;
        m_coWhishes_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb/Insert INTO T_Whishes '+E.Message);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< SaveEpgToDb');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg : String);
var
  sTmp    : String;
  Idn     : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> UpdateEpgInDb');
  try
    sTmp := m_coRecorded_ADOQuery.SQL.GetText;
    Idn:= IsInRecordedList(sEpgTitle, sEpgSubTitle);
    if Idn > 0 then
    begin
      try
        m_coRecorded_ADOQuery.Close;
        m_coRecorded_ADOQuery.SQL.Clear;
        m_coRecorded_ADOQuery.SQL.Add('UPDATE T_Recorded SET Titel=''' +
                                       CheckDbString(sEpgTitle) + ''' , SubTitel=''' +
                                       CheckDbString(sEpgSubTitle) + ''' , EPG=''' +
                                       CheckDbString(sEpg) + ''' WHERE IDN='+
                                       IntToStr(Idn)+' ;');
        m_coRecorded_ADOQuery.ExecSQL;
        m_coRecorded_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEpgInDb/Insert INTO T_RECORDED ['+E.Message+']');
      end;
      try
        m_coRecorded_ADOQuery.SQL.Clear;
        m_coRecorded_ADOQuery.SQL.Add(sTmp);
        m_coRecorded_ADOQuery.ExecSQL;
        m_coRecorded_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEpgInDb/SELECT * T_RECORDED '+E.Message);
      end;
    end else
    begin
      SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEpgInDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateEpgInDb');
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.IsInRecordedList(sTitel, sSubTitle : String): Integer;
var
  sTmp,
  sEpgTitle,
  sSQL : String;
  i    : Integer;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_SYNC, '> IsInRecordedList');
  try
    m_Trace.DBMSG(TRACE_SYNC, 'IsInRecordedList sTitel="' + sTitel + '"');

    sEpgTitle := sTitel + ' - ' + sSubTitle;
    if sSubTitle <> '' then
    begin
      sEpgTitle := sEpgTitle + ' - ' + sSubTitle;
    end;

    sTmp := Trim(sEpgTitle);
    sTmp:= ReplaceSubString(sTmp, ' - ', ' ');
    sTmp:= ReplaceSubString(sTmp, ', ', ' ');
    sTmp:= ReplaceSubString(sTmp, ' ', ''',''');

    sSQL:= '';
    sSQL:= sSQL + 'SELECT Idn, Titel FROM T_Recorded WHERE Titel IN( '''+sTmp + ' - ' + sSubTitle+''') OR Titel LIKE(''%'+sEpgTitle+'%'')';
    ExecWorkQuery(sSQL);
    i := FindTitleInRecordset(sEpgTitle);
    if i=0 then
    begin
      sTmp := Trim(sTitel);
      sTmp:= ReplaceSubString(sTmp, ' - ', ' ');
      sTmp:= ReplaceSubString(sTmp, ', ', ' ');
      sTmp:= ReplaceSubString(sTmp, ' ', ''',''');
      sSQL:= '';
      sSQL:= sSQL + 'SELECT Idn, Titel FROM T_Recorded WHERE Titel IN( '''+sTmp+''') OR Titel LIKE(''%'+sTitel+'%'')';
      ExecWorkQuery(sSQL);
      i := FindTitleInRecordset(sTitel);
    end;
    Result := i;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInRecordedList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_SYNC, '< IsInRecordedList');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.SaveWhishesToDb(sEpgTitle : String);
var
  sTmp : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> SaveWhishesToDb');
  try
    if IsInWhishesList(sEpgTitle) = 0 then
    begin
      try
        sTmp := m_coWhishes_ADOQuery.SQL.GetText;
        m_coWhishes_ADOQuery.Close;
        m_coWhishes_ADOQuery.SQL.Clear;
        m_coWhishes_ADOQuery.SQL.Add('INSERT INTO T_Whishes(Titel) VALUES(''' + CheckDbString(sEpgTitle) + ''');');
        m_coWhishes_ADOQuery.ExecSQL;
        m_coWhishes_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/Insert INTO T_Whishes '+E.Message);
      end;
      try
        m_coWhishes_ADOQuery.SQL.Clear;
        m_coWhishes_ADOQuery.SQL.Add(sTmp);
        m_coWhishes_ADOQuery.ExecSQL;
        m_coWhishes_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/SELECT * T_Whishes '+E.Message);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< SaveWhishesToDb');
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.FindTitleInRecordset(sEpgTitle : String): Integer;
var
  sRecorded: String;
begin
  Result:= 0;
  try
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      m_coWork_ADOQuery.Recordset.MoveFirst;
      while not m_coWork_ADOQuery.Recordset.Eof do
      begin
        Result    := m_coWork_ADOQuery.Recordset.Fields['Idn'].Value;
        sRecorded := VarToStr(m_coWork_ADOQuery.Recordset.Fields['Titel'].Value);
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'maybe the same   : "'+sRecorded+'" = "'+sEpgTitle+'" (?)');
          if SameName(     sRecorded+' *',     sEpgTitle+' ')
          or SameName('* '+sRecorded     , ' '+sEpgTitle    )
          or SameName('* '+sRecorded+' *', ' '+sEpgTitle+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_DETAIL, 'is the same : "'+sRecorded+'" = "'+sEpgTitle+'" (!)');
            exit;
          end;
          if SameName(     sEpgTitle+' *',     sRecorded+' ')
          or SameName('* '+sEpgTitle     , ' '+sRecorded    )
          or SameName('* '+sEpgTitle+' *', ' '+sRecorded+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_DETAIL, 'is the same : "'+sRecorded+'" = "'+sEpgTitle+'" (!)');
            exit;
          end;
        end;
        m_coWork_ADOQuery.Recordset.MoveNext;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FindTitleInRecordset '+E.Message);
  end;
end;

function  TVcrDb.IsInWhishesList(sEpgTitle : String): Integer;
var
  i    : Integer;
  sTmp,
  sSQL : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_SYNC, '> IsInWhishesList');
  try
    if sEpgTitle = '' then
    begin
      m_Trace.DBMSG(TRACE_SYNC, '< IsInWhishesList');
      exit;
    end;

    m_Trace.DBMSG(TRACE_SYNC, 'IsInWhishesList sTitel="' + sEpgTitle + '"');
    sTmp := Trim(sEpgTitle);
    sTmp:= ReplaceSubString(sTmp, ' - ', ' ');
    sTmp:= ReplaceSubString(sTmp, ', ', ' ');
    sTmp:= ReplaceSubString(sTmp, ' ', ''',''');

    sSQL:= '';
    sSQL:= sSQL + 'SELECT Idn, Titel FROM T_Whishes WHERE Titel IN( '''+sTmp+''') OR Titel LIKE(''%'+sEpgTitle+'%'')';
    ExecWorkQuery(sSQL);
    i := FindTitleInRecordset(sEpgTitle);
    Result:= i;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInWhishesList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_SYNC, '< IsInWhishesList '+IntToStr(i));
end;

//------------------------------------------------------------------------------
//

function TVcrDb.GetDbEvent( ChannelId            : String;
                            EventId              : String;
                            var sTitel, sSubTitel, sZeit, sDauer: String): String;
var
  sSQL     : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbEvent');
  try
    sSQL :=        'SELECT Epg, Titel, SubTitel, Zeit, Dauer FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'EventId = ''' + CheckDbString(EventId) + ''' AND ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTitel    := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Titel'].Value, '');
      sSubTitel := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['SubTitel'].Value, '');
      sZeit     := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Zeit'].Value, '');
      sDauer    := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Dauer'].Value, '');
      Result    := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Epg'].Value, '');
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg    Titel='+sTitel);
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg SubTitel='+sSubTitel);
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg      EPG='+Result);
    end else
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg -> EventId='+EventId+' not found');
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbEvent');
end;

function TVcrDb.GetDbEventEpg(ChannelId            : String;
                              EventId              : String;
                              var sTitel, sSubTitel: String): String;
var
  sZeit, sDauer: String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbEventEpg');
  try
    Result := GetDbEvent(ChannelId, EventId, sTitel, sSubTitel, sZeit, sDauer);
    m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg    Titel='+sTitel);
    m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg SubTitel='+sSubTitel);
    m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg      EPG='+Result);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelEpgFlag '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbEventEpg');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.TruncDbEvent;
var
  sSQL     : String;
  sZeit    : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> TruncDbEvent');
  try
    sZeit := IntToStr(DateTimeToUnix(IncHour((Now - OffsetFromUTC),-3)));
    sSQL :=        'DELETE * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'Zeit < ''' + CheckDbString(sZeit) + ''';';
    ExecWorkQuery(sSQL);
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'TruncDbEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< TruncDbEvent');
end;

//------------------------------------------------------------------------------
//
function TVcrDb.GetCurrentEventId(ChannelId : String): String;
var
  sZeit,
  sEventId,
  sSQL  : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetCurrentEventId');
  try
    sZeit := IntToStr( DateTimeToUnix(Now() - OffsetFromUTC() ) );
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId  + ''' AND ';
    sSQL := sSQL + 'Zeit < ''' + CheckDbString(sZeit) + ''' ';
    sSQL := sSQL + 'ORDER BY Zeit DESC;';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sEventId  := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['EventId'].Value, '0');
      Result    := sEventId;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetCurrentDbEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetCurrentEventId');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.UpdateEventInDb( ChannelId : String;
                                  sEventId  : String;
                                  sZeit     : String;
                                  sDauer    : String;
                                  sTitel    : String;
                                  sSubTitel : String;
                                  sEpg      : String );
var
  sTmp,
  sTmpEpg,
  sSQL : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> UpdateEventInDb');
  try
    // to decimal string ...
    sEventId  := IntToStr(StrToInt64Ex(sEventId));
    // check modus INSERT or UPDATE ...
    m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb check Event "' + sTitel + '" "' + sZeit + '"');
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
    sSQL := sSQL + 'Titel = ''' + CheckDbString(sTitel) + ''' AND ';
    sSQL := sSQL + 'Dauer = ''' + CheckDbString(sDauer) + ''' AND ';
    sSQL := sSQL + 'Zeit  = ''' + CheckDbString(sZeit)  + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['EventId'].Value, '0');
      sTmpEpg := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Epg'].Value, '');
      if sTmp = sEventId then
      begin
        // UPDATE-Mode.
        if Length(sEpg) > Length(sTmpEpg) then
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb UPDATE sTitel="' + sTitel + '"');
          sSQL :=        'UPDATE T_Events SET ';
          sSQL := sSQL + 'Titel = '''    + CheckDbString(sTitel) + ''', ';
          sSQL := sSQL + 'SubTitel = ''' + CheckDbString(sSubTitel) + ''', ';
          sSQL := sSQL + 'Epg = '''      + CheckDbString(sEpg) + ''' ';
          sSQL := sSQL + 'WHERE ';
          sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
          sSQL := sSQL + 'EventId   = ''' + CheckDbString(sEventId) + ''';';
          ExecWorkQuery(sSQL);
          DoEvents;
        end;
      end else
      begin
        InsertEventInDb(ChannelId,
                        sEventId,
                        sZeit,
                        sDauer,
                        sTitel,
                        sSubTitel,
                        sEpg);
      end;
    end else
    begin
      InsertEventInDb(ChannelId,
                      sEventId,
                      sZeit,
                      sDauer,
                      sTitel,
                      sSubTitel,
                      sEpg);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEventInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateEventInDb');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.InsertEventInDb( ChannelId : String;
                                  sEventId  : String;
                                  sZeit     : String;
                                  sDauer    : String;
                                  sTitel    : String;
                                  sSubTitel : String;
                                  sEpg      : String );
var
  sSQL : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> InsertEventInDb');
  try
    m_Trace.DBMSG(TRACE_SYNC, 'InsertEventInDb INSERT sTitel="' + sTitel + '"');
    sSQL :=        'INSERT INTO T_Events( ';
    sSQL := sSQL + 'ChannelId, ';
    sSQL := sSQL + 'EventId, ';
    sSQL := sSQL + 'Zeit, ';
    sSQL := sSQL + 'Dauer, ';
    sSQL := sSQL + 'Titel, ';
    sSQL := sSQL + 'SubTitel, ';
    sSQL := sSQL + 'Epg ) VALUES (';
    sSQL := sSQL + '''' + (ChannelId)     + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sEventId) + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sZeit)    + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sDauer)   + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sTitel)   + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sSubTitel)+ ''', ';
    sSQL := sSQL + '''' + CheckDbString(sEpg)     + ''');';
    ExecWorkQuery(sSQL);
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'InsertEventInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< InsertEventInDb');
end;
//------------------------------------------------------------------------------
//
procedure TVcrDb.UpdateChannelInDb( ChannelId : String;
                                    sName     : String );
var
  sTmpId,
  sTmpName,
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> UpdateChannelInDb');
  try
    // check modus INSERT or UPDATE ...
    m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb check ChannelId="' + ChannelId + '"');
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmpName := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Name'].Value, '');
      sTmpId   := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
      // UPDATE-Mode.
      if (sTmpName <> CheckDbString(sName)) then
      begin
        m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb UPDATE sName="' + sName + '" <> "'+sTmpName+'"');
        sSQL :=        'UPDATE T_Channel ';
        sSQL := sSQL + 'SET Name = '''     + CheckDbString(sName) + ''' ';
        sSQL := sSQL + 'WHERE ';
        sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
        ExecWorkQuery(sSQL);
        DoEvents;
      end;
    end else
    begin
      // INSERT-Mode.
      InsertChannelInDb( ChannelId, sName);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateChannelInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateChannelInDb');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.InsertChannelInDb( ChannelId : String;
                                    sName     : String );
var
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> InsertChannelInDb');
  try
    m_Trace.DBMSG(TRACE_SYNC, 'InsertChannelInDb sName="' + sName + '" ChannelId="'+ChannelId+'"');
    sSQL :=        'INSERT INTO T_Channel( ';
    sSQL := sSQL + 'ChannelId, ';
    sSQL := sSQL + 'Name ) VALUES (';
    sSQL := sSQL + '''' + ChannelId  + ''', ';
    sSQL := sSQL + '''' + CheckDbString(sName) + ''');';
    ExecWorkQuery(sSQL);
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'InsertChannelInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< InsertChannelInDb');
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.GetDbChannelSwitchFlag( ChannelId : String ) : Integer;
var
  sTmp,
  sSQL     : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelSwitchFlag');
  try
    sSQL :=        'SELECT SwitchEpg FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['SwitchEpg'].Value, '');
      if sTmp <> '' then
      begin
        Result := StrToInt(sTmp);
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelSwitchFlag '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelSwitchFlag');
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.GetDbChannelEpgFlag( ChannelId : String ) : Integer;
var
  sTmp,
  sSQL     : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelEpgFlag');
  try
    sSQL :=        'SELECT FindEpg FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['FindEpg'].Value, '0');
      if sTmp <> '' then
      begin
        Result := StrToIntDef(sTmp,0);
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelEpgFlag '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelEpgFlag');
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.GetDbChannelId( sChannelName : String ) : String;
var
  sTmpId,
  sSQL     : String;
begin
  Result := '0';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelId');
  try
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'Name = ''' + CheckDbString(sChannelName) + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmpId   := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
      if sTmpId <> '0' then
      begin
        Result := sTmpId;
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelId '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelId='+sTmpId);
end;

//------------------------------------------------------------------------------
//
function  TVcrDb.GetDbChannelName( ChannelId : String ) : String;
var
  sTmpName,
  sSQL     : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelName');
  try
    sSQL :=        'SELECT Name FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmpName := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Name'].Value, '');
      if sTmpName <> '' then
      begin
        Result := sTmpName;
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelName '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelName');
end;

//------------------------------------------------------------------------------
//
procedure TVcrDb.UpdateTimerInDb(ChannelId  : String;
                                 sEventId   : String;
                                 sStartZeit: String;
                                 sEndZeit  : String;
                                 sTitel     : String;
                                 sEPG       : String;
                                 iStatus    : Integer;
                                 iZielformat: Integer = 0 );
var
  sKanal,
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> UpdateTimerInDb');
  try

    DateSeparator   := '-';
    ShortDateFormat := 'yyyy-m-d';
    TimeSeparator   := ':';
//    sStartZeit:= IntToStr(DateTimeToUnix(dtStartZeit - OffsetFromUTC));
//    sEndZeit  := IntToStr(DateTimeToUnix(dtEndZeit - OffsetFromUTC));
    sKanal    := GetDbChannelName(ChannelId);

    sSQL :=        'SELECT Idn ';
    sSQL := sSQL + 'FROM T_Planner ';
    sSQL := sSQL + 'WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
    sSQL := sSQL + 'EventId = '''   + sEventId  + ''' AND ';
    sSQL := sSQL + 'Titel = '''     + sTitel    + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      //Update
      sSQL :=        'UPDATE ';
      sSQL := sSQL + 'T_Planner SET ';
      sSQL := sSQL + 'Kanal = '''     + sKanal                + ''', ';
      sSQL := sSQL + 'StartZeit = ''' + sStartZeit            + ''', ';
      sSQL := sSQL + 'EndZeit = '''   + sEndZeit              + ''', ';
      sSQL := sSQL + 'Status = '''    + IntToStr(iStatus)     + ''', ';
      sSQL := sSQL + 'Zielformat = '''+ IntToStr(iZielformat) + ''', ';
      sSQL := sSQL + 'EPG = '''       + sEPG                  + ''' ';
      sSQL := sSQL + 'WHERE ';
      sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
      sSQL := sSQL + 'EventId = '''   + sEventId  + ''' AND ';
      sSQL := sSQL + 'Titel = '''     + sTitel    + '''; ';

      ExecWorkQuery(sSQL);

    end else
    begin
      //Insert
      if iStatus = 1 then SaveWhishesToDb(sTitel);

      sSQL :=        'INSERT INTO ';
      sSQL := sSQL + 'T_Planner ( ';
      sSQL := sSQL + 'StartZeit, ';
      sSQL := sSQL + 'EndZeit, ';
      sSQL := sSQL + 'Kanal, ';
      sSQL := sSQL + 'ChannelId, ';
      sSQL := sSQL + 'EventId, ';
      sSQL := sSQL + 'Status, ';
      sSQL := sSQL + 'Zielformat, ';
      sSQL := sSQL + 'Titel, ';
      sSQL := sSQL + 'EPG ';
      sSQL := sSQL + ') VALUES ( ';
      sSQL := sSQL + '''' + sStartZeit + ''', ';
      sSQL := sSQL + '''' + sEndZeit + ''', ';
      sSQL := sSQL + '''' + sKanal + ''', ';
      sSQL := sSQL + '''' + ChannelId + ''', ';
      sSQL := sSQL + '''' + sEventId + ''', ';
      sSQL := sSQL + '''' + IntToStr(iStatus) + ''', ';
      sSQL := sSQL + '''' + IntToStr(iZielformat) + ''', ';
      sSQL := sSQL + '''' + sTitel + ''', ';
      sSQL := sSQL + '''' + sEPG + '''); ';

      ExecWorkQuery(sSQL);

    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateTimerInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateTimerInDb');
end;

/////////////////////////////////////////////////////////////////////////////////////////
//
procedure TVcrDb.CheckTimerStart;
var
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckTimerStart');
  try
    sSQL :=        'UPDATE ';
    sSQL := sSQL + 'T_Planner SET ';
    sSQL := sSQL + 'Status = 2 ';
    sSQL := sSQL + 'WHERE Status = 1';
    ExecWorkQuery(sSQL);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckTimerStart '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckTimerStart');
end;

procedure TVcrDb.CheckTimerEnd;
var
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckTimerEnd');
  try
    sSQL :=        'UPDATE ';
    sSQL := sSQL + 'T_Planner SET ';
    sSQL := sSQL + 'Status = 0 ';
    sSQL := sSQL + 'WHERE Status = 2';
    ExecWorkQuery(sSQL);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckTimerEnd '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckTimerEnd');
end;

function  TVcrDb.IsTimerAt(sStartZeit: String; sEndZeit: String = ''): Integer;
var
  sSQL : String;
  i    :Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> IsTimerAt ');
  i:= 0;
  try
    sSQL :=        'SELECT Count(*) as C ';
    sSQL := sSQL + 'FROM T_Planner ';
    sSQL := sSQL + 'WHERE Status = 1 AND ';
    sSQL := sSQL + '( ';
    sSQL := sSQL + '(StartZeit >= '''+sStartZeit+''' ';
    if sEndZeit <> '' then
    begin
      sSQL := sSQL + 'AND StartZeit <= '''+sEndZeit+''') ';
    end else
    begin
      sSQL := sSQL + 'AND StartZeit <= '''+IntToStr(DatetimeToUnix(IncMinute(UnixToDatetime(StrToInt64(sStartZeit)),15)))+''') ';
    end;
    sSQL := sSQL + 'OR ';
    sSQL := sSQL + '(EndZeit >= '''+IntToStr(DatetimeToUnix(IncMinute(UnixToDatetime(StrToInt64(sStartZeit)),-15)))+''' ';
    if sEndZeit <> '' then
    begin
      sSQL := sSQL + 'AND EndZeit <= '''+sEndZeit+''') ';
    end else
    begin
      sSQL := sSQL + 'AND EndZeit <= '''+sStartZeit+''') ';
    end;
    sSQL := sSQL + ') ';

    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      i:= StrToInt(VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['C'].Value, '0'));
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsTimerAt '+E.Message +' SQL:'+ sSQL);
  end;
  Result:= i;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< IsTimerAt ('+IntToStr(i)+')');
end;

procedure TVcrDb.CheckTimerEvent(ChannelId  : String;
                                 sStartZeit : String;
                                 sEndZeit   : String );
var
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckTimerEvent');
  try
    if IsTimerAt(sStartZeit, sEndZeit) > 0 then
    begin
      // timer reset to "active"
      sSQL :=        'UPDATE ';
      sSQL := sSQL + 'T_Planner SET ';
      sSQL := sSQL + 'Status = 1 ';
      sSQL := sSQL + 'WHERE Status = 2 AND ';
      sSQL := sSQL + 'StartZeit >= '''+sStartZeit+''' AND ';
      sSQL := sSQL + 'EndZeit <= '''+sEndZeit+''' ';
      ExecWorkQuery(sSQL);
      m_Trace.DBMSG(TRACE_SYNC, 'TimerEvent reset to "active"');
    end else
    begin
      // found new timer...
      m_Trace.DBMSG(TRACE_SYNC, 'TimerEvent new timer detected');
      sSQL :=        'SELECT * ';
      sSQL := sSQL + 'FROM T_Event ';
      sSQL := sSQL + 'WHERE  ';
      sSQL := sSQL + 'ChannelId = '''+ChannelId+''' ';
      sSQL := sSQL + 'AND StartZeit >= '''+sStartZeit+''' ';
      sSQL := sSQL + 'AND Dauer <= '''+IntToStr(StrToInt(sEndZeit)-StrToInt(sStartZeit))+''' ';
      sSQL := sSQL + 'AND StartZeit <= '''+IntToStr(DatetimeToUnix(IncMinute(UnixToDatetime(StrToInt64(sEndZeit)),-15)))+''' ';
      sSQL := sSQL + 'ORDER BY StartZeit ';
      ExecWorkQuery(sSQL);
      if not m_coWork_ADOQuery.Recordset.Eof then
      begin
        m_Trace.DBMSG(TRACE_SYNC, 'TimerEvent ['+VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Titel'].Value, '')+'] inserted');
        UpdateTimerInDb( ChannelId,
                         VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['EventId'].Value, ''),
                         sStartZeit,
                         sEndZeit,
                         VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Titel'].Value, ''),
                         VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['EPG'].Value, ''),
                         1,
                         0 );
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckTimerEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckTimerEvent');
end;

////////////////////////////////////////////////////////////////////////////////
//
// EOF.
//
////////////////////////////////////////////////////////////////////////////////
end.

