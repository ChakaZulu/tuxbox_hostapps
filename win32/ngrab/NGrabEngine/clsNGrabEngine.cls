VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsNGrabEngine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   clsNGrabEngine.cls
' </NAME>
'
' <DESCRIPTION>
'   NGrab
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Reinhard Eidelsburger, Michael Sommer
' </COPYRIGHT>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' <HISTORY>
'   20.10.2002 - RE Chr(34) = " -> Anführungszeichen darf nicht im Dateinamen vorkommen
'   20.10.2002 - LYNX CheckFilename Funktion durch msFilenameCheck ersetzt!
'   30.10.2002 - LYNX FileSystemInformation hinzugefügt.
'   10.11.2002 - LYNX Stop Methode Des moGrabControl verwendet um Streamen gemäss Wingrabengine Spezifikation zu beenden!
'                     Neue Methode Connect hinzugefügt!
' </HISTORY>
'
' </MODULE>
' </DOC>

Option Explicit

Implements IWinGrabProcessCallback

Private moSettings As clsNOXParameterBag
Private moStateMessages As clsNOXParameterBag
Private moStreamInfo As clsNOXParameterBag
Private moFileSystemInfo As clsNOXParameterBag
Private modBoxInfo As clsNOXParameterBag

Private moGrabLibrary As WinGrabLibrary
Private moGrabControl As WinGrabGrabControl

Private msMessages As String
Private msLog As String

Private msM2PFileName As String
Private msEPGFileName As String
Private msLOGFileName As String

Private msM2AFileName As String
Private msM2VFileName As String

Private msEPGID As String 'Electronic Program Guide Identifier
Private msONIDSID As String 'Original Network Identifier / Service Identifier
Private msChannelName As String
Private msVideoPID As String ' Video Packet Identifier
Private msAudioPID As String ' Audio Packet Identifier
Private msEPGTitle As String ' Name der Sendung

Private mnConnectionState As ConnectionState

Public Enum StreamInfo
    ChannelName = 1
    EPGTitle = 2
    EPGID = 3
    ONIDSID = 4
    VideoPID = 5
    AudioPID = 6
End Enum

Public Enum FileSystemInfo
    M2PFile = 1
    M2AFile = 2
    M2VFile = 3
    LOGFile = 4
    EPGFile = 5
End Enum

Public Enum dBoxInfo
    Info = 1
    Version = 2
    Settings = 3
    httpdversion = 4
End Enum

Public Enum ConnectionState
    Connected = 1
    Disconnected = 2
    Streaming = 3
End Enum

Public Event ConnectionStateChanged(nConnectionState As ConnectionState)

Public Property Get Messages() As String

    If Len(msMessages) > 0 Then
        msLog = msLog & msMessages & vbCrLf
    End If

    Messages = msMessages
    msMessages = ""

End Property

Public Property Get StateMessages() As clsNOXParameterBag

    Set StateMessages = moStateMessages

End Property

Public Property Get StreamInfo() As clsNOXParameterBag

    Set StreamInfo = moStreamInfo

End Property

Public Property Get FileSystemInfo() As clsNOXParameterBag

    Set FileSystemInfo = moFileSystemInfo

End Property

Public Property Get dBoxInfo() As clsNOXParameterBag

    Set dBoxInfo = modBoxInfo

End Property

Public Function Init(oSettings As clsNOXParameterBag) As Boolean

    If Not oSettings Is Nothing Then
        
        Set moSettings = oSettings
        Set moStateMessages = New clsNOXParameterBag
        Set moStreamInfo = New clsNOXParameterBag
        Set moFileSystemInfo = New clsNOXParameterBag
        Set modBoxInfo = New clsNOXParameterBag
        
        mnConnectionState = Disconnected
        
    End If

End Function

Public Property Get ConnectionState() As ConnectionState

    ConnectionState = mnConnectionState

End Property

Public Function Connect() As Boolean
        
    If gbICMPEchoReply(moSettings.sItem(NLSDBoxIPAdress)) Then
         
        If Len(gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/info")) > 0 Then
                   
            modBoxInfo.sItem(Info) = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/info")
            modBoxInfo.sItem(Version) = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/info?version")
            modBoxInfo.sItem(Settings) = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/info?settings")
            modBoxInfo.sItem(httpdversion) = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/info?httpdversion")
               
            Select Case modBoxInfo.sItem(httpdversion)
                Case 1
                    gsURLOpen ("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/popup=Streamingserver bereit!")
                Case 2
                    gsURLOpen ("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/message?popup=Streamingserver bereit!")
            End Select
                    
            If moSettings.sItem(NLSSyncTime) = 1 Then
                gSystemDateSet mdtDBoxDateGet()
            End If
                                                      
            RaiseEvent ConnectionStateChanged(Connected)
            Connect = True
        
        Else
        
            modBoxInfo.sItem(Info) = ""
            modBoxInfo.sItem(Version) = ""
            modBoxInfo.sItem(Settings) = ""
            modBoxInfo.sItem(httpdversion) = ""
            
            RaiseEvent ConnectionStateChanged(Disconnected)
            Connect = False
                
        End If
        
    Else
            
        modBoxInfo.sItem(Info) = ""
        modBoxInfo.sItem(Version) = ""
        modBoxInfo.sItem(Settings) = ""
        modBoxInfo.sItem(httpdversion) = ""
    
        RaiseEvent ConnectionStateChanged(Disconnected)
        Connect = False
    
    End If

End Function

Public Sub GrabStart(sXMLData As String)
       
    ' XML-Infos auslesen
    msONIDSID = gsXMLParse(sXMLData, "onidsid")
    msEPGID = gsXMLParse(sXMLData, "epgid")
    msChannelName = gsXMLParse(sXMLData, "channelname")
    
    ' Videopid 3 stellig setzen -> für Audio
    msVideoPID = gsXMLParse(sXMLData, "videopid")
    If msVideoPID = "0" Then msVideoPID = "000"
    
    msEPGTitle = gsXMLParse(sXMLData, "epgtitle")
    
    'Audipid
    Dim anfang_apid As String
    Dim ende_apid As String
    Dim differenz_apid As String
           
    If Len(msVideoPID) = 3 Then
        anfang_apid = InStr(sXMLData, "<audiopids selected=") + 21
        ende_apid = InStr(sXMLData, "<audiopids selected=") + 24
        differenz_apid = ende_apid - anfang_apid
        msAudioPID = Mid(sXMLData, anfang_apid, differenz_apid)
        
        ' X-Zone Bug beheben - Videopid 3 stellig, Audiopid 2 stellig
        Dim ergebnis As Integer
        ergebnis = InStr(msAudioPID, """")
        
        If ergebnis <> "0" Then
            msAudioPID = Mid(msAudioPID, 1, ergebnis - 1)
        End If
        
    ElseIf Len(msVideoPID) = 4 Then
        anfang_apid = InStr(sXMLData, "<audiopids selected=") + 21
        ende_apid = InStr(sXMLData, "<audiopids selected=") + 25
        differenz_apid = ende_apid - anfang_apid
        msAudioPID = Mid(sXMLData, anfang_apid, differenz_apid)
    
        ' X-Zone Bug beheben - Videopid 3 stellig, Audiopid 2 stellig
        Dim ergebnis2 As Integer
        ergebnis2 = InStr(msAudioPID, """")
        
        If ergebnis2 <> "0" Then
            msAudioPID = Mid(msAudioPID, 1, ergebnis - 1)
        End If
    
    End If
    
    moStreamInfo.sItem(ChannelName) = msChannelName
    moStreamInfo.sItem(EPGTitle) = msEPGTitle
    moStreamInfo.sItem(EPGID) = msEPGID
    moStreamInfo.sItem(ONIDSID) = msONIDSID
    moStreamInfo.sItem(VideoPID) = msVideoPID
    moStreamInfo.sItem(AudioPID) = msAudioPID
                                       
    Select Case moSettings.nItem(NLSWGEStreamType)
    
    Case 1
    
        ' Dateinamen erstellen
        msM2PFileName = msEPGTitle & " (" & msChannelName & ")" & " (" & Format(Now, "ddmmmyyyy hhmm") & ")." & moSettings.sItem(NLSFileExtM2P)
    
    Case 0
        
        ' Dateinamen erstellen
        msM2VFileName = msEPGTitle & " (" & msChannelName & ")" & " (" & Format(Now, "ddmmmyyyy hhmm") & ")." & moSettings.sItem(NLSFileExtM2V)
        msM2AFileName = msEPGTitle & " (" & msChannelName & ")" & " (" & Format(Now, "ddmmmyyyy hhmm") & ")." & moSettings.sItem(NLSFileExtM2A)
        
    End Select
                          
    msEPGFileName = msEPGTitle & " (" & msChannelName & ")" & " (" & Format(Now, "ddmmmyyyy hhmm") & ")." & moSettings.sItem(NLSFileExtTXT)
    msLOGFileName = msEPGTitle & " (" & msChannelName & ")" & " (" & Format(Now, "ddmmmyyyy hhmm") & ")." & moSettings.sItem(NLSFileExtLOG)
                          
    'If strEpgid <> 0 Then
    '    filename = CheckFilename(strEpgid)
    'Else
    '    filename = "keinepggefunden.m2p"
    'End If
        
    ' ----------------------------------------------------------------------
    ' Dateinamen erstellen
    ' ----------------------------------------------------------------------
    
    Select Case moSettings.nItem(NLSWGEStreamType)
    
        Case 1
    
            msM2PFileName = msFilenameCheck(msM2PFileName)

            msM2PFileName = moSettings.sItem(NLSGrabPath) & msM2PFileName
    
        Case 0
            
            msM2VFileName = msFilenameCheck(msM2VFileName)
            msM2AFileName = msFilenameCheck(msM2AFileName)
            
            msM2VFileName = moSettings.sItem(NLSGrabPath) & msM2VFileName
            msM2AFileName = moSettings.sItem(NLSGrabPath) & msM2AFileName

    End Select
        
    msEPGFileName = msFilenameCheck(msEPGFileName)
    msLOGFileName = msFilenameCheck(msLOGFileName)
        
    msEPGFileName = moSettings.sItem(NLSGrabPath) & msEPGFileName
    msLOGFileName = moSettings.sItem(NLSGrabPath) & msLOGFileName

  
    ' ----------------------------------------------------------------------
    ' Pfad für EPG-TXT erzeugen + Pfad für LOG-TXT erzeugen
    ' ----------------------------------------------------------------------
    
    'strEpgtxt = CreatePath()
    'strLogtxt = CreateLogPath()
          
    ' ----------------------------------------------------------------------
    ' Event Infos auslesen
    ' ----------------------------------------------------------------------
    
    GetEventInfo msEPGID, msEPGFileName
                      
    ' ----------------------------------------------------------------------
    ' Wingrabengine initialisieren
    ' ----------------------------------------------------------------------
    
    Set moGrabLibrary = New WinGrabLibrary
        
    ' ----------------------------------------------------------------------
    ' Starten des grabens -> MuxGrab
    ' ----------------------------------------------------------------------
    
    moFileSystemInfo.sItem(M2PFile) = msM2PFileName
    moFileSystemInfo.sItem(M2AFile) = msM2AFileName
    moFileSystemInfo.sItem(M2VFile) = msM2VFileName
    moFileSystemInfo.sItem(LOGFile) = msLOGFileName
    moFileSystemInfo.sItem(EPGFile) = msEPGFileName
    
    Select Case moSettings.nItem(NLSWGEStreamType)
        Case 0
            Set moGrabControl = moGrabLibrary.StartDirectGrabEx(moSettings.sItem(NLSDBoxIPAdress), msVideoPID, msAudioPID, msM2VFileName, msM2AFileName, False, False, Me)

        Case 1
            Set moGrabControl = moGrabLibrary.StartMuxGrabEx(moSettings.sItem(NLSDBoxIPAdress), msVideoPID, msAudioPID, msM2PFileName, moSettings.nItem(NLSWGESplitFile), Me)
                           
            'LYNX
            'Für Audio!!!
            'Set moGrabControl = moGrabLibrary.StartDirectGrabEx(moSettings.sItem(NLSDBoxIPAdress), "0", msAudioPID, "", msM2AFileName, False, False, Me)

    End Select

    RaiseEvent ConnectionStateChanged(Streaming)

End Sub

Public Sub GrabStop()
    
    If Not moGrabControl Is Nothing Then
    
        moGrabControl.Stop
        Set moGrabControl = Nothing
    
        If moSettings.nItem(NLSWriteLog) = 1 Then
    
            If WriteLog(msLOGFileName, msLog, False) = False Then
                MsgBox "Fehler beim Schreiben der Log-Datei!"
            End If
        
        End If
        
    End If
        
    RaiseEvent ConnectionStateChanged(Connected)
    
End Sub

Private Function msFilenameCheck(ByVal sFilename As String) As String

    Dim sResult As String
    Dim nAsc As Integer
    Dim nCnt As Integer
    
    For nCnt = 1 To Len(sFilename)
        nAsc = Asc(Mid(sFilename, nCnt, 1))
        
        If (nAsc > 64 And nAsc < 91) _
            Or (nAsc > 96 And nAsc < 123) _
            Or (nAsc > 47 And nAsc < 58) _
            Or (nAsc = Asc(" ")) _
            Or (nAsc = Asc("(")) _
            Or (nAsc = Asc(")")) _
            Or (nAsc = Asc(".")) Then
            
            sResult = sResult & Chr(nAsc)
        
        End If
        
    Next
    
    msFilenameCheck = sResult
    
End Function

Private Function mdtDBoxDateGet() As Date

    Dim strTime As String
    Dim strDate As String

    strTime = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/gettime")
    strDate = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/getdate")
    mdtDBoxDateGet = CDate(Left(strDate, 10) & " " & Left(strTime, 10))

End Function

Private Sub GetEventInfo(strEpgid As String, epgtxt As String)

Dim nstrlen As Integer
Dim nx1 As Integer
Dim nX2 As Integer
Dim nX3 As Integer

Dim nepginfo As String
Dim nlastlf As Integer

Dim titel As String
Dim filminfo As String
Dim genre As String

    nepginfo = gsURLOpen("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/epg?eventid=" & strEpgid)

    nstrlen = Len(nepginfo)
    nlastlf = 1

    For nx1 = 1 To nstrlen
    If Mid(nepginfo, nx1, 1) = vbLf Then
    Dim leer As String
    titel = Mid(nepginfo, 1, nx1)

    For nX2 = nx1 + 1 To nstrlen
    If Mid(nepginfo, nX2, 1) = vbLf Then

    genre = Mid(nepginfo, nx1 + 1, nX2 - nx1)

    For nX3 = nX2 + 1 To nstrlen
    If Mid(nepginfo, nX3, 1) = vbLf Then

    filminfo = Mid(nepginfo, nX2 + 1, nstrlen)
    
    ' Wenn GrabTxt gesetzt ist aus der INI, dann auch schreiben
    If moSettings.nItem(NLSWriteEPG) = 1 Then
        
        'Dim temp As String
        
        'temp = InStr(titel, vbLf)
        'titel = Mid(titel, 1, temp - 1)
        titel = titel & vbCrLf
        
        'temp = InStr(genre, vbLf)
        'genre = Mid(genre, 1, temp - 1)
        genre = genre & vbCrLf
        
        'temp = InStr(filminfo, vbLf)
        'filminfo = Mid(filminfo, 1, temp - 1)
        filminfo = filminfo & vbCrLf
        
        If WriteLog(msEPGFileName, "Titel: " & titel, False) = False Then
            MsgBox "Fehler beim Schreiben der Log-Datei!"
        End If

        If WriteLog(msEPGFileName, "Genre: " & genre, False) = False Then
            MsgBox "Fehler beim Schreiben der Log-Datei!"
        End If

        If WriteLog(msEPGFileName, "Beschreibung: " & filminfo, False) = False Then
            MsgBox "Fehler beim Schreiben der Log-Datei!"
        End If
        
    End If


    Exit For
    End If
    Next nX3

    Exit For
    End If
    Next nX2

    Exit For
    End If
    Next nx1
       
End Sub

Private Function WriteLog(astrPfad As String, astrText As String, astrDate As Boolean) As Boolean

    Dim lintFileNr As Integer

    On Error GoTo ErrHandler

    lintFileNr = FreeFile
    
    Open astrPfad For Append As #lintFileNr   ' Datei öffnen.
    
        If astrDate = True Then
            
            Print #lintFileNr, Now & " " & astrText
        
        Else
        
            Print #lintFileNr, astrText
            
        End If
        
    Close #lintFileNr
        
    WriteLog = True
            
Exit Function

ErrHandler:

WriteLog = False

End Function

Private Sub Class_Terminate()

    Select Case modBoxInfo.sItem(httpdversion)
        Case 1
            gsURLOpen ("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/popup=Streamingserver wurde beendet!")
        Case 2
            gsURLOpen ("http://" & moSettings.sItem(NLSDBoxIPAdress) & "/control/message?popup=Streamingserver beendet!")
    End Select

End Sub

Private Sub IWinGrabProcessCallback_OnMessage(ByVal sMessage As String)

    msMessages = msMessages & Now & " " & sMessage & vbCrLf
    
End Sub

Private Sub IWinGrabProcessCallback_OnStateChange(ByVal sName As String, ByVal sState As String)
  
    moStateMessages.sItem(sName) = sState

End Sub

