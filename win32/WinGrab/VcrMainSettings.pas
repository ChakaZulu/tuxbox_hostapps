////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrMainSettings.pas,v $
// Revision 1.3  2004/12/03 16:09:49  thotto
// - Bugfixes
// - EPG suchen überarbeitet
// - Timerverwaltung geändert
// - Ruhezustand / Standby gefixt
//
// Revision 1.2  2004/10/11 15:33:39  thotto
// Bugfixes
//
// Revision 1.1  2004/07/02 14:06:35  thotto
// initial
//
//

////////////////////////////////////////////////////////////////////////////////
//
//  Settings ...
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.LoadSettings;
var
  i    : Integer;
  iOk  : Integer;
  sTmp : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> LoadSettings');
  with TRegistryIniFile.Create('Software\GNU\TuxBox\1.0') do
  try
    DbgMsg('Load Settings');

    m_bInit := false;
    iOk := 0;

    m_sDBoxIp := ReadString('WinGrab', 'IP', '192.168.1.100');
    m_Trace.DBMSG(TRACE_DETAIL, 'IP : ' + m_sDBoxIp );
    edIp.IpAddress := m_sDBoxIp;
    DoEvents;

    VcrEpgClientSocket.Address:= m_sDBoxIp;
    VCRCommandServerSocket.Active := true;

    if not PingDBox(m_sDBoxIp) then
    begin
      iOk := iOk + 1;
    end;

    m_bDVDx      := ReadBool('WinGrab', 'DVDx', False);
    chk_DVDx_enabled.Enabled  := true;
    chk_DVDx_enabled.Checked  := m_bDVDx;

    m_bMoviX     := ReadBool('WinGrab', 'MoviX', False);
    chk_MoviX_enabled.Enabled := m_bDVDx AND chk_DVDx_enabled.Enabled;
    chk_MoviX_enabled.Checked := m_bMoviX;

    m_sM2pPath   := ReadString('WinGrab', 'M2pPath',   'C:\Movies\');
    m_Trace.DBMSG(TRACE_DETAIL, 'M2pPath : ' + m_sM2pPath );
    edOutPath.Text := m_sM2pPath;
    if not CheckPath(edOutPath) then iOk := iOk + 1;

    m_sDVDxPath  := ReadString('WinGrab', 'DVDxPath',  'C:\Programme\DVDx\DVDx.exe');
    m_Trace.DBMSG(TRACE_DETAIL, 'DVDxPath : ' + m_sDVDxPath );
    edDvdxFilePath.Text := m_sDVDxPath;
    if not FileExists(edDvdxFilePath.Text) then iOk := iOk + 1;

    m_sMoviXPath := ReadString('WinGrab', 'MoviXPath', 'C:\Programme\MoviX\');
    m_Trace.DBMSG(TRACE_DETAIL, 'MoviXPath : ' + m_sMoviXPath );
    edMovixPath.Text :=  m_sMoviXPath;
    if not CheckPath(edMovixPath) then iOk := iOk + 1;

    m_sIsoPath   := ReadString('WinGrab', 'IsoPath',   'C:\Iso\');
    m_Trace.DBMSG(TRACE_DETAIL, 'IsoPath : ' + m_sIsoPath );
    edIsoPath.Text := m_sIsoPath;
    if not CheckPath(edIsoPath) then iOk := iOk + 1;

    m_bCDRwBurn  := ReadBool( 'WinGrab', 'CDRwBurn', False);
    chk_CDRwBurn_enabled.Checked := m_bCDRwBurn;
    chk_CDRwBurn_enabled.Enabled := m_bMoviX    AND chk_MoviX_enabled.Enabled;

    m_bDVDx     := chk_DVDx_enabled.Checked     AND chk_DVDx_enabled.Enabled;
    m_bMoviX    := chk_MoviX_enabled.Checked    AND chk_MoviX_enabled.Enabled;
    m_bCDRwBurn := chk_CDRwBurn_enabled.Checked AND chk_CDRwBurn_enabled.Enabled;

    m_sCDRwDevId        := ReadString('WinGrab', 'CDRwDevId', '2,0,0');
    m_Trace.DBMSG(TRACE_DETAIL, 'CDRwDevId : ' + m_sCDRwDevId );
    edCDRWDeviceId.Text := m_sCDRwDevId;
    m_sCDRwSpeed     := ReadString('WinGrab', 'CDRwSpeed', '2');
    m_Trace.DBMSG(TRACE_DETAIL, 'CDRwSpeed : ' + m_sCDRwSpeed );
    edCDRwSpeed.Text := m_sCDRwSpeed;

    m_bVlc     := false;
    m_sVlcPath := ReadString('WinGrab', 'VlcPath', 'C:\Programme\VideoLAN\VLC\');
    m_Trace.DBMSG(TRACE_DETAIL, 'VlcPath : ' + m_sVlcPath );
    edVlcPath.Text := m_sVlcPath;
    m_bVlc     := ReadBool(  'WinGrab', 'UseVlc', False);
    chxVlc.Checked := m_bVlc;
    btnVlcView.Enabled:= m_bVlc;

///////
    cbxSplitSize.Text := ReadString('WinGrab', 'SplittSize', '');
    m_Trace.DBMSG(TRACE_DETAIL, 'SplittSize : ' + cbxSplitSize.Text );
    chxSplitting.Checked := cbxSplitSize.Text <> '';
    chxSplitting.OnClick(chxSplitting);
    i := cbxSplitSize.Items.IndexOf(cbxSplitSize.Text);
    if i >= 0 then
      cbxSplitSize.ItemIndex := i;
    if chxSplitting.Checked and (cbxSplitSize.Text <> '') then
      SplittSize := StrToInt(cbxSplitSize.Text)
    else
      SplittSize := 0;

    gbxPowersave.ItemIndex    := ReadInteger('WinGrab', 'Powersave', 2);
    gbxGrabMode.ItemIndex     := ReadInteger('WinGrab', 'GrabMode', 1);

    chxKillSectionsd.Checked  := ReadBool('WinGrab', 'KillSectionsd', true);

    chxSwitchChannel.Checked  := ReadBool('WinGrab', 'SwitchChannel', true);

    sTmp := ReadString('WinGrab', 'LastEpgUpdate', '2000-1-1 00.00.00');
    m_Trace.DBMSG(TRACE_DETAIL, 'LastEpgUpdate : ' + sTmp );
    try
      m_LastEpgUpdate := StrToDateTime(sTmp);
    except
      m_LastEpgUpdate := IncHour((Now - OffsetFromUTC), -48);
    end;
////////

    for i:= 0 to 9 do
    begin
      m_RecordingThread[i].RecordingData.bDVDx        := m_bDVDx;
      m_RecordingThread[i].RecordingData.bMoviX       := m_bMoviX;
      m_RecordingThread[i].RecordingData.sDVDxPath    := m_sDVDxPath;
      m_RecordingThread[i].RecordingData.sMoviXPath   := m_sMoviXPath;
      m_RecordingThread[i].RecordingData.sIsoPath     := m_sIsoPath;
      m_RecordingThread[i].RecordingData.bCDRwBurn    := m_bCDRwBurn;
      m_RecordingThread[i].RecordingData.sCDRwSpeed   := m_sCDRwSpeed;
      m_RecordingThread[i].RecordingData.sCDRwDevId   := m_sCDRwDevId;
    end;

  finally
    Free;
    StartupTimer.Enabled := True; // Trigger the INIT ...
  end;
  m_bInit := true;
  if iOk > 0 then
  begin
    pclMain.ActivePage := tbsDbox;
    Sleep(0);
    Application.ProcessMessages;
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< LoadSettings');
end;

procedure TfrmMain.SaveSettings;
var
  i    : Integer;
  sTmp : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> SaveSettings');
  with TRegistryIniFile.Create('Software\GNU\TuxBox\1.0') do
  try
    DbgMsg('Save Settings');

    WriteString('WinGrab', 'IP',        m_sDBoxIp);

    WriteString('WinGrab', 'M2pPath',   m_sM2pPath);

    WriteBool(  'WinGrab', 'DVDx',      m_bDVDx);
    WriteString('WinGrab', 'DVDxPath',  m_sDVDxPath);

    WriteBool(  'WinGrab', 'MoviX',     m_bMoviX);
    WriteString('WinGrab', 'MoviXPath', m_sMoviXPath);
    WriteString('WinGrab', 'IsoPath',   m_sIsoPath);

    WriteBool(  'WinGrab', 'CDRwBurn',  m_bCDRwBurn);
    WriteString('WinGrab', 'CDRwSpeed', m_sCDRwSpeed);
    WriteString('WinGrab', 'CDRwDevId', m_sCDRwDevId);

    WriteBool(  'WinGrab', 'UseVlc',    m_bVlc);
    WriteString('WinGrab', 'VlcPath',   m_sVlcPath);

////////
    i := lbxChannelList.ItemIndex;
    if i >= 0 then
      WriteString('WinGrab', 'Channel', lbxChannelList.Items[i])
    else
      WriteString('WinGrab', 'Channel', '');

    if chxSplitting.Checked then
      WriteString('WinGrab', 'SplittSize', cbxSplitSize.Text)
    else
      WriteString('WinGrab', 'SplittSize', '');

    WriteInteger('WinGrab', 'Powersave', gbxPowersave.ItemIndex);

    WriteInteger('WinGrab', 'GrabMode', gbxGrabMode.ItemIndex);

    WriteBool('WinGrab', 'KillSectionsd', chxKillSectionsd.Checked);

    WriteBool('WinGrab', 'SwitchChannel', chxSwitchChannel.Checked);

    sTmp := DateTimeToStr(m_LastEpgUpdate);
    WriteString('WinGrab', 'LastEpgUpdate', sTmp);
    m_Trace.DBMSG(TRACE_DETAIL, 'LastEpgUpdate : ' + sTmp );

////////

  finally
    Free;
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< SaveSettings');
end;

////////////////////////////////////////////////////////////////////////////////

function TfrmMain.BrowseForDir(const FormHandle: HWND; TitleName: string; var DirPath: string): Boolean;
var
  pidl       : PItemIDList;
  FBrowseInfo: TBrowseInfo;
  Success    : Boolean;
  Buffer     : array[0..Max_Path] of Char;
begin
  Result := False;
  ZeroMemory(@FBrowseInfo, SizeOf(FBrowseInfo));
  try
    GetMem(FBrowseInfo.pszDisplayName, MAX_PATH);
    FBrowseInfo.HWndOwner := FormHandle;
    if TitleName = '' then TitleName := 'Please specify a directory';
    FBrowseInfo.lpszTitle := PChar(TitleName);
    pidl := SHBrowseForFolder(FBrowseInfo);
    if pidl <> nil then
    begin
      Success := SHGetPathFromIDList(pidl, Buffer);
      if Success then
      begin
        DirPath := Buffer;
        if DirPath[Length(DirPath)] <> '\' then
          DirPath := DirPath + '\';
        result := True;
      end;
      GlobalFreePtr(pidl);
    end;
  finally
    if Assigned(FBrowseInfo.pszDisplayName) then
    begin
      FreeMem(FBrowseInfo.pszDisplayName, Max_Path);
    end;
  end;
end;

function TfrmMain.CheckPath(PathEdit: TTeEdit): Boolean;
begin
  Result:= false;
  try
    if DirectoryExists(PathEdit.Text) then
    begin
      PathEdit.Color := clWindow;
      Result:= true;
    end else
    begin
      PathEdit.Color := clYellow;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.chxSplittingClick(Sender: TObject);
begin
  if chxSplitting.Checked then
  begin
    cbxSplitSize.Enabled := true;
    cbxSplitSize.Color := clWindow;
    lblSplitt1.Enabled := true;
    lblSplitt2.Enabled := true;
    if cbxSplitSize.Text  = '' then
       cbxSplitSize.Text := '3999';
    if (cbxSplitSize.Text <> '') then
      SplittSize := StrToInt(cbxSplitSize.Text)
    else
      SplittSize := 0;
  end else
  begin
    cbxSplitSize.Text := '';
    cbxSplitSize.Enabled := false;
    cbxSplitSize.ParentColor := true;
    lblSplitt1.Enabled := false;
    lblSplitt2.Enabled := false;
    SplittSize := 0;
  end;
end;

procedure TfrmMain.lblSplitt1Click(Sender: TObject);
begin
  chxSplitting.Checked := not chxSplitting.Checked;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.chk_DVDx_enabledExit(Sender: TObject);
begin
  try
    if not m_bInit then exit;
    VCRCommandServerSocket.Active := true;
    chk_DVDx_enabled.Enabled      := true;
    chk_MoviX_enabled.Enabled     := chk_DVDx_enabled.Checked AND chk_DVDx_enabled.Enabled;
    chk_CDRwBurn_enabled.Enabled  := chk_MoviX_enabled.Checked AND chk_MoviX_enabled.Enabled;
    m_bDVDx     := chk_DVDx_enabled.Checked     AND chk_DVDx_enabled.Enabled;
    m_bMoviX    := chk_MoviX_enabled.Checked    AND chk_MoviX_enabled.Enabled;
    m_bCDRwBurn := chk_CDRwBurn_enabled.Checked AND chk_CDRwBurn_enabled.Enabled;
    btnMuxTransform.Enabled := m_bDVDx;
    if NOT FileExists(m_sDVDxPath + 'DVDx.exe') then
    begin
      btnBrowseDvdxPathClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.chk_MoviX_enabledExit(Sender: TObject);
begin
  try
    if not m_bInit then exit;
    VCRCommandServerSocket.Active := true;
    chk_DVDx_enabled.Enabled      := true;
    chk_MoviX_enabled.Enabled     := chk_DVDx_enabled.Checked AND chk_DVDx_enabled.Enabled;
    chk_CDRwBurn_enabled.Enabled  := chk_MoviX_enabled.Checked AND chk_MoviX_enabled.Enabled;
    m_bDVDx     := chk_DVDx_enabled.Checked     AND chk_DVDx_enabled.Enabled;
    m_bMoviX    := chk_MoviX_enabled.Checked    AND chk_MoviX_enabled.Enabled;
    m_bCDRwBurn := chk_CDRwBurn_enabled.Checked AND chk_CDRwBurn_enabled.Enabled;
    if NOT FileExists(m_sMoviXPath + 'mkmvxiso.bat') then
    begin
      btnBrowseMovixPathClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.chk_CDRwBurn_enabledExit(Sender: TObject);
begin
  // m_bCDRwBurn
  try
    if not m_bInit then exit;
    VCRCommandServerSocket.Active := true;
    chk_DVDx_enabled.Enabled      := true;
    chk_MoviX_enabled.Enabled     := chk_DVDx_enabled.Checked AND chk_DVDx_enabled.Enabled;
    chk_CDRwBurn_enabled.Enabled  := chk_MoviX_enabled.Checked AND chk_MoviX_enabled.Enabled;
    m_bDVDx     := chk_DVDx_enabled.Checked     AND chk_DVDx_enabled.Enabled;
    m_bMoviX    := chk_MoviX_enabled.Checked    AND chk_MoviX_enabled.Enabled;
    m_bCDRwBurn := chk_CDRwBurn_enabled.Checked AND chk_CDRwBurn_enabled.Enabled;
    if not CheckPath(edIsoPath) then
    begin
      btnBrowseIsoPathClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.btnBrowseMovixPathClick(Sender: TObject);
begin
  try
    if BrowseForDir(self.Handle, 'Please select the folder where "MoviX" stores', m_sMoviXPath) then
    begin
      edMovixPath.Text := m_sMoviXPath;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.btnBrowseDvdxPathClick(Sender: TObject);
begin
  try
    with TOpenDialog.Create(nil) do
    try
      FileName := edDvdxFilePath.Text;
      Filter := 'Application (*.exe)|*.exe';
      DefaultExt := 'exe';
      if Execute then
      begin
        m_sDVDxPath := FileName;
        edDvdxFilePath.Text := m_sDVDxPath;
      end;
    finally
      Free;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.btnBrowseOutPathClick(Sender: TObject);
begin
  try
    if BrowseForDir(self.Handle, 'Please select the folder to store grabbed stream files', m_sM2pPath) then
    begin
      edOutPath.Text := m_sM2pPath;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.btnBrowseIsoPathClick(Sender: TObject);
begin
  try
    if BrowseForDir(self.Handle, 'Please select the folder to store builded ISO files', m_sIsoPath) then
    begin
      edIsoPath.Text := m_sIsoPath;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;


////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.edOutPathChange(Sender: TObject);
begin
  try
    if not m_bInit then exit;

    if CheckPath(edOutPath) then
    begin
      m_sM2pPath:= edOutPath.Text;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.edDvdxFilePathChange(Sender: TObject);
begin
  try
    if FileExists(edDvdxFilePath.text) then
    begin
      m_sDvdxPath:= edDvdxFilePath.Text;
      edDvdxFilePath.Color := clWindow;
    end else
    begin
      edDvdxFilePath.Color := clYellow;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.edMovixPathChange(Sender: TObject);
begin
  try
    if not m_bInit then exit;

    if CheckPath(edMovixPath) then
    begin
      m_sMovixPath:= edMovixPath.Text;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.edIsoPathChange(Sender: TObject);
begin
  try
    if not m_bInit then exit;

    if CheckPath(edIsoPath) then
    begin
      m_sIsoPath:= edIsoPath.Text;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.edCDRWDeviceIdChange(Sender: TObject);
begin
  m_sCDRwDevId := edCDRWDeviceId.Text;
end;

procedure TfrmMain.edCDRwSpeedChange(Sender: TObject);
begin
  m_sCDRwSpeed := edCDRwSpeed.Text;
end;

procedure TfrmMain.btnBrowseVlcClick(Sender: TObject);
begin
  try
    if BrowseForDir(self.Handle, 'Please select the folder of the Video Lan Client', m_sVlcPath) then
    begin
      edVlcPath.Text := m_sVlcPath;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

procedure TfrmMain.chxVlcClick(Sender: TObject);
begin
  m_bVlc := chxVlc.Checked;
  btnVlcView.Enabled:= m_bVlc;
  if not m_bVlc then exit;
  if NOT FileExists(edVlcPath.Text + 'vlc.exe') then
  begin
    btnBrowseVlcClick(self);
  end;
end;

procedure TfrmMain.edVlcPathChange(Sender: TObject);
begin
  try
    if not m_bInit then exit;
    if not m_bVlc  then exit;

    if NOT FileExists(edVlcPath.Text + 'vlc.exe') then
    begin
      btnBrowseVlcClick(self);
    end;
    if FileExists(edVlcPath.Text + 'vlc.exe') then
    begin
      m_sVlcPath:= edVlcPath.Text;
    end else
    begin
      chxVlc.Checked := false;
      m_bVlc := chxVlc.Checked;
      btnVlcView.Enabled:= m_bVlc;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,PChar(E.Message));
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.edIpChange(Sender: TObject);
begin
  try
    DoEvents;
    Sleep(10);
    if PingDBox(edIp.IpAddress) then
    begin
      if  (edIp.IpAddress <> m_sDBoxIp)
      and (edIp.IpAddress <> '')
      then
      begin
        m_sDBoxIp := edIp.IpAddress;
//        StartupTimer.Enabled := True; // Trigger the INIT...
      end;
      edIp.Font.Color := clWindowText;
    end else
    begin
      VCRCommandServerSocket.Active := false;
      edIp.Font.Color := clRed;
    end;
    DoEvents;
    Sleep(0);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message );
  end;
end;


////////////////////////////////////////////////////////////////////////////////
