////////////////////////////////////////////////////////////////////////////////
//
// $Log: TransformThread.pas,v $
// Revision 1.3  2004/12/03 16:09:49  thotto
// - Bugfixes
// - EPG suchen überarbeitet
// - Timerverwaltung geändert
// - Ruhezustand / Standby gefixt
//
// Revision 1.2  2004/10/15 13:39:16  thotto
// neue Db-Klasse
//
// Revision 1.1  2004/07/02 13:56:23  thotto
// initial
//
//

unit TransformThread;

interface

uses
  Classes,
  Windows,
  Messages,
  SysUtils,
  JclShell,
  JclSysInfo,
  IdGlobal,
  MyTrace,
  DelTools,
  VcrDivXtools,
  VcrTypes,
  TeFiFo,
  TeFileStreamThread,
  TeHTTPStreamThread,
  TeProcessManager,
  TeGrabManager,
  TePesParserThread,
  TePesFiFo,
  VcrDbHandling
  ;

type
  TTransformThread = class(TThread)
  private
    m_Trace             : TTrace;
    m_RecordingData     : T_RecordingData;
    m_hMutexHandle,
    m_hMuxerMutexHandle : Cardinal;
    m_coProcessManager  : TTeProcessManager;

    procedure SetToDbRecorded;

    procedure TransformPsStream;
    procedure TransformToDivX(sM2pFile: String);
    procedure EditAvi(var sAviFile: String);
    procedure TransformToIso(sAviFile: String);

    procedure TransformMuxPES;

    {$W+}
    procedure MessageCallback(aSender       : TTeProcessManager;
                              const aMessage: string);
    procedure MuxStateCallback(aSender      : TTeProcessManager;
                               const aName,
                                     aState : string);
    {$W-}

    procedure SerializeIsoThread;
    procedure SerializeIsoThreadFinish;
    
    procedure DbgMsg( Msg: String );

  protected
    procedure Execute; override;

  public
    Terminated: Boolean;
    Success   : Boolean;

    procedure SetParams(my_RecordingData: T_RecordingData);

  end;

implementation

{ TTransformThread }

procedure TTransformThread.Execute;
var
  sTmp      : String;
  sr        : TSearchRec;
  FileAttrs : Integer;
begin
  try
    Terminated := false;
    Success    := false;

    m_Trace := TTrace.Create();
    m_Trace.DBMSG_INIT('',
                       'TuxBox',
                       '1.0',
                       '',
                       'WinGrab');
    DbgMsg('--- Starte Transformthread ---');

    FileAttrs := faAnyFile;
    sTmp:= ExtractFilePath(m_RecordingData.filename);
    if FindFirst(m_RecordingData.filename+'*'+DivXFileExt, FileAttrs, sr) = 0 then
    begin
      repeat
        if sr.Name[1] <> '.' then
        begin
          m_RecordingData.filename := sTmp+sr.Name;
          TransformPsStream;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    TransformMuxPES;

    sTmp:= ExtractFilePath(m_RecordingData.filename);
    if FindFirst(m_RecordingData.filename+'*'+Mgeg2FileExt, FileAttrs, sr) = 0 then
    begin
      repeat
        if sr.Name[1] <> '.' then
        begin
          m_RecordingData.filename := sTmp+sr.Name;
          TransformPsStream;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  except
    Terminated := true;
  end;
  Terminated:= true;
end;

procedure TTransformThread.SetParams(my_RecordingData: T_RecordingData);
begin
  try
    m_RecordingData := my_RecordingData;

    m_RecordingData.iMuxerSyncs  := my_RecordingData.iMuxerSyncs;
    m_RecordingData.bDVDx        := my_RecordingData.bDVDx;
    m_RecordingData.bMoviX       := my_RecordingData.bMoviX;
    m_RecordingData.bCDRwBurn    := my_RecordingData.bCDRwBurn;
    m_RecordingData.cmd          := my_RecordingData.cmd;
    m_RecordingData.channel_id   := my_RecordingData.channel_id;
    m_RecordingData.apids[0]     := my_RecordingData.apids[0];
    m_RecordingData.apids[1]     := my_RecordingData.apids[1];
    m_RecordingData.apids[2]     := my_RecordingData.apids[2];
    m_RecordingData.apids[3]     := my_RecordingData.apids[3];
    m_RecordingData.vpid         := my_RecordingData.vpid;
    m_RecordingData.mode         := my_RecordingData.mode;
    m_RecordingData.epgid        := my_RecordingData.epgid;
    m_RecordingData.channelname  := my_RecordingData.channelname;
    m_RecordingData.epgtitle     := my_RecordingData.epgtitle;
    m_RecordingData.epgsubtitle  := my_RecordingData.epgsubtitle;
    m_RecordingData.epg          := my_RecordingData.epg;
    m_RecordingData.filename     := my_RecordingData.filename;
    m_RecordingData.sDVDxPath    := my_RecordingData.sDVDxPath;
    m_RecordingData.sMoviXPath   := my_RecordingData.sMoviXPath;
    m_RecordingData.sIsoPath     := my_RecordingData.sIsoPath;
    m_RecordingData.sCDRwDevId   := my_RecordingData.sCDRwDevId;
    m_RecordingData.sCDRwSpeed   := my_RecordingData.sCDRwSpeed;
    m_RecordingData.sDbConnectStr:= my_RecordingData.sDbConnectStr;
    m_RecordingData.HWndMsgList  := my_RecordingData.HWndMsgList;

    if Pos('[',my_RecordingData.filename) > 0 then
    begin
      m_RecordingData.filename   := copy(my_RecordingData.filename, 1, Pos('[',my_RecordingData.filename) - 1);
    end else
    begin
      m_RecordingData.filename   := my_RecordingData.filename;
    end;

    Terminated := false;
    Success    := false;
  except
  end;
end;

procedure TTransformThread.TransformToDivX(sM2pFile: String);
var
  cBuffer   : array[0..255] of Char;
  sTmp      : String;
  sCmdLine  : String;
  sCmdParam : String;
  sCmdVerb  : String;
  iCmdShow  : Integer;
  sTrace    : String;
begin
  try
    if FileExists(sM2pFile) then
    begin
      DbgMsg('Transform file:[' + ExtractFileName(sM2pFile) + ']');
      if FileSizeByName(sM2pFile) = 0 then
      begin
        DbgMsg('file:[' + ExtractFileName(sM2pFile) + '] is 0 byte -> cancel');
        exit;
      end;

      FillChar(cBuffer, 255, 0);
      GetShortPathName(PChar(sM2pFile), cBuffer, 254);
      sCmdParam:= cBuffer;

      sCmdParam:= sM2pFile;
      iCmdShow := SW_SHOWNORMAL;
      sCmdLine := m_RecordingData.sDVDxPath;
      sTmp     := ChangeFileExt(sCmdParam, DivXFileExt);
      sCmdVerb := 'open';

      if ShellExecAndWait(sCmdLine,
                          sCmdParam,
                          sCmdVerb,
                          iCmdShow)
      then
      begin

        sTrace := 'umbenannt zu [' + ExtractFileName(ChangeFileExt(sM2pFile, '.AVI')) + ']';
        DbgMsg(PChar(sTrace));

        if RenameFile(sTmp, ChangeFileExt(sM2pFile, '.AVI')) then
        begin
          sTmp := ChangeFileExt(sM2pFile, '.AVI');

          sTrace := 'size of [' + ExtractFileName(sM2pFile) + '] is ' + IntToStr(FileSizeByName(sM2pFile));
          DbgMsg(PChar(sTrace));
          sTrace := 'size of [' + ExtractFileName(sTmp) + '] is ' + IntToStr(FileSizeByName(sTmp));
          DbgMsg(PChar(sTrace));

          if ( (FileSizeByName(sM2pFile) / 10)  > FileSizeByName(sTmp) ) then
          begin
            // AVI nicht komplett ???
            sTrace := 'size mismatch -> exit';
            DbgMsg(PChar(sTrace));
            exit;
          end else
          begin
            // check consistence of the new DivX file ...
            if CheckDivX(sTmp) then
            begin
              SHDeleteFile(sM2pFile,0);
              sTrace := 'delete file [' + ExtractFileName(sM2pFile) + ']';
              DbgMsg(PChar(sTrace));
              Success:= true;
            end else
            begin
              sTrace := 'CheckDivXFile [' + ExtractFileName(sM2pFile) + '] failed -> not deleted !';
              DbgMsg(PChar(sTrace));
            end;
          end;
        end else
        begin
          sTrace := 'rename failed -> exit';
          DbgMsg(PChar(sTrace));
          Exit;
        end;
      end else
      begin
        DbgMsg( '[' + ExtractFileName(sM2pFile) + '] nicht gefunden' );
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TTransformThread.EditAvi(var sAviFile: String);
var
  sTmp      : String;
  sCmdLine  : String;
  sCmdParam : String;
  sCmdVerb  : String;
  iCmdShow  : Integer;
  sTrace    : String;
begin
  try
    // if we can find 'VirtualDub.exe' then open it to edit/cut/resize/.. the AVI .
    sCmdLine:= FileSearch('VirtualDub.exe', GetEnvironmentVariable('PATH') + ';' + GetCurrentDir + '\;' + GetProgramFilesFolder + '\VirtualDub\;');
    sCmdParam := '"' + sAviFile + '"';
    if FileExists(sCmdLine) and FileExists(sAviFile) then
    begin
      sTrace := 'edit [' + ExtractFileName(sAviFile) + '] using "VirtualDub"';
      DbgMsg(PChar(sTrace));

      if FileSizeByName(sAviFile) = 0 then
      begin
        DbgMsg('file:[' + ExtractFileName(sAviFile) + '] is 0 byte -> cancel');
        exit;
      end;

      iCmdShow := SW_SHOWNORMAL;
      sCmdVerb := 'open';
      ShellExecAndWait( sCmdLine,
                        sCmdParam,
                        sCmdVerb,
                        iCmdShow);

      m_Trace.DBMSG(TRACE_DETAIL, sAviFile);
      if Pos('[',sAviFile) > 0 then
      begin
        sTmp := copy(sAviFile, 1, Pos('[',sAviFile) - 1) + DivXFileExt;
        m_Trace.DBMSG(TRACE_DETAIL, sTmp);
        if  FileExists(UpperCase(sTmp))
        and FileExists(UpperCase(sAviFile)) then
        begin
          if FileSizeByName(sAviFile) > FileSizeByName(sTmp) then
          begin
            if CheckDivX(sTmp) then
            begin
              SHDeleteFile(sAviFile,0);
              sAviFile:= sTmp;
              Success := true;
              m_Trace.DBMSG(TRACE_DETAIL, 'success check '+sAviFile);
            end else
            begin
              Success := false;
              m_Trace.DBMSG(TRACE_MIN, 'failed check '+sTmp);
            end;
          end;
        end;
      end else
      begin
        if CheckDivX(sAviFile) then
        begin
          Success := true;
          m_Trace.DBMSG(TRACE_DETAIL, 'success check '+sAviFile);
        end else
        begin
          Success := false;
          m_Trace.DBMSG(TRACE_MIN, 'failed check '+sAviFile);
        end;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TTransformThread.TransformToIso(sAviFile: String);
var
  sCmdLine  : String;
  sCmdParam : String;
  sCmdVerb  : String;
  iCmdShow  : Integer;
  sAviPath  : String;
  sIso      : String;
  sTrace    : String;
  TmpList   : TStringList;
begin
  try
    if FileExists(sAviFile) then
    begin
      if FileSizeByName(sAviFile) = 0 then
      begin
        DbgMsg('file:[' + ExtractFileName(sAviFile) + '] is 0 byte -> cancel');
        exit;
      end;
      sAviPath := ExtractFilePath(sAviFile);
      m_Trace.DBMSG(TRACE_DETAIL, 'to ISO '+sAviFile);
      
      SerializeIsoThread;
      try
{        sTrace := 'copy [' + ExtractFileName(sAviFile) + '] to [' + m_RecordingData.sMoviXPath + 'src\ ... ]';
        DbgMsg(PChar(sTrace));

        if Length(ExtractFileName(sAviFile)) > 64 then
        begin
          sAviFile:= Copy(ExtractFileName(sAviFile),1,60);
          m_Trace.DBMSG(TRACE_DETAIL, 'trunc filename to '+sAviFile);
        end;

        if not SHCopyFile(sAviFile, m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(sAviFile),0) then
        begin
          sTrace := 'error copy to [' + m_RecordingData.sMoviXPath + 'src\'+ExtractFileName(sAviFile)+']';
          DbgMsg(PChar(sTrace));
          exit;
        end;

        if FileExists(ChangeFileExt(sAviFile, EpgFileExt)) then
        begin
          sTrace := 'copy [' + ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt)) + '] to [' + m_RecordingData.sMoviXPath + 'src\ ... ]';
          DbgMsg(PChar(sTrace));
          if Length(ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt))) > 64 then
          begin
            SHCopyFile(PChar(ChangeFileExt(sAviFile, EpgFileExt)), PChar(m_RecordingData.sMoviXPath + 'src\' + Copy(ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt)),1,59) + EpgFileExt ));
          end else
          begin
            SHCopyFile(PChar(ChangeFileExt(sAviFile, EpgFileExt)), PChar(m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt)) ));
          end;
        end;
}
        TmpList := TStringList.Create;
        try
          TmpList.Add('@echo on');
          TmpList.Add('start /WAIT "" "' + ExtractFileName(sAviFile) + '"');
          TmpList.SaveToFile(sAviPath + 'Autorun.bat');

          TmpList.Clear;
          TmpList.Add('[autorun]');
          TmpList.Add('open=autorun.bat');
          TmpList.Add('icon=cdrom.ico');
          TmpList.SaveToFile(sAviPath + 'Autorun.inf');
        finally
          TmpList.Free;
        end;

        sIso     := m_RecordingData.sIsoPath + ChangeFileExt(ExtractFileName(sAviFile), '.ISO');
        iCmdShow := SW_SHOWNORMAL;
        sCmdLine := m_RecordingData.sMoviXPath + 'mkisofs.exe';
        sCmdParam:= '-o ' + sIso + ' -r -J -V "eMoviX CD" -v -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -sort src\isolinux\iso.sort  -A "eMoviX CD" src "'+sAviPath+'"';
        sCmdVerb := 'open';
        sTrace := 'call cmd=[' + sCmdLine + '] param=[' + sCmdParam + ']';
        DbgMsg(PChar(sTrace));
        SetCurrentDir(m_RecordingData.sMoviXPath);

        ShellExecAndWait( sCmdLine,
                          sCmdParam,
                          sCmdVerb,
                          iCmdShow);

{
        if FileExists( m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(sAviFile) ) then
        begin
          sTrace := 'del [' + ExtractFileName(m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(sAviFile)) + ']';
          DbgMsg(PChar(sTrace));
          SHDeleteFile(  m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(sAviFile) ,0);
        end;

        SHDeleteFile(  m_RecordingData.sMoviXPath + 'src\Autorun.bat' ,0);
        SHDeleteFile(  m_RecordingData.sMoviXPath + 'src\Autorun.inf' ,0);

        if FileExists( m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt)) ) then
        begin
          sTrace := 'del [' + ExtractFileName(m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt))) + ']';
          DbgMsg(PChar(sTrace));
          SHDeleteFile(  m_RecordingData.sMoviXPath + 'src\' + ExtractFileName(ChangeFileExt(sAviFile, EpgFileExt)) ,0);
        end;
}
        sTrace := 'ISO [' + ExtractFileName(sIso)  + '] size ' + IntToStr(FileSizeByName(sIso)) + ' bytes';
        DbgMsg(PChar(sTrace));
        if  (FileExists(sIso)
        AND (FileSizeByName(sIso) > FileSizeByName(sAviFile) + 20808796)) then  //~20 MB (kernel + mplayer)
        begin
          sTrace := 'create [' + ExtractFileName(sIso) + '] success';
          DbgMsg(PChar(sTrace));
        end else
        begin
          sTrace := 'create [' + ExtractFileName(sIso) + '] NOT success';
          DbgMsg(PChar(sTrace));
        end;
      finally
        SerializeIsoThreadFinish;
      end;
    end else
    begin
      m_Trace.DBMSG(TRACE_MIN, 'not found '+sAviFile);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTransformThread.TransformPsStream;
var
  sCmdLine  : String;
  sCmdParam : String;
  sCmdVerb  : String;
  iCmdShow  : Integer;
  sAviFile,
  sM2pFile  : String;
  sIso      : String;
  sTrace    : String;
begin
  try
    if ((m_RecordingData.bDVDx  = false)  and
        (m_RecordingData.bMoviX = false)) then
    begin
      DbgMsg('Transform mit DVDx nicht gewählt !');
      DbgMsg('--- Ende Transformthread [' + ExtractFileName(sM2pFile) + '] ---');
      exit;
    end;
    DbgMsg('Transform mit [' + ExtractFileName(m_RecordingData.sDVDxPath) + '] gewählt');

    try
      if FileExists(m_RecordingData.sDVDxPath) then
      begin
        sM2pFile := ChangeFileExt(m_RecordingData.filename, Mgeg2FileExt);
        TransformToDivX(sM2pFile);
      end else
      begin
        DbgMsg('[' + ExtractFileName(m_RecordingData.sDVDxPath) + '] nicht gefunden');
      end;

      sAviFile:= ChangeFileExt(m_RecordingData.filename, DivXFileExt);
      if not FileExists(sAviFile) then
      begin
        if Pos('[',sAviFile) > 0 then
        begin
          sAviFile := copy(sAviFile, 1, Pos('[',sAviFile) - 1) + DivXFileExt;
        end;
      end;
      if FileExists(sAviFile) then
      begin

        EditAvi(sAviFile);
        if Success then
        begin
          SetToDbRecorded;
        end;
        
        if  m_RecordingData.bMoviX
        AND Success then
        begin

          TransformToIso(sAviFile);

          sIso    := m_RecordingData.sIsoPath + ChangeFileExt(ExtractFileName(sAviFile), '.ISO');
          Success := (FileExists(sIso) AND (FileSizeByName(sIso) > 20808796)); //~20 MB (kernel + mplayer)

          if  Success then
          begin
            // jetzt könnte man hier noch automatisch BRENNEN ...
            Success := (FileSizeByName(sIso) <= 734003200); // <= 700 MB
            if ( m_RecordingData.bCDRwBurn AND Success ) then
            begin
              sCmdLine := m_RecordingData.sMoviXPath + 'cdrecord.exe';
              sCmdParam:= 'speed=' + m_RecordingData.sCDRwSpeed + ' dev=' + m_RecordingData.sCDRwDevId + ' -ignsize -overburn -eject ' + sIso;
              sCmdVerb := 'open';
              iCmdShow := SW_SHOWNORMAL;

              sTrace := 'burn [' + ExtractFileName(sIso) + '] on dev=' + m_RecordingData.sCDRwDevId + ' speed=' + m_RecordingData.sCDRwSpeed;
              DbgMsg(PChar(sTrace));

              ShellExecAndWait( sCmdLine,
                                sCmdParam,
                                sCmdVerb,
                                iCmdShow);

              Success := true;
            end else
            begin
              sTrace := '[' + ExtractFileName(sIso) + '] is ' + IntToStr(FileSizeByName(sIso)) + ' Bytes !';
              DbgMsg(PChar(sTrace));
            end;
          end;
        end;
      end;
    finally
      DbgMsg('--- Ende Transformthread [' + ExtractFileName(sM2pFile) + '] ---');
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTransformThread.MessageCallback(aSender       : TTeProcessManager;
                                           const aMessage: string);
begin
  try
    m_Trace.DBMSG(TRACE_DETAIL, 'MuxerMsg   Thread='+m_RecordingData.epgid+' : '+aMessage);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'MessageCallback '+ E.Message );
  end;
end;

procedure TTransformThread.MuxStateCallback(aSender     : TTeProcessManager;
                                            const aName,
                                                  aState: string);
begin
  try
    DoEvents;
    m_Trace.DBMSG(TRACE_DETAIL, 'MuxerState Thread='+m_RecordingData.epgid+' : ['+aName+'] '+aState);
    if  (aName  = 'MuxWriter') then
    begin
      if  (aState = 'terminated') then
      begin
        if (m_hMuxerMutexHandle <> 0) then
        begin
          SetEvent(m_hMuxerMutexHandle);
          m_Trace.DBMSG(TRACE_DETAIL,'Release Mutex "WinGrabVcrIsoThreads"');
          m_hMuxerMutexHandle:= 0;
        end;
      end;
    end;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'MuxStateCallback '+ E.Message );
  end;
end;

procedure TTransformThread.TransformMuxPES;
var
  dwResult : DWORD;
begin
  try
    if not FileExists(m_RecordingData.filename + VideoFileExt) then
    begin
		  m_Trace.DBMSG(TRACE_DETAIL,'no video file to multiplex');
      exit;
    end;
    if not FileExists(m_RecordingData.filename + '_0' + AudioFileExt) then
    begin
		  m_Trace.DBMSG(TRACE_DETAIL,'no audio file to multiplex');
      exit;
    end;

  	m_hMuxerMutexHandle := CreateEvent(nil, FALSE, FALSE, PChar('WinGrabVcrMuxerThreads'+m_RecordingData.epgid));
    if (m_hMuxerMutexHandle = 0) then
    begin
		  m_Trace.DBMSG(TRACE_ERROR,'Can not init MuxerMutex !');
			exit;
		end;
    Sleep(300);
    DoEvents;
    m_coProcessManager := TTeMuxProcessManager.Create(m_RecordingData.filename + VideoFileExt,
                                                      -1, -1,
                                                      [m_RecordingData.filename + '_0' + AudioFileExt ],
                                                      m_RecordingData.filename + Mgeg2FileExt,
                                                      9999,
                                                      MessageCallback,
                                                      MuxStateCallback);

		m_Trace.DBMSG(TRACE_DETAIL,'waiting signal event "WinGrabVcrMuxerThreads"');
    DoEvents;
    dwResult := WaitForSingleObject(m_hMuxerMutexHandle, INFINITE);
    if (dwResult = WAIT_TIMEOUT) then
    begin
      m_Trace.DBMSG(TRACE_ERROR,'timeout waiting for signal event');
      exit;
    end;
    try
	  	m_Trace.DBMSG(TRACE_DETAIL,'signal event "WinGrabVcrMuxerThreads" found');
      DoEvents;
      CloseHandle(m_hMuxerMutexHandle);
    except
    end;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'TransformMuxPES '+ E.Message );
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTransformThread.SerializeIsoThread;
var
  bResult     : Boolean;
  dwResult    : DWORD;
begin
  try
    m_hMutexHandle := OpenMutex(MUTEX_ALL_ACCESS, bResult, PChar('WinGrabVcrIsoThreads'));
    if (m_hMutexHandle = 0) then
    begin
  		m_Trace.DBMSG(TRACE_DETAIL,'create Mutex "WinGrabVcrIsoThreads"');
			m_hMutexHandle := CreateMutex(nil, TRUE, PChar('WinGrabVcrIsoThreads'));
      if (m_hMutexHandle = 0) then
      begin
				m_Trace.DBMSG(TRACE_ERROR,'Can not init Mutex !');
				exit;
			end;
		end	else
    begin
			// Mutex exists from another Instance, wait ...
			m_Trace.DBMSG(TRACE_DETAIL,'waiting to release Mutex "WinGrabVcrIsoThreads"');
			dwResult := WaitForSingleObject(m_hMutexHandle, INFINITE);
			if (dwResult = WAIT_TIMEOUT) then
      begin
				m_Trace.DBMSG(TRACE_ERROR,'timeout waiting to release Mutex');
				exit;
			end;
		end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TTransformThread.SerializeIsoThreadFinish;
begin
  try
    if (m_hMutexHandle <> 0) then
    begin
      ReleaseMutex(m_hMutexHandle);
  		m_Trace.DBMSG(TRACE_DETAIL,'Release Mutex "WinGrabVcrIsoThreads"');
      m_hMutexHandle:= 0;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTransformThread.DbgMsg( Msg: String );
var
  sTrace,
  sNow    : String;
begin
  try
    sNow := '';
    DateTimeToString(sNow, 'hh:nn:ss.zzz', Now);
    sTrace := Format('%s %s', [sNow,Msg]);
    SendMessage( m_RecordingData.HWndMsgList,
                 LB_INSERTSTRING,
                 0,
                 Integer(PChar(sTrace)));

    m_Trace.DBMSG(TRACE_MIN, Msg);

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Database.
//
procedure TTransformThread.SetToDbRecorded;
var
  coVcrDb : TVcrDb;
begin
  try
    coVcrDb := TVcrDb.Create(m_RecordingData.sDbConnectStr);
    m_Trace.DBMSG(TRACE_MIN, 'epgtitle   =[' + m_RecordingData.epgtitle + ']');
    m_Trace.DBMSG(TRACE_MIN, 'epgsubtitle=[' + m_RecordingData.epgsubtitle + ']');
    m_Trace.DBMSG(TRACE_MIN, 'epg        =[' + m_RecordingData.epg + ']');

    coVcrDb.UpdateEpgInDb(m_RecordingData.epgtitle,
                          m_RecordingData.epgsubtitle,
                          m_RecordingData.epg);

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// EOF.
//
////////////////////////////////////////////////////////////////////////////////
end.
