Attribute VB_Name = "basNGrabConst"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   basNGrabConst
' </NAME>
'
' <DESCRIPTION>
'   Global Constants
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Michael Sommer (LYNX)
' </COPYRIGHT>
'
' <AUTHOR>
'   LYNX
' </AUTHOR>
'
' <HISTORY>
'   25.07.2002 - LYNX Neues Modul für globale Konstanten eingeführt (Kommt bald in externe Library)
'   26.07.2002 - LYNX Konstante für Namen des HelpFiles eingeführt (Namen sollte mal in NGrab.chm geändert werden)
'   31.07.2002 - LYNX Neue Konstanten für die RegistryKeys eingeführt
'   01.08.2002 - LYNX Neue Konstanten für NGrabState eingeführt
'   21.10.2002 - LYNX Neue Konstanten für neue Registry Datenstruktur eingeführt.
'   23.10.2002 - ZE   Neue Konstanten bezüglich D2S eingebunden
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Global Const NLSAppTitle = "NGrab"
Global Const NLSHelpFile = "HTMLHelp.chm"

'D2S Files
Global Const NLSND2SProjectFile = "dvd2svcd project file.d2s"
Global Const NLSND2SINIFile = "DVD2SVCD.ini"

'Registry Keys
Global Const NLSNGrabRegKey = "Software\NGrab\"
Global Const NLSNGrabRegKeySettings = "Settings\"
Global Const NLSND2SRegKeySettings = "D2SSettings\"

Global Const NLSDBoxIPAdress = "DBoxIPAdress"
Global Const NLSDBoxPort = "DBoxPort"
Global Const NLSFileCount = "NGrabFileCount"
Global Const NLSGrabPath = "NGrabGrabPath"
Global Const NLSD2SPath = "D2SPath"
Global Const NLSSyncTime = "NGrabSyncTime"
Global Const NLSWriteLog = "NGrabWriteLog"
Global Const NLSWriteEPG = "NGrabGrabEPG"
Global Const NLSWGESplitFile = "WinGrabEngineSplitFile"
Global Const NLSWGEStreamType = "WinGrabEngineStreamType"
Global Const NLSStartEnc = "StartMPEG2Encoder"
Global Const NLSEncFile = "DVD2SVCDFile"

Global Const NLSFileExtM2P = "FileExtM2P"
Global Const NLSFileExtM2V = "FileExtM2V"
Global Const NLSFileExtM2A = "FileExtM2A"
Global Const NLSFileExtTXT = "FileExtTXT"
Global Const NLSFileExtLOG = "FileExtLOG"

'States
Global Const NLSStateDisconnected = "Disconnected"
Global Const NLSStateConnected = "Connected"
Global Const NLSStateStreaming = "Streaming"

Global Const NLSNGrabNoConnection = "DBox konnte nicht erreicht werden."
Global Const NLSNGrabReady = "verbunden mit "
Global Const NLSNGrabRecord = " wird aufgenommen."

'INI Keys
Global Const NLSND2SSettings = "Settings"
Global Const NLSND2SExecutables = "Executables"
Global Const NLSND2SFolders = "Folders"
Global Const NLSND2SGenderal = "General"
Global Const NLSND2SFilenames = "Filenames"
Global Const NLSND2SVOBFiles = "VOBFiles"
Global Const NLSND2SMovieInfo = "MovieInfo"

' Settings
Global Const NLSND2STargetFolder = "TargetFolder"
Global Const NLSND2SAspectRatio = "SelectedAspectRatio"
Global Const NLSND2SAutoShutdown = "Automatic Shutdown"
Global Const NLSND2SDontDelete = "Dont Delete Files"
Global Const NLSND2SUseCCE = "Use CCE"
Global Const NLSND2SUseTMPG = "Use TMPGEnc"
Global Const NLSND2SAudioMode = "tooLame Mode"
Global Const NLSND2SAudioBitrate = "Audio1BitRate"
Global Const NLSND2SAudioResample = "Add ResampleAudio"
Global Const NLSND2SSafeMode = "CCE Safe Mode"
Global Const NLSND2SCCECBR = "CBR"
Global Const NLSND2SCCEOneVBR = "One Pass VBR"
Global Const NLSND2SCCEMultiVBR = "Multi Pass VBR"
Global Const NLSND2SCCEPasses = "NoOfpasses"
Global Const NLSND2STMPGRateControl = "TMPGEnc Rate Control Mode"
Global Const NLSND2STMPGMotionSearch = "TMPGEnc Motion search precision"
Global Const NLSND2SMaxBitrate = "MaxBitrate"
Global Const NLSND2SMinBitrate = "MinBitrate"
Global Const NLSND2SMaxAvg = "MaxAvg"
Global Const NLSND2SMinAvg = "MinAvg"
Global Const NLSND2SMinsHigh1 = "MinsHigh1"
Global Const NLSND2SMinsHigh2 = "MinsHigh2"
Global Const NLSND2SMinsHigh3 = "MinsHigh3"
Global Const NLSND2SMinsHigh4 = "MinsHigh4"
Global Const NLSND2SMinsHigh5 = "MinsHigh5"
Global Const NLSND2SNumCD1 = "NumCd1"
Global Const NLSND2SNumCD2 = "NumCd2"
Global Const NLSND2SNumCD3 = "NumCd3"
Global Const NLSND2SNumCD4 = "NumCd4"
Global Const NLSND2SNumCD5 = "NumCd5"
Global Const NLSND2SNumCD6 = "NumCd6"
Global Const NLSND2SCDSize1 = "CDSize 1"
Global Const NLSND2SCDSize2 = "CDSize 2"
Global Const NLSND2SCDSize3 = "CDSize 3"
Global Const NLSND2SCDSize4 = "CDSize 4"
Global Const NLSND2SCDSize5 = "CDSize 5"
Global Const NLSND2SCDSize6 = "CDSize 6"
Global Const NLSND2SFirstRun = "FirstRun"

' Executables
Global Const NLSND2SPVAExecutable = "PVA Executable"
Global Const NLSND2SCCEExecutable = "CCE Executable"
Global Const NLSND2STMPGExecutable = "TMPGEnc Executable"
Global Const NLSND2SDVD2AVIEx = "DVD2AVI Executable"
Global Const NLSND2SBeSweetEx = "BeSweet Executable"
Global Const NLSND2SMadPlayEx = "MadPlay Executable"
Global Const NLSND2SMPEG51Ex = "MPEG51 Executable"
Global Const NLSND2SVFAPIEx = "VFAPI Executable"
Global Const NLSND2SPulldownEx = "Pulldown Executable"
Global Const NLSND2SSubMuxEx = "SubMux Executable"
Global Const NLSND2SbbMPEGEx = "bbMPEG Executable"
Global Const NLSND2SMPG2DecDLL = "MPG2Dec DLL"
Global Const NLSND2SMPG2DecDIV = "Dividee MPEG2Dec"
Global Const NLSND2SInverseTelecineDLL = "InverseTelecine DLL"
Global Const NLSND2SSimpleResizeDLL = "SimpleResize DLL"

'Folders
Global Const NLSND2SPVAFolder = "PVA Folder"
Global Const NLSND2SD2AFolder = "DVD2AVI Folder"
Global Const NLSND2SVStripFolder = "vStrip Folder"
Global Const NLSND2SAudioFolder = "Audio Folder"
Global Const NLSND2SCCEFolder = "CCE Folder"
Global Const NLSND2STMPGFolder = "TMPGEnc Folder"
Global Const NLSND2SPullFolder = "Pulldown Folder"
Global Const NLSND2SbbMPEGFolder = "bbMPEG Folder"

'Filenames
Global Const NLSND2SAudioFileName = "DVDAudioFileName0"
Global Const NLSND2SMP2FileName = "MP2FileName0"
Global Const NLSND2SFinalMPV = "FinalMPVName"
Global Const NLSND2SMPVFileName = "MPVFileName"
Global Const NLSND2SFinalbbMpeg = "FinalbbMPEGFileName"
Global Const NLSND2SD2SINIFile = "DVD2SVCD INI File"
Global Const NLSND2SVobName = "VobName_0"




