VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{797630EB-49AE-4367-92B6-BAA93930814B}#2.0#0"; "NGrabTrayIcon10.ocx"
Begin VB.Form frmNGrabMain 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "NGrab"
   ClientHeight    =   6735
   ClientLeft      =   150
   ClientTop       =   105
   ClientWidth     =   7905
   Icon            =   "frmNGrabMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6735
   ScaleWidth      =   7905
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'Bildschirmmitte
   Begin MSComctlLib.ImageList imlTrayIcon 
      Left            =   5475
      Top             =   5865
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmNGrabMain.frx":08CA
            Key             =   "Disconnected"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmNGrabMain.frx":0A24
            Key             =   "Connected"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmNGrabMain.frx":0B7E
            Key             =   "Streaming"
         EndProperty
      EndProperty
   End
   Begin MSWinsockLib.Winsock ocxWinsock 
      Left            =   6645
      Top             =   6030
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   4000
   End
   Begin VB.Frame Frame3 
      Appearance      =   0  '2D
      Caption         =   "Status"
      ForeColor       =   &H80000008&
      Height          =   2460
      Left            =   90
      TabIndex        =   15
      Top             =   4170
      Width           =   7710
      Begin VB.Timer ocxTimer 
         Enabled         =   0   'False
         Interval        =   1500
         Left            =   7065
         Top             =   1800
      End
      Begin NOXTrayIcon10.ctlNOXTrayIcon ocxTrayIcon 
         Left            =   6030
         Top             =   1725
         _ExtentX        =   847
         _ExtentY        =   847
      End
      Begin MSComctlLib.ListView lvStateMessages 
         Height          =   2070
         Left            =   135
         TabIndex        =   16
         Top             =   255
         Width           =   7425
         _ExtentX        =   13097
         _ExtentY        =   3651
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   0   'False
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483633
         Appearance      =   0
         NumItems        =   2
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Thread"
            Object.Width           =   3210
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "Status"
            Object.Width           =   9895
         EndProperty
      End
   End
   Begin VB.Frame Frame2 
      Appearance      =   0  '2D
      Caption         =   "Nachrichten"
      ForeColor       =   &H80000008&
      Height          =   2565
      Left            =   90
      TabIndex        =   13
      Top             =   1575
      Width           =   7710
      Begin VB.TextBox txtMessages 
         Appearance      =   0  '2D
         BackColor       =   &H8000000B&
         BorderStyle     =   0  'Kein
         Height          =   2145
         Left            =   150
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertikal
         TabIndex        =   14
         Top             =   285
         Width           =   7410
      End
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  '2D
      Caption         =   "Programm Informationen"
      ForeColor       =   &H80000008&
      Height          =   1470
      Left            =   90
      TabIndex        =   0
      Top             =   75
      Width           =   7710
      Begin VB.TextBox txtChannelName 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   1470
         TabIndex        =   6
         Top             =   315
         Width           =   3135
      End
      Begin VB.TextBox txtONIDSID 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   5700
         TabIndex        =   5
         Top             =   315
         Width           =   1815
      End
      Begin VB.TextBox txtEPGID 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   5700
         TabIndex        =   4
         Top             =   660
         Width           =   1815
      End
      Begin VB.TextBox txtEPGTitle 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   1470
         TabIndex        =   3
         Top             =   675
         Width           =   3135
      End
      Begin VB.TextBox txtVideoPID 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   1470
         TabIndex        =   2
         Top             =   1035
         Width           =   855
      End
      Begin VB.TextBox txtAudioPID 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   225
         Left            =   5700
         TabIndex        =   1
         Top             =   1035
         Width           =   855
      End
      Begin VB.Label Label4 
         Appearance      =   0  '2D
         Caption         =   "Programm Name"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   150
         TabIndex        =   12
         Top             =   315
         Width           =   1215
      End
      Begin VB.Label Label5 
         Appearance      =   0  '2D
         Caption         =   "Onidid"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   4830
         TabIndex        =   11
         Top             =   315
         Width           =   1215
      End
      Begin VB.Label Label6 
         Appearance      =   0  '2D
         Caption         =   "EPG ID"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   4830
         TabIndex        =   10
         Top             =   675
         Width           =   1215
      End
      Begin VB.Label Label7 
         Appearance      =   0  '2D
         Caption         =   "EPG Titel"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   150
         TabIndex        =   9
         Top             =   675
         Width           =   1215
      End
      Begin VB.Label Label8 
         Appearance      =   0  '2D
         Caption         =   "Video PID"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   165
         TabIndex        =   8
         Top             =   1035
         Width           =   1215
      End
      Begin VB.Label Label9 
         Appearance      =   0  '2D
         Caption         =   "Audio PID"
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   4830
         TabIndex        =   7
         Top             =   1035
         Width           =   1215
      End
   End
   Begin VB.Menu mnuTrayMenu 
      Caption         =   "TrayMenu"
      Visible         =   0   'False
      Begin VB.Menu mnuTrayMenuShow 
         Caption         =   "&Status anzeigen..."
      End
      Begin VB.Menu mnuTrayMenuSetup 
         Caption         =   "&Einstellungen..."
      End
      Begin VB.Menu mnuTrayMenuSeperator1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuTrayMenuHelp 
         Caption         =   "&Hilfe"
      End
      Begin VB.Menu mnuTrayMenuSeperator2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuTrayMenuClose 
         Caption         =   "&Beenden"
      End
   End
End
Attribute VB_Name = "frmNGrabMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   frmNGrabMain.frm
' </NAME>
'
' <DESCRIPTION>
'   Hauptform von NGrab
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Reinhard Eidelsburger
' </COPYRIGHT>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' <HISTORY>
'   04.07.2002 - RE Hinzufügen der Dokumentation
'   06.07.2002 - RE Bugfixing von NGrab
'   09.07.2002 - RE Hinzufügen der Online Hilfe + neues Icon
'   25.07.2002 - LYNX Änderungen am Formulardesign, Formularnamen geändert (Notation), Variable bolFlagExit => bTerminate, Timer Steuerelement entfernt
'   26.07.2002 - LYNX HTMLHelp Object eingefügt
'   27.07.2002 - LYNX Form_MouseMove Ereignis entfernt (wird jetzt vom TrayIcon Steuerelement gemacht), Form_Resize Ereignis entfernt (es gibt keine minimieren Schaltfläche mehr :)), Winsock Control nach ocxWinsock umbenannt., Neue Sub mFormInit hinzugefügt., Objectvariable moSocket für Winsock hinzugefügt (HN), Objectvariable moTrayIcon für TrayIcon hinzugefügt (HN), Menüleiste ist jetzt kontextmenü des TrayIcon
'   30.07.2002 - LYNX ICMP Functions in externe DLL ausgelagert (NGrabICMPFct10.dll)
'   01.08.2002 - LYNX intFileCount entfernt. Aktuelle Uhrzeit nebst Datum eingesetzt :)
'   03.08.2002 - LYNX If => Else If durch Select Case ersetzt!
'   15.08.2002 - LYNX Kapselung der DBOX WinGrabEngine in die NGrabEngine (DLL)
'   30.10.2002 - LYNX Aufruf für DVD2SVCD geändert. Filename jetzt aus Engine Object. Modale Variable msM2PFileName entfernt.
'   01.11.2002 - LYNX ToolTip im TrayIcon bekommt jetzt Channelname und EPGTitle aus der NGrabEngine
'   10.11.2002 - LYNX Einige Änderungen am Formulardesign, Connection Handling zur DBox teilweise in die Engine gemacht
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Private WithEvents moSocket As Winsock
Attribute moSocket.VB_VarHelpID = -1
Private WithEvents moTrayIcon As ctlNOXTrayIcon
Attribute moTrayIcon.VB_VarHelpID = -1
Private WithEvents moTimer As Timer
Attribute moTimer.VB_VarHelpID = -1

Private WithEvents moEngine As clsNGrabEngine
Attribute moEngine.VB_VarHelpID = -1

Private mbTerminate As Boolean

Private Sub mFormInit()

    Me.Hide

    Set moSocket = Me.ocxWinsock
    Set moTrayIcon = Me.ocxTrayIcon
    Set moTimer = Me.ocxTimer
    
    Set moTrayIcon.Icon = Me.imlTrayIcon.ListImages(NLSStateDisconnected).Picture
    moTrayIcon.ToolTip = NLSAppTitle & " - " & NLSNGrabNoConnection
    moTrayIcon.Start
    
    Set moEngine = New clsNGrabEngine
    Set goEngine = moEngine
    
    Call moEngine.Init(goSettings)
        
    frmNGrabMain.Caption = NLSAppTitle & " " & App.Major & "." & App.Minor & "." & App.Revision
            
    If mbSocketInit Then
             
        moEngine.Connect
                     
    Else
    
        Call mStateChange(Disconnected)
    
    End If
                                 
End Sub

Private Function mbSocketInit() As Boolean

    On Error GoTo ERRSocketInit
        
    moSocket.Protocol = sckTCPProtocol
    moSocket.LocalPort = goSettings.lItem(NLSDBoxPort)
    moSocket.Listen
    
    mbSocketInit = True
    Exit Function
    
ERRSocketInit:
    
    mbSocketInit = False
    Exit Function
    
End Function

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  
    If KeyCode = vbKeyF1 Then
        goHelp.TopicShow
    End If
  
End Sub

Private Sub Form_Load()
   
    frmNGrabSplash.Show
    DoEvents
    Wait 1, "s"
    
    Call mFormInit
    
    Unload frmNGrabSplash
                        
End Sub

Private Sub Form_Unload(Cancel As Integer)
   
    If mbTerminate Then
        
        Set moEngine = Nothing
        moSocket.Close
        
    Else
        Cancel = True
        Me.Hide
    End If
            
End Sub

Private Sub mnuTrayMenuClose_Click()

    mbTerminate = True
    Unload Me

End Sub

Private Sub mnuTrayMenuSetup_Click()
    
    frmNgrabSetup.Show
    
End Sub

Private Sub mnuTrayMenuHelp_Click()

    goHelp.TopicShow

End Sub

Private Sub mnuTrayMenuShow_Click()

    Me.Show

End Sub

Private Sub moEngine_ConnectionStateChanged(nConnectionState As NGrabEngine10.ConnectionState)

    Call mStateChange(nConnectionState)

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   moSocket_ConnectionRequest
' </NAME>
'
' <DESCRIPTION>
'   Connect mit Winsock-Steuerelement
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub moSocket_ConnectionRequest(ByVal requestID As Long)
    
    ' ----------------------------------------------------------------------
    ' Winsock einstellen -> Connections werden akzeptiert!
    ' ----------------------------------------------------------------------
    
    Do Until moSocket.State = sckClosed
        moSocket.Close
        DoEvents
    Loop
    
    moSocket.Protocol = sckTCPProtocol
    moSocket.LocalPort = goSettings.nItem(NLSDBoxPort)
    moSocket.Accept requestID

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   moSocket_DataArrival
' </NAME>
'
' <DESCRIPTION>
'   Empfangen von Daten des Winsock-Steuerelement
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub moSocket_DataArrival(ByVal bytesTotal As Long)
                  
    Dim strData As String

    
    If (moSocket.State = sckConnected) Then
        moSocket.GetData strData, vbString, bytesTotal
    End If
     
    ' ----------------------------------------------------------------------
    ' Nach record oder stop suchen -> dann Unterprozeduren ausführen
    ' ----------------------------------------------------------------------
    If InStr(strData, "command=""record""") <> 0 Then
                
        moEngine.GrabStart strData
        
        moTimer.Enabled = True
        
        Me.txtChannelName = moEngine.StreamInfo.sItem(ChannelName)
        Me.txtEPGTitle = moEngine.StreamInfo.sItem(EPGTitle)
        Me.txtEPGID = moEngine.StreamInfo.sItem(EPGID)
        Me.txtONIDSID = moEngine.StreamInfo.sItem(ONIDSID)
        Me.txtVideoPID = moEngine.StreamInfo.sItem(VideoPID)
        Me.txtAudioPID = moEngine.StreamInfo.sItem(AudioPID)
                
    ElseIf InStr(strData, "command=""stop""") <> 0 Then
                                
        moEngine.GrabStop
    
        moTimer.Enabled = False
                        
        Me.lvStateMessages.ListItems.Clear
        Me.txtMessages = ""
                
        Me.txtChannelName = ""
        Me.txtEPGTitle = ""
        Me.txtEPGID = ""
        Me.txtONIDSID = ""
        Me.txtVideoPID = ""
        Me.txtAudioPID = ""
        
        ' Umwandlung ggf. starten
        If goSettings.sItem(NLSStartEnc) = 1 Then
            Call D2S_Start(moEngine.FileSystemInfo.sItem(M2PFile), 1)
        End If
        
    End If
        
    moSocket.Close
    moSocket.Listen

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   moSocket_Error
' </NAME>
'
' <DESCRIPTION>
'   Abfangen von Fehlern des Winsock-Controls
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub moSocket_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)

    MsgBox Description, 16, "Problem"

End Sub

Private Sub moTrayIcon_Click(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = vbRightButton Then
        PopupMenu mnuTrayMenu, , , , mnuTrayMenuShow
    End If

End Sub

Private Sub moTrayIcon_DblClick(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Me.Show

End Sub

Private Sub mStateChange(nState As ConnectionState)

    Select Case nState
    
        Case Disconnected
            Set moTrayIcon.Icon = Me.imlTrayIcon.ListImages(NLSStateDisconnected).Picture
            moTrayIcon.ToolTip = NLSAppTitle & " - " & NLSNGrabNoConnection
            moTrayIcon.Modify
    
        Case Connected
            Set moTrayIcon.Icon = Me.imlTrayIcon.ListImages(NLSStateConnected).Picture
            moTrayIcon.ToolTip = NLSAppTitle & " - " & NLSNGrabReady & goSettings.sItem(NLSDBoxIPAdress)
            moTrayIcon.Modify
        
        Case Streaming
            Set moTrayIcon.Icon = Me.imlTrayIcon.ListImages(NLSStateStreaming).Picture
            moTrayIcon.ToolTip = NLSAppTitle & " - " & moEngine.StreamInfo.sItem(EPGTitle) & " von " & moEngine.StreamInfo.sItem(ChannelName) & NLSNGrabRecord
            moTrayIcon.Modify

    End Select

End Sub

Private Sub moTimer_Timer()

    Call mMessagesUpdate
    Call mStateMessagesUpdate

End Sub

Private Sub mMessagesUpdate()

    Dim sMessage As String
    
    sMessage = moEngine.Messages
    
    If Len(sMessage) > 0 Then
        Me.txtMessages = Me.txtMessages & sMessage
        Me.txtMessages.SelStart = Len(Me.txtMessages)
    End If
    
End Sub

Private Sub mStateMessagesUpdate()

    Dim sKey As Variant
    Dim sItem As String
    Dim oListItem As ListItem

    For Each sKey In moEngine.StateMessages.colKeys
        
        sItem = sKey
        
        Set oListItem = Me.lvStateMessages.FindItem(sItem)
        
        If oListItem Is Nothing Then
            
            Set oListItem = Me.lvStateMessages.ListItems.Add(, , sItem)
            oListItem.ListSubItems.Add , , moEngine.StateMessages.sItem(sItem)
            
        Else
            
            oListItem.ListSubItems.Add 1, , moEngine.StateMessages.sItem(sItem)
        
        End If
        
    Next

End Sub
