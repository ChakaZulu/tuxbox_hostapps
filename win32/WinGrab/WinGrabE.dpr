program WinGrabE;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {frmMain},
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
  TimerFrm in 'TimerFrm.pas' {frmTimer},
  TeVideoFrameProcessorThread in 'TeVideoFrameProcessorThread.pas',
  TeAudioFrameProcessorThread in 'TeAudioFrameProcessorThread.pas',
  TePesParser in 'TePesParser.pas',
  TeSectionParser in 'TeSectionParser.pas',
  TeSectionParserThread in 'TeSectionParserThread.pas',
  TeTCPStreamThread in 'TeTCPStreamThread.pas',
  TeTsParserThread in 'TeTsParserThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WinGrab EliteDVB Edition v0.81';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.