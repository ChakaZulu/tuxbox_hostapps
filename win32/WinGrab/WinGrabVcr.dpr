////////////////////////////////////////////////////////////////////////////////
//
// $Log: WinGrabVcr.dpr,v $
// Revision 1.2  2004/10/15 13:39:16  thotto
// neue Db-Klasse
//
// Revision 1.1  2004/07/02 14:07:40  thotto
// initial
//
//

program WinGrabVcr;

uses
  QMemory in 'QMemory.pas',
  Windows,
  Forms,
  VcrMainFrm in 'VcrMainFrm.pas' {frmMain},
  WinSock2 in 'WinSock2.pas',
  TeChannelsReader in 'TeChannelsReader.pas',
  TeFiFo in 'TeFiFo.pas',
  TeFileStreamThread in 'TeFileStreamThread.pas',
  TeHTTPStreamThread in 'TeHTTPStreamThread.pas',
  TePesFiFo in 'TePesFiFo.pas',
  TePesMuxerThread in 'TePesMuxerThread.pas',
  TeVideoParser in 'TeVideoParser.pas',
  TePesParserThread in 'TePesParserThread.pas',
  TeSocket in 'TeSocket.pas',
  TeThrd in 'TeThrd.pas',
  TeBase in 'TeBase.pas',
  TeLogableThread in 'TeLogableThread.pas',
  TeProcessManager in 'TeProcessManager.pas',
  TeGrabManager in 'TeGrabManager.pas',
  TeAudioFrameProcessorThread in 'TeAudioFrameProcessorThread.pas',
  TransformThread in 'TransformThread.pas',
  VcrTypes in 'VcrTypes.pas',
  DelTools in 'DelTools.pas',
  MyTrace in 'MyTrace.pas',
  ShutDownDlg in 'ShutDownDlg.pas' {FrmShutdown},
  VcrDivXtools in 'VcrDivXtools.pas',
  VcrDivXchk in 'VcrDivXchk.pas' {FrmDivXchk},
  VcrDbHandling in 'VcrDbHandling.pas';

{$R *.RES}


var
  hMux: THandle;

Function CanStartNow: Boolean;
const
  szAppTitle = 'WingrabVcr'#0;
var
  Tmp : String;
begin
  Tmp:= szAppTitle;
  hMux:= OpenMutex(MUTEX_ALL_ACCESS, FALSE, @Tmp[1]);
  if hMux = 0 then
  begin
    hMux:= CreateMutex(nil, FALSE, @Tmp[1]);
    Result:= TRUE;
  end else
  begin
    Result:= FALSE;
  end;
end;

begin
  try
    hMux:= 0;
    if CanStartNow then
    begin
      Application.Initialize;
      Application.Title := 'WinGrab v0.83 - VCR Edition';
      Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
      if hMux<>0 then ReleaseMutex(hMux);
    end;
  except
  end;
end.
