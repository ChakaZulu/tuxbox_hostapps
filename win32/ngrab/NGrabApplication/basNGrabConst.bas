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
Global Const NLSD2SProjectFile = "dvd2svcd project file.d2s"
Global Const NLSD2SINIFile = "DVD2SVCD.ini"

'Registry Keys
Global Const NLSNGrabRegKey = "Software\NGrab\"
Global Const NLSNGrabRegKeySettings = "Settings\"
Global Const NLSD2SRegKeySettings = "D2SSettings\"

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
Global Const NLSD2SSettings = "Settings"
Global Const NLSD2SExecutables = "Executables"
Global Const NLSD2SFolders = "Folders"
Global Const NLSD2SGenderal = "General"
Global Const NLSD2SFilenames = "Filenames"
Global Const NLSD2SVOBFiles = "VOBFiles"
Global Const NLSD2SMovieInfo = "MovieInfo"

' Settings
Global Const NLSD2STargetFolder = "TargetFolder"
Global Const NLSD2SAspectRatio = "SelectedAspectRatio"
Global Const NLSD2SAutoShutdown = "Automatic Shutdown"
Global Const NLSD2SDontDelete = "Dont Delete Files"
Global Const NLSD2SUseCCE = "Use CCE"
Global Const NLSD2SUseTMPG = "Use TMPGEnc"
Global Const NLSD2SAudioMode = "tooLame Mode"
Global Const NLSD2SAudioBitrate = "Audio1BitRate"
Global Const NLSD2SAudioResample = "Add ResampleAudio"
Global Const NLSD2SSafeMode = "CCE Safe Mode"
Global Const NLSD2SCCECBR = "CBR"
Global Const NLSD2SCCEOneVBR = "One Pass VBR"
Global Const NLSD2SCCEMultiVBR = "Multi Pass VBR"
Global Const NLSD2SCCEPasses = "NoOfpasses"
Global Const NLSD2STMPGRateControl = "TMPGEnc Rate Control Mode"
Global Const NLSD2STMPGMotionSearch = "TMPGEnc Motion search precision"
Global Const NLSD2SMaxBitrate = "MaxBitrate"
Global Const NLSD2SMinBitrate = "MinBitrate"
Global Const NLSD2SMaxAvg = "MaxAvg"
Global Const NLSD2SMinAvg = "MinAvg"
Global Const NLSD2SMinsHigh1 = "MinsHigh1"
Global Const NLSD2SMinsHigh2 = "MinsHigh2"
Global Const NLSD2SMinsHigh3 = "MinsHigh3"
Global Const NLSD2SMinsHigh4 = "MinsHigh4"
Global Const NLSD2SMinsHigh5 = "MinsHigh5"
Global Const NLSD2SNumCD1 = "NumCd1"
Global Const NLSD2SNumCD2 = "NumCd2"
Global Const NLSD2SNumCD3 = "NumCd3"
Global Const NLSD2SNumCD4 = "NumCd4"
Global Const NLSD2SNumCD5 = "NumCd5"
Global Const NLSD2SNumCD6 = "NumCd6"
Global Const NLSD2SCDSize1 = "CDSize 1"
Global Const NLSD2SCDSize2 = "CDSize 2"
Global Const NLSD2SCDSize3 = "CDSize 3"
Global Const NLSD2SCDSize4 = "CDSize 4"
Global Const NLSD2SCDSize5 = "CDSize 5"
Global Const NLSD2SCDSize6 = "CDSize 6"
Global Const NLSD2SFirstRun = "FirstRun"

' Executables
Global Const NLSD2SPVAExecutable = "PVA Executable"
Global Const NLSD2SCCEExecutable = "CCE Executable"
Global Const NLSD2STMPGExecutable = "TMPGEnc Executable"
Global Const NLSD2SDVD2AVIEx = "DVD2AVI Executable"
Global Const NLSD2SBeSweetEx = "BeSweet Executable"
Global Const NLSD2SMadPlayEx = "MadPlay Executable"
Global Const NLSD2SMPEG51Ex = "MPEG51 Executable"
Global Const NLSD2SVFAPIEx = "VFAPI Executable"
Global Const NLSD2SPulldownEx = "Pulldown Executable"
Global Const NLSD2SSubMuxEx = "SubMux Executable"
Global Const NLSD2SbbMPEGEx = "bbMPEG Executable"
Global Const NLSD2SMPG2DecDLL = "AVS2.5 MPG2Dec DLL"
Global Const NLSD2SMPG2DecDIV = "AVS2.5 Dividee MPEG2Dec"
Global Const NLSD2SInverseTelecineDLL = "AVS2.5 InverseTelecine DLL"
Global Const NLSD2SSimpleResizeDLL = "AVS2.5 SimpleResize DLL"

'Folders
Global Const NLSD2SPVAFolder = "PVA Folder"
Global Const NLSD2SD2AFolder = "DVD2AVI Folder"
Global Const NLSD2SVStripFolder = "vStrip Folder"
Global Const NLSD2SAudioFolder = "Audio Folder"
Global Const NLSD2SCCEFolder = "CCE Folder"
Global Const NLSD2STMPGFolder = "TMPGEnc Folder"
Global Const NLSD2SPullFolder = "Pulldown Folder"
Global Const NLSD2SbbMPEGFolder = "bbMPEG Folder"

'Filenames
Global Const NLSD2SAudioFileName = "DVDAudioFileName0"
Global Const NLSD2SMP2FileName = "MP2FileName0"
Global Const NLSD2SFinalMPV = "FinalMPVName"
Global Const NLSD2SMPVFileName = "MPVFileName"
Global Const NLSD2SFinalbbMpeg = "FinalbbMPEGFileName"
Global Const NLSD2SD2SINIFile = "DVD2SVCD INI File"
Global Const NLSD2SVobName = "VobName_0"




