unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeControls, ComCtrls, ExtCtrls, TeButtons, TeChannelsReader,
  ActnList, TeFiFo, TeFileStreamThread, TeHTTPStreamThread, JclSynch,
  TeProcessManager, TeGrabManager, TePesParserThread, TePesFiFo, Registry,
  TeSocket, TeComCtrls, Winsock2, IdThreadMgr, IdThreadMgrPool, TePesMuxerThread,
  IdBaseComponent, IdComponent, IdTCPServer, IdHTTPServer, TeSectionParserThread,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmMain = class(TForm)
    aclMain: TActionList;
    acGSStart: TAction;
    TePanel1: TTePanel;
    TePanel2: TTePanel;
    pclMain: TPageControl;
    tbsWelcome: TTabSheet;
    tbsDbox: TTabSheet;
    lblCaption: TLabel;
    gbxSelect: TTeRadioGroup;
    bnNext: TTeBitBtn;
    plDbox: TTePanel;
    gbxChannelList: TTeGroupBox;
    lbxChannelList: TListBox;
    gbxIp: TTeGroupBox;
    edIp: TTeEdit;
    Bevel1: TBevel;
    bnRestart: TTeBitBtn;
    Bevel2: TBevel;
    bnClose: TTeBitBtn;
    tbsOutFiles: TTabSheet;
    plOutFiles: TTePanel;
    gbxVideoOut: TTeGroupBox;
    edOutVideo: TTeEdit;
    gbxOutAudio1: TTeGroupBox;
    edOutAudio1: TTeEdit;
    tbsOutMux: TTabSheet;
    plOutMux: TTePanel;
    gbxOutMux: TTeGroupBox;
    edOutMux: TTeEdit;
    tbsRunning: TTabSheet;
    plRunning: TTePanel;
    gbxMessages: TTeGroupBox;
    mmoMessages: TMemo;
    tbsInFiles: TTabSheet;
    plInFiles: TTePanel;
    gbxInVideo: TTeGroupBox;
    edInVideo: TTeEdit;
    gbxInAudio1: TTeGroupBox;
    edInAudio1: TTeEdit;
    tbsTimer: TTabSheet;
    plTimer: TTePanel;
    gbxTimer: TTeGroupBox;
    chxTimer: TTeCheckBox;
    edTimerStart: TTeEdit;
    edTimerEnd: TTeEdit;
    lblTimerStart: TLabel;
    lblTimerEnd: TLabel;
    Timer: TTimer;
    Button1: TButton;
    gbxSplittOutput: TTeGroupBox;
    Bevel5: TBevel;
    chxSplitting: TCheckBox;
    lblSplitt1: TLabel;
    cbxSplitSize: TComboBox;
    lblSplitt2: TLabel;
    chxKillZap: TTeCheckBox;
    chxAutoZap: TTeCheckBox;
    tbsInMux: TTabSheet;
    plInMux: TTePanel;
    gbxInMux: TTeGroupBox;
    edInMux: TTeEdit;
    plWarningNeedSplitt: TPanel;
    shpWarningNeedSplitt: TShape;
    Label1: TLabel;
    DecommitTimer: TTimer;
    gbxPids: TTeGroupBox;
    edVideoPID: TTeEdit;
    edAudioPID1: TTeEdit;
    Label2: TLabel;
    Label3: TLabel;
    gbxState: TTeGroupBox;
    Bevel6: TBevel;
    lvwState: TListView;
    StateTimer: TTimer;
    chxAudioStripPesHeader1: TTeCheckBox;
    chxVideoStripPesHeader: TTeCheckBox;
    rbnPidHex: TRadioButton;
    rbnPidDezimal: TRadioButton;
    edAudioPID2: TTeEdit;
    edAudioPID3: TTeEdit;
    edAudioPID4: TTeEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    gbxOutAudio4: TTeGroupBox;
    edOutAudio4: TTeEdit;
    chxAudioStripPesHeader4: TTeCheckBox;
    gbxOutAudio3: TTeGroupBox;
    edOutAudio3: TTeEdit;
    chxAudioStripPesHeader3: TTeCheckBox;
    gbxOutAudio2: TTeGroupBox;
    edOutAudio2: TTeEdit;
    chxAudioStripPesHeader2: TTeCheckBox;
    chxKillSectionsd: TTeCheckBox;
    gbxInAudio4: TTeGroupBox;
    edInAudio4: TTeEdit;
    gbxInAudio3: TTeGroupBox;
    edInAudio3: TTeEdit;
    gbxInAudio2: TTeGroupBox;
    edInAudio2: TTeEdit;
    IdHTTPServer: TIdHTTPServer;
    IdThreadMgrPool: TIdThreadMgrPool;
    Label7: TLabel;
    edVideoInOffsetStart: TTeEdit;
    Label8: TLabel;
    Label9: TLabel;
    edVideoInOffsetEnd: TTeEdit;
    Label10: TLabel;
    bnFromBox: TButton;
    bnStop: TTeBitBtn;
    tbsInTs: TTabSheet;
    plInTs: TTePanel;
    gbxTsIn: TTeGroupBox;
    edInTs: TTeEdit;
    Bevel3: TBevel;
    gbxTsPIDs: TTeGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edTsVideoPid: TTeEdit;
    edTsAudioPid1: TTeEdit;
    rbnTsPidHex: TRadioButton;
    rbnTsPidDezimal: TRadioButton;
    edTsAudioPid2: TTeEdit;
    edTsAudioPid3: TTeEdit;
    edTsAudioPid4: TTeEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pclMainChange(Sender: TObject);
    procedure lbxChannelListClick(Sender: TObject);
    procedure lbxChannelListDblClick(Sender: TObject);
    procedure lbxChannelListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure bnNextClick(Sender: TObject);
    procedure bnRestartClick(Sender: TObject);
    procedure bnCloseClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure chxTimerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chxSplittingClick(Sender: TObject);
    procedure chxKillZapClick(Sender: TObject);
    procedure tbsOutMuxShow(Sender: TObject);
    procedure cbxSplitSizeChange(Sender: TObject);
    procedure lblSplitt1Click(Sender: TObject);
    procedure DecommitTimerTimer(Sender: TObject);
    procedure StateTimerTimer(Sender: TObject);
    procedure tbsRunningShow(Sender: TObject);
    procedure tbsRunningHide(Sender: TObject);
    procedure edInAudioDblClick(Sender: TObject);
    procedure edInVideoDblClick(Sender: TObject);
    procedure edInMuxDblClick(Sender: TObject);
    procedure edOutAudioDblClick(Sender: TObject);
    procedure edOutVideoDblClick(Sender: TObject);
    procedure edOutMuxDblClick(Sender: TObject);
    procedure tbsOutFilesShow(Sender: TObject);
    procedure IdHTTPServerCommandGet(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServerCommandOther(Thread: TIdPeerThread;
      const asCommand, asData, asVersion: string);
    procedure bnFromBoxClick(Sender: TObject);
    procedure bnStopClick(Sender: TObject);
    procedure edInTsDblClick(Sender: TObject);
  private
    procedure StateCallback(aSender: TTeProcessManager; const aName, aState: string);
    procedure MessageCallback(aSender: TTeProcessManager; const aMessage: string);
    procedure ClearStateList;
    function getPIDs(var VPid: Word; var APid: Word): Boolean;
  public
    {$IFDEF Neutrino}
    ChannelList: TTeChannelList;
    {$ENDIF}
    StateList: TStringList;
    ProcessManager: TTeProcessManager;
    StartTime: TDateTime;
    EndTime: TDateTime;
    SplittSize: Word;
    LastZap: Integer;
    NumberZap: Boolean;
    {$IFDEF ZapIt}
    ZapItVPid: Word;
    ZapItAPid: Word;
    {$ENDIF}
    {$IFDEF Elite}
    Channel: TChannel;
    {$ENDIF}

    procedure SendZapperCommand(aCmd: Byte; aPrm1, aPrm2: Word; aPrm3: string);
    procedure SendZapperZapCommand(aChannel: Word); overload;
    procedure SendZapperZapCommand(aChannel: string); overload;
    procedure SendZapperDisableCommand;

    procedure SendSectionsCommand(aCmd: Byte; aDataLength: Integer; var aData);
    procedure SendSectionsPauseCommand(aPause: Boolean);

    procedure DoAutoZap;

    procedure InitChannels;
    procedure LoadSettings;
    procedure SaveSettings;

    procedure CheckSplittWarning;
  end;

  TStateItem = class(TObject)
    State: string;
    Item: TListItem;
  end;

var
  frmMain                     : TfrmMain;

implementation

uses
  {QMemory,} Contnrs,
  TimerFrm;

function GetHTTP(aUrl: string): TStringList;
begin
  with TIdHTTP.Create(nil) do try
    Result := TStringList.Create;
    try
      Result.Text := Get(aUrl);
    except
      Result.Free;
      raise;
    end;
  finally
    Free;
  end;
end;

function MidColor(aColor1, aColor2: TColor): TColor;
var
  hColor1                     : TRGBQuad absolute aColor1;
  hColor2                     : TRGBQuad absolute aColor2;
  hResult                     : TRGBQuad absolute Result;
begin
  aColor1 := ColorToRGB(aColor1);
  aColor2 := ColorToRGB(aColor2);
  Result := 0;
  hResult.rgbBlue := (hColor1.rgbBlue + hColor2.rgbBlue) div 2;
  hResult.rgbGreen := (hColor1.rgbGreen + hColor2.rgbGreen) div 2;
  hResult.rgbRed := (hColor1.rgbRed + hColor2.rgbRed) div 2;
end;

{$R *.DFM}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i                           : Integer;
begin
  StateList := TStringList.Create;
  StateList.Sorted := true;
  StateList.Duplicates := dupError;
  LastZap := -1;
  Caption := Application.Title;
  {$IFDEF Neutrino}
  ChannelList := TTeChannelList.Create;
  {$ENDIF}
  {$IFDEF Elite}
  gbxPids.Visible := True;
  {$ELSE}
  gbxChannelList.Visible := True;
  {$ENDIF}
  for i := 0 to Pred(pclMain.PageCount) do
    pclMain.Pages[i].TabVisible := false;
  pclMain.ActivePage := tbsWelcome;
  pclMain.OnChange(pclMain);
  LoadSettings;
  lvwState.DoubleBuffered := true;
  {$IFDEF ZapIt}
  bnFromBox.Visible := True;
  {$ENDIF}
  if FindCmdLineSwitch('DONTPANIC', ['-', '/'], True) then
    _NoMuxerPanic := True;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ClearStateList;
  FreeAndNil(StateList);
  {$IFDEF Neutrino}
  FreeAndNil(ChannelList);
  {$ENDIF}
end;

procedure TfrmMain.pclMainChange(Sender: TObject);
begin
  lblCaption.Caption := pclMain.ActivePage.Caption;
end;

procedure TfrmMain.lbxChannelListClick(Sender: TObject);
begin
  bnNext.Enabled := lbxChannelList.ItemIndex >= 0;
  if bnNext.Enabled then DoAutoZap;
end;

procedure TfrmMain.lbxChannelListDblClick(Sender: TObject);
begin
  {$IFNDEF Elite}
  if lbxChannelList.ItemIndex >= 0 then
    if gbxSelect.ItemIndex = 5 then
      {$IFDEF ZapIt}
      GetHTTP('http://' + edIp.Text + ':80/control/zapto?' + IntToStr(Int64(LongWord(lbxChannelList.Items.Objects[lbxChannelList.itemindex])))).Free
        {$ELSE}
      if NumberZap then
        SendZapperZapCommand(lbxChannelList.ItemIndex + 1)
      else
        SendZapperZapCommand(lbxChannelList.Items[lbxChannelList.ItemIndex])
          {$ENDIF}
    else
      if bnNext.Enabled then
        bnNext.Click;
  {$ENDIF}
end;

procedure TfrmMain.lbxChannelListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  if not (odSelected in State) then
    if Index mod 2 = 0 then
      lbxChannelList.Canvas.Brush.Color := clWindow
    else
      lbxChannelList.Canvas.Brush.Color := MidColor(clWindow, MidColor(clWindow, clBtnShadow));

  {$IFNDEF Elite}
  if (Index >= 0) and (Index < lbxChannelList.Items.Count) then begin
    WriteText(lbxChannelList.Canvas, Rect, 2, 2, lbxChannelList.Items[Index], taLeftJustify, false)
  end else
    {$ENDIF}
    lbxChannelList.Canvas.FillRect(Rect);
end;

function StrToIntEx(aString: string; aAsHex: Boolean): Integer;
begin
  aString := Trim(aString);
  if AnsiUpperCase(Copy(aString, 1, 2)) = '0X' then begin
    Delete(aString, 1, 2);
    aString := '$' + aString;
  end;
  if aAsHex and (Length(aString) > 0) and (aString[1] <> '$') then
    aString := '$' + aString;
  Result := StrToIntDef(aString, 0);
end;

procedure TfrmMain.bnNextClick(Sender: TObject);
begin
  try
    if pclMain.ActivePage = tbsWelcome then begin
      chxKillZap.Visible := true;
      chxKillZap.Top := chxAutoZap.Top + chxAutoZap.Height;
      chxKillSectionsd.Visible := true;
      chxKillSectionsd.Top := chxKillZap.Top + chxKillZap.Height;
      case gbxSelect.ItemIndex of
        0: pclMain.ActivePage := tbsDbox;
        1: pclMain.ActivePage := tbsDbox;
        2: pclMain.ActivePage := tbsInFiles;
        3: pclMain.ActivePage := tbsInTs;
        4: pclMain.ActivePage := tbsInMux;
        {$IFNDEF Elite}
        5: begin
            chxKillZap.Visible := false;
            chxKillSectionsd.Visible := false;
            bnNext.Visible := false;
            bnStop.Visible := true;
            pclMain.ActivePage := tbsDbox;
          end;
        {$ENDIF}
        6: pclMain.ActivePage := tbsInFiles;
      else
        ShowMessage('Sorry! not implemented yet...');
      end;
    end else if pclMain.ActivePage = tbsDbox then begin
      {$IFDEF ZapIt}
      with GetHTTP('http://' + edIp.Text + ':80/control/zapto?getpids') do try
        if Count <> 2 then
          raise Exception.Create('unexpected answer from dbox');
        ZapItVPid := StrToInt(Strings[0]);
        ZapItAPid := StrToInt(Strings[1]);
      finally
        Free;
      end;
      {$ENDIF}
      case gbxSelect.ItemIndex of
        0: pclMain.ActivePage := tbsOutFiles;
        1: pclMain.ActivePage := tbsOutMux;
      else
        ShowMessage('Sorry! not implemented yet...');
      end;
    end else if pclMain.ActivePage = tbsInFiles then begin
      case gbxSelect.ItemIndex of
        2: pclMain.ActivePage := tbsOutMux;
        6: pclMain.ActivePage := tbsRunning;
      end;
    end else if pclMain.ActivePage = tbsInMux then begin
      pclMain.ActivePage := tbsOutMux;
    end else if pclMain.ActivePage = tbsInTs then begin
      case gbxSelect.ItemIndex of
        //0: pclMain.ActivePage := tbsOutFiles;
        3: pclMain.ActivePage := tbsOutMux;
      else
        ShowMessage('Sorry! not implemented yet...');
      end;
    end else if pclMain.ActivePage = tbsOutFiles then begin
      pclMain.ActivePage := tbsTimer;
    end else if pclMain.ActivePage = tbsOutMux then begin
      if chxSplitting.Checked and (cbxSplitSize.Text <> '') then
        SplittSize := StrToInt(cbxSplitSize.Text)
      else
        SplittSize := 0;
      case gbxSelect.ItemIndex of
        0: pclMain.ActivePage := tbsTimer;
        1: pclMain.ActivePage := tbsTimer;
      else
        pclMain.ActivePage := tbsRunning;
      end;
    end else if pclMain.ActivePage = tbsTimer then begin
      if chxTimer.Checked then begin
        StartTime := StrToTime(edTimerStart.Text);
        EndTime := StrToTime(edTimerEnd.Text);
        if EndTime < StartTime then
          EndTime := EndTime + 1;
        StartTime := StartTime + Date;
        EndTime := EndTime + Date;
        if StartTime < Now then begin
          StartTime := StartTime + 1;
          EndTime := EndTime + 1;
        end;
        if not TimerWaitUntil(StartTime) then
          Exit;
        Timer.Enabled := true;
      end;
      pclMain.ActivePage := tbsRunning;
    end;

    pclMain.OnChange(pclMain);
    if pclMain.ActivePage = tbsDBox then begin
      DoAutoZap;
    end else if pclMain.ActivePage = tbsRunning then begin
      bnNext.Visible := false;
      bnStop.Visible := true;
      SaveSettings;
      {$IFNDEF Elite}
      if gbxSelect.ItemIndex <> 6 then begin
        if (chxKillZap.Checked) and (gbxSelect.ItemIndex in [0, 1]) then try
          SendZapperDisableCommand;
          Sleep(100);
        except
          Application.HandleException(Self);
        end;
        if (chxKillSectionsd.Checked) and (gbxSelect.ItemIndex in [0, 1]) then try
          SendSectionsPauseCommand(True);
          Sleep(100);
        except
          Application.HandleException(Self);
        end;
      end;
      {$ENDIF}
      lvwState.Items.Clear;
      ClearStateList;

      mmoMessages.Clear;
      case gbxSelect.ItemIndex of
        {$IFDEF Neutrino}
        0: ProcessManager := TTeDirectGrabManager.Create(edIp.Text, ntohs(PChannel(ChannelList[lbxChannelList.ItemIndex]).usVPID), [ntohs(PChannel(ChannelList[lbxChannelList.ItemIndex]).usAPID)], edOutVideo.Text, [edOutAudio1.Text], chxVideoStripPesHeader.Checked, [chxAudioStripPesHeader1.Checked], MessageCallback, StateCallback);
        1: ProcessManager := TTeMuxGrabManager.Create(edIp.Text, ntohs(PChannel(ChannelList[lbxChannelList.ItemIndex])^.usVPID), [ntohs(PChannel(ChannelList[lbxChannelList.ItemIndex]).usAPID)], edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        {$ENDIF}
        {$IFDEF ZapIt}
        0: ProcessManager := TTeDirectGrabManager.Create(edIp.Text, ZapItVPid, [ZapItAPid], edOutVideo.Text, [edOutAudio1.Text], chxVideoStripPesHeader.Checked, [chxAudioStripPesHeader1.Checked], MessageCallback, StateCallback);
        1: ProcessManager := TTeMuxGrabManager.Create(edIp.Text, ZapItVPid, [ZapItAPid], edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        {$ENDIF}
        {$IFDEF Elite}
        0: ProcessManager := TTeDirectGrabManager.Create(edIp.Text, StrToIntEx(edVideoPID.Text, rbnPidHex.Checked), [StrToIntEx(edAudioPID1.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID2.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID3.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID4.Text, rbnPidHex.Checked)], edOutVideo.Text, [edOutAudio1.Text, edOutAudio2.Text, edOutAudio3.Text, edOutAudio4.Text], chxVideoStripPesHeader.Checked, [chxAudioStripPesHeader1.Checked, chxAudioStripPesHeader2.Checked, chxAudioStripPesHeader3.Checked, chxAudioStripPesHeader4.Checked], MessageCallback, StateCallback);
        1: ProcessManager := TTeMuxGrabManager.Create(edIp.Text, StrToIntEx(edVideoPID.Text, rbnPidHex.Checked), [StrToIntEx(edAudioPID1.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID2.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID3.Text, rbnPidHex.Checked), StrToIntEx(edAudioPID4.Text, rbnPidHex.Checked)], edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        {$ENDIF}
        2: ProcessManager := TTeMuxProcessManager.Create(edInVideo.Text, StrToIntDef(edVideoInOffsetStart.Text, -1), StrToIntDef(edVideoInOffsetEnd.Text, -1), [edInAudio1.Text, edInAudio2.Text, edInAudio3.Text, edInAudio4.Text], edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        3: ProcessManager := TTeReMuxTsProcessManager.Create(edInTs.Text, StrToIntEx(edTsVideoPID.Text, rbnTsPidHex.Checked), [StrToIntEx(edTsAudioPID1.Text, rbnTsPidHex.Checked), StrToIntEx(edTsAudioPID2.Text, rbnTsPidHex.Checked), StrToIntEx(edTsAudioPID3.Text, rbnTsPidHex.Checked), StrToIntEx(edTsAudioPID4.Text, rbnTsPidHex.Checked)], edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        4: ProcessManager := TTeReMuxProcessManager.Create(edInMux.Text, edOutMux.Text, SplittSize, MessageCallback, StateCallback);
        6: ProcessManager := TTeSendPesManager.Create(edIp.Text, 40000, 40001, edInVideo.Text, edInAudio1.Text, MessageCallback, StateCallback);
      else
        ShowMessage('Sorry! not implemented yet...');
      end;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TfrmMain.bnRestartClick(Sender: TObject);
begin
  bnNext.Visible := true;
  bnStop.Visible := False;
  FreeAndNil(ProcessManager);
  pclMain.ActivePage := tbsWelcome;
  pclMain.OnChange(pclMain);
end;

procedure TfrmMain.bnCloseClick(Sender: TObject);
begin
  FreeAndNil(ProcessManager);
  Close;
end;

procedure TfrmMain.FormHide(Sender: TObject);
begin
  FreeAndNil(ProcessManager);
end;

procedure TfrmMain.chxTimerClick(Sender: TObject);
begin
  if chxTimer.Checked then begin
    lblTimerStart.Enabled := true;
    lblTimerEnd.Enabled := true;
    edTimerStart.Enabled := true;
    edTimerEnd.Enabled := true;
    edTimerStart.Color := clWindow;
    edTimerEnd.Color := clWindow;
  end else begin
    lblTimerStart.Enabled := false;
    lblTimerEnd.Enabled := false;
    edTimerStart.Enabled := false;
    edTimerEnd.Enabled := false;
    edTimerStart.Text := '';
    edTimerEnd.Text := '';
    edTimerStart.ParentColor := true;
    edTimerEnd.ParentColor := True;
  end;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  if chxTimer.Checked and (Now > EndTime) then begin
    Timer.Enabled := false;
    FreeAndNil(ProcessManager);
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
//var
//  RawFiFo                     : TTeFiFoBuffer;
//var
//  FCaller                     : TCaller;
//  FFunction                   : TFunction;
//  FResult                     : TResult;
var
  p                           : PInteger;
  i                           : Integer;
begin
  //  FCaller := TCaller.Create;
  //  FFunction := TFunction.Create;
  //  //FCaller.DebugOutMemo := Memo2;
  //  //FCaller.DebugInMemo := Memo1;
  //  FCaller.EndPoint := '/RPC';
  //  FCaller.HostName := '192.168.40.4';
  //  FCaller.HostPort := 7575;
  //
  //  {calling a method that accepts a single boolean and returns a single boolean}
  //
  //  FFunction.ObjectMethod := 'test.testd';
  //  FFunction.AddParam(1);
  //  FFunction.AddParam(10);
  //  FResult := FCaller.Execute(FFunction);
  //  //  RawFiFo := TTeFiFoBuffer.Create(1024000, 0, 0, 1000);
  //  //  TTeHTTPSecStreamThread.Create(nil, tpTimeCritical, edIp.Text, 31340, $12, $50, $50, RawFiFo);
  //  //  TTeSectionParserThread.Create(nil, tpNormal, RawFiFo);
end;

procedure TfrmMain.LoadSettings;
var
  i                           : Integer;
begin
  with TRegistryIniFile.Create('Software') do try
    edIp.Text := ReadString('WinGrab', 'IP', '192.168.40.4');
    {$IFNDEF Elite}
    i := lbxChannelList.Items.IndexOf(ReadString('WinGrab', 'Channel', ''));
    if (i < 0) and (lbxChannelList.Items.Count > 0) then
      i := 0;
    lbxChannelList.ItemIndex := i;
    {$ENDIF}

    {$IFDEF Elite}
    edAudioPID1.Text := ReadString('WinGrab', 'AudioPID1', '');
    edAudioPID2.Text := ReadString('WinGrab', 'AudioPID2', '');
    edAudioPID3.Text := ReadString('WinGrab', 'AudioPID3', '');
    edAudioPID4.Text := ReadString('WinGrab', 'AudioPID4', '');
    edVideoPID.Text := ReadString('WinGrab', 'VideoPID', '');
    rbnPidHex.Checked := ReadBool('WinGrab', 'PIDHex', False);
    rbnPidDezimal.Checked := not rbnPidHex.Checked;
    {$ENDIF}

    edInAudio1.Text := ReadString('WinGrab', 'InputAudio1', 'c:\in.m2a');
    edInAudio2.Text := ReadString('WinGrab', 'InputAudio2', '');
    edInAudio3.Text := ReadString('WinGrab', 'InputAudio3', '');
    edInAudio4.Text := ReadString('WinGrab', 'InputAudio4', '');
    edInVideo.Text := ReadString('WinGrab', 'InputVideo', 'c:\in.m2v');

    edVideoInOffsetStart.Text := ReadString('WinGrab', 'InputVideoOffsetStart', '');
    edVideoInOffsetEnd.Text := ReadString('WinGrab', 'InputVideoOffsetEnd', '');

    edOutAudio1.Text := ReadString('WinGrab', 'OutputAudio1', 'c:\out.m2a');
    edOutAudio2.Text := ReadString('WinGrab', 'OutputAudio2', '');
    edOutAudio3.Text := ReadString('WinGrab', 'OutputAudio3', '');
    edOutAudio4.Text := ReadString('WinGrab', 'OutputAudio4', '');
    edOutVideo.Text := ReadString('WinGrab', 'OutputVideo', 'c:\out.m2v');
    chxAudioStripPesHeader1.Checked := ReadBool('WinGrab', 'OutputStripAudioPesHeader1', False);
    chxAudioStripPesHeader2.Checked := ReadBool('WinGrab', 'OutputStripAudioPesHeader2', False);
    chxAudioStripPesHeader3.Checked := ReadBool('WinGrab', 'OutputStripAudioPesHeader3', False);
    chxAudioStripPesHeader4.Checked := ReadBool('WinGrab', 'OutputStripAudioPesHeader4', False);
    chxVideoStripPesHeader.Checked := ReadBool('WinGrab', 'OutputStripVideoPesHeader', False);

    edInMux.Text := ReadString('WinGrab', 'InputMux', 'c:\in.m2p');
    edOutMux.Text := ReadString('WinGrab', 'OutputMux', 'c:\out.m2p');

    edInTs.Text := ReadString('WinGrab', 'InputTs', 'c:\in.ts');
    edTsAudioPID1.Text := ReadString('WinGrab', 'TsAudioPID1', '');
    edTsAudioPID2.Text := ReadString('WinGrab', 'TsAudioPID2', '');
    edTsAudioPID3.Text := ReadString('WinGrab', 'TsAudioPID3', '');
    edTsAudioPID4.Text := ReadString('WinGrab', 'TsAudioPID4', '');
    edTsVideoPID.Text := ReadString('WinGrab', 'TsVideoPID', '');
    rbnTsPidHex.Checked := ReadBool('WinGrab', 'TsPIDHex', False);
    rbnTsPidDezimal.Checked := not rbnTsPidHex.Checked;

    cbxSplitSize.Text := ReadString('WinGrab', 'SplittSize', '');
    chxSplitting.Checked := cbxSplitSize.Text <> '';
    chxSplitting.OnClick(chxSplitting);
    i := cbxSplitSize.Items.IndexOf(cbxSplitSize.Text);
    if i >= 0 then
      cbxSplitSize.ItemIndex := i;

    {$IFNDEF Elite}
    chxAutoZap.Checked := ReadBool('WinGrab', 'AutoZap', false);
    chxKillZap.Checked := ReadBool('WinGrab', 'KillZap', false);
    chxKillSectionsd.Checked := ReadBool('WinGrab', 'KillSectionsd', false);
    {$ENDIF}

    NumberZap := ReadBool('WinGrab', 'NumberZap', false);
  finally
    Free;
  end;
end;

procedure TfrmMain.SaveSettings;
{$IFNDEF Elite}
var
  i                           : Integer;
  {$ENDIF}
begin
  with TRegistryIniFile.Create('Software') do try
    WriteString('WinGrab', 'IP', edIp.Text);

    {$IFNDEF Elite}
    i := lbxChannelList.ItemIndex;
    if i >= 0 then
      WriteString('WinGrab', 'Channel', lbxChannelList.Items[i])
    else
      WriteString('WinGrab', 'Channel', '');
    {$ENDIF}

    {$IFDEF Elite}
    WriteString('WinGrab', 'AudioPID1', edAudioPID1.Text);
    WriteString('WinGrab', 'AudioPID2', edAudioPID2.Text);
    WriteString('WinGrab', 'AudioPID3', edAudioPID3.Text);
    WriteString('WinGrab', 'AudioPID4', edAudioPID4.Text);
    WriteString('WinGrab', 'VideoPID', edVideoPID.Text);
    WriteBool('WinGrab', 'PIDHex', rbnPidHex.Checked);
    {$ENDIF}

    WriteString('WinGrab', 'InputAudio1', edInAudio1.Text);
    WriteString('WinGrab', 'InputAudio2', edInAudio2.Text);
    WriteString('WinGrab', 'InputAudio3', edInAudio3.Text);
    WriteString('WinGrab', 'InputAudio4', edInAudio4.Text);
    WriteString('WinGrab', 'InputVideo', edInVideo.Text);

    WriteString('WinGrab', 'InputVideoOffsetStart', edVideoInOffsetStart.Text);
    WriteString('WinGrab', 'InputVideoOffsetEnd', edVideoInOffsetEnd.Text);

    WriteString('WinGrab', 'OutputAudio1', edOutAudio1.Text);
    WriteString('WinGrab', 'OutputAudio2', edOutAudio2.Text);
    WriteString('WinGrab', 'OutputAudio3', edOutAudio3.Text);
    WriteString('WinGrab', 'OutputAudio4', edOutAudio4.Text);
    WriteString('WinGrab', 'OutputVideo', edOutVideo.Text);
    WriteBool('WinGrab', 'OutputStripAudioPesHeader1', chxAudioStripPesHeader1.Checked);
    WriteBool('WinGrab', 'OutputStripAudioPesHeader2', chxAudioStripPesHeader2.Checked);
    WriteBool('WinGrab', 'OutputStripAudioPesHeader3', chxAudioStripPesHeader3.Checked);
    WriteBool('WinGrab', 'OutputStripAudioPesHeader4', chxAudioStripPesHeader4.Checked);
    WriteBool('WinGrab', 'OutputStripVideoPesHeader', chxVideoStripPesHeader.Checked);

    WriteString('WinGrab', 'InputMux', edInMux.Text);
    WriteString('WinGrab', 'OutputMux', edOutMux.Text);

    WriteString('WinGrab', 'InputTs', edInTs.Text);
    WriteString('WinGrab', 'TsAudioPID1', edTsAudioPID1.Text);
    WriteString('WinGrab', 'TsAudioPID2', edTsAudioPID2.Text);
    WriteString('WinGrab', 'TsAudioPID3', edTsAudioPID3.Text);
    WriteString('WinGrab', 'TsAudioPID4', edTsAudioPID4.Text);
    WriteString('WinGrab', 'TsVideoPID', edTsVideoPID.Text);
    WriteBool('WinGrab', 'TsPIDHex', rbnTsPidHex.Checked);

    if chxSplitting.Checked then
      WriteString('WinGrab', 'SplittSize', cbxSplitSize.Text)
    else
      WriteString('WinGrab', 'SplittSize', '');

    {$IFNDEF Elite}
    WriteBool('WinGrab', 'AutoZap', chxAutoZap.Checked);
    WriteBool('WinGrab', 'KillZap', chxKillZap.Checked);
    WriteBool('WinGrab', 'KillSectionsd', chxKillSectionsd.Checked);
    {$ENDIF}
  finally
    Free;
  end;
end;

procedure TfrmMain.InitChannels;
{$IFDEF Neutrino}
var
  i                           : Integer;
  {$ENDIF}
begin
  {$IFDEF Neutrino}
  if ChannelList.Count = 0 then

    ChannelList.ReadFromFile('channels.bin');

  for i := 0 to Pred(ChannelList.Count) do
    lbxChannelList.Items.AddObject(PChannel(ChannelList.Items[i])^.szName, TObject(i));
  if (lbxChannelList.ItemIndex < 0) and (ChannelList.Count > 0) then
    lbxChannelList.ItemIndex := 0;

  {$ENDIF}
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  InitChannels;
  LoadSettings;
  IdHTTPServer.Active := True;
end;

procedure TfrmMain.chxSplittingClick(Sender: TObject);
begin
  if chxSplitting.Checked then begin
    cbxSplitSize.Enabled := true;
    cbxSplitSize.Color := clWindow;
    lblSplitt1.Enabled := true;
    lblSplitt2.Enabled := true;
  end else begin
    cbxSplitSize.Text := '';
    cbxSplitSize.Enabled := false;
    cbxSplitSize.ParentColor := true;
    lblSplitt1.Enabled := false;
    lblSplitt2.Enabled := false;
  end;
  CheckSplittWarning;
end;

procedure TfrmMain.SendZapperZapCommand(aChannel: Word);
begin
  SendZapperCommand(1, aChannel, 0, '');
end;

procedure TfrmMain.SendZapperDisableCommand;
begin
  LastZap := -1;
  {$IFDEF ZapIt}
  GetHTTP('http://' + edIp.Text + ':80/control/zapto?stopplayback').Free
    {$ELSE}
  SendZapperCommand(2, 0, 0, '');
  {$ENDIF}
end;

procedure TfrmMain.SendZapperCommand(aCmd: Byte; aPrm1, aPrm2: Word; aPrm3: string);
var
  Socket                      : TTeClientSocket;
  answer                      : array[0..3] of char;
  Message                     : packed record
    Ver: Byte;
    Cmd: Byte;
    Prm1: Word;
    Prm2: Word;
    Prm3: array[0..29] of Char;
  end;
begin
  aPrm3 := TrimRight(aPrm3);
  if Length(aPrm3) > 29 then
    SetLength(aPrm3, 29);

  with Message do begin
    Ver := 1;
    Cmd := aCmd;
    Prm1 := aPrm1;
    Prm2 := aPrm2;
    FillChar(Prm3, SizeOf(Prm3), 0);
    StrPCopy(Prm3, aPrm3);
  end;

  Socket := TTeClientSocket.Create;
  try
    Socket.Host := edIP.Text;
    {$IFNDEF ZapIt}
    Socket.Port := 1500;
    {$ENDIF}
    {$IFDEF ZapIt}
    Socket.Port := 1505;
    {$ENDIF}
    Socket.Active := true;
    with TTeWinSocketStream.Create(Socket.Socket, 5000) do try
      WriteBuffer(Message, SizeOf(Message));
      {$IFDEF ZapIt}
      ReadBuffer(answer, 3);
      answer[3] := #0;
      {$ENDIF}
    finally
      Free;
    end;
  except
    FreeAndNil(Socket);
    raise;
  end;
end;

procedure TfrmMain.DoAutoZap;
var
  VPid, APid                  : Word;
begin
  {$IFNDEF Elite}
  if not chxAutoZap.Checked then
    Exit;
  if not IsWindowVisible(chxAutoZap.Handle) then
    Exit;
  if (lbxChannelList.ItemIndex < 0) or (lbxChannelList.ItemIndex = LastZap) then
    Exit;
  try
    {$IFDEF ZapIt}
    GetHTTP('http://' + edIp.Text + ':80/control/zapto?' + IntToStr(Int64(LongWord(lbxChannelList.Items.Objects[lbxChannelList.itemindex])))).Free;
    {$ELSE}
    if NumberZap then
      SendZapperZapCommand(lbxChannelList.ItemIndex + 1)
    else
      SendZapperZapCommand(lbxChannelList.Items[lbxChannelList.ItemIndex]);
    {$ENDIF}
    LastZap := lbxChannelList.ItemIndex;
  except
    LastZap := -1;
    chxAutoZap.Checked := false;
    raise;
  end;
  {$ENDIF}
end;

function TfrmMain.getPIDs(var VPid: Word; var APid: Word): Boolean;
var
  Message                     : packed record
    Ver: Byte;
    Cmd: Byte;
    Prm1: Word;
    Prm2: Word;
    Prm3: array[0..29] of Char;
  end;
  Socket                      : TTeClientSocket;
  buffer                      : array[0..3] of Char;

begin
  with Message do begin
    Ver := 1;
    Cmd := byte('b');
    Prm1 := 0;
    Prm2 := 0;
    FillChar(Prm3, SizeOf(Prm3), 0);
  end;

  result := false;
  Socket := TTeClientSocket.Create;
  try
    Socket.Host := edIP.Text;
    Socket.Port := 1505;
    Socket.Active := true;
    with TTeWinSocketStream.Create(Socket.Socket, 5000) do try
      WriteBuffer(Message, SizeOf(Message));
      ReadBuffer(Buffer, 3);
      if Buffer[0] <> '-' then begin
        result := True;
        ReadBuffer(VPId, sizeof(VPid));
        ReadBuffer(APId, sizeof(APid));
      end;
    finally
      Free;
    end;
  except
    FreeAndNil(Socket);
    raise;
  end;
end;

procedure TfrmMain.chxKillZapClick(Sender: TObject);
begin
  DoAutoZap;
end;

procedure TfrmMain.tbsOutMuxShow(Sender: TObject);
begin
  shpWarningNeedSplitt.Pen.Color := MidColor(clInfoBk, clBtnShadow);
  CheckSplittWarning;
end;

procedure TfrmMain.cbxSplitSizeChange(Sender: TObject);
begin
  CheckSplittWarning;
end;

procedure TfrmMain.CheckSplittWarning;
begin
  plWarningNeedSplitt.Visible := not chxSplitting.Checked or (StrToIntDef(cbxSplitSize.Text, 1000) > 999);
end;

procedure TfrmMain.lblSplitt1Click(Sender: TObject);
begin
  chxSplitting.Checked := not chxSplitting.Checked;
end;

procedure TfrmMain.SendZapperZapCommand(aChannel: string);
begin
  SendZapperCommand(3, 1, 0, aChannel);
end;

procedure TfrmMain.DecommitTimerTimer(Sender: TObject);
begin
  //QMemDecommitOverstock;
end;

procedure TfrmMain.StateCallback(aSender: TTeProcessManager; const aName, aState: string);
var
  i                           : Integer;
begin
  i := StateList.IndexOf(aName);
  if i < 0 then
    i := StateList.AddObject(aName, TStateItem.Create);
  TStateItem(StateList.Objects[i]).State := aState;
end;

procedure TfrmMain.ClearStateList;
var
  i                           : Integer;
begin
  for i := 0 to Pred(StateList.Count) do
    StateList.Objects[i].Free;
  StateList.Clear;
end;

procedure TfrmMain.StateTimerTimer(Sender: TObject);
var
  i                           : Integer;
begin
  lvwState.Items.BeginUpdate;
  try
    for i := 0 to Pred(StateList.Count) do
      with TStateItem(StateList.Objects[i]) do begin
        if not Assigned(Item) then begin
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
end;

procedure TfrmMain.tbsRunningShow(Sender: TObject);
begin
  StateTimer.Enabled := True;
end;

procedure TfrmMain.tbsRunningHide(Sender: TObject);
begin
  StateTimer.Enabled := False;
end;

procedure TfrmMain.edInAudioDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do try
    FileName := TEdit(Sender).Text;
    Filter := 'mpeg2 audio (*.m2a)|*.m2a';
    DefaultExt := 'm2a';
    if Execute then
      TEdit(Sender).Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edInVideoDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do try
    FileName := edInVideo.Text;
    Filter := 'mpeg2 video (*.m2v)|*.m2v';
    DefaultExt := 'm2v';
    if Execute then
      edInVideo.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edInMuxDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do try
    FileName := edInMux.Text;
    Filter := 'mpeg2 program stream (*.m2p;*.vob)|*.m2p;*.vob';
    DefaultExt := 'm2p';
    if Execute then
      edInMux.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edOutAudioDblClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do try
    FileName := TEdit(Sender).Text;
    Filter := 'mpeg2 audio (*.m2a)|*.m2a';
    DefaultExt := 'm2a';
    if Execute then
      TEdit(Sender).Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edOutVideoDblClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do try
    FileName := edOutVideo.Text;
    Filter := 'mpeg2 video (*.m2v)|*.m2v';
    DefaultExt := 'm2v';
    if Execute then
      edOutVideo.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.edOutMuxDblClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do try
    FileName := edOutMux.Text;
    Filter := 'mpeg2 program stream (*.m2p;*.vob)|*.m2p;*.vob';
    DefaultExt := 'm2p';
    if Execute then
      edOutMux.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmMain.tbsOutFilesShow(Sender: TObject);
begin
  {$IFDEF Elite}
  gbxOutAudio1.Visible := Trim(edAudioPID1.Text) <> '';
  gbxOutAudio2.Visible := Trim(edAudioPID2.Text) <> '';
  gbxOutAudio3.Visible := Trim(edAudioPID3.Text) <> '';
  gbxOutAudio4.Visible := Trim(edAudioPID4.Text) <> '';
  gbxVideoOut.Visible := Trim(edVideoPID.Text) <> '';
  {$ENDIF}
  {$IFDEF Neutrino}
  gbxOutAudio1.Visible := PChannel(ChannelList[lbxChannelList.ItemIndex]).usAPID <> 0;
  gbxOutAudio2.Visible := False;
  gbxOutAudio3.Visible := False;
  gbxOutAudio4.Visible := False;
  gbxVideoOut.Visible := PChannel(ChannelList[lbxChannelList.ItemIndex]).usVPID <> 0;
  {$ENDIF}
  //...
end;

procedure TfrmMain.SendSectionsCommand(aCmd: Byte; aDataLength: Integer;
  var aData);
var
  Socket                      : TTeClientSocket;
  Message                     : packed record
    Ver: Byte;
    Cmd: Byte;
    DataLength: Word;
    Data: array[0..1024] of Byte;
  end;
begin
  FillChar(Message, SizeOf(Message), 0);

  with Message do begin
    Ver := 2;
    Cmd := aCmd;
    DataLength := ntohs(aDataLength);
    if aDataLength > 0 then
      Move(aData, Data, aDataLength);
  end;

  Socket := TTeClientSocket.Create;
  try
    Socket.Host := edIP.Text;
    Socket.Port := 1600;
    Socket.Active := true;
    with TTeWinSocketStream.Create(Socket.Socket, 5000) do try
      WriteBuffer(Message, 4 + aDataLength);
    finally
      Free;
    end;
  except
    FreeAndNil(Socket);
    raise;
  end;
end;

procedure TfrmMain.SendSectionsPauseCommand(aPause: Boolean);
var
  i                           : Integer;
begin
  {$IFDEF ZapIt}
  if aPause then
    GetHTTP('http://' + edIp.Text + ':80/control/zapto?stopsectionsd').Free
  else
    GetHTTP('http://' + edIp.Text + ':80/control/zapto?startsectionsd').Free
      {$ELSE}
  if aPause then
    i := $01000000
  else
    i := 0;
  SendSectionsCommand(11, SizeOf(i), i);
  {$ENDIF}
end;

procedure TfrmMain.IdHTTPServerCommandGet(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  Beep;
end;

type
  TIdHTTPResponseInfoHack = class(TIdHTTPResponseInfo);

procedure TfrmMain.IdHTTPServerCommandOther(Thread: TIdPeerThread;
  const asCommand, asData, asVersion: string);
var
  LResponseInfo               : TIdHTTPResponseInfoHack;
  FileStream                  : TFileStream;
  BytesRead                   : Integer;
  Buffer                      : array[Word] of Byte;
  i                           : Integer;
  Output                      : TTeBufferPage;
  OutputStream                : TTeFiFoBuffer;
begin
  LResponseInfo := TIdHTTPResponseInfoHack(TIdHTTPResponseInfo.Create(Thread.Connection));
  try
    _OutputStreamLock.Enter;
    try
      LResponseInfo.RawHeaders.Values['Server'] := Application.Title;
      LResponseInfo.RawHeaders.Values['Content-Length'] := IntToStr(High(Integer));
      LResponseInfo.RawHeaders.Values['Connection'] := 'close';
      LResponseInfo.RawHeaders.Values['Content-Type'] := 'video/mpeg';
      LResponseInfo.ContentType := 'video/mpeg';

      LResponseInfo.FServerSoftware := Application.Title;
      if not LResponseInfo.HeaderHasBeenWritten then begin
        LResponseInfo.WriteHeader;
      end;

      if LResponseInfo.FResponseNo = 404 then
        exit;

      OutputStream := TTeFiFoBuffer.Create(0, 0, 250);
      if not assigned(_OutputStream) then
        _OutputStream := TObjectList.Create;
      _OutputStream.Add(OutputStream);
    finally
      _OutputStreamLock.Leave;
    end;
    try

      i := 0;
      repeat
        Output := OutputStream.GetReadPage(False);

        if Output = nil then begin
          Sleep(100);
          Inc(i);
        end else try
          with LResponseInfo.FConnection do begin
            WriteBuffer(Output.Memory^, Output.Size);
            i := 0;
          end;
        finally
          Output.Finished;
        end;
      until i = 100;

    finally
      _OutputStreamLock.Enter;
      try
        if Assigned(_OutputStream) then begin
          _OutputStream.Remove(OutputStream);
          if _OutputStream.Count < 1 then
            FreeAndNil(_OutputStream);
        end;
      finally
        _OutputStreamLock.Leave;
      end;
      FreeAndNil(OutputStream);
    end;
  finally
    LResponseInfo.Free;
  end;
end;

procedure TfrmMain.bnFromBoxClick(Sender: TObject);
{$IFDEF ZapIt}
var
  i, j                        : Integer;
  k                           : Int64;
  s, t                        : string;
  {$ENDIF}
begin
  {$IFDEF ZapIt}
  lbxChannelList.Items.clear;
  with GetHTTP('http://' + edIp.Text + ':80/control/channellist') do try
    for i := 0 to Pred(Count) do begin
      s := Strings[i];
      j := Pos(' ', s);
      if j > 0 then begin
        t := Copy(s, 1, j - 1);
        System.Delete(s, 1, j);
        k := StrToInt64(t);
        lbxChannelList.Items.AddObject(s, TObject(LongWord(k)));
      end;
    end;
  finally
    Free;
  end;
  try
    with GetHTTP('http://' + edIp.Text + ':80/control/zapto') do try
      if Count = 1 then begin
        k := StrToInt64('$' + Strings[0]);
        i := lbxChannelList.Items.IndexOfObject(TObject(LongWord(k)));
        if i >= 0 then
          lbxChannelList.ItemIndex := i;
      end;
    finally
      Free;
    end;
  except
  end;
  {$ENDIF}
end;

procedure TfrmMain.bnStopClick(Sender: TObject);
begin
  FreeAndNil(ProcessManager);
end;

procedure TfrmMain.MessageCallback(aSender: TTeProcessManager;
  const aMessage: string);
var
  s                           : string;
begin
  s := '';
  DateTimeToString(s, 'hh:nn:ss.zzz', Now);
  s := Format('%s %s', [s, aMessage]);
  mmoMessages.Lines.Insert(0, s);
end;

procedure TfrmMain.edInTsDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do try
    FileName := edInTs.Text;
    Filter := 'mpeg2 transport stream (*.ts)|*.ts';
    DefaultExt := 'ts';
    if Execute then
      edInTs.Text := FileName;
  finally
    Free;
  end;
end;

end.

