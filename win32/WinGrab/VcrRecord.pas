////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrRecord.pas,v $
// Revision 1.3  2004/10/15 13:39:16  thotto
// neue Db-Klasse
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
//  VCR - Procedures ...
//
procedure TfrmMain.VCRCommandServerSocketClientRead(Sender: TObject;
                                                    Socket: TCustomWinSocket);
var
  sTmp   : String;
  sBuffer: String;
  RecordingData: T_RecordingData;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> VCRCommandServerSocketClientRead');

    sBuffer := Socket.ReceiveText;
    AnalyzeXMLRequest(sBuffer, RecordingData);

    case  RecordingData.cmd of
      CMD_VCR_RECORD:
        begin
          RecordingStart(Socket,RecordingData);
        end;

      CMD_VCR_STOP:
        begin
          RecordingStop(RecordingData);
        end;

      CMD_VCR_AVAILABLE,
      CMD_VCR_PAUSE,
      CMD_VCR_RESUME,
      CMD_VCR_UNKNOWN:
        begin
          sTmp := '********************** COMMAND NOT AVAILABLE **************';
          DbgMsg(sTmp);
        end;
      else
        begin
          sTmp := '********************** UNKNOWN COMMAND ********************';
          DbgMsg(sTmp);
        end;
    end; //case

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'VCRCommandServerSocketClientRead '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< VCRCommandServerSocketClientRead');
end;

//------------------------------------------------------------------------------
//
//
procedure TfrmMain.RecordingStart(Socket:        TCustomWinSocket;
                                  RecordingData: T_RecordingData);
var
  sTmp     : String;
  sOutPath : String;
  k        : Integer;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingStart');

    DateSeparator   := '-';
    ShortDateFormat := 'yyyy/m/d';
    TimeSeparator   := '.';

    // find next unused thread entry ...
    k:= GetNextFreeThread;

    m_RecordingThread[k].RecordingData.cmd         := RecordingData.cmd;
    m_RecordingThread[k].RecordingData.channel_id  := RecordingData.channel_id;
    m_RecordingThread[k].RecordingData.apids[0]    := RecordingData.apids[0];
    m_RecordingThread[k].RecordingData.apids[1]    := RecordingData.apids[1];
    m_RecordingThread[k].RecordingData.apids[2]    := RecordingData.apids[2];
    m_RecordingThread[k].RecordingData.vpid        := RecordingData.vpid;
    m_RecordingThread[k].RecordingData.channelname := RecordingData.channelname;
    m_RecordingThread[k].RecordingData.epgid       := RecordingData.epgid;
    m_RecordingThread[k].RecordingData.epgtitle    := RecordingData.epgtitle;

    sTmp := '********************** START RECORDING [' + m_RecordingThread[k].RecordingData.epgtitle + '] *********************';
    DbgMsg(sTmp);

    m_Trace.DBMSG(TRACE_DETAIL, 'prepare lists');
    try
      ClearStateList;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_DETAIL, 'ClearStateList '+E.Message);
    end;

    try
      DoEvents;
      m_sDBoxIp := Socket.RemoteAddress;
    except
    end;

    m_RecordingThread[k].RecordingData.bIsPreview   := false;
    m_RecordingThread[k].RecordingData.iMuxerSyncs  := 0;
    m_RecordingThread[k].TheadState                 := Thread_Recording;

    m_Trace.DBMSG(TRACE_DETAIL, 'create folder');
    sOutPath:= RecordingCreateOutPath( k );

    m_Trace.DBMSG(TRACE_DETAIL, 'get EPG');
    RecordingSaveEpgFile( k, sOutPath );

    m_Trace.DBMSG(TRACE_DETAIL, 'build filename');
    RecordingCreateOutFileName( k, sOutPath );

    RecordingStopTimer;

    m_Trace.DBMSG(TRACE_DETAIL, 'DBoxIP = '      + m_sDBoxIp);
    m_Trace.DBMSG(TRACE_DETAIL, 'vpid = '        + IntToStrDef(m_RecordingThread[k].RecordingData.vpid,0));

    m_Trace.DBMSG(TRACE_DETAIL, 'apids[1] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[1],0));
    m_Trace.DBMSG(TRACE_DETAIL, 'apids[2] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[2],0));
    m_Trace.DBMSG(TRACE_DETAIL, 'apids[3] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[3],0));

    m_Trace.DBMSG(TRACE_DETAIL, 'channelid   = ' + m_RecordingThread[k].RecordingData.channel_id);
    m_Trace.DBMSG(TRACE_DETAIL, 'channelname = ' + m_RecordingThread[k].RecordingData.channelname);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgid       = ' + m_RecordingThread[k].RecordingData.epgid);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgtitel    = ' + m_RecordingThread[k].RecordingData.epgtitle);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgsubtitel = ' + m_RecordingThread[k].RecordingData.epgsubtitle);
    m_Trace.DBMSG(TRACE_DETAIL, 'epg         = ' + m_RecordingThread[k].RecordingData.epg);
    m_Trace.DBMSG(TRACE_DETAIL, 'filename    = ' + m_RecordingThread[k].RecordingData.filename);

    m_Trace.DBMSG(TRACE_DETAIL, 'start grabber');
    StateTimer.Enabled := true;
    case gbxGrabMode.ItemIndex of

      0: m_RecordingThread[k].pcoProcessManager := TTeDirectGrabManager.Create( m_sDBoxIp,
                                                                                m_RecordingThread[k].RecordingData.vpid,
                                                                                [m_RecordingThread[k].RecordingData.apids[1],
                                                                                 m_RecordingThread[k].RecordingData.apids[2],
                                                                                 m_RecordingThread[k].RecordingData.apids[3]],
                                                                                m_RecordingThread[k].RecordingData.filename + VideoFileExt,
                                                                                [m_RecordingThread[k].RecordingData.filename +'_0'+AudioFileExt,
                                                                                 m_RecordingThread[k].RecordingData.filename +'_1'+AudioFileExt,
                                                                                 m_RecordingThread[k].RecordingData.filename +'_2'+AudioFileExt],
                                                                                chxVideoStripPesHeader.Checked,
                                                                                [chxAudioStripPesHeader1.Checked,
                                                                                 chxAudioStripPesHeader2.Checked,
                                                                                 chxAudioStripPesHeader3.Checked],
                                                                                MessageCallback,
                                                                                StateCallback);

      1: m_RecordingThread[k].pcoProcessManager :=    TTeMuxGrabManager.Create( m_sDBoxIp,
                                                                                 m_RecordingThread[k].RecordingData.vpid,
                                                                                [m_RecordingThread[k].RecordingData.apids[1]],
                                                                                m_RecordingThread[k].RecordingData.filename + Mgeg2FileExt,
                                                                                SplittSize,
                                                                                MessageCallback,
                                                                                StateCallback);


    end; //case

    pclMain.ActivePage := tbsRunning;
    DoEvents;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordStart '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStart');
end;

//------------------------------------------------------------------------------
//
//
procedure TfrmMain.RecordingStop(RecordingData : T_RecordingData);
var
  k,x       : Integer;
  sFileName,
  sTmp      : String;
  sr        : TSearchRec;
  FileAttrs : Integer;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingStop');
    try
      k:= GetMachingThread(RecordingData);
      sTmp := '********************** STOP RECORDING [' + m_RecordingThread[k].RecordingData.epgtitle + '] *********************';
      DbgMsg(sTmp);

      StateTimer.Enabled := false;

      if m_RecordingThread[k].RecordingData.bIsPreview then
      begin
        ////////////////////////////////////////////////////
        //
        //  stop preview now ...
        //
        m_Trace.DBMSG(TRACE_DETAIL, 'stop grabber (preview)');

        // stop the grabber ...
        FreeAndNil(m_RecordingThread[k].pcoProcessManager);
        //wait to destroy all grab threads
        for x:= 1 to 10 do
        begin
          Sleep(300);
          DoEvents;
        end;
        ClearStateList;

        sTmp := 'Möchten Sie das Preview von [' + m_RecordingThread[k].RecordingData.epgtitle + '] jetzt löschen ?';
        if Application.MessageBox(PChar(sTmp), PChar('Frage'), MB_YESNO) = IDYES then
        begin
          FileAttrs := faAnyFile;
          if FindFirst(ExtractFilePath(m_RecordingThread[k].RecordingData.filename)+'*.*', FileAttrs, sr) = 0 then
          begin
            repeat
              if sr.Name[1] <> '.' then
              begin
                DeleteFile(sr.Name);
              end;
            until FindNext(sr) <> 0;
            FindClose(sr);
          end;
          SHDeleteDirectory( ExtractFilePath(m_RecordingThread[k].RecordingData.filename) );
          Sleep(100);
          Application.ProcessMessages;

          m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStop');
          exit;
        end;
      end;

      ////////////////////////////////////////////////////
      //
      //  stop recording now ...
      //
      m_Trace.DBMSG(TRACE_DETAIL, 'stop grabber');
      // stop the grabber ...
      FreeAndNil(m_RecordingThread[k].pcoProcessManager);
      //wait to destroy all grab threads
      for x:= 1 to 10 do
      begin
        Sleep(300);
        DoEvents;
      end;
      m_RecordingThread[k].TheadState := Thread_TransformStart;
      ClearStateList;
      DbgMsg( IntToStr(m_RecordingThread[k].RecordingData.iMuxerSyncs) + ' ReSyncs' );

      m_Trace.DBMSG(TRACE_DETAIL, 'channelid   = ' + m_RecordingThread[k].RecordingData.channel_id);
      m_Trace.DBMSG(TRACE_DETAIL, 'channelname = ' + m_RecordingThread[k].RecordingData.channelname);
      m_Trace.DBMSG(TRACE_DETAIL, 'epgid       = ' + m_RecordingThread[k].RecordingData.epgid);
      m_Trace.DBMSG(TRACE_DETAIL, 'epgtitel    = ' + m_RecordingThread[k].RecordingData.epgtitle);
      m_Trace.DBMSG(TRACE_DETAIL, 'epgsubtitel = ' + m_RecordingThread[k].RecordingData.epgsubtitle);
      m_Trace.DBMSG(TRACE_DETAIL, 'filename    = ' + m_RecordingThread[k].RecordingData.filename);

      if (gbxGrabMode.ItemIndex = 1) then
      begin
        if m_RecordingThread[k].RecordingData.iMuxerSyncs > 10 then
        begin
          DbgMsg('### Fehler - '+IntToStr(m_RecordingThread[k].RecordingData.iMuxerSyncs) + ' Resyncs ! ###');
          DbgMsg('### Automatische Umwandlung von [' + m_RecordingThread[k].RecordingData.epgtitle + '] wird abgebrochen ###');
          m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStop');
          exit;
        end;
        if m_RecordingThread[k].RecordingData.iMuxerSyncs > 3 then
        begin
          DbgMsg('### Warnung - Mehr als 3 Resyncs ! ###');
        end;
      end;

      ////////////////////////////////////////////////////
      //
      //  start transforming now ...
      //
      sFileName := m_RecordingThread[k].RecordingData.filename;
      if SplittSize > 0 then
      begin
        sFileName := sFileName + '[01]';
      end;
      case gbxGrabMode.ItemIndex of
        0: begin
             sFileName := sFileName + VideoFileExt
           end;
        1: begin
             sFileName := sFileName + Mgeg2FileExt
           end;
      end;

      if FileSizeByName( sFileName ) > 1048576 then
      begin
        m_Trace.DBMSG(TRACE_DETAIL, 'start transforming of [' + sFileName + ']');
        Sleep(300);
        DoEvents;

        RecordingLoadEpgFile( k, m_RecordingThread[k].RecordingData.filename + EpgFileExt );

{        //save epg -> now in transforthread
        SaveEpgToDb(m_RecordingThread[k].RecordingData.epgtitle,
                    m_RecordingThread[k].RecordingData.epgsubtitle,
                    m_RecordingThread[k].RecordingData.epg);
}
        sTmp := ExtractFilePath( m_RecordingThread[k].RecordingData.filename );

        // Transform the StreamFiles to DivX ...
        m_RecordingThread[k].pcoTransformThread                 := TTransformThread.Create(true);
        m_RecordingThread[k].pcoTransformThread.FreeOnTerminate := false;
        m_RecordingThread[k].pcoTransformThread.Priority        := tpLower;
        m_RecordingThread[k].TheadState                         := Thread_Muxing;
        m_RecordingThread[k].pcoTransformThread.SetParams(m_RecordingThread[k].RecordingData);
        m_RecordingThread[k].pcoTransformThread.Resume;

        m_RecordingThread[k].RecordingData.bIsPreview   := false;
        m_RecordingThread[k].RecordingData.iMuxerSyncs  := 0;
        m_RecordingThread[k].RecordingData.cmd          := CMD_VCR_UNKNOWN;
        m_RecordingThread[k].RecordingData.channel_id   := '0';
        m_RecordingThread[k].RecordingData.apids[1]     := 0;
        m_RecordingThread[k].RecordingData.apids[2]     := 0;
        m_RecordingThread[k].RecordingData.apids[3]     := 0;
        m_RecordingThread[k].RecordingData.vpid         := 0;
        m_RecordingThread[k].RecordingData.mode         := 0;
        m_RecordingThread[k].RecordingData.epgid        := '';
        m_RecordingThread[k].RecordingData.channelname  := '';
        m_RecordingThread[k].RecordingData.epgtitle     := '';
        m_RecordingThread[k].RecordingData.epgsubtitle  := '';
        m_RecordingThread[k].RecordingData.filename     := '';

        Sleep(300);
        DoEvents;
      end else
      begin
        m_Trace.DBMSG(TRACE_DETAIL, 'file [' + sFileName + '] not found or size mismatch ...');
      end;

      lvwState.Items.Clear;
      ClearStateList;
      pclMain.ActivePage := m_coGoBackTo;
    finally
      SendHttpCommand('/control/setmode?record=stop');
      SendSectionsPauseCommand(false);

      if not IsDBoxRecording then
        RecordingStartTimer;
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordStop '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStop');
end;

//------------------------------------------------------------------------------
//
//
procedure TfrmMain.AnalyzeXMLRequest(sBuffer: String; var RecordingData : T_RecordingData);
var
  sTmp : String;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> AnalyzeXMLRequest');

    RecordingData.cmd := CMD_VCR_UNKNOWN;
    m_Trace.DBMSG(TRACE_MIN, sBuffer);

    if Pos('<neutrino commandversion="1">', sBuffer) > 0 then
    begin
      if Pos('<record ', sBuffer) > 0 then
      begin
        sTmp := Copy(sBuffer, Pos('command="', sBuffer) + Length('command="'), Length(sBuffer));
        sTmp := Copy(sTmp, 1, Pos('">', sTmp)-1);
        if UpperCase(sTmp) = 'RECORD' then
        begin
          // start recording
          RecordingData.cmd := CMD_VCR_RECORD;
          m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_RECORD');

          sTmp := Copy(sBuffer, Pos('<channelname>', sBuffer) + Length('<channelname>'), Length(sBuffer));
          RecordingData.channelname := Copy(sTmp, 1, Pos('</channelname>', sTmp)-1);

          sTmp := Copy(sBuffer, Pos('<epgtitle>', sBuffer) + Length('<epgtitle>'), Length(sBuffer));
          RecordingData.epgtitle := Copy(sTmp, 1, Pos('</epgtitle>', sTmp)-1);

          if Pos('<onidsid>', sBuffer) > 0 then
          begin
            sTmp := Copy(sBuffer, Pos('<onidsid>', sBuffer) + Length('<onidsid>'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('</onidsid>', sTmp)-1);
            RecordingData.channel_id := Trim(sTmp);
            m_Trace.DBMSG(TRACE_MIN, #13#10' old image version on DBox detected '#13#10'Please update to yadi image version 1.8 or higher ! '#13#10'(http://dboxupdate.berlios.de/?mode=&deliver=&get=download&cat=7)'#13#10);
          end;

          sTmp := Copy(sBuffer, Pos('<mode>', sBuffer) + Length('<mode>'), Length(sBuffer));
          sTmp := Copy(sTmp, 1, Pos('</mode>', sTmp)-1);
          RecordingData.mode    := StrToInt(sTmp);

          if Pos('<id>', sBuffer) > 0 then
          begin
            sTmp := Copy(sBuffer, Pos('<id>', sBuffer) + Length('<id>'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('</id>', sTmp)-1);
            RecordingData.channel_id := Trim(sTmp);
          end;

          sTmp := Copy(sBuffer, Pos('<info1>', sBuffer) + Length('<info1>'), Length(sBuffer));
          sTmp := Copy(sTmp, 1, Pos('</info1>', sTmp)-1);
          RecordingData.epgsubtitle := Trim(sTmp);

          sTmp := Copy(sBuffer, Pos('<info2>', sBuffer) + Length('<info2>'), Length(sBuffer));
          sTmp := Copy(sTmp, 1, Pos('</info2>', sTmp)-1);
          RecordingData.epg    := Trim(sTmp);

          sTmp := Copy(sBuffer, Pos('<epgid>', sBuffer) + Length('<epgid>'), Length(sBuffer));
          RecordingData.epgid  := Copy(sTmp, 1, Pos('</epgid>', sTmp)-1);

          sTmp := Copy(sBuffer, Pos('<videopid>', sBuffer) + Length('<videopid>'), Length(sBuffer));
          sTmp := Copy(sTmp, 1, Pos('</videopid>', sTmp)-1);
          RecordingData.vpid    := StrToInt(sTmp);

          sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
          sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
          RecordingData.apids[1]   := StrToIntDef(sTmp,0);

          if gbxGrabMode.ItemIndex = 1 then
          begin
            sBuffer := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
            sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
            RecordingData.apids[2]   := StrToIntDef(sTmp,0);

            sBuffer := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
            sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
            RecordingData.apids[3]   := StrToIntDef(sTmp,0);
          end;
        end else
        begin
          if UpperCase(sTmp) = 'STOP' then
          begin
            // stop recording
            RecordingData.cmd     := CMD_VCR_STOP;
            m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_STOP');

            RecordingData.channel_id  := '0';
            RecordingData.apids[1]    := 0;
            RecordingData.apids[2]    := 0;
            RecordingData.apids[3]    := 0;
            RecordingData.vpid        := 0;
            RecordingData.channelname := '';
            RecordingData.epgtitle    := '';

            sTmp := Copy(sBuffer, Pos('<videopid>', sBuffer) + Length('<videopid>'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('</videopid>', sTmp)-1);
            RecordingData.vpid    := StrToInt(sTmp);

            sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
            sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
            RecordingData.apids[1]   := StrToIntDef(sTmp,0);

            if gbxGrabMode.ItemIndex = 1 then
            begin
              sBuffer := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
              sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
              sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
              RecordingData.apids[2]   := StrToIntDef(sTmp,0);

              sBuffer := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
              sTmp := Copy(sBuffer, Pos('<audio pid="', sBuffer) + Length('<audio pid="'), Length(sBuffer));
              sTmp := Copy(sTmp, 1, Pos('" name', sTmp)-1);
              RecordingData.apids[3]   := StrToIntDef(sTmp,0);
            end;
          end else
          begin
            // not implemented yet
            RecordingData.cmd := CMD_VCR_UNKNOWN;
            if UpperCase(sTmp) = 'PAUSE'     then
            begin
              RecordingData.cmd := CMD_VCR_PAUSE;
              m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_PAUSE');
            end;
            if UpperCase(sTmp) = 'RESUME'    then
            begin
              RecordingData.cmd := CMD_VCR_RESUME;
              m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_RESUME');
            end;
            if UpperCase(sTmp) = 'AVAILABLE' then
            begin
              RecordingData.cmd := CMD_VCR_AVAILABLE;
              m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_AVAILABLE');
            end;
            m_Trace.DBMSG(TRACE_DETAIL, 'cmd not implemented yet');
            RecordingData.channel_id  := '0';
            RecordingData.apids[1]    := 0;
            RecordingData.apids[2]    := 0;
            RecordingData.apids[3]    := 0;
            RecordingData.vpid        := 0;
            RecordingData.channelname := '';
            RecordingData.epgtitle    := '';
          end;
        end;
      end;
    end else
    begin
      // version <> 1 => not implemented yet
      m_Trace.DBMSG(TRACE_DETAIL, 'cmd = CMD_VCR_UNKNOWN');
      m_Trace.DBMSG(TRACE_DETAIL, sBuffer);
      RecordingData.cmd         := CMD_VCR_UNKNOWN;
      RecordingData.channel_id  := '0';
      RecordingData.apids[1]    := 0;
      RecordingData.apids[2]    := 0;
      RecordingData.apids[3]    := 0;
      RecordingData.vpid        := 0;
      RecordingData.channelname := '';
      RecordingData.epgtitle    := '';
    end;

    if gbxGrabMode.ItemIndex = 0 then
    begin
      RecordingData.apids[2]    := 0;
      RecordingData.apids[3]    := 0;
    end;

    m_Trace.DBMSG(TRACE_DETAIL, 'channel_id  = '  + RecordingData.channel_id);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgid       = '  + IntToHex(StrToInt64Def(RecordingData.epgid,0),10));
    m_Trace.DBMSG(TRACE_DETAIL, 'apids[1]    = '  + IntToStrDef(RecordingData.apids[1],0));
    m_Trace.DBMSG(TRACE_DETAIL, 'apids[2]    = '  + IntToStrDef(RecordingData.apids[2],0));
    m_Trace.DBMSG(TRACE_DETAIL, 'apids[3]    = '  + IntToStrDef(RecordingData.apids[3],0));
    m_Trace.DBMSG(TRACE_DETAIL, 'vpid        = '  + IntToStrDef(RecordingData.vpid,0));
    m_Trace.DBMSG(TRACE_DETAIL, 'channelname = '  + RecordingData.channelname);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgtitel    = '  + RecordingData.epgtitle);
    m_Trace.DBMSG(TRACE_DETAIL, 'epgsubtitel = '  + RecordingData.epgsubtitle);
    m_Trace.DBMSG(TRACE_DETAIL, 'epg         = '  + RecordingData.epg);

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'AnalyzeXMLRequest '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< AnalyzeXMLRequest');
end;


//------------------------------------------------------------------------------
//
//
procedure TfrmMain.CheckShutdown;
var
  k        : Integer;
  bRunning : Boolean;
begin
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> CheckShutdown');
    bRunning := false;
    for k:=0 to 9 do
    begin
      try
        if m_RecordingThread[k].pcoTransformThread <> nil then
        begin
          if not m_RecordingThread[k].pcoTransformThread.Terminated then
          begin
            bRunning := true;
            m_Trace.DBMSG(TRACE_DETAIL, 'CheckShutdown - work on Thread['+IntToStr(k)+'] is in progress ...' );
            break;
          end else
          begin
            // free finished TransformThread ...
            try
              m_RecordingThread[k].pcoTransformThread.Free;
            finally
              m_RecordingThread[k].pcoTransformThread := nil;
              m_RecordingThread[k].TheadState := Thread_Idle;
            end;
          end;
        end;
        if m_RecordingThread[k].TheadState <> Thread_Idle then
        begin
          m_Trace.DBMSG(TRACE_DETAIL, 'CheckShutdown - work on Thread['+IntToStr(k)+'] is in progress ...' );
          break;
        end;
      except
      end;
    end;

    if not bRunning then
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'VCR-PC is Idle ...' );

      // This subroutine decommits the unused memory blocks.
      QMemDecommitOverstock;

      // check the status of the DBox ...
      if not PingDBox(m_sDBoxIp) then
      begin
        m_Trace.DBMSG(TRACE_DETAIL, '... and the DBox is down, also posible to shutdown the VCR-PC now.');
        //
        // ... nur dann, wenn das AUFWECKEN via LAN geht ...
        //
        DoShutdownDialog(Shutdown_Hibernate);
        DoEvents;
        Sleep(10000);
        DoEvents;
        DoShutdownDialog(Shutdown_Standby);
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'CheckShutdown '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< CheckShutdown');
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
function TfrmMain.RecordingCreateOutPath( ThreadId : Integer ): String;
var
  sTmp,
  sOutPath : String;
begin
  Result := '';
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingCreateOutPath');
  try
    DateTimeToString(sTmp, 'YYYYMMDD_hhnn', Now);
    sOutPath := CheckPathNameString(m_sM2pPath + sTmp + '_-_'+ m_RecordingThread[ThreadId].RecordingData.channelname + '\');
    DbgMsg(PChar(sOutPath));
    ForceDirectories(sOutPath);
    Result := sOutPath;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingCreateOutPath '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingCreateOutPath');
end;

procedure TfrmMain.RecordingSaveEpgFile( ThreadId : Integer; sOutPath : String );
var
  sEpg : TStringList;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingSaveEpgFile');
  try
//    if m_RecordingThread[ThreadId].RecordingData.epg = '' then
    begin
      sEpg := TStringList.Create;
      try
        sEpg.Add( m_coVcrDb.GetDbEventEpg(m_RecordingThread[ThreadId].RecordingData.channel_id,
                                          m_RecordingThread[ThreadId].RecordingData.epgid,
                                          m_RecordingThread[ThreadId].RecordingData.epgtitle,
                                          m_RecordingThread[ThreadId].RecordingData.epgsubtitle) );
        if sEpg.Text = '' then
        begin
          sEpg.Add( SaveEpgText(m_RecordingThread[ThreadId].RecordingData.epgid,
                                '',
                                m_RecordingThread[ThreadId].RecordingData.epgtitle,
                                m_RecordingThread[ThreadId].RecordingData.epgsubtitle).Text );
        end;
        if m_RecordingThread[ThreadId].RecordingData.epgsubtitle <> '' then
        begin
          sEpg.SaveToFile(CheckPathNameString(sOutPath + m_RecordingThread[ThreadId].RecordingData.epgtitle + '_-_' + m_RecordingThread[ThreadId].RecordingData.epgsubtitle + '.HTML'));
        end else
        begin
          sEpg.SaveToFile(CheckPathNameString(sOutPath + m_RecordingThread[ThreadId].RecordingData.epgtitle + '.HTML'));
        end;
        if m_RecordingThread[ThreadId].RecordingData.epg = '' then
        begin
          m_RecordingThread[ThreadId].RecordingData.epg := sEpg.Text;
        end;
      finally
        sEpg.Free;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingSaveEpgFile '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingSaveEpgFile');
end;
Function TfrmMain.RecordingLoadEpgFile( ThreadId : Integer; sEpgFileName : String ): String;
var
  sEpg : TStringList;
  sTmp,
  sTmpFilename : String;
  i    : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingLoadEpgFile');
  try
    sTmpFilename := sEpgFileName;
    if not FileExists(sTmp) then
    begin
      i    := Pos('[', sTmpFilename);
      if i > 0 then
      begin
        sTmpFilename := copy(sEpgFileName, 1, i-1) + copy(sEpgFileName, Pos(']',sEpgFileName)+1, Length(sEpgFileName));
      end;
    end;
    if FileExists(sTmpFilename) then
    begin
      sEpg := TStringList.Create;
      try
        sEpg.LoadFromFile(sTmpFilename);
        m_RecordingThread[ThreadId].RecordingData.epg := sEpg.Text;
        sTmp := sEpg.Text;
        i:= Pos('<b>',LowerCase(sTmp));
        if i <> 0 then
        begin
          sTmp := Copy( sTmp, Pos('<b>',LowerCase(sTmp))+3, Length(sTmp));
          sTmp := Trim(Copy( sTmp, 1, Pos('</b>',LowerCase(sTmp))-1));
          if sTmp <> 'keine ausführlichen Informationen verfügbar' then
          begin
            m_RecordingThread[ThreadId].RecordingData.epgsubtitle := sTmp;
          end;
        end;
        if m_RecordingThread[ThreadId].RecordingData.epgtitle = '' then
        begin
          m_RecordingThread[ThreadId].RecordingData.epgtitle := ChangeFileExt(ExtractFileName(sTmpFilename), '');
        end;
        Result := sEpg.Text;
      finally
        sEpg.Free;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingLoadEpgFile '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingLoadEpgFile');
end;

procedure TfrmMain.RecordingCreateOutFileName( ThreadId : Integer; sOutPath : String );
var
  sTmp : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingCreateOutFileName');
  try
    sTmp := '';
    if m_RecordingThread[ThreadId].RecordingData.epgsubtitle <> '' then
    begin
      sTmp := m_RecordingThread[ThreadId].RecordingData.epgtitle + '_-_' + m_RecordingThread[ThreadId].RecordingData.epgsubtitle;
    end else
    begin
      sTmp := m_RecordingThread[ThreadId].RecordingData.epgtitle;
    end;
    if sTmp = 'not available' then
    begin
      DateTimeToString(sTmp, 'YYYYMMDD_hhnn', Now);
    end;
    m_RecordingThread[ThreadId].RecordingData.filename     := sOutPath + CheckFileNameString(sTmp);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingCreateOutFileName '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingCreateOutFileName');
end;

procedure TfrmMain.RecordingStartTimer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingStartTimer');
  try
    RefreshTimer.Enabled   := true;
    dbRefreshTimer.Enabled := true;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingStartTimer '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStartTimer');
end;

procedure TfrmMain.RecordingStopTimer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordingStopTimer');
  try
    RefreshTimer.Enabled   := false;
    dbRefreshTimer.Enabled := false;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'RecordingStopTimer '+E.Message);
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordingStopTimer');
end;
//
//  VCR - Procedures ...
//
////////////////////////////////////////////////////////////////////////////////




