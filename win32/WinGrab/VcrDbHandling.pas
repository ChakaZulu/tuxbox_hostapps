////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrDbHandling.pas,v $
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

  protected


  public
    constructor Create(strConnectString: String);
    destructor  Destroy;

    function  CheckDbString(sPathName: String): String;

    // ArchivListe
    function  IsInRecordedList(sTitel, sSubTitle : String): Integer;
    procedure SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg : String);
    procedure UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg : String);

    // WhishesListe
    function  IsInWhishesList(sEpgTitle : String): Integer;
    procedure SaveWhishesToDb(sEpgTitle : String);

    // EventListe
    function  GetDbEventEpg(ChannelId            : String;
                            EventId              : String;
                            var sTitel, sSubTitel: String): String;
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
    m_coWork_ADOQuery.Active := true;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckDbString '+ E.Message );
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
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckDbString '+ E.Message );
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
    Idn:= IsInRecordedList(sEpgTitle, sEpgSubTitle);
    if Idn > 0 then
    begin
      try
        sTmp := m_coRecorded_ADOQuery.SQL.GetText;
        m_coRecorded_ADOQuery.Close;
        m_coRecorded_ADOQuery.SQL.Clear;
        m_coRecorded_ADOQuery.SQL.Add('UPDATE T_Recorded SET Titel=''' + CheckDbString(sEpgTitle) + ''' , SubTitel=''' + CheckDbString(sEpgSubTitle) + ''' , EPG=''' + CheckDbString(sEpg) + ''' WHERE IDN='+IntToStr(Idn)+' ;');
        m_coRecorded_ADOQuery.ExecSQL;
        m_coRecorded_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEpgInDb/Insert INTO T_RECORDED '+E.Message);
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
      m_Trace.DBMSG(TRACE_DETAIL, 'UpdateEpgInDb "'+sEpgTitle+'" not found');
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
  sRecorded : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> IsInRecordedList');
  try
    m_Trace.DBMSG(TRACE_SYNC, 'IsInRecordedList sTitel="' + sTitel + '"');
    try
      if not m_coRecorded_ADOQuery.Recordset.Eof then
      begin
        m_coRecorded_ADOQuery.Recordset.MoveFirst;
        while not m_coRecorded_ADOQuery.Recordset.Eof do
        begin
          sRecorded := VarToStr(m_coRecorded_ADOQuery.Recordset.Fields['Titel'].Value);
          if SameName(     sRecorded+' *',     sTitel+' ')
          or SameName('* '+sRecorded     , ' '+sTitel    )
          or SameName('* '+sRecorded+' *', ' '+sTitel+' ')
          then
          begin
            sRecorded := VarToStr(m_coRecorded_ADOQuery.Recordset.Fields['SubTitel'].Value);
            if (sSubTitle <> '') and (sRecorded <> '') then
            begin
              if SameName(     sRecorded+' *',     sSubTitle+' ')
              or SameName('* '+sRecorded     , ' '+sSubTitle    )
              or SameName('* '+sRecorded+' *', ' '+sSubTitle+' ')
              then
              begin
                m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+' - '+sSubTitle+'" (?)');
                Result := (m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value);
                m_coRecorded_ADOQuery.Recordset.MoveFirst;
                m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
                exit;
              end;
            end else
            begin
              m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
              Result := (m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value);
              m_coRecorded_ADOQuery.Recordset.MoveFirst;
              m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
              exit;
            end;
          end;
          if SameName(     sTitel+' *',     sRecorded+' ')
          or SameName('* '+sTitel     , ' '+sRecorded    )
          or SameName('* '+sTitel+' *', ' '+sRecorded+' ')
          then
          begin
            sRecorded := VarToStr(m_coRecorded_ADOQuery.Recordset.Fields['SubTitel'].Value);
            if (sSubTitle <> '') and (sRecorded <> '') then
            begin
              if SameName(     sSubTitle+' *',     sRecorded+' ')
              or SameName('* '+sSubTitle     , ' '+sRecorded    )
              or SameName('* '+sSubTitle+' *', ' '+sRecorded+' ')
              then
              begin
                m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+' - '+sSubTitle+'" (?)');
                Result := (m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value);
                m_coRecorded_ADOQuery.Recordset.MoveFirst;
                m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
                exit;
              end;
            end else
            begin
              m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
              Result := (m_coRecorded_ADOQuery.Recordset.Fields['Idn'].Value);
              m_coRecorded_ADOQuery.Recordset.MoveFirst;
              m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
              exit;
            end;
          end;
          m_coRecorded_ADOQuery.Recordset.MoveNext;
        end;
        m_coRecorded_ADOQuery.Recordset.MoveFirst;
      end;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInRecordedList '+E.Message);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInRecordedList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
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
function  TVcrDb.IsInWhishesList(sEpgTitle : String): Integer;
var
  sRecorded  : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> IsInWhishesList');
  try
    if sEpgTitle = '' then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
      exit;
    end;
    m_Trace.DBMSG(TRACE_SYNC, 'IsInWhishesList sTitel="' + sEpgTitle + '"');
    try
      if not m_coWhishes_ADOQuery.Recordset.Eof then
      begin
        m_coWhishes_ADOQuery.Recordset.MoveFirst;
        while not m_coWhishes_ADOQuery.Recordset.Eof do
        begin
          sRecorded := VarToStr(m_coWhishes_ADOQuery.Recordset.Fields['Titel'].Value);
          if SameName(     sRecorded+' *',     sEpgTitle+' ')
          or SameName('* '+sRecorded     , ' '+sEpgTitle    )
          or SameName('* '+sRecorded+' *', ' '+sEpgTitle+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sEpgTitle+'" (?)');
            Result := (m_coWhishes_ADOQuery.Recordset.Fields['Idn'].Value);
            m_coWhishes_ADOQuery.Recordset.MoveFirst;
            m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
            exit;
          end;
          if SameName(     sEpgTitle+' *',     sRecorded+' ')
          or SameName('* '+sEpgTitle     , ' '+sRecorded    )
          or SameName('* '+sEpgTitle+' *', ' '+sRecorded+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sEpgTitle+'" (?)');
            Result := (m_coWhishes_ADOQuery.Recordset.Fields['Idn'].Value);
            m_coWhishes_ADOQuery.Recordset.MoveFirst;
            m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
            exit;
          end;
          m_coWhishes_ADOQuery.Recordset.MoveNext;
        end;
        m_coWhishes_ADOQuery.Recordset.MoveFirst;
      end;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInWhishesList/SELECT * T_Whishes WHERE '+E.Message);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInWhishesList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
end;

//------------------------------------------------------------------------------
//
function TVcrDb.GetDbEventEpg(ChannelId            : String;
                              EventId              : String;
                              var sTitel, sSubTitel: String): String;
var
  sSQL     : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbEventEpg');
  try
    sSQL :=        'SELECT Epg, Titel, SubTitel FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'EventId = ''' + CheckDbString(EventId) + ''' AND ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTitel    := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Titel'].Value, '');
      sSubTitel := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['SubTitel'].Value, '');
      Result    := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Epg'].Value, '');
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg    Titel='+sTitel);
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg SubTitel='+sSubTitel);
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg      EPG='+Result);
    end else
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'GetDbEventEpg -> EventId='+EventId+' not found');
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelEpgFlag '+E.Message +' SQL:'+ sSQL);
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
    m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb check EventId="' + sEventId + '"');
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
    sSQL := sSQL + 'EventId   = ''' + CheckDbString(sEventId) + ''';';
    ExecWorkQuery(sSQL);
    if not m_coWork_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['EventId'].Value, '0');
      sTmpEpg := VarToStrDef(m_coWork_ADOQuery.Recordset.Fields['Epg'].Value, '');
      if sTmp <> '0' then
      begin
        // UPDATE-Mode.
        if sEpg <> sTmpEpg then
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb UPDATE sTitel="' + sTitel + '"');
          sSQL :=        'UPDATE T_Events SET ';
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
        // INSERT-Mode.
        m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb INSERT sTitel="' + sTitel + '" (sTmp=' + sTmp + ')');
        sSQL :=        'INSERT INTO T_Events( ';
        sSQL := sSQL + 'ChannelId, ';
        sSQL := sSQL + 'EventId, ';
        sSQL := sSQL + 'Zeit, ';
        sSQL := sSQL + 'Dauer, ';
        sSQL := sSQL + 'Titel, ';
        sSQL := sSQL + 'SubTitel, ';
        sSQL := sSQL + 'Epg ) VALUES (';
        sSQL := sSQL + '''' + ChannelId     + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sEventId) + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sZeit)    + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sDauer)   + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sTitel)   + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sSubTitel)+ ''', ';
        sSQL := sSQL + '''' + CheckDbString(sEpg)     + ''');';
        ExecWorkQuery(sSQL);
        DoEvents;
      end;
    end else
    begin
      // INSERT-Mode.
      m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb INSERT sTitel="' + sTitel + '"');
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
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEventInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateEventInDb');
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
      if sTmpId <> '0' then
      begin
        // UPDATE-Mode.
        if (sTmpName <> CheckDbString(sName)) then
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb UPDATE sName="' + sName + '"');
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
        m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb INSERT sName="' + sName + '"');
        sSQL :=        'INSERT INTO T_Channel( ';
        sSQL := sSQL + 'ChannelId, ';
        sSQL := sSQL + 'Name ) VALUES (';
        sSQL := sSQL + '''' + ChannelId  + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sName) + ''');';
        ExecWorkQuery(sSQL);
        DoEvents;
      end;
    end else
    begin
      // INSERT-Mode.
      m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb INSERT sName="' + sName + '"');
      sSQL :=        'INSERT INTO T_Channel( ';
      sSQL := sSQL + 'ChannelId, ';
      sSQL := sSQL + 'Name ) VALUES (';
      sSQL := sSQL + '''' + ChannelId  + ''', ';
      sSQL := sSQL + '''' + CheckDbString(sName) + ''');';
      ExecWorkQuery(sSQL);
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateChannelInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateChannelInDb');
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
    sSQL :=        'SELECT ChannelId FROM ';
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





////////////////////////////////////////////////////////////////////////////////
//
// EOF.
//
////////////////////////////////////////////////////////////////////////////////
end.

