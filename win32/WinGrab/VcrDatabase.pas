////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrDatabase.pas,v $
// Revision 1.1  2004/07/02 14:02:37  thotto
// initial
//
//

////////////////////////////////////////////////////////////////////////////////
//
//  DataBase - Procedures ...
//
procedure TfrmMain.OpenEpgDb(sEpgDbFilename : String);
var
  sd1,sd2:string;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> OpenEpgDb');
  try
    if FileExists(sEpgDbFilename) then
    begin
      try
        m_Recorded_dbConnectionString           := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source="' + sEpgDbFilename + '";Persist Security Info=False';
        Recorded_ADOConnection.ConnectionString := m_Recorded_dbConnectionString;
        Recorded_ADOConnection.Open;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb ( Connect ) '+ E.Message );
      end;
      try
        Whishes_ADOConnection.ConnectionString := m_Recorded_dbConnectionString;
        Whishes_ADOConnection.Open;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb ( Connect ) '+ E.Message );
      end;
      try
        Work_ADOConnection.ConnectionString := m_Recorded_dbConnectionString;
        Work_ADOConnection.Open;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb ( Connect ) '+ E.Message );
      end;
      try
        Planner_ADOConnection.ConnectionString := m_Recorded_dbConnectionString;
        Planner_ADOConnection.Open;
        Planner_ADOTable.Active:= true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb ( Connect ) '+ E.Message );
      end;

      try
        Record_Planner.Visible:= true;
        Planner_DBDaySource.Day := Now;
        DoEvents;

        { Before the planner needs to be reloaded with records from the database
          a custom filter can be applied to minimize the nr. of records the planner
          must check to load into the planner.
        }
        sd1 := DateToStr(Planner_DBDaySource.Day);
        sd1 := #39+sd1+#39;

        sd2 := DateToStr(Planner_DBDaySource.Day+7);
        sd2 := #39+sd2+#39;

        Planner_ADOTable.Filter:=  'STARTTIME > '+sd1+' AND ENDTIME < '+sd2;
        Planner_ADOTable.Filtered := true;
        DoEvents;

        Record_Planner_UpdateHeaders;
        DoEvents;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb ( Connect ) '+ E.Message );
      end;

      try
        Recorded_ADOQuery.Close;
        Recorded_ADOQuery.SQL.Clear;
        Recorded_ADOQuery.SQL.Add('SELECT * FROM T_Recorded ORDER BY Titel;');
        Recorded_ADOQuery.ExecSQL;
        Recorded_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb / open T_Recorded  '+ E.Message );
      end;
      try
        Whishes_ADOQuery.Close;
        Whishes_ADOQuery.SQL.Clear;
        Whishes_ADOQuery.SQL.Add('SELECT * FROM T_Whishes ORDER BY Titel;');
        Whishes_ADOQuery.ExecSQL;
        Whishes_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb / open T_Whishes  '+ E.Message );
      end;
      try
        Work_ADOQuery.Close;
        Work_ADOQuery.SQL.Clear;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'OpenEpgDb / open T_Whishes  '+ E.Message );
      end;

      CheckDbVersion;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'OpenEpgDb '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< OpenEpgDb');
end;

procedure TfrmMain.CloseEpgDb();
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CloseEpgDb');
  try
    Recorded_ADOConnection.Close;
    Whishes_ADOConnection.Close;
    Work_ADOConnection.Close;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'OpenEpgDb '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CloseEpgDb');
end;

procedure TfrmMain.CheckDbVersion;
var
  sTmp,
  sSQL : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckDbVersion');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_DbVersion ;';
    Work_ADOQuery.SQL.Add(sSQL);
    try
      Work_ADOQuery.Active := true;
      if not Work_ADOQuery.Recordset.Eof then
      begin
        sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['Version'].Value, '0');
        if sTmp = '0' then
        begin
{
          sSQL :=        'UPDATE T_Events ';
          sSQL := sSQL + 'SET Zeit = '''     + CheckDbString(sZeit) + ''', ';
          sSQL := sSQL + 'SET Dauer = '''    + CheckDbString(sDauer) + ''', ';
          sSQL := sSQL + 'SET Titel = '''    + CheckDbString(sTitel) + ''', ';
          sSQL := sSQL + 'SET SubTitel = ''' + CheckDbString(sSubTitel) + ''', ';
          sSQL := sSQL + 'SET Epg = '''      + CheckDbString(sEpg) + ''' ';
          sSQL := sSQL + 'WHERE ';
          sSQL := sSQL + 'ChannelId = ''' + IntToStr(ChannelId) + ''' AND ';
          sSQL := sSQL + 'EventId   = ''' + CheckDbString(sEventId) + ''';';
          Work_ADOQuery.SQL.Clear;
          Work_ADOQuery.SQL.Add(sSQL);
          Work_ADOQuery.ExecSQL;
          Work_ADOQuery.Close;
 }
          Work_ADOQuery.SQL.Clear;
        end;
      end;
    except
      on E: Exception do
      begin
        Work_ADOQuery.SQL.Clear;
        sSQL :=        'CREATE TABLE ';
        sSQL := sSQL + 'T_DbVersion ( ';
        sSQL := sSQL + 'Version     NUMBER(10), ';
        sSQL := sSQL + 'Description VARCHAR2(255) ';
        sSQL := sSQL + ')';
        Work_ADOQuery.SQL.Add(sSQL);
        try
          Work_ADOQuery.ExecSQL;
          Work_ADOQuery.Close;
        except
        end;
        Work_ADOQuery.SQL.Clear;
        sSQL :=        'INSERT INTO ';
        sSQL := sSQL + 'T_DbVersion ( ';
        sSQL := sSQL + 'Version, Description ) VALUES ( 1, ''''Initial'''' ';
        sSQL := sSQL + ')';
        Work_ADOQuery.SQL.Add(sSQL);
        try
          Work_ADOQuery.ExecSQL;
          Work_ADOQuery.Close;
        except
        end;
        Work_ADOQuery.SQL.Clear;
      end;
    end;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'OpenEpgDb '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckDbVersion');
end;

procedure TfrmMain.Recorded_DBGridTitleClick(Column: TColumn);
begin
  try
    Recorded_ADOQuery.SQL.Clear;
    Recorded_ADOQuery.SQL.Add('SELECT * FROM T_Recorded ORDER BY ' + Column.FieldName + ';');
    Recorded_ADOQuery.ExecSQL;
    Recorded_ADOQuery.Active := true;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'Recorded_DBGridTitleClick '+ E.Message );
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TfrmMain.UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg : String);
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
        sTmp := Recorded_ADOQuery.SQL.GetText;
        Recorded_ADOQuery.Close;
        Recorded_ADOQuery.SQL.Clear;
        Recorded_ADOQuery.SQL.Add('UPDATE T_Recorded SET Titel=''' + CheckDbString(sEpgTitle) + ''' , SubTitel=''' + CheckDbString(sEpgSubTitle) + ''' , EPG=''' + CheckDbString(sEpg) + ''' WHERE IDN='+IntToStr(Idn)+' ;');
        Recorded_ADOQuery.ExecSQL;
        Recorded_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEpgInDb/Insert INTO T_RECORDED '+E.Message);
      end;
      try
        Recorded_ADOQuery.SQL.Clear;
        Recorded_ADOQuery.SQL.Add(sTmp);
        Recorded_ADOQuery.ExecSQL;
        Recorded_ADOQuery.Active := true;
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


procedure TfrmMain.SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg : String);
var
  sTmp    : String;
  Idn     : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> SaveEpgToDb');
  try
    Idn := 0;
    if not Recorded_ADOQuery.Recordset.Eof then
    begin
      Recorded_ADOQuery.Recordset.MoveFirst;
      try
        while not Recorded_ADOQuery.Recordset.Eof do
        begin
          if sEpgTitle = VarToStr(Recorded_ADOQuery.Recordset.Fields['Titel'].Value) then
          begin
            if sEpgSubTitle <> '' then
            begin
              if sEpgSubTitle = VarToStr(Recorded_ADOQuery.Recordset.Fields['SubTitel'].Value) then
              begin
                Idn:= Recorded_ADOQuery.Recordset.Fields['Idn'].Value;
                break;
              end;
            end else
            begin
              Idn:= Recorded_ADOQuery.Recordset.Fields['Idn'].Value;
              break;
            end;
          end;
          Recorded_ADOQuery.Recordset.MoveNext;
        end;
      finally
        Recorded_ADOQuery.Recordset.MoveFirst;
      end;

      if Idn > 0 then
      begin
        UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg);
      end else
      begin
        try
          sTmp := Recorded_ADOQuery.SQL.GetText;
          Recorded_ADOQuery.Close;
          Recorded_ADOQuery.SQL.Clear;
          Recorded_ADOQuery.SQL.Add('INSERT INTO T_Recorded(Titel, SubTitel, EPG) VALUES(''' + CheckDbString(sEpgTitle) + ''', ''' + CheckDbString(sEpgSubTitle) + ''', ''' + CheckDbString(sEpg) + ''');');
          Recorded_ADOQuery.ExecSQL;
          Recorded_ADOQuery.Close;
        except
          on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb/Insert INTO T_RECORDED '+E.Message);
        end;
      end;
    end;

    Idn := IsInWhishesList(sEpgTitle, '','');
    if Idn > 0 then
    begin
      try
        sTmp := Whishes_ADOQuery.SQL.GetText;
        Whishes_ADOQuery.Close;
        Whishes_ADOQuery.SQL.Clear;
        Whishes_ADOQuery.SQL.Add('DELETE FROM T_Whishes WHERE IDN='+IntToStr(Idn)+' AND Serie=0;');
        Whishes_ADOQuery.ExecSQL;
        Whishes_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/Insert INTO T_Whishes '+E.Message);
      end;
      try
        Whishes_ADOQuery.SQL.Clear;
        Whishes_ADOQuery.SQL.Add(sTmp);
        Whishes_ADOQuery.ExecSQL;
        Whishes_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/SELECT * T_Whishes '+E.Message);
      end;
    end;

    try
      Recorded_ADOQuery.SQL.Clear;
      Recorded_ADOQuery.SQL.Add(sTmp);
      Recorded_ADOQuery.ExecSQL;
      Recorded_ADOQuery.Active := true;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb/SELECT * T_RECORDED '+E.Message);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveEpgToDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< SaveEpgToDb');
end;

function  TfrmMain.IsInRecordedList(sTitel, sSubTitle : String): Integer;
var
  sTmp,
  sRecorded : String;
  iCount    : Integer;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> IsInRecordedList');
  try
    m_Trace.DBMSG(TRACE_SYNC, 'IsInRecordedList sTitel="' + sTitel + '"');
    try
      if not Recorded_ADOQuery.Recordset.Eof then
      begin
        Recorded_ADOQuery.Recordset.MoveFirst;
        while not Recorded_ADOQuery.Recordset.Eof do
        begin
          sRecorded := VarToStr(Recorded_ADOQuery.Recordset.Fields['Titel'].Value);
          if SameName(     sRecorded+' *',     sTitel+' ')
          or SameName('* '+sRecorded     , ' '+sTitel    )
          or SameName('* '+sRecorded+' *', ' '+sTitel+' ')
          then
          begin
            sRecorded := VarToStr(Recorded_ADOQuery.Recordset.Fields['SubTitel'].Value);
            if (sSubTitle <> '') and (sRecorded <> '') then
            begin
              if SameName(     sRecorded+' *',     sSubTitle+' ')
              or SameName('* '+sRecorded     , ' '+sSubTitle    )
              or SameName('* '+sRecorded+' *', ' '+sSubTitle+' ')
              then
              begin
                m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+' - '+sSubTitle+'" (?)');
                Result := (Recorded_ADOQuery.Recordset.Fields['Idn'].Value);
                Recorded_ADOQuery.Recordset.MoveFirst;
                m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
                exit;
              end;
            end else
            begin
              m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
              Result := (Recorded_ADOQuery.Recordset.Fields['Idn'].Value);
              Recorded_ADOQuery.Recordset.MoveFirst;
              m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
              exit;
            end;
          end;
          if SameName(     sTitel+' *',     sRecorded+' ')
          or SameName('* '+sTitel     , ' '+sRecorded    )
          or SameName('* '+sTitel+' *', ' '+sRecorded+' ')
          then
          begin
            sRecorded := VarToStr(Recorded_ADOQuery.Recordset.Fields['SubTitel'].Value);
            if (sSubTitle <> '') and (sRecorded <> '') then
            begin
              if SameName(     sSubTitle+' *',     sRecorded+' ')
              or SameName('* '+sSubTitle     , ' '+sRecorded    )
              or SameName('* '+sSubTitle+' *', ' '+sRecorded+' ')
              then
              begin
                m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+' - '+sSubTitle+'" (?)');
                Result := (Recorded_ADOQuery.Recordset.Fields['Idn'].Value);
                Recorded_ADOQuery.Recordset.MoveFirst;
                m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
                exit;
              end;
            end else
            begin
              m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
              Result := (Recorded_ADOQuery.Recordset.Fields['Idn'].Value);
              Recorded_ADOQuery.Recordset.MoveFirst;
              m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
              exit;
            end;
          end;
          Recorded_ADOQuery.Recordset.MoveNext;
        end;
        Recorded_ADOQuery.Recordset.MoveFirst;
      end;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInRecordedList '+E.Message);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInRecordedList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInRecordedList');
end;

procedure TfrmMain.SaveWhishesToDb(sEpgTitle : String);
var
  sTmp : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> SaveWhishesToDb');
  try
    if IsInWhishesList(sEpgTitle, '','') = 0 then
    begin
      try
        sTmp := Whishes_ADOQuery.SQL.GetText;
        Whishes_ADOQuery.Close;
        Whishes_ADOQuery.SQL.Clear;
        Whishes_ADOQuery.SQL.Add('INSERT INTO T_Whishes(Titel) VALUES(''' + CheckDbString(sEpgTitle) + ''');');
        Whishes_ADOQuery.ExecSQL;
        Whishes_ADOQuery.Close;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/Insert INTO T_Whishes '+E.Message);
      end;
      try
        Whishes_ADOQuery.SQL.Clear;
        Whishes_ADOQuery.SQL.Add(sTmp);
        Whishes_ADOQuery.ExecSQL;
        Whishes_ADOQuery.Active := true;
      except
        on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb/SELECT * T_Whishes '+E.Message);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'SaveWhishesToDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< SaveWhishesToDb');
end;

function  TfrmMain.IsInWhishesList(sTitel, sZeit, sDauer : String): Integer;
var
  sRecorded,
  sTmp       : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> IsInWhishesList');
  try
    if sTitel = '' then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
      exit;
    end;
    m_Trace.DBMSG(TRACE_SYNC, 'IsInWhishesList sTitel="' + sTitel + '"');
    try
      if not Whishes_ADOQuery.Recordset.Eof then
      begin
        Whishes_ADOQuery.Recordset.MoveFirst;
        while not Whishes_ADOQuery.Recordset.Eof do
        begin
          sRecorded := VarToStr(Whishes_ADOQuery.Recordset.Fields['Titel'].Value);
          if SameName(     sRecorded+' *',     sTitel+' ')
          or SameName('* '+sRecorded     , ' '+sTitel    )
          or SameName('* '+sRecorded+' *', ' '+sTitel+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
            Result := (Whishes_ADOQuery.Recordset.Fields['Idn'].Value);
            Whishes_ADOQuery.Recordset.MoveFirst;
            m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
            exit;
          end;
          if SameName(     sTitel+' *',     sRecorded+' ')
          or SameName('* '+sTitel     , ' '+sRecorded    )
          or SameName('* '+sTitel+' *', ' '+sRecorded+' ')
          then
          begin
            m_Trace.DBMSG(TRACE_SYNC, 'maybe the same : "'+sRecorded+'" = "'+sTitel+'" (?)');
            Result := (Whishes_ADOQuery.Recordset.Fields['Idn'].Value);
            Whishes_ADOQuery.Recordset.MoveFirst;
            m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
            exit;
          end;
          Whishes_ADOQuery.Recordset.MoveNext;
        end;
        Whishes_ADOQuery.Recordset.MoveFirst;
      end;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInWhishesList/SELECT * T_Whishes WHERE '+E.Message);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'IsInWhishesList '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< IsInWhishesList');
end;

////////////////////////////////////////////////////////////////////////////////
//
// Kanalliste
//
function  TfrmMain.GetDbChannelId( sChannelName : String ) : String;
var
  sTmpId,
  sSQL     : String;
begin
  Result := '0';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelId');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT ChannelId FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'Name = ''' + CheckDbString(sChannelName) + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmpId   := VarToStrDef(Work_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
      if sTmpId <> '0' then
      begin
        Result := sTmpId;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelId '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelId='+sTmpId);
end;

function  TfrmMain.GetDbChannelName( ChannelId : String ) : String;
var
  sTmpName,
  sSQL     : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelName');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT Name FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmpName := VarToStrDef(Work_ADOQuery.Recordset.Fields['Name'].Value, '');
      if sTmpName <> '' then
      begin
        Result := sTmpName;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelName '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelName');
end;

function  TfrmMain.GetDbChannelSwitchFlag( ChannelId : String ) : Integer;
var
  sTmp,
  sSQL     : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelSwitchFlag');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT SwitchEpg FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['SwitchEpg'].Value, '');
      if sTmp <> '' then
      begin
        Result := StrToInt(sTmp);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelSwitchFlag '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelSwitchFlag');
end;


function  TfrmMain.GetDbChannelEpgFlag( ChannelId : String ) : Integer;
var
  sTmp,
  sSQL     : String;
begin
  Result := 0;
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbChannelEpgFlag');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT FindEpg FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['FindEpg'].Value, '0');
      if sTmp <> '' then
      begin
        Result := StrToIntDef(sTmp,0);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetDbChannelEpgFlag '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetDbChannelEpgFlag');
end;


procedure TfrmMain.FillDbChannelListBox;
var
  sTmp,
  sName,
  sSQL     : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> FillDbChannelListBox');
  try
    lbxChannelList.Items.BeginUpdate;
    lbxChannelList.Items.Clear;
    try
      Work_ADOQuery.SQL.Clear;
      sSQL :=        'SELECT * FROM ';
      sSQL := sSQL + 'T_Channel;';
      Work_ADOQuery.SQL.Add(sSQL);
      Work_ADOQuery.Active := true;
      if not Work_ADOQuery.Recordset.Eof then
      begin
        repeat
          sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
          if sTmp <> '0' then
          begin
            sName := VarToStrDef(Work_ADOQuery.Recordset.Fields['Name'].Value, '?');
            lbxChannelList.Items.Add(sName);
          end;
          Work_ADOQuery.Recordset.MoveNext;
        until(Work_ADOQuery.Recordset.Eof);
        lbxChannelList.ItemIndex := 0;
      end;
    finally
      lbxChannelList.Items.EndUpdate;
    end;
    DoEvents;
    lbxChannelListClick(self);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FillDbChannelListBox '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< FillDbChannelListBox');
end;

procedure TfrmMain.UpdateChannelInDb( ChannelId : String;
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
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Channel WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmpName := VarToStrDef(Work_ADOQuery.Recordset.Fields['Name'].Value, '');
      sTmpId   := VarToStrDef(Work_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
      if sTmpId <> '0' then
      begin
        // UPDATE-Mode.
        if (sTmpName <> CheckDbString(sName)) then
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb UPDATE sName="' + sName + '"');
          Work_ADOQuery.SQL.Clear;
          sSQL :=        'UPDATE T_Channel ';
          sSQL := sSQL + 'SET Name = '''     + CheckDbString(sName) + ''' ';
          sSQL := sSQL + 'WHERE ';
          sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
          Work_ADOQuery.SQL.Add(sSQL);
          Work_ADOQuery.ExecSQL;
          DoEvents;
          Work_ADOQuery.Close;
          Work_ADOQuery.SQL.Clear;
        end;
      end else
      begin
        // INSERT-Mode.
        m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb INSERT sName="' + sName + '"');
        Work_ADOQuery.SQL.Clear;
        sSQL :=        'INSERT INTO T_Channel( ';
        sSQL := sSQL + 'ChannelId, ';
        sSQL := sSQL + 'Name ) VALUES (';
        sSQL := sSQL + '''' + ChannelId  + ''', ';
        sSQL := sSQL + '''' + CheckDbString(sName) + ''');';
        Work_ADOQuery.SQL.Add(sSQL);
        Work_ADOQuery.ExecSQL;
        DoEvents;
        Work_ADOQuery.Close;
        Work_ADOQuery.SQL.Clear;
      end;
    end else
    begin
      // INSERT-Mode.
      m_Trace.DBMSG(TRACE_SYNC, 'UpdateChannelInDb INSERT sName="' + sName + '"');
      Work_ADOQuery.SQL.Clear;
      sSQL :=        'INSERT INTO T_Channel( ';
      sSQL := sSQL + 'ChannelId, ';
      sSQL := sSQL + 'Name ) VALUES (';
      sSQL := sSQL + '''' + ChannelId  + ''', ';
      sSQL := sSQL + '''' + CheckDbString(sName) + ''');';
      Work_ADOQuery.SQL.Add(sSQL);
      Work_ADOQuery.ExecSQL;
      DoEvents;
      Work_ADOQuery.Close;
      Work_ADOQuery.SQL.Clear;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateChannelInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateChannelInDb');
end;

////////////////////////////////////////////////////////////////////////////////
//
// EventListe
//
procedure TfrmMain.FillDbEventListView( ChannelId : String );
var
  iTmp     : String;
  sTmp,
  sSQL     : String;
  sEventId : String;
  sZeit    : String;
  sDatum   : String;
  sUhrzeit : String;
  sDauer   : String;
  sTitel   : String;
  sSubTitel: String;
  sEpg     : String;
  Datum    : TDateTime;
  ListItem : TListItem;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> FillDbEventListView ' + ChannelId);
  try
    lvChannelProg.Items.Clear;
    lvChannelProg.Items.BeginUpdate;
    try
      sZeit := IntToStr(DateTimeToUnix(IncHour((Now - OffsetFromUTC),-3)));
      Work_ADOQuery.SQL.Clear;
      sSQL :=        'SELECT * FROM ';
      sSQL := sSQL + 'T_Events WHERE ';
      sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
      sSQL := sSQL + 'Zeit     >= ''' + CheckDbString(sZeit) + ''' ';
      sSQL := sSQL + 'ORDER BY Zeit ;';
      Work_ADOQuery.SQL.Add(sSQL);
      Work_ADOQuery.Active := true;
      if not Work_ADOQuery.Recordset.Eof then
      begin
        repeat
          sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['ChannelId'].Value, '0');
          if sTmp <> '0' then
          begin
            try            //dezimal-string ...
              sEventId  := VarToStrDef(Work_ADOQuery.Recordset.Fields['EventId'].Value, '0');
              if Length(sEventId) = 10 then //hex ???
                sEventId  := IntToStr(StrToInt64Ex(sEventId));
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sEventId '+E.Message);
            end;
            try
              sZeit     := VarToStrDef(Work_ADOQuery.Recordset.Fields['Zeit'].Value, '0');
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sZeit '+E.Message);
            end;
            try            //from sec to min ...
              sDauer    := IntToStr(StrToInt(VarToStrDef(Work_ADOQuery.Recordset.Fields['Dauer'].Value, '0')) div 60);
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sDauer '+E.Message);
            end;
            try
              sTitel    := VarToStrDef(Work_ADOQuery.Recordset.Fields['Titel'].Value, '?');
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sTitel '+E.Message);
            end;
            try
              sSubTitel := VarToStrDef(Work_ADOQuery.Recordset.Fields['SubTitel'].Value, '');
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sSubTitel '+E.Message);
            end;
            try
              sEpg      := VarToStrDef(Work_ADOQuery.Recordset.Fields['Epg'].Value, '');
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error sEpg '+E.Message);
            end;
            try            //add offset from daylightsaving ...
              Datum     := UnixToDateTime(StrToInt64Def(sZeit,0)) + OffsetFromUTC;
              DateTimeToString(sDatum,   'dd.mm.yyyy', Datum);
              DateTimeToString(sUhrzeit, 'hh:nn', Datum);
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error Datum '+E.Message);
            end;
            try
              ListItem := lvChannelProg.Items.Add;
              ListItem.Caption := sEventId; //unvisible ...
              ListItem.SubItems.Add(sZeit);
              ListItem.SubItems.Add(sDatum);
              ListItem.SubItems.Add(sUhrzeit);
              ListItem.SubItems.Add(sDauer);
              if sSubTitel <> '' then
              begin
                ListItem.SubItems.Add(sTitel + ' - ' + sSubTitel);
              end else
              begin
                ListItem.SubItems.Add(sTitel);
              end;
              ListItem.SubItems.Add(sEpg);
            except
              on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'Error lvChannelProg.Items... '+E.Message);
            end;
          end;
          Work_ADOQuery.Recordset.MoveNext;
        until(Work_ADOQuery.Recordset.Eof);
        GetCurrentEvent(ChannelId);
        DoEvents;
      end;
    finally
      lvChannelProg.Items.EndUpdate;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'FillDbChannelListBox '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< FillDbEventListView');
end;

procedure TfrmMain.TruncDbEvent;
var
  sTmp,
  sSQL     : String;
  sZeit    : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> TruncDbEvent');
  try
    sZeit := IntToStr(DateTimeToUnix(IncHour((Now - OffsetFromUTC),-3)));
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'DELETE * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'Zeit < ''' + CheckDbString(sZeit) + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.ExecSQL;
    DoEvents;
    Work_ADOQuery.Close;
    Work_ADOQuery.SQL.Clear;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'TruncDbEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< TruncDbEvent');
end;


function TfrmMain.GetCurrentDbEvent(ChannelId : String): String;
var
  sZeit,
  sEventId,
  sSQL  : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetCurrentDbEvent');
  try
    sZeit := IntToStr( DateTimeToUnix(Now() - OffsetFromUTC() ) );
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId  + ''' AND ';
    sSQL := sSQL + 'Zeit < ''' + CheckDbString(sZeit) + ''' ';
    sSQL := sSQL + 'ORDER BY Zeit DESC;';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sEventId  := VarToStrDef(Work_ADOQuery.Recordset.Fields['EventId'].Value, '0');
      if sEventId <> '0' then
      begin
        lvChannelProg.Selected:= lvChannelProg.FindCaption(1,sEventId,false,true,true);
        Result := sEventId;
        DoEvents;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'GetCurrentDbEvent '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< GetCurrentDbEvent');
end;

procedure TfrmMain.UpdateEventInDb( ChannelId : String;
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
    Work_ADOQuery.Active:= false;
    Work_ADOQuery.SQL.Clear;
    DoEvents;
    sSQL :=        'SELECT * FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
    sSQL := sSQL + 'EventId   = ''' + CheckDbString(sEventId) + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTmp := VarToStrDef(Work_ADOQuery.Recordset.Fields['EventId'].Value, '0');
      sTmpEpg := VarToStrDef(Work_ADOQuery.Recordset.Fields['Epg'].Value, '');
      if sTmp <> '0' then
      begin
        // UPDATE-Mode.
        if sEpg <> sTmpEpg then
        begin
          m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb UPDATE sTitel="' + sTitel + '"');
          Work_ADOQuery.SQL.Clear;
          sSQL :=        'UPDATE T_Events SET ';
          sSQL := sSQL + 'SubTitel = ''' + CheckDbString(sSubTitel) + ''', ';
          sSQL := sSQL + 'Epg = '''      + CheckDbString(sEpg) + ''' ';
          sSQL := sSQL + 'WHERE ';
          sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''' AND ';
          sSQL := sSQL + 'EventId   = ''' + CheckDbString(sEventId) + ''';';
          Work_ADOQuery.SQL.Add(sSQL);
          Work_ADOQuery.ExecSQL;
          DoEvents;
          Work_ADOQuery.Close;
          Work_ADOQuery.SQL.Clear;
        end;
      end else
      begin
        // INSERT-Mode.
        m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb INSERT sTitel="' + sTitel + '" (sTmp=' + sTmp + ')');
        Work_ADOQuery.SQL.Clear;
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
        Work_ADOQuery.SQL.Add(sSQL);
        Work_ADOQuery.ExecSQL;
        DoEvents;
        Work_ADOQuery.Close;
        Work_ADOQuery.SQL.Clear;
      end;
    end else
    begin
      // INSERT-Mode.
      m_Trace.DBMSG(TRACE_SYNC, 'UpdateEventInDb INSERT sTitel="' + sTitel + '"');
      Work_ADOQuery.SQL.Clear;
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
      Work_ADOQuery.SQL.Add(sSQL);
      Work_ADOQuery.ExecSQL;
      DoEvents;
      Work_ADOQuery.Close;
      Work_ADOQuery.SQL.Clear;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'UpdateEventInDb '+E.Message +' SQL:'+ sSQL);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< UpdateEventInDb');
end;

function TfrmMain.GetDbEventEpg(ChannelId    : String;
                                EventId      : String;
                                var sTitel,
                                    sSubTitel: String): String;
var
  sTmp,
  sSQL     : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> GetDbEventEpg');
  try
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT Epg, Titel, SubTitel FROM ';
    sSQL := sSQL + 'T_Events WHERE ';
    sSQL := sSQL + 'EventId = ''' + CheckDbString(EventId) + ''' AND ';
    sSQL := sSQL + 'ChannelId = ''' + ChannelId + ''';';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      sTitel    := VarToStrDef(Work_ADOQuery.Recordset.Fields['Titel'].Value, '');
      sSubTitel := VarToStrDef(Work_ADOQuery.Recordset.Fields['SubTitel'].Value, '');
      Result    := VarToStrDef(Work_ADOQuery.Recordset.Fields['Epg'].Value, '');
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

procedure TfrmMain.CheckChannelsInDb;
var
//  ChannelId        : Int64;
//  EventId          : Int64;
//  i,j,x            : Integer;
  sDbg             : String;
//  sLabel           : String;
  sTmp,
  sSQL             : String;

  sChannelName     : String;

  sChannelId : String;
  sEventId : String;
  sZeit    : String;
  sDatum   : String;
  sUhrzeit : String;
  sDauer   : String;
  sTitel   : String;
  sSubTitel: String;
//  sEpg     : String;
  sTimerStr: String;
  Datum    : TDateTime;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckChannelsInDb');

    sZeit := IntToStr( DateTimeToUnix(Now() - OffsetFromUTC() ) );
    Work_ADOQuery.SQL.Clear;
    sSQL :=        'SELECT ';
    sSQL := sSQL + 'T_Events.ChannelId, T_Events.EventId, T_Channel.Name, ';
    sSQL := sSQL + 'Titel, SubTitel, Zeit, Dauer ';
    sSQL := sSQL + 'FROM ';
    sSQL := sSQL + 'T_Events, T_Channel ';
    sSQL := sSQL + 'WHERE ';
    sSQL := sSQL + 'T_Channel.ChannelId = T_Events.ChannelId AND ';
    sSQL := sSQL + 'T_Channel.FindEpg   > 0 AND ';
    sSQL := sSQL + 'Zeit > ''' + CheckDbString(sZeit) + ''' ';
    sSQL := sSQL + 'ORDER BY Zeit ASC, T_Channel.Idn ASC ;';
    Work_ADOQuery.SQL.Add(sSQL);
    Work_ADOQuery.Active := true;
    if not Work_ADOQuery.Recordset.Eof then
    begin
      Whishes_Result.Items.Clear;
      Whishes_Result.Items.Add('Durchsuche die EPG-Datenbank nach vorgemerkten Sendungen ...');
      DoEvents;
      repeat
        sChannelId   := VarToStrDef(Work_ADOQuery.Recordset.Fields['ChannelId'].Value, '');
        sTitel       := VarToStrDef(Work_ADOQuery.Recordset.Fields['Titel'].Value, '');
        sSubTitel    := VarToStrDef(Work_ADOQuery.Recordset.Fields['SubTitel'].Value, '');
        sEventId     := VarToStrDef(Work_ADOQuery.Recordset.Fields['EventId'].Value, '');
        sZeit        := VarToStrDef(Work_ADOQuery.Recordset.Fields['Zeit'].Value, '');
        sDauer       := VarToStrDef(Work_ADOQuery.Recordset.Fields['Dauer'].Value, '');
        sChannelName := VarToStrDef(Work_ADOQuery.Recordset.Fields['Name'].Value, '');
        if Length(sSubTitel) > 0 then
          sTmp := sTitel + ' - ' + sSubTitel
        else
          sTmp := sTitel;
        try
          Datum  := UnixToDateTime(StrToInt64Def(sZeit,0)) + OffsetFromUTC;
        except
        end;
        DateTimeToString(sDatum, 'dd.mm.yyyy', Datum);
        DateTimeToString(sUhrzeit, 'hh:nn', Datum);

        lbl_check_EPG.Caption:= sDatum +' '+ sUhrzeit +' "'+ sChannelName +'"';
        DoEvents;

        sDbg := 'CheckChannelProg '+sChannelName+' eventid=' + sEventId + ' Titel="' + sTmp  + '"';
        m_Trace.DBMSG(TRACE_SYNC, sDbg);
        DoEvents;

        if IsInWhishesList(sTmp,sZeit,sDauer) > 0 then
        begin
          sDbg:= '"'+sTmp+'" am '+sDatum+' '+sUhrzeit+' auf "'+sChannelName+'" gefunden';
          m_Trace.DBMSG(TRACE_DETAIL, sDbg);

          sTimerStr :=             '/fb/timer.dbox2?action=new&type=5&alarm=' + sZeit;
          sTimerStr := sTimerStr + '&stop=' + IntToStr( StrToInt64Def(sZeit,0) + StrToIntDef(sDauer,0) );
          sTimerStr := sTimerStr + '&channel_id=' + sChannelId + '&rs=1';

          Whishes_Result.Items.Add(sDbg + '                                                                                                    ### ' + sTimerStr);
        end;
        Work_ADOQuery.Recordset.MoveNext;
      until(Work_ADOQuery.Recordset.Eof);

      Whishes_Result.Items.Add('... fertig');
    end;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckChannelsInDb '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelsInDb');
end;

procedure TfrmMain.CheckChannelProgInDb(ChannelId: String);
var
  sDbg     : String;
  sTmp     : String;
  sLabel   : String;
  iLabel   : Integer;
  sLine    : String;
  sEventId : String;
  sFstEvId : String;
  sZeit    : String;
  sDatum   : String;
  sUhrzeit : String;
  sDauer   : String;
  sTitel   : String;
  sSubTitel: String;
  sEpg     : String;
  sTimerStr: String;
  Datum    : TDateTime;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckChannelProg');
  try
    if not PingDBox(m_sDBoxIp) then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelProg (no PING)');
      exit;
    end;

    if IsDBoxRecording then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelProg (DBox is recording now)');
      exit;
    end;

    sDbg := 'CheckChannelProg /control/epg?' + (ChannelId);
    m_Trace.DBMSG(TRACE_SYNC, sDbg);

    DateSeparator   := '-';
    ShortDateFormat := 'yyyy/m/d';
    TimeSeparator   := '.';

    sLabel := lbl_check_EPG.Caption;
    iLabel := 1;

    sTmp := SendHttpCommand('/control/epg?' + (ChannelId));
    if Length(sTmp) > 0 then
    begin
      sTmp := sTmp + #10;
      repeat
        sLine := Copy(sTmp, 1, Pos(#10,sTmp)-1);
        if sLine = '' then
        begin
          m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelProg (line is empty)');
          exit;
        end;
        m_Trace.DBMSG(TRACE_SYNC, sLine);

        case iLabel of
          1: begin
               iLabel:= 2;
               lbl_check_EPG.Caption:= sLabel + ' .';
             end;
          2: begin
               iLabel:= 3;
               lbl_check_EPG.Caption:= sLabel + ' ..';
             end;
          3: begin
               iLabel:= 1;
               lbl_check_EPG.Caption:= sLabel + ' ...';
             end;
        end;
        DoEvents;

        sTmp := Copy(sTmp, Pos(#10,sTmp)+1, Length(sTmp));
        ////////
        try
          sEventId := Copy(sLine, 1, Pos(' ',sLine)-1);
        except
        end;
        if sFstEvId = '' then
        begin
          sFstEvId := sEventId;
        end;
        sLine    := Copy(sLine, Pos(' ',sLine)+1, Length(sLine));
        sZeit    := Copy(sLine, 1, Pos(' ',sLine)-1);
        ////////
        Datum := Now();
        try
          Datum  := UnixToDateTime(StrToInt64Def(sZeit,0)) + OffsetFromUTC;
        except
        end;
        if Datum > Now() then
        begin
          DateTimeToString(sDatum, 'dd.mm.yyyy', Datum);
          DateTimeToString(sUhrzeit, 'hh:nn', Datum);
          ////////
          sLine    := Copy(sLine, Pos(' ',sLine)+1, Length(sLine));
          sDauer   := IntToStr(StrToIntDef(Trim(Copy(sLine, 1, Pos(' ',sLine)-1)),60));
          m_Trace.DBMSG(TRACE_SYNC, 'Dauer '+sDauer);
          ////////
          sTitel   := Copy(sLine, Pos(' ',sLine)+1, Length(sLine));
          sEpg     := SaveEpgText(IntToHex(StrToInt64Ex(sEventId),10), '', sTitel, sSubTitel).Text;
          ////////

{
          UpdateEventInDb(ChannelId,
                          sEventId,
                          sZeit,
                          sDauer,
                          sTitel,
                          sSubTitel,
                          sEpg);
}
          DoEvents;

          sDbg := 'CheckChannelProg eventid=' + sEventId + ' Titel="' + sTitel + '" SubTilel="' + sSubTitel  + '"';
          m_Trace.DBMSG(TRACE_SYNC, sDbg);
          DoEvents;
          if IsInWhishesList(sTitel,sZeit,sDauer) > 0 then
          begin
            sDbg:= 'Titel "'+sTitel+'" auf "'+GetDbChannelName(ChannelId)+'" am '+sDatum+' um '+sUhrzeit+' gefunden !';
            m_Trace.DBMSG(TRACE_DETAIL, sDbg);

            sTimerStr := '/fb/timer.dbox2?action=new&type=5&alarm=' + sZeit;
            sTimerStr := sTimerStr + '&stop=' + IntToStr( StrToInt64Def(sZeit,0) + StrToIntDef(sDauer,0) );
            sTimerStr := sTimerStr + '&channel_id=' + ChannelId + '&rs=1';

            Whishes_Result.Items.Add(sDbg + '                                                                                                    ### ' + sTimerStr);
          end;
        end;
        if IsDBoxRecording then
        begin
          m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelProg (DBox is recording now)');
          exit;
        end;
        DoEvents;
      until( Length(sTmp) <= 0 );
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckChannelProg '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckChannelProg');
end;

//
//  DataBase - Procedures ...
//
////////////////////////////////////////////////////////////////////////////////
