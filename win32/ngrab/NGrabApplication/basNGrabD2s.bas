Attribute VB_Name = "basNGrabD2s"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   basNGrabD2S
' </NAME>
'
' <DESCRIPTION>
'   NGrab Functions for DVD2SVCD
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Andreas Wilhelm (ZEROQ)
' </COPYRIGHT>
'
' <AUTHOR>
'   ZERO
' </AUTHOR>
'
' <HISTORY>
'   21.10.2002 - ZERO Neues Modul basNGRabD2S eingeführt. Dieses Modul enthält Globale NGrab Funktionen bezüglich
'                     DVD2SVCD.
'                     SaveINISetting und GetINISetting hinzugefügt
'                     Filename = Name der INI Datei
'                     Key = [Gruppe] in der INI Datei
'                     Setting = Eintrag in der INI Datei
'                     Default = Rückgabewert bei leerem Schlüssel (nur beim lesen)
'                     Value = Wert der geschrieben wird (nur eim schreiben)
'   29.10.2002 - ZERO Fehler bezüglich Pfad und Dateinamen behoben
'   30.10.2002 - LYNX FormatDate und FormatFileName Functions entfernt (nicht mehr notwendig)
'   13.11.2002 - ZERO Ab Sofort Unterstützung für D2S 1.1
'                     Variablen und Steuerelemente für Madplay rausgeflogen (-> d2s 1.1)
'   11.12.2002 - ZERO Timer wurde hinzgefügt, damit PVAStrumento nicht NGRAB blockiert
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

'API-Funktionen deklarieren
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lsString As Any, ByVal lplFilename As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hWnd As Long, ByVal lOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Private Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Private Declare Function GetDesktopWindow Lib "user32" () As Long
Private Declare Function SetTimer Lib "user32" (ByVal hWnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
Private Declare Function KillTimer Lib "user32" (ByVal hWnd As Long, ByVal nIDEvent As Long) As Long


'Konstanten
Private Const STILL_ACTIVE = &H103
Private Const PROCESS_ALL_ACCESS = &H1F0FFF
Private Const SE_ERR_NOASSOC = 31
Private Const SE_ERR_NOTFOUND = 2
Private Const INFINITE = -1&
Private Const SYNCHRONIZE = &H100000
Private Const PVA_JOB_IMG = "PVA.TXT"
Private Const PVA_JOB = "PVA_JOB.TXT"
Private Const D2S_BATCH_IMG = "d2s_batch.bat"
Private Const D2S_BATCH = "dvd2svcd batch.bat"

'Globale Variablen
Private gsD2SPath As String
Private gsAppPath As String
Private gsTargetPath As String
Private gsVideoFilename As String
Private gsAudioFilename As String
Private gdProgID As Double
Private ghTimer As Long


'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   SaveINISetting
' </NAME>
'
' <DESCRIPTION>
'   Funktion zum Schreiben von INI Dateien
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub SaveINISetting(ByVal filename As String, ByVal Key As String, ByVal Setting As String, ByVal Value As String)
   
   Call WritePrivateProfileString(Key, Setting, Value, filename)

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   GetINISetting
' </NAME>
'
' <DESCRIPTION>
'   Funktion zum Lesen von INI Dateien
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Function GetINISetting(ByVal filename As String, ByVal Key As String, ByVal Setting As String, ByVal Default As Variant) As Variant
   
   Dim Temp As String * 1024

   Call GetPrivateProfileString(Key, Setting, Default, Temp, Len(Temp), filename)
   
   GetINISetting = Mid(Temp, 1, InStr(1, Temp, Chr(0)) - 1)

End Function

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   appendLine
' </NAME>
'
' <DESCRIPTION>
'   Funktion zum Anhängen einer Zeile an eine Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Function AppendLine(ByVal filename As String, ByVal lineText As String) As Boolean

   Dim lintFileNr As Integer

    On Error GoTo ErrHandler

    lintFileNr = FreeFile
    
    Open filename For Append As #lintFileNr   ' Datei öffnen.
    
            Print #lintFileNr, vbCrLf & lineText
            AppendLine = True
                
    Close #lintFileNr
    
    Exit Function

ErrHandler:

AppendLine = False

End Function

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   insertLine
' </NAME>
'
' <DESCRIPTION>
'   Funktion zum Einfügen einer Zeile innerhalb einer Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Function InsertLine(ByVal filename As String, ByVal pLen As Integer, ByVal lineText As String) As Boolean

   Dim lintFileNr As Integer

    On Error GoTo ErrHandler

    lintFileNr = FreeFile
    
    Open filename For Binary As #lintFileNr   ' Datei öffnen.
    
'        If Filename = True Then
        
            Put #lintFileNr, pLen, lineText
            InsertLine = True
        
 '       End If
        
    Close #lintFileNr
    
    Exit Function

ErrHandler:

InsertLine = False

End Function



'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   demuxStream
' </NAME>
'
' <DESCRIPTION>
'   Funktion ruft PVAStrumento auf um Stream zu demuxen
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Function D2S_DemuxStream(ByVal pPVAEx As String, pStream As String, ByVal pCount As String) As Double

Dim progID As Double
    
    'Prüfen ob PVAStrumento existiert
    If gbFileExists(pPVAEx) = False Then
        D2S_DemuxStream = 0
        Exit Function
    End If
    
    'PVA Job Datei kopieren und bearbeiten
    FileCopy gsAppPath & PVA_JOB_IMG, gsAppPath & PVA_JOB
    pStream = Replace(pStream, ".m2p", "[" & pCount & "].m2p", , , vbTextCompare)
    pStream = UCase(Left(pStream, 1)) & Mid(pStream, 2)
    If InsertLine(gsAppPath & PVA_JOB, 120, "demux """ & pStream & """ """ & gsVideoFilename & ".vob"" """ & gsAudioFilename & ".mpa""") = True Then
    
        'PVAStrumento ausführen
        progID = Shell(pPVAEx & " """ & gsAppPath & PVA_JOB & """", vbMinimizedNoFocus)
    
        'ProzessID zurückgeben
         D2S_DemuxStream = progID
         
    Else
    
        D2S_DemuxStream = 0
    
    End If
    
End Function



'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   startD2S
' </NAME>
'
' <DESCRIPTION>
'   Funktion ruft den Batch Vorgang auf
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub D2S_Start(ByVal pStream As String, ByVal pCount As Integer)

    Dim lsPVAEx As String
    Dim lsTargetPath As String
    Dim ldProgID&
    Dim lsCount As String
        
    'Globale Variablen initialisieren
    Call D2S_InitGVar
    
    gsD2SPath = Replace(gsD2SINIFile, NLSND2SINIFile, "", , , vbTextCompare)
    gsAppPath = Replace(gsINIFile, NLSND2SINIFile, "", , , vbTextCompare)
    gsTargetPath = GetINISetting(gsProjectFile, NLSND2SFilenames, NLSND2STargetFolder, "C:\")
    gsTargetPath = UCase(Left(gsTargetPath, 1)) & Mid(gsTargetPath, 2)
    lsPVAEx = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SPVAExecutable, "C:\")
    If Right(gsTargetPath, 1) = "\" Then
        gsVideoFilename = gsTargetPath & "Video"
        gsAudioFilename = gsTargetPath & "Audio"
    Else
        gsVideoFilename = gsTargetPath & "\Video"
        gsAudioFilename = gsTargetPath & "\Audio"
    End If
    'Stream demuxen
    If pCount < 10 Then lsCount = "0"
    lsCount = lsCount & pCount
    gdProgID = D2S_DemuxStream(lsPVAEx, pStream, lsCount)
    
    'Timer starten, damit D2S und NGRAB nach Demuxen ausgeführt werden kann
    StartTimer 1000


End Sub




'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2S_InitGVar
' </NAME>
'
' <DESCRIPTION>
'   Funktion initialisiert Globale Variablen
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub D2S_InitGVar()

   gsD2SINIFile = Replace(goSettings.sItem(NLSEncFile), "DVD2SVCD.EXE", NLSND2SINIFile, , , vbTextCompare)
   gsProjectFile = App.Path & "\D2S\" & NLSND2SProjectFile
   gsINIFile = App.Path & "\D2S\" & NLSND2SINIFile

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   pInt
' </NAME>
'
' <DESCRIPTION>
'   Funktion wandelt Bool in Int Werte um (True = 1; False = 0)
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Function pInt(ByVal Value As Boolean) As Integer

    If Value = True Then
        pInt = 1
    Else
        pInt = 0
    End If
    
End Function

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   gbFileExists
' </NAME>
'
' <DESCRIPTION>
'   Funktion prüft Existenz von Dateien
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Function gbFileExists(ByVal Path As String) As Boolean

    On Error Resume Next
        gbFileExists = (GetAttr(Path) And (vbDirectory Or vbVolume)) = 0
    On Error GoTo 0

End Function

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   d2s_check
' </NAME>
'
' <DESCRIPTION>
'   Funktion prüft DVD2SVCD Paket
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Function D2S_CheckPrograms(ByVal pD2SINI As String, ByVal pKey As String, Optional ByVal pPVAEx As String, Optional ByVal sEncoderEXE As String) As String

    Dim lsMessage As String
    Dim colPrograms As New Collection
    Dim sProgram As Variant
    
    'Püfen ob dvd2svcd.ini vorhanden
    If gbFileExists(pD2SINI) = False Then
        D2S_CheckPrograms = NLSND2SINIFile & " nicht vorhanden !"
        Exit Function
    End If
    
    'Programme prüfen
    colPrograms.Add (NLSND2SDVD2AVIEx)
    colPrograms.Add (NLSND2SBeSweetEx)
    colPrograms.Add (NLSND2SMPEG51Ex)
    colPrograms.Add (NLSND2SVFAPIEx)
    colPrograms.Add (NLSND2SPulldownEx)
    colPrograms.Add (NLSND2SSubMuxEx)
    colPrograms.Add (NLSND2SbbMPEGEx)
    colPrograms.Add (NLSND2SVFAPIEx)
    colPrograms.Add (NLSND2SMPG2DecDLL)
    colPrograms.Add (NLSND2SInverseTelecineDLL)
    colPrograms.Add (NLSND2SSimpleResizeDLL)
    
    For Each sProgram In colPrograms
    
        If gbFileExists(GetINISetting(pD2SINI, pKey, sProgram, " ")) Then
            lsMessage = lsMessage & sProgram & " wurde erfolgreich gefunden" & vbCrLf
        Else
            lsMessage = lsMessage & sProgram & " wurde nicht gefunden !!!" & vbCrLf
        End If
    
    Next
    
    If gbFileExists(pPVAEx) And Not pPVAEx = "" Then
        lsMessage = lsMessage & vbCrLf & "PVAStrumento wurde erfolgreich gefunden" & vbCrLf
    Else
        lsMessage = lsMessage & "PVAStrumento wurde nicht gefunden !!!" & vbCrLf
    End If

    If gbFileExists(sEncoderEXE) And Not sEncoderEXE = "" Then
        lsMessage = lsMessage & vbCrLf & "Ausführbare Encoder Datei wurde erfolgreich gefunden" & vbCrLf
    Else
        lsMessage = lsMessage & "Ausführbare Encoder Datei wurde nicht gefunden !!!" & vbCrLf
    End If
    
'   Rückagebwert
    D2S_CheckPrograms = lsMessage
   
End Function

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   IsActive
' </NAME>
'
' <DESCRIPTION>
'   Funktion prüft Windows Prozess
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Function IsActive(ByVal pTaskID As Double) As Boolean
    Dim Handle&, ExitCode&
    
    Handle = OpenProcess(PROCESS_ALL_ACCESS, False, pTaskID)
    Call GetExitCodeProcess(Handle, ExitCode)
    Call CloseHandle(Handle)
    
    IsActive = IIf(ExitCode = STILL_ACTIVE, True, False)
End Function


'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2S_ImportLinks
' </NAME>
'
' <DESCRIPTION>
'   Importiert Adressen der verknüpften Programme von der DVD2SVCD INI
'   in lokale INI Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub D2S_ImportLinks()

    'Executables
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SDVD2AVIEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SDVD2AVIEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SBeSweetEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SBeSweetEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SMPEG51Ex, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SMPEG51Ex, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SVFAPIEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SVFAPIEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SPulldownEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SPulldownEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SSubMuxEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SSubMuxEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SMPEG51Ex, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SMPEG51Ex, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SbbMPEGEx, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SbbMPEGEx, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SMPG2DecDLL, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SMPG2DecDLL, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SMPG2DecDIV, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SMPG2DecDLL, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SInverseTelecineDLL, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SInverseTelecineDLL, " ")
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SSimpleResizeDLL, GetINISetting(gsD2SINIFile, NLSND2SExecutables, NLSND2SSimpleResizeDLL, " ")
    
End Sub



'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2S_InitProject
' </NAME>
'
' <DESCRIPTION>
'   Schreibt Projektinformationen und sonstige Verwaltungssachen vor dem
'   Start
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub D2S_InitProject()
    
    'Filenames
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SAudioFileName, gsAudioFilename & ".mpa"
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SMP2FileName, gsAudioFilename & ".mp2"
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SFinalMPV, gsVideoFilename & ".mpv"
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SMPVFileName, gsVideoFilename & ".mpv"
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SFinalbbMpeg, gsVideoFilename & ".mpg"
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2SD2SINIFile, gsINIFile
    'VobFiles
    SaveINISetting gsProjectFile, NLSND2SVOBFiles, NLSND2SVobName, gsVideoFilename & ".vob"
    'Folders
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SPVAFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SD2AFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SVStripFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SAudioFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SCCEFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2STMPGFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SPullFolder, gsTargetPath & "\"
    SaveINISetting gsINIFile, NLSND2SFolders, NLSND2SbbMPEGFolder, gsTargetPath & "\"
    
    'deaktiviert FirstTime Flag
    SaveINISetting gsD2SINIFile, NLSND2SSettings, NLSND2SFirstRun, "0"

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   DocumentOpen
' </NAME>
'
' <DESCRIPTION>
'   Öffnen einer fremden Anwendung
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub DocumentOpen(sFilename As String)
  Dim sDirectory As String
  Dim lRet As Long
  Dim DeskWin As Long
  
  DeskWin = GetDesktopWindow()
  lRet = ShellExecute(DeskWin, "open", sFilename, _
    vbNullString, vbNullString, vbNormalFocus)

  If lRet = SE_ERR_NOTFOUND Then
    'Datei nicht gefunden
    
  ElseIf lRet = SE_ERR_NOASSOC Then
    'Wenn die Dateierweiterung noch nicht bekannt ist...
    'wird der "Öffnen mit..."-Dialog angezeigt.
    sDirectory = Space(260)
    lRet = GetSystemDirectory(sDirectory, Len(sDirectory))
    sDirectory = Left(sDirectory, lRet)
    Call ShellExecute(DeskWin, vbNullString, _
      "RUNDLL32.EXE", "shell32.dll,OpenAs_RunDLL " & _
      sFilename, sDirectory, vbNormalFocus)
  End If
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   StartTimer
' </NAME>
'
' <DESCRIPTION>
'   Startet einen Timer
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub StartTimer(ByVal lInterval As Long)

  ' Timer starten:
  ' Interval-Angabe in Millisekunden
  ghTimer = SetTimer(0&, 0&, lInterval, AddressOf TimerProc)
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   TimerProc
' </NAME>
'
' <DESCRIPTION>
'   Wird bei Timerereigniss ausgeführt
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub TimerProc(ByVal hWnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long)
  
  Dim lsBatchString As String
  
  If Not IsActive(gdProgID) Then
  
    'Timer killen
    KillTheTimer
    gdProgID = -1
    
    'Projektdateien verfollständigen
    Call D2S_InitProject
    
    'Batch Datei kopieren, bearbeiten und ausführen
    FileCopy gsAppPath & D2S_BATCH_IMG, gsAppPath & D2S_BATCH
    lsBatchString = gsD2SPath & "DVD2SVCD.EXE -d2s:""" & gsProjectFile & """ -run"
    If GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SAutoShutdown, "0") = 1 Then
     lsBatchString = lsBatchString & " -shutdown"
    Else
     lsBatchString = lsBatchString & " -exit"
    End If
    
    If AppendLine(gsAppPath & D2S_BATCH, lsBatchString) = True Then
         
     'Programm Ausführen
     DocumentOpen (gsAppPath & D2S_BATCH)
                                           
     End If
  
  End If
  
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   KillTimer
' </NAME>
'
' <DESCRIPTION>
'   Löscht vorhanden Timer (nicht vergessen!)
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Sub KillTheTimer()
  If ghTimer = 0 Then Exit Sub
  KillTimer 0&, ghTimer
End Sub
