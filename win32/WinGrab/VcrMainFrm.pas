////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrMainFrm.pas,v $
// Revision 1.3  2004/10/11 15:33:39  thotto
// Bugfixes
//
// Revision 1.2  2004/07/02 14:24:19  thotto
// *** empty log message ***
//
// Revision 1.1  2004/07/02 14:05:00  thotto
// initial
//
//

////////////////////////////////////////////////////////////////////////////////
//
// Ein WinGrab, mit ein wenig mehr Komfort ;-)
//
//
// Author: ThOtto@GMX.NET
//
////////////////////////////////////////////////////////////////////////////////

unit VcrMainFrm;

interface

uses
  QMemory,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeControls, ComCtrls, ExtCtrls, TeButtons, TeChannelsReader,
  ActnList, TeFiFo, TeFileStreamThread, TeHTTPStreamThread, JclSynch,
  TeProcessManager, TeGrabManager, TePesParserThread, TePesFiFo, Registry, Buttons,
  TeSocket, TeComCtrls, Winsock2, IdThreadMgr, IdThreadMgrPool, TePesMuxerThread,
  IdBaseComponent, IdComponent, IdTCPServer, IdHTTPServer, TeSectionParserThread,
  IdTCPConnection, IdTCPClient, IdHTTP, Sockets, ScktComp, PJDropFiles, JclShell,
  ShlObj, ShellAPI,
  IdRawBase,
  IdRawClient,
  IdIcmpClient,
  TeRichEdit,
  Variants,
  OleCtrls,
  SHDocVw,
  IdGlobal,
  JclWin32,
  JclSysInfo,
  JclDateTime,
  DelTools,
  MyTrace,
  VcrTypes,
  TransformThread,
  ShutDownDlg,
  DateUtils,
  DB,
  ADODB,
  Grids,
  DBGrids,
  DBCtrls,
  IPAddressControl,
  VcrDivXchk,
  HTMLLite,
  Planner,
  DBPlanner;

{$M 65536,4194304}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

type

  e_TheadState = ( Thread_StateUnknown,
                   Thread_Idle,
                   Thread_Recording,
                   Thread_TransformStart,
                   Thread_Muxing           );

  T_Recording = record
    pcoTransformThread : TTransformThread;
    pcoProcessManager  : TTeProcessManager;
    RecordingData      : T_RecordingData;
    TheadState         : e_TheadState;
  end;


  TfrmMain = class(TForm)
    aclMain: TActionList;
    acGSStart: TAction;
    TePanel1: TTePanel;
    pclMain: TPageControl;
    tbsWelcome: TTabSheet;
    tbsDbox: TTabSheet;
    plDbox: TTePanel;
    tbsRunning: TTabSheet;
    plRunning: TTePanel;
    gbxMessages: TTeGroupBox;
    tbsInFiles: TTabSheet;
    plInFiles: TTePanel;
    tbsTimer: TTabSheet;
    plTimer: TTePanel;
    tbsInMux: TTabSheet;
    plInMux: TTePanel;
    gbxState: TTeGroupBox;
    lvwState: TListView;
    StateTimer: TTimer;
    tbsInTs: TTabSheet;
    plInTs: TTePanel;
    VCRCommandServerSocket: TServerSocket;
    VcrEpgClientSocket: TClientSocket;
    gbxDBox: TTeGroupBox;
    VCR_Ping: TIdIcmpClient;
    chxKillSectionsd: TTeCheckBox;
    Label2: TLabel;
    gbxSplittOutput: TTeGroupBox;
    lblSplitt1: TLabel;
    lblSplitt2: TLabel;
    chxSplitting: TCheckBox;
    cbxSplitSize: TComboBox;
    edOutPath: TTeEdit;
    Label3: TLabel;
    btnBrowseOutPath: TSpeedButton;
    gbxGrabMode: TTeRadioGroup;
    gbxDvdx: TTeGroupBox;
    chk_DVDx_enabled: TCheckBox;
    edDvdxFilePath: TTeEdit;
    btnBrowseDvdxPath: TSpeedButton;
    TeGroupBox2: TTeGroupBox;
    chxVideoStripPesHeader: TTeCheckBox;
    chxAudioStripPesHeader1: TTeCheckBox;
    chxAudioStripPesHeader2: TTeCheckBox;
    chxAudioStripPesHeader3: TTeCheckBox;
    chxAudioStripPesHeader4: TTeCheckBox;
    gbxMovix: TTeGroupBox;
    chk_MoviX_enabled: TCheckBox;
    edMovixPath: TTeEdit;
    btnBrowseMovixPath: TSpeedButton;
    chk_CDRwBurn_enabled: TCheckBox;
    TePanel2: TTePanel;
    bnStop: TTeBitBtn;
    TePanel3: TTePanel;
    btnSaveSettings: TTeBitBtn;
    btnLoadSettings: TTeBitBtn;
    edIsoPath: TTeEdit;
    btnBrowseIsoPath: TSpeedButton;
    mmoMessages: TListBox;
    TePanel4: TTePanel;
    Label1: TLabel;
    Label4: TLabel;
    edCDRWDeviceId: TTeEdit;
    edCDRwSpeed: TTeEdit;
    edVlcPath: TTeEdit;
    btnBrowseVlc: TSpeedButton;
    Label5: TLabel;
    chxVlc: TCheckBox;
    btnVlcView: TTeBitBtn;
    plWelcome: TTePanel;
    lbxChannelList: TListBox;
    Panel1: TPanel;
    plChannelProg: TTePanel;
    lvChannelProg: TTeListView;
    Panel2: TPanel;
    Timer_WebBrowser: TWebBrowser;
    TePanel5: TTePanel;
    TeGroupBox1: TTeGroupBox;
    gbxInAudio4: TTeGroupBox;
    edInAudio4MuxPes: TTeEdit;
    gbxInAudio3: TTeGroupBox;
    edInAudio3MuxPes: TTeEdit;
    gbxInAudio2: TTeGroupBox;
    edInAudio2MuxPes: TTeEdit;
    gbxInAudio1: TTeGroupBox;
    edInAudio1_DropFiles: TPJDropFiles;
    edInAudio1MuxPes: TTeEdit;
    gbxInVideo: TTeGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edVideoInOffsetStart: TTeEdit;
    edVideoInOffsetEnd: TTeEdit;
    edInVideo_DropFiles: TPJDropFiles;
    edInVideoMuxPes: TTeEdit;
    TePanel6: TTePanel;
    btnMuxPes: TTeBitBtn;
    TePanel7: TTePanel;
    btnReMuxPs: TTeBitBtn;
    TePanel8: TTePanel;
    btnReMuxTs: TTeBitBtn;
    TePanel9: TTePanel;
    gbxInMux: TTeGroupBox;
    TePanel10: TTePanel;
    gbxTsIn: TTeGroupBox;
    btnMuxTransform: TTeBitBtn;
    edOutMux_DropFiles: TPJDropFiles;
    edOutMuxPes: TTeEdit;
    edInReMuxPs_DropFiles: TPJDropFiles;
    edInReMuxPs: TTeEdit;
    TeGroupBox3: TTeGroupBox;
    edOutReMuxPs: TTeEdit;
    edReMuxTs_DropFiles: TPJDropFiles;
    edInReMuxTs: TTeEdit;
    TeGroupBox4: TTeGroupBox;
    edOutReMuxTs: TTeEdit;
    gbxTsPIDs: TTeGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edTsVideoPid: TTeEdit;
    edTsAudioPid1: TTeEdit;
    edTsAudioPid2: TTeEdit;
    edTsAudioPid3: TTeEdit;
    edTsAudioPid4: TTeEdit;
    btnRecordNow: TTeBitBtn;
    RecordNowTimer: TTimer;
    Label6: TLabel;

    Recorded_ADOConnection: TADOConnection;

    Recorded_DataSource: TDataSource;
    Recorded_DBGrid: TDBGrid;
    Recorded_DBNavigator: TDBNavigator;
    Recorded_ADOQuery: TADOQuery;

    Whishes_DataSource: TDataSource;
    Whishes_DBGrid: TDBGrid;
    Whishes_DBNavigator: TDBNavigator;
    Whishes_ADOQuery: TADOQuery;

    StartupTimer: TTimer;
    Whishes_Result: TListBox;
    btnWishesSeek: TTeBitBtn;
    RefreshTimer: TTimer;
    btnRefreshChannels: TTeBitBtn;
    Panel3: TPanel;
    edIp: TIPAddressControl;
    Whishes_ADOConnection: TADOConnection;
    Work_ADOConnection: TADOConnection;
    Work_ADOQuery: TADOQuery;
    EpgViewer: ThtmlLite;
    chxSwitchChannel: TTeCheckBox;
    lbl_check_EPG: TLabel;
    dbRefreshTimer: TTimer;
    Record_Planner: TDBPlanner;
    Planner_DBDaySource: TDBDaySource;
    Planner_ADOTable: TADOTable;
    btnWishesSeekDb: TTeBitBtn;
    Planner_DataSource: TDataSource;
    Planner_ADOConnection: TADOConnection;
    Recorded_Epg_DropFiles: TPJDropFiles;
    Recorded_EpgView: ThtmlLite;
    Label16: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbxChannelListClick(Sender: TObject);
    procedure lbxChannelListDblClick(Sender: TObject);
    procedure lbxChannelListDrawItem(Control: TWinControl; Index: Integer;
                                     Rect: TRect; State: TOwnerDrawState);

    procedure chxSplittingClick(Sender: TObject);
    procedure lblSplitt1Click(Sender: TObject);
    procedure StateTimerTimer(Sender: TObject);
    procedure tbsRunningShow(Sender: TObject);
    procedure tbsRunningHide(Sender: TObject);
    procedure tbsWelcomeShow(Sender: TObject);
    procedure tbsWelcomeHide(Sender: TObject);

    procedure edInAudioDblClick(Sender: TObject);
    procedure edInVideoMuxPesDblClick(Sender: TObject);
    procedure edInReMuxPsDblClick(Sender: TObject);
    procedure edOutAudioDblClick(Sender: TObject);

    procedure bnStopClick(Sender: TObject);
    procedure edInReMuxTsDblClick(Sender: TObject);
    procedure VCRCommandServerSocketClientRead(Sender: TObject;
                                               Socket: TCustomWinSocket);
    procedure edInVideo_DropFilesDropFiles(Sender: TObject);
    procedure edInAudio1_DropFilesDropFiles(Sender: TObject);
    procedure chk_DVDx_enabledExit(Sender: TObject);
    procedure chk_MoviX_enabledExit(Sender: TObject);
    procedure VCR_PingReply(ASender: TComponent;
                            const AReplyStatus: TReplyStatus);
    procedure edIpChange(Sender: TObject);

    procedure btnBrowseMovixPathClick(Sender: TObject);
    procedure btnBrowseDvdxPathClick(Sender: TObject);
    procedure btnBrowseOutPathClick(Sender: TObject);
    procedure btnSaveSettingsClick(Sender: TObject);
    procedure btnLoadSettingsClick(Sender: TObject);
    procedure btnBrowseIsoPathClick(Sender: TObject);
    procedure edOutPathChange(Sender: TObject);
    procedure edDvdxFilePathChange(Sender: TObject);
    procedure edMovixPathChange(Sender: TObject);
    procedure edIsoPathChange(Sender: TObject);
    procedure chk_CDRwBurn_enabledExit(Sender: TObject);
    procedure edCDRWDeviceIdChange(Sender: TObject);
    procedure edCDRwSpeedChange(Sender: TObject);
    procedure lvChannelProgDblClick(Sender: TObject);
    procedure lvChannelProgClick(Sender: TObject);
    procedure btnBrowseVlcClick(Sender: TObject);
    procedure chxVlcClick(Sender: TObject);
    procedure edVlcPathChange(Sender: TObject);
    procedure btnVlcViewClick(Sender: TObject);
    procedure pclMainChange(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure edInAudio1MuxPesChange(Sender: TObject);
    procedure btnMuxPesClick(Sender: TObject);
    procedure btnMuxTransformClick(Sender: TObject);
    procedure edOutMux_DropFilesDropFiles(Sender: TObject);
    procedure edInVideoMuxPesChange(Sender: TObject);
    procedure tbsDboxHide(Sender: TObject);
    procedure edInReMuxPs_DropFilesDropFiles(Sender: TObject);
    procedure edInReMuxPsChange(Sender: TObject);
    procedure btnReMuxPsClick(Sender: TObject);
    procedure btnReMuxTsClick(Sender: TObject);
    procedure edReMuxTs_DropFilesDropFiles(Sender: TObject);
    procedure edInReMuxTsChange(Sender: TObject);
    procedure btnRecordNowClick(Sender: TObject);
    procedure RecordNowTimerTimer(Sender: TObject);
    procedure Recorded_DBGridTitleClick(Column: TColumn);
    procedure StartupTimerTimer(Sender: TObject);
    procedure btnWishesSeekClick(Sender: TObject);
    procedure btnWishesSeekDbClick(Sender: TObject);
    procedure btnRefreshChannelsClick(Sender: TObject);
    procedure Recorded_ADOQueryAfterScroll(DataSet: TDataSet);
    procedure Whishes_ResultDblClick(Sender: TObject);

    procedure dbRefreshTimerTimer(Sender: TObject);

    procedure Planner_DBDaySourceFieldsToItem(Sender: TObject; Fields: TFields;
                                              Item: TPlannerItem);
    procedure Planner_DBDaySourceItemToFields(Sender: TObject; Fields: TFields;
                                              Item: TPlannerItem);
    procedure Whishes_ResultDrawItem(Control: TWinControl; Index: Integer;
                                     Rect: TRect; State: TOwnerDrawState);
    procedure mmoMessagesDrawItem(Control: TWinControl; Index: Integer;
                                  Rect: TRect; State: TOwnerDrawState);
    procedure Recorded_Epg_DropFilesDropFiles(Sender: TObject);

  private
    m_bInit              : Boolean;

    m_coGoBackTo         : TTabSheet;

    m_sDBoxIp            : String;

    m_bDVDx              : Boolean;
    m_sDVDxPath          : String;
    m_bMoviX             : Boolean;
    m_sMoviXPath         : String;
    m_sM2pPath           : String;
    m_sIsoPath           : String;
    m_bCDRwBurn          : Boolean;
    m_sCDRwDevId         : String;
    m_sCDRwSpeed         : String;
    m_bVlc               : Boolean;
    m_sVlcPath           : String;
    m_tStopRecordNow     : TDateTime;
    m_bVCR_Ping_Ok       : Boolean;
    m_bHttpInProgress    : Boolean;
    m_LastEpgUpdate      : TDateTime;
    m_bAbortWishesSeek   : Boolean;
    
    m_Recorded_dbConnectionString : String;

    m_Trace              : TTrace;

{$W+}
    procedure ReMuxTsStateCallback(aSender: TTeProcessManager; const aName, aState: string);
    procedure ReMuxPsStateCallback(aSender: TTeProcessManager; const aName, aState: string);
    procedure MuxStateCallback(aSender: TTeProcessManager; const aName, aState: string);
    procedure MessageCallback(aSender: TTeProcessManager; const aMessage: string);
    procedure StateCallback(aSender: TTeProcessManager; const aName, aState: string);
{$W-}

    procedure ClearStateList;

    procedure AnalyzeXMLRequest(sBuffer: String;   var RecordingData : T_RecordingData);
    procedure RecordingStart(Socket: TCustomWinSocket; RecordingData : T_RecordingData);
    procedure RecordingStop(RecordingData : T_RecordingData);
    function  RecordingCreateOutPath( ThreadId : Integer ): String;
    procedure RecordingCreateOutFileName( ThreadId : Integer; sOutPath : String );
    procedure RecordingSaveEpgFile( ThreadId : Integer; sOutPath : String );
    procedure RecordingStartTimer;
    procedure RecordingStopTimer;

    function  PingDBox(sIp: String) : Boolean;
    procedure CheckShutdown;

    function  CheckFileNameString(sFileName: String): String;
    function  CheckPathNameString(sPathName: String): String;
    function  CheckDbString(sPathName: String): String;

    function  CheckPath(PathEdit: TTeEdit): Boolean;
    function  BrowseForDir(const FormHandle: HWND; TitleName: string; var DirPath: string): Boolean;

    procedure RetrieveChannelList(ChannelList : TListBox);
    function  RetrieveCurrentChannel(ChannelList : TListBox; var channelname: String): String;

    procedure GetChannelProg(ChannelId: String; var epgid: integer; var epgtitel: string);
    function  GetCurrentEvent(ChannelId: String) : String;

    procedure GetProgEpg(sEventId, sFilePath: String; var epgtitel, epgsubtitel: String);
    function  SaveEpgText(aUrl, sFilePath: String; var epgtitel, epgsubtitel: String): TStringList;
    Function  RecordingLoadEpgFile( ThreadId : Integer; sEpgFileName : String ): String;

    procedure GetPids(var vpid: Integer; var apids: array of Integer);

    function  SetHttpHeader: String;
    function  SendHttpCommand(sCommand: String): String;

    procedure OpenEpgDb(sEpgDbFilename : String);
    procedure CloseEpgDb;

    procedure SaveEpgToDb(  sEpgTitle, sEpgSubTitle, sEpg : String);
    procedure UpdateEpgInDb(sEpgTitle, sEpgSubTitle, sEpg : String);
    function  IsInRecordedList(sTitel, sSubTitle : String): Integer;

    procedure SaveWhishesToDb(sEpgTitle : String);
    function  IsInWhishesList(sEpgTitle : String): Integer;

    procedure CheckChannelProg(ChannelId: String; sChannelName: String);
    procedure CheckChannelProgInDb(ChannelId: String);
    procedure CheckChannels(bSwitchChannels: Boolean);
    procedure CheckChannelsInDb;

    function  IsDBoxRecording: Boolean;
    function  GetNextFreeThread: Integer;
    function  GetMachingThread(RecordingData: T_RecordingData): Integer;

    procedure CheckDbVersion;

    // EventListe
    procedure UpdateEventInDb(ChannelId : String;
                              sEventId  : String;
                              sZeit     : String;
                              sDauer    : String;
                              sTitel    : String;
                              sSubTitel : String;
                              sEpg      : String );
    procedure FillDbEventListView(ChannelId : String);
    function  GetCurrentDbEvent(ChannelId : String): String;
    function  GetDbEventEpg(ChannelId    : String;
                            EventId      : String;
                            var sTitel,
                                sSubTitel: String): String;
    procedure TruncDbEvent;

    // KanalListe
    procedure UpdateChannelInDb( ChannelId : String;
                                 sName     : String );
    function  GetDbChannelId( sChannelName : String ) : String;
    function  GetDbChannelName( ChannelId : String ) : String;
    function  GetDbChannelSwitchFlag( ChannelId : String ) : Integer;
    function  GetDbChannelEpgFlag( ChannelId : String ) : Integer;
    procedure FillDbChannelListBox;

    // Record-Timer
    procedure Record_Planner_UpdateHeaders;

    
  public
    ChannelList   : TTeChannelList;
    StateList     : TStringList;

    m_RecordingThread : array[0..10] of T_Recording;

    StartTime     : TDateTime;
    EndTime       : TDateTime;
    SplittSize    : Word;

    procedure SendSectionsPauseCommand(aPause: Boolean);

    procedure ClearRecordingThread( k : Integer );

    procedure InitChannels;
    procedure LoadSettings;
    procedure SaveSettings;

    procedure DbgMsg( Msg: String );

  end;

  TStateItem = class(TObject)
    State: string;
    Item: TListItem;
  end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

var
  frmMain : TfrmMain;

implementation

uses
  {QMemory,}
  Contnrs,
  TimerFrm;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function MidColor(aColor1, aColor2: TColor): TColor;
var
  hColor1                     : TRGBQuad absolute aColor1;
  hColor2                     : TRGBQuad absolute aColor2;
  hResult                     : TRGBQuad absolute Result;
begin
  try
    aColor1 := ColorToRGB(aColor1);
    aColor2 := ColorToRGB(aColor2);
    Result := 0;
    hResult.rgbBlue := (hColor1.rgbBlue + hColor2.rgbBlue) div 2;
    hResult.rgbGreen := (hColor1.rgbGreen + hColor2.rgbGreen) div 2;
    hResult.rgbRed := (hColor1.rgbRed + hColor2.rgbRed) div 2;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

function IntToStrDef(aInt, aDefInt: Integer) : String;
begin
  try
    Result := IntToStr(aInt);
  except
    Result := IntToStr(aDefInt);
  end;
end;

function StrToIntEx(aString: string): Integer;
begin
  Result := 0;
  try
    aString := AnsiUpperCase(Trim(aString));
    if Copy(aString, 1, 2) = '0X' then
    begin
      Delete(aString, 1, 2);
      aString := '$' + aString;
      Result := StrToInt(aString);
      exit;
    end;
    if Pos('$',aString) = 1 then
    begin
      Result := StrToInt(aString);
      exit;
    end;
    if (Pos('A',aString) <> 0) or
       (Pos('B',aString) <> 0) or
       (Pos('C',aString) <> 0) or
       (Pos('D',aString) <> 0) or
       (Pos('E',aString) <> 0) or
       (Pos('F',aString) <> 0) then
    begin
      aString := '$'+aString;
    end;
    try
      Result := StrToInt(aString);
    except
      on E: EConvertError do
        Result := 0;
    end;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

function StrToInt64Ex(aString: string): Int64;
begin
  Result := 0;
  try
    aString := AnsiUpperCase(Trim(aString));
    if Copy(aString, 1, 2) = '0X' then
    begin
      Delete(aString, 1, 2);
      aString := '$' + aString;
      Result := StrToInt64(aString);
      exit;
    end;
    if Pos('$',aString) = 1 then
    begin
      Result := StrToInt64(aString);
      exit;
    end;
    if (Pos('A',aString) <> 0) or
       (Pos('B',aString) <> 0) or
       (Pos('C',aString) <> 0) or
       (Pos('D',aString) <> 0) or
       (Pos('E',aString) <> 0) or
       (Pos('F',aString) <> 0) then
    begin
      aString := '$'+aString;
    end;
    try
      Result := StrToInt64(aString);
    except
      on E: EConvertError do
        Result := 0;
    end;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

function GetHTTP(aUrl: string): TStringList;
begin
  with TIdHTTP.Create(nil) do
  try
    Result := TStringList.Create;
    try
      Result.Text := Get(aUrl);
    except
//      Free;
      raise;
    end;
  finally
    Free;
  end;
end;

function  TfrmMain.CheckFileNameString(sFileName: String): String;
var
  k    : Integer;
  sTmp : String;
begin
  try
    sTmp := sFileName;
    for k:= 1 to Length(sTmp) do
    begin
      if sTmp[k] = ':' then sTmp[k]:= '.';
      if sTmp[k] = '*' then sTmp[k]:= '_';
      if sTmp[k] = '?' then sTmp[k]:= '_';
      if sTmp[k] = '\' then sTmp[k]:= '_';
      if sTmp[k] = '/' then sTmp[k]:= '_';
      if sTmp[k] = '"' then sTmp[k]:= '_';
      if sTmp[k] = '<' then sTmp[k]:= '_';
      if sTmp[k] = '>' then sTmp[k]:= '_';
      if sTmp[k] = '|' then sTmp[k]:= '_';
      if sTmp[k] = ' ' then sTmp[k]:= '_';
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckFileNameString '+ E.Message );
  end;
  Result := sTmp;
end;

function  TfrmMain.CheckPathNameString(sPathName: String): String;
var
  k        : Integer;
  sOutPath : String;
begin
  try
    sOutPath:= sPathName;
    for k:= 3 to Length(sOutPath) do
    begin
      if sOutPath[k] = ':' then sOutPath[k]:= '.';
      if sOutPath[k] = '*' then sOutPath[k]:= '_';
      if sOutPath[k] = '?' then sOutPath[k]:= '_';
      if sOutPath[k] = '/' then sOutPath[k]:= '\';
      if sOutPath[k] = '"' then sOutPath[k]:= '_';
      if sOutPath[k] = '<' then sOutPath[k]:= '_';
      if sOutPath[k] = '>' then sOutPath[k]:= '_';
      if sOutPath[k] = '|' then sOutPath[k]:= '_';
      if sOutPath[k] = ' ' then sOutPath[k]:= '_';
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckPathNameString '+ E.Message );
  end;
  Result := sOutPath;
end;

function  TfrmMain.CheckDbString(sPathName: String): String;
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
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckDbString '+ E.Message );
  end;
  Result := sOutPath;
end;

procedure TfrmMain.ClearRecordingThread( k : Integer );
begin
  try
    try
      FreeAndNil(m_RecordingThread[k].pcoTransformThread);
      // reset status
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
      m_RecordingThread[k].RecordingData.epg          := '';
      m_RecordingThread[k].RecordingData.filename     := '';
    finally
      m_RecordingThread[k].TheadState := Thread_Idle;
      m_RecordingThread[k].pcoTransformThread := nil;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'CheckDbString '+ E.Message );
  end;
end;

function TfrmMain.IsDBoxRecording: Boolean;
var
  k : Integer;
begin
  Result := false;
  try
    for k:=0 to 9 do
    begin
      if m_RecordingThread[k].TheadState = Thread_Recording then
      begin
        Result := true;
      end;
      if not (m_RecordingThread[k].pcoTransformThread = nil) then
      begin
        if m_RecordingThread[k].pcoTransformThread.Terminated then
        begin
          // free finished TransformThread ...
          ClearRecordingThread(k);
        end;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'IsDBoxRecording '+ E.Message );
  end;
end;

function TfrmMain.GetNextFreeThread: Integer;
var
  k : Integer;
begin
  Result := 0;
  try
    for k:=1 to 9 do
    begin
      if not (m_RecordingThread[k].pcoTransformThread = nil) then
      begin
        if m_RecordingThread[k].pcoTransformThread.Terminated then
        begin
          // free finished TransformThread ...
          ClearRecordingThread(k);
        end;
      end;
      if (m_RecordingThread[k].pcoTransformThread = nil) then
      begin
        Result := k;
        break;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'GetNextFreeThread '+ E.Message );
  end;
end;

function TfrmMain.GetMachingThread(RecordingData: T_RecordingData): Integer;
var
  k : Integer;
begin
  Result := 0;
  try
    for k:=0 to 9 do
    begin
      if  (                     RecordingData.cmd = CMD_VCR_STOP)
      and (m_RecordingThread[k].RecordingData.cmd = CMD_VCR_RECORD)
      then
      begin
        Result:= k;
        m_Trace.DBMSG(TRACE_ALL,'GetMachingThread (VCR_RECORD) '+ IntToStr(k) );
        break;
      end;
      if  (RecordingData.vpid = m_RecordingThread[k].RecordingData.vpid)
      and (RecordingData.vpid <> 0)
      then
      begin
        Result:= k;
        m_Trace.DBMSG(TRACE_ALL,'GetMachingThread (vpid) '+ IntToStr(k) );
        break;
      end;
      if  (RecordingData.channel_id = m_RecordingThread[k].RecordingData.channel_id)
      and (RecordingData.channel_id <> '0')
      then
      begin
        Result:= k;
        m_Trace.DBMSG(TRACE_ALL,'GetMachingThread (channel_id) '+ IntToStr(k) );
        break;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'GetMachingThread '+ E.Message );
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//  Mainform ...
//
procedure TfrmMain.FormCreate(Sender: TObject);
var
  k    : Integer;
begin
  try
    Caption := Application.Title;

    DateSeparator   := '-';
    ShortDateFormat := 'yyyy/m/d';
    TimeSeparator   := '.';

    m_Trace := TTrace.Create();
    m_Trace.DBMSG_INIT('',
                       'TuxBox',
                       '1.0',
                       '',
                       'WinGrab');
    DbgMsg('***###*** Startup ***###***');
    DoEvents;

    OpenEpgDb(ExtractFilePath(Application.ExeName) + 'WinGrabVcr.mdb');

    StateList            := TStringList.Create;
    StateList.Sorted     := true;
    StateList.Duplicates := dupIgnore;

    ChannelList          := TTeChannelList.Create;
    m_bAbortWishesSeek   := false;
    
    lvwState.DoubleBuffered := true;
    if FindCmdLineSwitch('DONTPANIC', ['-', '/'], True) then
    begin
      _NoMuxerPanic := True;
    end;

    SendMessage( Whishes_Result.Handle,
                 LB_SETHORIZONTALEXTENT,
                 3000,
                 0);
    mmoMessages.Sorted := true;
    SendMessage( mmoMessages.Handle,
                 LB_SETHORIZONTALEXTENT,
                 3000,
                 0);

    CenterWindow(frmMain);
    m_coGoBackTo        := pclMain.ActivePage;
    lvChannelProg.Parent:= plChannelProg;

    for k:= 0 to 9 do
    begin
      m_RecordingThread[k].RecordingData.HWndMsgList  := mmoMessages.Handle;
      ClearRecordingThread(k);
    end;

    LoadSettings;

    Windows.SetThreadPriority(Application.Handle , THREAD_PRIORITY_ABOVE_NORMAL);

    Record_Planner_UpdateHeaders;
    DoEvents;
    Sleep(100);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'FormCreate '+ E.Message );
  end;
end;

procedure TfrmMain.StartupTimerTimer(Sender: TObject);
var
  ChannelId : String;
  x         : Integer;
  sTmp      : String;
begin
  StartupTimer.Enabled := False;
  try
    m_Trace.DBMSG(TRACE_CALLSTACK, '> StartupTimerTimer');
    DoEvents;
    Sleep(100);

    ////////////////
    FillDbChannelListBox;
    if lbxChannelList.ItemIndex >= 0 then
    begin
      pclMain.ActivePage := tbsWelcome;
      DoEvents;
      ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
      FillDbEventListView( ChannelId );
      if lvChannelProg.Items.Count < 10 then
      begin
        GetChannelProg( ChannelId, x, sTmp );
      end;
      RetrieveCurrentChannel(lbxChannelList, sTmp);
      lvChannelProgClick(self);
    end else
    begin
      InitChannels;
    end;
    DoEvents;
    ////////////////

    if not PingDBox(m_sDBoxIp) then
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'DBox ' + m_sDBoxIp + ' not found');
      pclMain.ActivePage := tbsDbox;
      DoEvents;
    end else
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'DBox ' + m_sDBoxIp + ' found ...');
      pclMain.ActivePage := tbsWelcome;
      DoEvents;
      Timer_WebBrowser.Navigate(m_sDBoxIp + '/fb/timer.dbox2');
      DoEvents;
      SendHttpCommand('/control/setmode?tv');
      DoEvents;
    end;
    VCRCommandServerSocket.Active := true;
    SendHttpCommand('/control/message?popup=streaming%20server%20started');
    DoEvents;

    m_Trace.DBMSG(TRACE_DETAIL, '... all Init');

    DoEvents;
    Sleep(100);
  except
  end;
  DoEvents;
  Sleep(10);
  m_Trace.DBMSG(TRACE_CALLSTACK, '< StartupTimerTimer');
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  try
    LoadSettings;
    DoEvents;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'FormShow '+ E.Message );
  end;
end;

procedure TfrmMain.FormHide(Sender: TObject);
begin
  try
    SaveSettings;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'FormHide '+ E.Message );
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  try
    if PingDBox(m_sDBoxIp) then
    begin
      SendHttpCommand('/control/message?popup=streaming%20server%20stopped');
    end;

    ClearStateList;
    FreeAndNil(StateList);
    FreeAndNil(ChannelList);

    CloseEpgDb;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'FormDestroy '+ E.Message );
  end;

  DbgMsg('***###*** END ***###***');
end;
//
//  Mainform ...
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Handle the Settings ...
//
{$I VcrMainSettings.pas}
procedure TfrmMain.btnSaveSettingsClick(Sender: TObject);
begin
  try
    SaveSettings;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnSaveSettingsClick '+ E.Message );
  end;
end;

procedure TfrmMain.btnLoadSettingsClick(Sender: TObject);
begin
  try
    LoadSettings;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnLoadSettingsClick '+ E.Message );
  end;
end;

procedure TfrmMain.tbsDboxHide(Sender: TObject);
begin
end;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  HTTP-Clients to receive Infos from DBox ...
//
{$I VcrMainHttpClients.pas}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  DataBase - Procedures ...
//
{$I VcrDatabase.pas}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Handle 'Welcome' Page ...
//
procedure TfrmMain.RefreshTimerTimer(Sender: TObject);
var
  ChannelId  : String;
  x          : Integer;
  bRecording : Boolean;
  sTmp       : String;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RefreshTimerTimer');
  try
    if StartupTimer.Enabled then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< RefreshTimerTimer (startup)');
      exit;
    end;

    if not RefreshTimer.Enabled then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< RefreshTimerTimer (running)');
      exit;
    end;

    RefreshTimer.Enabled := false;
    try
      DoEvents;
      bRecording := IsDBoxRecording;
      if PingDBox(m_sDBoxIp) then
      begin
        if not bRecording then
        begin
          RetrieveCurrentChannel(lbxChannelList, sTmp);
          if lbxChannelList.ItemIndex >= 0 then
          begin
            ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
            FillDbEventListView( ChannelId );
            lvChannelProg.SetFocus;
            lvChannelProgClick(self);
          end else
          begin
            InitChannels;
          end;
          DoEvents;

        end;
      end;
      CheckShutdown;

      // This subroutine decommits the unused memory blocks.
      QMemDecommitOverstock;

    finally
      RefreshTimer.Enabled := true;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'RefreshTimerTimer '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RefreshTimerTimer');
end;

procedure TfrmMain.dbRefreshTimerTimer(Sender: TObject);
var
  ChannelId  : String;
  x          : Integer;
  bRecording : Boolean;
  sTmp       : String;
  AYear,
  AMonth,
  ADay,
  AHour,
  AMinute,
  ASecond,
  AMilliSecond: Word;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> dbRefreshTimerTimer');
  try
    if StartupTimer.Enabled then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< dbRefreshTimerTimer (startup)');
      exit;
    end;

    if not dbRefreshTimer.Enabled then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< dbRefreshTimerTimer (running)');
      exit;
    end;

    if IsDBoxRecording then
    begin
      m_Trace.DBMSG(TRACE_CALLSTACK, '< dbRefreshTimerTimer (recording)');
      exit;
    end;

    dbRefreshTimer.Enabled := false;
    try
      DoEvents;
      DecodeDateTime((Now),
                     AYear,
                     AMonth,
                     ADay,
                     AHour,
                     AMinute,
                     ASecond,
                     AMilliSecond);
      m_Trace.DBMSG(TRACE_DETAIL, 'dbRefreshTimerTimer  LastUpdate='+DateTimeToStr(m_LastEpgUpdate));
      m_Trace.DBMSG(TRACE_DETAIL, 'dbRefreshTimerTimer         Now='+DateTimeToStr(Now - OffsetFromUTC));
      m_Trace.DBMSG(TRACE_DETAIL, 'dbRefreshTimerTimer        Hour='+IntToStr(AHour));
      m_Trace.DBMSG(TRACE_DETAIL, 'dbRefreshTimerTimer CompareDate='+IntToStr(CompareDate((Now - OffsetFromUTC), m_LastEpgUpdate)));
      if (AHour > 02) and
         (AHour < 10) then
      begin
        if (CompareDate(Now, m_LastEpgUpdate) > 0) then
        begin
          CheckChannels( chxSwitchChannel.Checked );
        end;
      end;
      if lvChannelProg.Items.Count < 20 then
      begin
        m_Trace.DBMSG(TRACE_DETAIL, 'dbRefreshTimerTimer lvChannelProg.Items.Count='+IntToStr(lvChannelProg.Items.Count));
        ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
        GetChannelProg( ChannelId, x, sTmp );
        CheckChannels( false );
      end;

    finally
      dbRefreshTimer.Enabled := true;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'dbRefreshTimerTimer '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< dbRefreshTimerTimer');
end;

procedure TfrmMain.tbsWelcomeShow(Sender: TObject);
begin
  lvChannelProg.SetFocus;
  RefreshTimer.Enabled := true;
  DoEvents;
end;

procedure TfrmMain.tbsWelcomeHide(Sender: TObject);
begin
  RefreshTimer.Enabled := false;
  DoEvents;
end;

procedure TfrmMain.lbxChannelListClick(Sender: TObject);
var
  ChannelId   : String;
begin
  try
    if lbxChannelList.ItemIndex >= 0 then
    begin
      ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
      m_Trace.DBMSG(TRACE_DETAIL,'Click Channel '+(ChannelId)+' "'+ lbxChannelList.Items.Strings[lbxChannelList.ItemIndex] + '"');
      FillDbEventListView( ChannelId );

      if pclMain.ActivePage = tbsWelcome then
      begin
        lvChannelProg.SetFocus;
      end;
      lvChannelProgClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lbxChannelListClick '+ E.Message );
  end;
end;

procedure TfrmMain.lbxChannelListDblClick(Sender: TObject);
var
  ChannelId : String;
begin
  // Zap To Channel
  try
    if lbxChannelList.ItemIndex >= 0 then
    begin
      ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
      if PingDBox(m_sDBoxIp) then
        SendHttpCommand('/fb/switch.dbox2?zapto=' + (ChannelId) );

      lbxChannelListClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lbxChannelListDblClick '+ E.Message );
  end;
end;

procedure TfrmMain.lbxChannelListDrawItem(Control: TWinControl;
                                          Index: Integer;
                                          Rect: TRect;
                                          State: TOwnerDrawState);
begin
  try
    if not (odSelected in State) then
    begin
      if Index mod 2 = 0 then
        lbxChannelList.Canvas.Brush.Color := clWindow
      else
        lbxChannelList.Canvas.Brush.Color := MidColor(clWindow, MidColor(clWindow, clBtnShadow));
    end;
    if (Index >= 0) and (Index < lbxChannelList.Items.Count) then
    begin
      WriteText(lbxChannelList.Canvas, Rect, 2, 2, lbxChannelList.Items[Index], taLeftJustify, false)
    end else
      lbxChannelList.Canvas.FillRect(Rect);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lbxChannelListDrawItem '+ E.Message );
  end;
end;

procedure TfrmMain.lvChannelProgClick(Sender: TObject);
var
  sEpg     : String;
  sDbg     : String;
  sEventId : String;
  sTmp     : String;
  x        : Integer;
  ChannelId: String;

begin
  try
    if lvChannelProg.Items.Count < 20 then
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'lvChannelProgClick lvChannelProg.Items.Count='+IntToStr(lvChannelProg.Items.Count));
      ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
      GetChannelProg( ChannelId, x, sTmp );
    end;

    if lvChannelProg.ItemIndex = -1 then exit;

    sEventId := lvChannelProg.Selected.Caption;
    sDbg := 'Get EPG from eventid=' + sEventId;
    m_Trace.DBMSG(TRACE_MIN, sDbg);

    sEpg:= lvChannelProg.Selected.SubItems[5];
    EpgViewer.LoadFromString( sEpg, '' );
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lvChannelProgClick '+ E.Message );
  end;
end;

procedure TfrmMain.Whishes_ResultDblClick(Sender: TObject);
var
  sTmp,
  sMsg   : String;
  bFound : Boolean;
  i      : Integer;
begin
  try
    for i := 0 to (Whishes_Result.Items.Count - 1) do
    begin
      if Whishes_Result.Selected[i] then
      begin
        sTmp:= Whishes_Result.Items.Strings[i];
        sTmp := Trim(Copy(sTmp, Pos('"',sTmp)+1,Length(sTmp)));
        sTmp := Trim(Copy(sTmp, 1, Pos('"',sTmp)-1));

        bFound := (IsInRecordedList(sTmp, '') > 0);
        if bFound then
        begin
          sMsg :=  '"' + sTmp + '" wurde bereits aufgenommen !';
          DbgMsg(PChar(sMsg));
          sMsg :=  sMsg + #13 + #10;
          sMsg :=  sMsg + #13 + #10;
          Beep;
        end;
        sMsg := sMsg + 'Möchten Sie "' + sTmp + '" zur Aufnahme vormerken ?';
        if Application.MessageBox(PChar(sMsg), PChar('Frage'), MB_YESNO) = IDYES then
        begin
          sTmp:= Whishes_Result.Items.Strings[i];
          sTmp := Trim(Copy(sTmp, Pos('###',sTmp)+4,Length(sTmp)));
          m_Trace.DBMSG(TRACE_DETAIL,'Whishes_ResultDblClick send HTTP: '+ sTmp);
          SendHttpCommand(sTmp);
          DoEvents;
          Timer_WebBrowser.Navigate(m_sDBoxIp + '/fb/timer.dbox2');
        end;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lvChannelProgClick '+ E.Message );
  end;
end;

procedure TfrmMain.lvChannelProgDblClick(Sender: TObject);
var
  ChannelId : String;
  sDbg   : String;
  sZeit  : String;
  sDauer : String;
  sTmp   : String;
  bFound : Boolean;
begin
  if lvChannelProg.ItemIndex = -1 then exit;
  if not PingDBox(m_sDBoxIp) then exit;
  try
    bFound := (IsInRecordedList(lvChannelProg.Selected.SubItems[4], '') > 0);
    sTmp := '';
    if bFound then
    begin
      sTmp :=  '"' + lvChannelProg.Selected.SubItems[4] + '" wurde bereits aufgenommen !';
      DbgMsg(PChar(sTmp));
      sTmp :=  sTmp + #13 + #10;
      Beep;
    end;
    sTmp := sTmp + 'Möchten Sie "' + lvChannelProg.Selected.SubItems[4] + '" zur Aufnahme vormerken ?';
    if Application.MessageBox(PChar(sTmp), PChar('Frage'), MB_YESNO) = IDYES then
    begin

      SaveWhishesToDb(lvChannelProg.Selected.SubItems[4]);

      ChannelId := GetDbChannelId(lbxChannelList.Items.Strings[lbxChannelList.ItemIndex]);
      sZeit     := lvChannelProg.Selected.SubItems[0];
      sDauer    := lvChannelProg.Selected.SubItems[3];

      sTmp := '/fb/timer.dbox2?action=new&type=5&alarm=' + sZeit;
      sTmp := sTmp + '&stop=' + IntToStr( StrToIntDef(sZeit,0) + (StrToIntDef(sDauer,0) * 60) );
      sTmp := sTmp + '&channel_id=' + ChannelId + '&rs=1';
      DbgMsg(sTmp);

      SendHttpCommand(sTmp);
      DoEvents;
      Timer_WebBrowser.Navigate(m_sDBoxIp + '/fb/timer.dbox2');
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'lvChannelProgDblClick '+ E.Message );
  end;
end;

procedure TfrmMain.btnRecordNowClick(Sender: TObject);
var
  sTmp     : String;
  x        : Integer;
  sDbg,
  sZeit,
  sDauer,
  sOutPath : String;
  i,k      : Integer;
  sEpg     : TStringList;
begin
  if not PingDBox(m_sDBoxIp) then exit;

  try
    lvChannelProg.SetFocus;
    DoEvents;
    if lvChannelProg.ItemIndex = -1 then
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> lvChannelProg.ItemIndex = -1');
      exit;
    end;

    //Record it ...
    DateSeparator   := '-';
    ShortDateFormat := 'yyyy/m/d';
    TimeSeparator   := '.';

    if not IsDBoxRecording then
    begin
      // find next unused thread entry ...
      k:= GetNextFreeThread;
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> NextFreeThread = ' + IntToStr(k));
      m_RecordingThread[k].RecordingData.bIsPreview  := false;
      m_RecordingThread[k].RecordingData.iMuxerSyncs := 0;

      //Zap to Channel ...
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> DBoxIP      = ' + m_sDBoxIp);
      m_RecordingThread[k].RecordingData.channelname     := lbxChannelList.Items.Strings[lbxChannelList.ItemIndex];
      m_RecordingThread[k].RecordingData.channel_id      := GetDbChannelId(m_RecordingThread[k].RecordingData.channelname);
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> channel_id  = ' + m_RecordingThread[k].RecordingData.channel_id);
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> channelname = ' + m_RecordingThread[k].RecordingData.channelname);
      SendHttpCommand('/fb/switch.dbox2?zapto=' + m_RecordingThread[k].RecordingData.channel_id );
      DoEvents;

      GetPids(m_RecordingThread[k].RecordingData.vpid,
              m_RecordingThread[k].RecordingData.apids);
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> vpid = '        + IntToStrDef(m_RecordingThread[k].RecordingData.vpid,0));
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> apids[0] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[0],0));
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> apids[1] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[1],0));
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> apids[2] = '    + IntToStrDef(m_RecordingThread[k].RecordingData.apids[2],0));

      m_RecordingThread[k].RecordingData.cmd  := CMD_VCR_RECORD;
      m_RecordingThread[k].TheadState         := Thread_Recording;

      lvChannelProg.SetFocus;
      m_RecordingThread[k].RecordingData.epgid := lvChannelProg.Selected.Caption;
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> epgid    = '    + m_RecordingThread[k].RecordingData.epgid);

      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> create folder');
      sOutPath:= RecordingCreateOutPath( k );

      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> get EPG');
      RecordingSaveEpgFile( k, sOutPath );
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> epgtitel = '    + m_RecordingThread[k].RecordingData.epgtitle);
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> epgtitel2= '    + m_RecordingThread[k].RecordingData.epgsubtitle);

      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> build filename');
      RecordingCreateOutFileName( k, sOutPath );
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> filename = '    + m_RecordingThread[k].RecordingData.filename);
      DoEvents;

      SendHttpCommand('/control/setmode?record=start');
      SendSectionsPauseCommand(true);
      DoEvents;

      m_RecordingThread[k].pcoProcessManager := TTeMuxGrabManager.Create( m_sDBoxIp,
                                                                          m_RecordingThread[k].RecordingData.vpid,
                                                                          [m_RecordingThread[k].RecordingData.apids[0],
                                                                           m_RecordingThread[k].RecordingData.apids[1],
                                                                           m_RecordingThread[k].RecordingData.apids[2]],
                                                                          m_RecordingThread[k].RecordingData.filename + Mgeg2FileExt,
                                                                          SplittSize,
                                                                          MessageCallback,
                                                                          StateCallback);
      DoEvents;
      if Length(m_RecordingThread[k].RecordingData.epgid) <> 0 then
      begin
        try
          if m_RecordingThread[k].RecordingData.epgtitle = 'not available' then
          begin
            Application.ProcessMessages;
            Sleep(1000);
          end;
          i := 0;
          repeat
            i := i + 1;
            Application.ProcessMessages;
            GetProgEpg(m_RecordingThread[k].RecordingData.epgid,
                       sOutPath,
                       m_RecordingThread[k].RecordingData.epgtitle,
                       m_RecordingThread[k].RecordingData.epgsubtitle);
          until( (FileExists(sOutPath + m_RecordingThread[k].RecordingData.epgtitle + '_-_' + m_RecordingThread[k].RecordingData.epgsubtitle + '.HTML')) or (i > 10));
        except
          on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'RecordNow> GetProgEpg '+ E.Message );
        end;
      end;
      Sleep(3000);
      m_coGoBackTo       := pclMain.ActivePage;
      pclMain.ActivePage := tbsRunning;
      DoEvents;
    end else
    begin
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNow> IsDBoxRecording=true');
    end;

    sZeit := lvChannelProg.Selected.SubItems[0];
    sDbg := 'RecordNow> Zeit =' + sZeit;
    m_Trace.DBMSG(TRACE_MIN, sDbg);

    sDauer := lvChannelProg.Selected.SubItems[3];
    sDbg := 'RecordNow> Dauer =' + sDauer;
    m_Trace.DBMSG(TRACE_MIN, sDbg);

    m_tStopRecordNow := UnixToDateTime(StrToInt64(sZeit)) + OffsetFromUTC;
    if CompareDateTime(IncMinute(now, 45), m_tStopRecordNow) >= 0 then
    begin
      m_tStopRecordNow := IncMinute(m_tStopRecordNow,45);
    end else
    begin
      m_tStopRecordNow := IncMinute(m_tStopRecordNow,StrToInt64(sDauer));
    end;

    RecordNowTimer.Enabled := true;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'RecordNow>  '+ E.Message );
  end;
end;

procedure TfrmMain.RecordNowTimerTimer(Sender: TObject);
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> RecordNowTimerTimer');
  try
    if CompareDateTime(now, m_tStopRecordNow) >= 0  then
    begin
      RecordNowTimer.Enabled := false;
      m_Trace.DBMSG(TRACE_DETAIL, 'RecordNowTimerTimer = StopTime');
      bnStopClick(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'RecordNowTimerTimer '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< RecordNowTimerTimer');
end;

procedure TfrmMain.btnVlcViewClick(Sender: TObject);
var
  sTmp,
  sTrace,
  sOutPath,
  sCmdLine,
  sCmdParam     : String;
  TmpList       : TStringList;
  k,x           : Integer;
  RecordingData : T_RecordingData;
begin
  if not PingDBox(m_sDBoxIp) then exit;
  try
    TmpList := TStringList.Create;
    try
      if not IsDBoxRecording then
      begin
        DateSeparator   := '-';
        ShortDateFormat := 'yyyy/m/d';
        TimeSeparator   := '.';

        // find next unused thread entry ...
        k:= GetNextFreeThread;
        GetPids(m_RecordingThread[k].RecordingData.vpid,
                m_RecordingThread[k].RecordingData.apids);

        m_Trace.DBMSG(TRACE_DETAIL, 'create folder');
        sOutPath:= RecordingCreateOutPath( k );

        m_Trace.DBMSG(TRACE_DETAIL, 'get EPG');
        RecordingSaveEpgFile( k, sOutPath );

        m_Trace.DBMSG(TRACE_DETAIL, 'build filename');
        RecordingCreateOutFileName( k, sOutPath );

        m_RecordingThread[k].RecordingData.iMuxerSyncs := 0;
        m_RecordingThread[k].RecordingData.bIsPreview  := true;
        m_RecordingThread[k].TheadState                := Thread_Recording;

        m_RecordingThread[k].pcoProcessManager := TTeMuxGrabManager.Create( m_sDBoxIp,
                                                                            m_RecordingThread[k].RecordingData.vpid,
                                                                            [m_RecordingThread[k].RecordingData.apids[1],
                                                                             m_RecordingThread[k].RecordingData.apids[2],
                                                                             m_RecordingThread[k].RecordingData.apids[3]],
                                                                            m_RecordingThread[k].RecordingData.filename + Mgeg2FileExt,
                                                                            SplittSize,
                                                                            MessageCallback,
                                                                            StateCallback);
        m_coGoBackTo       := pclMain.ActivePage;
        pclMain.ActivePage := tbsRunning;
        DoEvents;
      end else
      begin
        RecordingData.cmd:= CMD_VCR_STOP;
        GetPids(RecordingData.vpid,
                RecordingData.apids);
        k:= GetMachingThread(RecordingData);
      end;
      SetCurrentDir(m_sVlcPath);

      sCmdLine := m_sVlcPath + 'vlc.exe';
      sCmdParam:= '--fullscreen --filter deinterlace "' + m_RecordingThread[k].RecordingData.filename + '[01]'+ Mgeg2FileExt+'"';
      sTrace := 'exec VLC with param=[' + sCmdParam + ']';
      DbgMsg(PChar(sTrace));

      TmpList.Add('@echo on');
      TmpList.Add(sCmdLine + ' ' + sCmdParam);
      TmpList.SaveToFile(m_sM2pPath + 'VcrView.cmd');

      DbgMsg('waiting for mpeg file');
      repeat
        DoEvents;
        Sleep(1000);
      until(SizeOfFile(m_RecordingThread[k].RecordingData.filename + '[01]'+ Mgeg2FileExt) > 1000000);
      DbgMsg('found '+ ExtractFileName(m_RecordingThread[k].RecordingData.filename + '[01]'+ Mgeg2FileExt));

      try
        sCmdLine := m_sM2pPath + 'VcrView.cmd';
        sCmdParam:= '';
        WinExecAndWait(sCmdLine,
                       sCmdParam);
      finally
        DeleteFile(m_sM2pPath + 'VcrView.cmd');
      end;
    finally
      TmpList.Free;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnVlcViewClick '+ E.Message );
  end;
end;

//
//  Handle 'Welcome' Page ...
//
////////////////////////////////////////////////////////////////////////////////



procedure TfrmMain.pclMainChange(Sender: TObject);
begin
  try
    m_coGoBackTo := pclMain.ActivePage;

    Record_Planner_UpdateHeaders;

  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'pclMainChange '+ E.Message );
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//  Handle 'Mux PES' - Page ...
//
procedure TfrmMain.edInVideoMuxPesDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := edInVideoMuxPes.Text;
    Filter := 'mpeg2 video (*'+VideoFileExt+')|*'+VideoFileExt;
    DefaultExt := 'm2v';
    if Execute then
    begin
      edInVideoMuxPes.Text := FileName;
      if FileExists(ChangeFileExt(edInVideoMuxPes.Text, '_1'+AudioFileExt)) then
        edInAudio1MuxPes.Text := ChangeFileExt(edInVideoMuxPes.Text, '_1'+AudioFileExt);
      if FileExists(ChangeFileExt(edInVideoMuxPes.Text, AudioFileExt)) then
        edInAudio1MuxPes.Text := ChangeFileExt(edInVideoMuxPes.Text, AudioFileExt);
      edInVideoMuxPesChange(self);
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.edInAudioDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := TEdit(Sender).Text;
    Filter := 'mpeg2 audio (*'+AudioFileExt+')|*'+AudioFileExt;
    DefaultExt := 'm2a';
    if Execute then
    begin
      TEdit(Sender).Text := FileName;
      edInVideoMuxPesChange(self);
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.edInAudio1MuxPesChange(Sender: TObject);
begin
  try
    if FileExists(edInAudio1MuxPes.Text) then
    begin
      if FileExists(ChangeFileExt(edInAudio1MuxPes.Text, '_2'+AudioFileExt)) then
        edInAudio2MuxPes.Text := ChangeFileExt(edInAudio1MuxPes.Text, '_2'+AudioFileExt);
      if FileExists(ChangeFileExt(edInAudio1MuxPes.Text, '_3'+AudioFileExt)) then
        edInAudio3MuxPes.Text := ChangeFileExt(edInAudio1MuxPes.Text, '_3'+AudioFileExt);
      if FileExists(ChangeFileExt(edInAudio1MuxPes.Text, '_3'+AudioFileExt)) then
        edInAudio4MuxPes.Text := ChangeFileExt(edInAudio1MuxPes.Text, '_4'+AudioFileExt);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TfrmMain.edInVideo_DropFilesDropFiles(Sender: TObject);
var
  sTmp : String;
begin
  try
    if Pos(UpperCase(VideoFileExt),UpperCase(edInVideo_DropFiles.FileName)) > 0 then
    begin
      edInVideoMuxPes.Text := edInVideo_DropFiles.FileName;
      sTmp:= ChangeFileExt(edInVideoMuxPes.Text, '_0' + AudioFileExt);
      if FileExists( sTmp ) then
      begin
        edInAudio1MuxPes.Text := sTmp;
      end;
      edOutMuxPes.Text := ChangeFileExt(sTmp, Mgeg2FileExt);
      edInVideoMuxPesChange(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edInVideo_DropFilesDropFiles '+ E.Message );
  end;
end;

procedure TfrmMain.edInAudio1_DropFilesDropFiles(Sender: TObject);
begin
  try
    if Pos(AudioFileExt,UpperCase(edInAudio1_DropFiles.FileName)) > 0 then
    begin
      edInAudio1MuxPes.Text := edInAudio1_DropFiles.FileName;
      edInVideoMuxPesChange(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edInAudio1_DropFilesDropFiles '+ E.Message );
  end;
end;

procedure TfrmMain.edOutMux_DropFilesDropFiles(Sender: TObject);
begin
  try
    if (Pos(UpperCase(Mgeg2FileExt),UpperCase(edOutMux_DropFiles.FileName)) > 0) OR
       (Pos(UpperCase(DivXFileExt), UpperCase(edOutMux_DropFiles.FileName)) > 0) then
    begin
      edOutMuxPes.Text := edOutMux_DropFiles.FileName;
      edInVideoMuxPesChange(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edOutMux_DropFilesDropFiles '+ E.Message );
  end;
end;

procedure TfrmMain.edInVideoMuxPesChange(Sender: TObject);
var
  filename : String;
begin
  try
    if chxSplitting.Checked then
    begin
      if FileExists( edInVideoMuxPes.Text ) then
      begin
        filename   := ChangeFileExt(edOutMuxPes.Text, '[01]');
      end else
      begin
        filename   := ChangeFileExt(edOutMuxPes.Text, '');
      end;
    end else
    begin
      filename   := ChangeFileExt(edOutMuxPes.Text, '');
    end;
    if (FileExists( filename + Mgeg2FileExt )  OR
        FileExists( filename + DivXFileExt )) then
    begin
      btnMuxTransform.Enabled := m_bDVDx;
    end else
    begin
      btnMuxTransform.Enabled := false;
    end;

    if  FileExists( edInVideoMuxPes.Text )
    AND FileExists( edInAudio1MuxPes.Text ) then
    begin
      btnMuxPes.Enabled := true;
    end else
    begin
      btnMuxPes.Enabled       := false;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edInVideoMuxPesChange '+ E.Message );
  end;
end;

procedure TfrmMain.MuxStateCallback(aSender            : TTeProcessManager;
                                    const aName, aState: string);
begin
  try
    DoEvents;
    if  (aState = 'terminated')
    AND (aName  = 'MuxWriter') then
    begin
      pclMain.ActivePage := m_coGoBackTo;
      edInVideoMuxPesChange(self);
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'MuxStateCallback '+ E.Message );
  end;
end;

procedure TfrmMain.btnMuxPesClick(Sender: TObject);
var
  sTmp : String;
  k    : Integer;
begin
  try
    if  FileExists( edInVideoMuxPes.Text )
    AND FileExists( ChangeFileExt(edInVideoMuxPes.Text, '') + '_0' + AudioFileExt) then
    begin
      // find next unused thread entry ...
      k:= GetNextFreeThread;

      DateTimeToString(sTmp, 'YYYYMMDD_hhnn', Now);
      m_RecordingThread[k].TheadState             := Thread_TransformStart;
      m_RecordingThread[k].RecordingData.epgid    := sTmp;
      m_RecordingThread[k].RecordingData.filename := ChangeFileExt(edInVideoMuxPes.Text, '');

      // Transform the StreamFiles to DivX ...
      m_RecordingThread[k].pcoTransformThread                 := TTransformThread.Create(true);
      m_RecordingThread[k].pcoTransformThread.FreeOnTerminate := false;
      m_RecordingThread[k].pcoTransformThread.Priority        := tpLower;
      m_RecordingThread[k].TheadState                         := Thread_TransformStart;
      m_RecordingThread[k].pcoTransformThread.SetParams(m_RecordingThread[k].RecordingData);
      m_RecordingThread[k].pcoTransformThread.Resume;

      m_coGoBackTo       := pclMain.ActivePage;
      pclMain.ActivePage := tbsRunning;
      DoEvents;
    end else
    begin
      if  FileExists( edInVideoMuxPes.Text )
      AND FileExists( edInAudio1MuxPes.Text) then
      begin
        // find next unused thread entry ...
        k:= GetNextFreeThread;

        DateTimeToString(sTmp, 'YYYYMMDD_hhnn', Now);
        m_RecordingThread[k].TheadState             := Thread_Muxing;
        m_RecordingThread[k].RecordingData.epgid    := sTmp;
        m_RecordingThread[k].RecordingData.filename := ChangeFileExt(edInVideoMuxPes.Text, '');

        m_RecordingThread[k].pcoProcessManager := TTeMuxProcessManager.Create(edInVideoMuxPes.Text,
                                                                              StrToIntDef(edVideoInOffsetStart.Text,-1),
                                                                              StrToIntDef(edVideoInOffsetEnd.Text, -1),
                                                                              [edInAudio1MuxPes.Text, edInAudio2MuxPes.Text, edInAudio3MuxPes.Text, edInAudio4MuxPes.Text],
                                                                              edOutMuxPes.Text,
                                                                              SplittSize,
                                                                              MessageCallback,
                                                                              MuxStateCallback);
        m_coGoBackTo       := pclMain.ActivePage;
        pclMain.ActivePage := tbsRunning;
        DoEvents;
      end else
      begin
        Beep;
        DoEvents;
        Beep;
        DoEvents;
        Beep;
        DoEvents;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnMuxPesClick '+ E.Message );
  end;
end;

procedure TfrmMain.btnMuxTransformClick(Sender: TObject);
var
  k        : Integer;
  filename : String;
begin
  try
    if chxSplitting.Checked then
    begin
      if FileExists( edInVideoMuxPes.Text ) then
      begin
        filename   := ChangeFileExt(edOutMuxPes.Text, '[01]');
      end else
      begin
        filename   := ChangeFileExt(edOutMuxPes.Text, '');
      end;
    end else
    begin
      filename   := ChangeFileExt(edOutMuxPes.Text, '');
    end;

    if (FileExists( filename + Mgeg2FileExt )  OR
        FileExists( filename + DivXFileExt )) then
    begin
      // find next unused thread entry ...
      k:= GetNextFreeThread;

      m_RecordingThread[k].RecordingData.filename := filename;

      SaveEpgToDb(CheckDbString(ExtractFilename(m_RecordingThread[k].RecordingData.filename)),
                  '',
                  RecordingLoadEpgFile( k, m_RecordingThread[k].RecordingData.filename + EpgFileExt ));

      // Transform the PsStream to DivX ...
      m_RecordingThread[k].TheadState                         := Thread_TransformStart;
      m_RecordingThread[k].pcoTransformThread                 := TTransformThread.Create(true);
      m_RecordingThread[k].pcoTransformThread.FreeOnTerminate := false;
      m_RecordingThread[k].pcoTransformThread.Priority        := tpLower;
      m_RecordingThread[k].pcoTransformThread.SetParams(m_RecordingThread[k].RecordingData);
      m_RecordingThread[k].pcoTransformThread.Resume;

      m_coGoBackTo       := pclMain.ActivePage;
      pclMain.ActivePage := tbsRunning;
      DoEvents;
    end else
    begin
      Beep;
      DoEvents;
      Beep;
      DoEvents;
      Beep;
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnMuxTransformClick '+ E.Message );
  end;
end;
//
//  Handle 'Mux PES' - Page ...
//
////////////////////////////////////////////////////////////////////////////////




procedure TfrmMain.edOutAudioDblClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  try
    FileName := TEdit(Sender).Text;
    Filter := 'mpeg2 audio (*'+AudioFileExt+')|*'+AudioFileExt;
    DefaultExt := 'm2a';
    if Execute then
      TEdit(Sender).Text := FileName;
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//  Handle 'Running'-Page ...
//
procedure TfrmMain.MessageCallback(aSender       : TTeProcessManager;
                                   const aMessage: string);
begin
  try
    DbgMsg(aMessage);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'MessageCallback '+ E.Message );
  end;
end;

{$W+}
procedure TfrmMain.StateCallback(aSender : TTeProcessManager; const aName, aState: string);
var
  i,x           : Integer;
  sTmp          : String;
  RecordingData : T_RecordingData;
begin
  m_Trace.DBMSG(TRACE_ALL, '> StateCallback');
  try
    try
      m_Trace.DBMSG(TRACE_ALL, aName+' = '+aState);
      i := StateList.IndexOf(aName);
      if i < 0 then
      begin
        m_Trace.DBMSG(TRACE_ALL, 'add slot for '+aName);
        i := StateList.AddObject(aName, TStateItem.Create);
        m_Trace.DBMSG(TRACE_ALL, 'add slot finished');
      end;
      m_Trace.DBMSG(TRACE_ALL, 'add state ');
      TStateItem(StateList.Objects[i]).State := aState;
      m_Trace.DBMSG(TRACE_ALL, 'add state finished');
      if aName = 'Muxer' then
      begin
        i := Pos('Syncs:', aState);
        if i > 0 then
        begin
          m_Trace.DBMSG(TRACE_ALL, 'found "Syncs:"');
          RecordingData.cmd:= CMD_VCR_STOP;
          x:= GetMachingThread(RecordingData);
          m_Trace.DBMSG(TRACE_ALL, 'recording thread is '+IntToStr(x));
          sTmp := Copy(aState, i + 6, 3);
          m_RecordingThread[x].RecordingData.iMuxerSyncs := StrToInt(sTmp);
          m_Trace.DBMSG(TRACE_ALL, 'thread syncs now '+IntToStr(m_RecordingThread[x].RecordingData.iMuxerSyncs));
        end;
      end;
      if aState = 'terminated' then
      begin
        m_Trace.DBMSG(TRACE_ALL, 'found "terminated"');
        RecordingData.cmd:= CMD_VCR_STOP;
        x:= GetMachingThread(RecordingData);
        m_Trace.DBMSG(TRACE_ALL, 'recording thread is '+IntToStr(x));
        RecordingStop(m_RecordingThread[x].RecordingData);
        ClearStateList;
        pclMain.ActivePage := m_coGoBackTo;
        DoEvents;
      end;
      m_Trace.DBMSG(TRACE_ALL, '< StateCallback (exit)');
      exit;
    finally
      m_Trace.DBMSG(TRACE_ALL, '< StateCallback (finally)');
    end;
    m_Trace.DBMSG(TRACE_ALL, '< StateCallback (exit)');
    exit;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'StateCallback Error = '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_ALL, '< StateCallback');
end;
{$W-}

procedure TfrmMain.StateTimerTimer(Sender: TObject);
var
  i : Integer;
begin
  try
    lvwState.Items.BeginUpdate;
    try
      for i := 0 to Pred(StateList.Count) do
        with TStateItem(StateList.Objects[i]) do
        begin
          if not Assigned(Item) then
          begin
            Item := lvwState.Items.Add;
            Item.Caption := StateList[i];
          end;
          if Item.SubItems.Count < 1 then
            Item.SubItems.Add(State)
          else
            if not SameText(State, Item.SubItems[0]) then
              Item.SubItems[0] := State;
        end;
    finally
      lvwState.Items.EndUpdate;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'StateTimerTimer '+ E.Message );
  end;
end;

procedure TfrmMain.bnStopClick(Sender: TObject);
var
  RecordingData: T_RecordingData;
  x : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> bnStopClick');
  try
    RecordNowTimer.Enabled := false;
    m_tStopRecordNow := 0;
    if IsDBoxRecording then
    begin
      RecordingData.cmd:= CMD_VCR_STOP;
      GetPids(RecordingData.vpid,
              RecordingData.apids);
      x:= GetMachingThread(RecordingData);
      m_Trace.DBMSG(TRACE_DETAIL, 'StopClick found and stop recording thread[' + IntToStr(x) + ']');
      RecordingStop(m_RecordingThread[x].RecordingData);
      FreeAndNil(m_RecordingThread[x].pcoProcessManager);
      ClearStateList;
    end else
    begin
      for x:=0 to 9 do
      begin
        RecordingStop(m_RecordingThread[x].RecordingData);
        FreeAndNil(m_RecordingThread[x].pcoProcessManager);
      end;
      mmoMessages.Clear;
      m_Trace.DBMSG(TRACE_DETAIL, 'StopClick stops all the threads');
    end;

    pclMain.ActivePage := m_coGoBackTo;
    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'bnStopClick '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< bnStopClick');
end;

procedure TfrmMain.ClearStateList;
var
  i : Integer;
begin
  m_Trace.DBMSG(TRACE_CALLSTACK, '> ClearStateList');
  try
    DoEvents;
    for i := 0 to Pred(StateList.Count) do
    begin
      StateList.Objects[i].Free;
    end;
    FreeAndNil(StateList);
    StateList            := TStringList.Create;
    StateList.Sorted     := true;
    StateList.Duplicates := dupIgnore;
    lvwState.Items.Clear;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'ClearStateList '+ E.Message );
  end;
  m_Trace.DBMSG(TRACE_CALLSTACK, '< ClearStateList');
end;

procedure TfrmMain.tbsRunningShow(Sender: TObject);
begin
  StateTimer.Enabled := True;
end;

procedure TfrmMain.tbsRunningHide(Sender: TObject);
begin
  StateTimer.Enabled := False;
end;
//
//  Handle 'Running'-Page ...
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  VCR - Procedures ...
//
{$I VcrRecord.pas}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Handle 'Mux TS'-Page ...
//
procedure TfrmMain.edInReMuxTsDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := edInReMuxTs.Text;
    Filter := 'mpeg2 transport stream (*.ts)|*.ts';
    DefaultExt := 'ts';
    if Execute then
      edInReMuxTs.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.ReMuxTsStateCallback(aSender            : TTeProcessManager;
                                        const aName, aState: string);
begin
  Application.ProcessMessages;
  if  (aState = 'terminated')
  AND (aName  = 'MuxWriter') then
  begin
    pclMain.ActivePage := m_coGoBackTo;
    edInVideoMuxPesChange(self);
    DoEvents;
  end;
end;

procedure TfrmMain.btnReMuxTsClick(Sender: TObject);
var
  k: Integer;
begin
  try
    if FileExists(edInReMuxTs.Text) then
    begin
      // find next unused thread entry ...
      k:= GetNextFreeThread;
      m_RecordingThread[k].pcoProcessManager := TTeReMuxTsProcessManager.Create(edInReMuxTs.Text,
                                                                                StrToIntEx( edTsVideoPID.Text),
                                                                                [StrToIntEx(edTsAudioPID1.Text),
                                                                                 StrToIntEx(edTsAudioPID2.Text),
                                                                                 StrToIntEx(edTsAudioPID3.Text),
                                                                                 StrToIntEx(edTsAudioPID4.Text)],
                                                                                edOutReMuxTs.Text,
                                                                                SplittSize,
                                                                                MessageCallback,
                                                                                ReMuxTsStateCallback);
      m_coGoBackTo       := pclMain.ActivePage;
      pclMain.ActivePage := tbsRunning;
      DoEvents;
    end else
    begin
      Beep;
      DoEvents;
      Beep;
      DoEvents;
      Beep;
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnReMuxTsClick '+ E.Message );
  end;
end;

procedure TfrmMain.edReMuxTs_DropFilesDropFiles(Sender: TObject);
begin
  try
    if Pos('.TS',UpperCase(edReMuxTs_DropFiles.FileName)) > 0 then
    begin
      edInReMuxTs.Text := edReMuxTs_DropFiles.FileName;
      edInReMuxTsChange(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edReMuxTs_DropFilesDropFiles '+ E.Message );
  end;
end;

procedure TfrmMain.edInReMuxTsChange(Sender: TObject);
begin
  try
    btnReMuxTs.Enabled := FileExists(edInReMuxTs.Text);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edInReMuxTsChange '+ E.Message );
  end;
end;
//
//  Handle 'Mux TS'-Page ...
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  Handle 'Mux PS'-Page ...
//
procedure TfrmMain.edInReMuxPsDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := edInReMuxPs.Text;
    Filter := 'mpeg2 program stream (*'+Mgeg2FileExt+')|*'+Mgeg2FileExt;
    DefaultExt := 'm2p';
    if Execute then
      edInReMuxPs.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edInReMuxPs_DropFilesDropFiles(Sender: TObject);
begin
  try
    if Pos(UpperCase(Mgeg2FileExt),UpperCase(edInReMuxPs_DropFiles.FileName)) > 0 then
    begin
      edInReMuxPs.Text := edInReMuxPs_DropFiles.FileName;
      edInReMuxPsChange(self);
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'edInReMuxPs_DropFilesDropFiles '+ E.Message );
  end;
end;

procedure TfrmMain.edInReMuxPsChange(Sender: TObject);
begin
  try
    btnReMuxPs.Enabled := FileExists(edInReMuxPs.Text);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,' '+ E.Message );
  end;
end;

procedure TfrmMain.ReMuxPsStateCallback(aSender            : TTeProcessManager;
                                        const aName, aState: string);
begin
  try
    Application.ProcessMessages;
    if  (aState = 'terminated')
    AND (aName  = 'MuxWriter') then
    begin
      pclMain.ActivePage := m_coGoBackTo;
      edInVideoMuxPesChange(self);
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnReMuxPsClick '+ E.Message );
  end;
end;

procedure TfrmMain.btnReMuxPsClick(Sender: TObject);
var
  k: Integer;
begin
  try
    if FileExists(edInReMuxPs.Text) then
    begin
      // find next unused thread entry ...
      k:= GetNextFreeThread;
      m_RecordingThread[k].pcoProcessManager := TTeReMuxProcessManager.Create(edInReMuxPs.Text,
                                                                              edOutReMuxPs.Text,
                                                                              SplittSize,
                                                                              MessageCallback,
                                                                              ReMuxPsStateCallback);
    end else
    begin
      Beep;
      DoEvents;
      Beep;
      DoEvents;
      Beep;
      DoEvents;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'btnReMuxPsClick '+ E.Message );
  end;
end;
//
//  Handle 'Mux PS'-Page ...
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TfrmMain.DbgMsg( Msg: String );
var
  sTrace,
  sNow   : String;
begin
  try
    sNow := '';
    DateTimeToString(sNow, 'hh:nn:ss.zzz', Now);
    sTrace := Format('%s %s', [sNow,Msg]);

    SendMessage( mmoMessages.Handle,
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
//
//
procedure TfrmMain.btnWishesSeekDbClick(Sender: TObject);
var
  oldHeight : Integer;
begin
  try
    if not Whishes_DBNavigator.Visible then exit;

    btnWishesSeek.Enabled      := False;
    btnWishesSeekDb.Enabled    := False;
    Whishes_DBNavigator.Visible:= false;
    oldHeight := Whishes_DBGrid.Height;
    Whishes_DBGrid.Height := 0;
    try
      lbl_check_EPG.Caption:= '';
      DoEvents;

      CheckChannelsInDb;

      lbl_check_EPG.Caption:= '';
      DoEvents;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'btnWhishesSeekDbClick '+E.Message);
    end;
    try
      Whishes_ADOQuery.SQL.Clear;
      Whishes_ADOQuery.SQL.Add('SELECT * FROM T_Whishes ORDER BY Titel;');
      Whishes_ADOQuery.ExecSQL;
      Whishes_ADOQuery.Active := true;
      Whishes_DBGrid.Datasource.DataSet := Whishes_ADOQuery;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'StartupTimerTimer/SELECT * T_Whishes '+E.Message);
    end;
  finally
    Whishes_DBGrid.Height      := oldHeight;
    Whishes_DBNavigator.Visible:= true;
    btnWishesSeek.Enabled      := True;
    btnWishesSeekDb.Enabled    := True;
  end;
end;

procedure TfrmMain.btnWishesSeekClick(Sender: TObject);
var
  oldHeight : Integer;
begin
  try
    if not Whishes_DBNavigator.Visible then
    begin
      m_bAbortWishesSeek := true;
      btnWishesSeek.Caption := 'wird abgebrochen';
      DoEvents;
      exit;
    end;

    m_bAbortWishesSeek         := false;
    btnWishesSeek.Caption      := 'Abbrechen';
    btnWishesSeekDb.Enabled    := False;
    Whishes_DBNavigator.Visible:= false;
    oldHeight := Whishes_DBGrid.Height;
    Whishes_DBGrid.Height := 0;
    try
      lbl_check_EPG.Caption:= '';
      DoEvents;

      CheckChannels(chxSwitchChannel.Checked);
      DoEvents;
      CheckChannelsInDb;
      DoEvents;

      lbl_check_EPG.Caption:= '';
      DoEvents;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'btnWishesSeekClick '+E.Message);
    end;
    try
      Whishes_ADOQuery.SQL.Clear;
      Whishes_ADOQuery.SQL.Add('SELECT * FROM T_Whishes ORDER BY Titel;');
      Whishes_ADOQuery.ExecSQL;
      Whishes_ADOQuery.Active := true;
      Whishes_DBGrid.Datasource.DataSet := Whishes_ADOQuery;
    except
      on E: Exception do m_Trace.DBMSG(TRACE_ERROR, 'StartupTimerTimer/SELECT * T_Whishes '+E.Message);
    end;
  finally
    Whishes_DBGrid.Height      := oldHeight;
    Whishes_DBNavigator.Visible:= true;
    btnWishesSeekDb.Enabled    := True;
    btnWishesSeek.Caption      := 'DBox neu lesen';
  end;
end;

procedure TfrmMain.btnRefreshChannelsClick(Sender: TObject);
var
  sTmp      : String;
begin
  RetrieveCurrentChannel(lbxChannelList, sTmp);
  lvChannelProgClick(Sender);
end;

procedure TfrmMain.Recorded_ADOQueryAfterScroll(DataSet: TDataSet);
var
  sTmp    : String;
begin
  try
    if VarIsStr(DataSet.FieldValues['Epg']) then
      sTmp := VarToStrDef(DataSet.FieldValues['Epg'],'kein EPG verfügbar');
    if sTmp = '' then
      sTmp := 'kein EPG verfügbar';
    Recorded_EpgView.LoadFromString(sTmp,'');
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TfrmMain.Record_Planner_UpdateHeaders;
var
  i: Integer;
begin
  try
    Record_Planner.Positions := 5;
    Record_Planner.Header.Captions.Clear;
    Record_Planner.Header.Captions.Add('');
    if Planner_DBDaySource.Active then
    begin
      for i := 1 to Record_Planner.Positions do
      begin
        Record_Planner.Header.Captions.Add(FormatDateTime('DDD dd.mm.yy',Planner_DBDaySource.Day + i - 1 ));
      end;
    end else
    begin
      for i := 1 to Record_Planner.Positions do
      begin
        Record_Planner.Header.Captions.Add(FormatDateTime('DDD dd.mm.yy',Now + i - 1 ));
      end;
    end;
{
    Record_Planner.SelectCells((AHour * 60 + AMinute + 1) div Record_Planner.Display.DisplayUnit,
                               (AHour * 60 + AMinute + 1) div Record_Planner.Display.DisplayUnit,
                                0  ); //Spalte
}
    if Record_Planner.Items.SelCount > 0 then
      Record_Planner.Items.Selected.ScrollInView;

    DoEvents;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TfrmMain.Planner_DBDaySourceFieldsToItem(Sender: TObject;
  Fields: TFields; Item: TPlannerItem);
begin
  try
    { The FieldsToItem event is called when records are read from the database
      and extra properties are set from database fields. With this code, any
      field from the database can be connected in a custom way to planner item
      properties.
     }
    Item.Color := TColor(Fields.FieldByName('COLOR').AsInteger);
    Item.CaptionBkg := Item.Color;
    Item.ImageID := Fields.FieldByName('IMAGE').AsInteger;
    if Fields.FieldByName('CAPTION').AsBoolean then
      Item.CaptionType := ctTime
    else
      Item.CaptionType := ctNone;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;

procedure TfrmMain.Planner_DBDaySourceItemToFields(Sender: TObject;
  Fields: TFields; Item: TPlannerItem);
begin
  try
    { The ItemToFields event is called when items are written to the database
      and extra properties are stored in database fields. With this code, any
      property of the item can be saved into any field of the database in
      a custom way to be retrieved later with the inverse event FieldsToItem
    }
    Fields.FieldByName('COLOR').AsInteger := Integer(Item.Color);
    Fields.FieldByName('CAPTION').AsBoolean := Item.CaptionType = ctTime;
    Fields.FieldByName('IMAGE').AsInteger := Item.ImageID;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR, E.Message);
  end;
end;



procedure TfrmMain.Whishes_ResultDrawItem(Control: TWinControl;
                                          Index  : Integer;
                                          Rect   : TRect;
                                          State  : TOwnerDrawState);
begin
  try
    if not (odSelected in State) then
    begin
      if Index mod 2 = 0 then
        Whishes_Result.Canvas.Brush.Color := clWindow
      else
        Whishes_Result.Canvas.Brush.Color := MidColor(clWindow, MidColor(clWindow, clBtnShadow));
    end;
    if (Index >= 0) and (Index < Whishes_Result.Items.Count) then
    begin
      WriteText(Whishes_Result.Canvas, Rect, 2, 2, Whishes_Result.Items[Index], taLeftJustify, false)
    end else
      Whishes_Result.Canvas.FillRect(Rect);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'Whishes_ResultDrawItem '+ E.Message );
  end;
end;

procedure TfrmMain.mmoMessagesDrawItem(Control: TWinControl;
                                       Index: Integer;
                                       Rect: TRect;
                                       State: TOwnerDrawState);
begin
  try
    if not (odSelected in State) then
    begin
      if Index mod 2 = 0 then
        mmoMessages.Canvas.Brush.Color := clWindow
      else
        mmoMessages.Canvas.Brush.Color := MidColor(clWindow, MidColor(clWindow, clBtnShadow));
    end;
    if (Index >= 0) and (Index < mmoMessages.Items.Count) then
    begin
      WriteText(mmoMessages.Canvas, Rect, 2, 2, mmoMessages.Items[Index], taLeftJustify, false)
    end else
      mmoMessages.Canvas.FillRect(Rect);
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'mmoMessagesDrawItem '+ E.Message );
  end;
end;

procedure TfrmMain.Recorded_Epg_DropFilesDropFiles(Sender: TObject);
var
  sEpg         : TStringList;
  sTmp,
  sEpgTitle,
  sEpgSubTitle : String;
  i : Integer;
begin
  try
    if Pos(UpperCase(EpgFileExt),UpperCase(Recorded_Epg_DropFiles.FileName)) > 0 then
    begin
      sEpg := TStringList.Create;
      try
        sEpg.LoadFromFile(Recorded_Epg_DropFiles.FileName);

        sTmp := sEpg.Text;
        sTmp := Copy( sTmp, Pos('<BODY>',sTmp), Length(sTmp));
        m_Trace.DBMSG(TRACE_DETAIL,'Recorded_Epg_DropFilesDropFiles ['+ Recorded_Epg_DropFiles.FileName + '] = ' + #13#10 + sTmp );
        i:= Pos('<td class=´a´>',LowerCase(sTmp));
        if i <> 0 then
        begin
          sTmp := Copy( sTmp, Pos('<td class=´a´>',LowerCase(sTmp))+14, Length(sTmp));
          sEpgTitle := Trim(Copy( sTmp, 1, Pos('</td>',LowerCase(sTmp))-1));
        end;

        i:= Pos('<b>',LowerCase(sTmp));
        if i <> 0 then
        begin
          sTmp := Copy( sTmp, Pos('<b>',LowerCase(sTmp))+3, Length(sTmp));
          sTmp := Trim(Copy( sTmp, 1, Pos('</b>',LowerCase(sTmp))-1));
          if sTmp <> 'keine ausführlichen Informationen verfügbar' then
          begin
            sEpgSubTitle := sTmp;
          end;
        end;
        sTmp := 'Möchten Sie die Filmbeschreibung von ' + #13#10 + '"' + sEpgTitle + ' - ' + sEpgSubTitle + '"' + #13#10 + 'jetzt in die Datenbank einfügen?';
        if Application.MessageBox(PChar(sTmp), PChar('Frage'), MB_YESNO) = IDYES then
        begin
          SaveEpgToDb(sEpgTitle, sEpgSubTitle, sEpg.Text);
        end;
      finally
        sEpg.free;
      end;
    end;
  except
    on E: Exception do m_Trace.DBMSG(TRACE_ERROR,'Recorded_Epg_DropFilesDropFiles '+ E.Message );
  end;
end;

end.

