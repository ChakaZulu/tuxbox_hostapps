VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Object = "{7A3134F8-8B34-4546-B016-D82D86DFBB3B}#1.0#0"; "ProgressBar.ocx"
Begin VB.Form Database 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   7560
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5400
   BeginProperty Font 
      Name            =   "Trebuchet MS"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Database.frx":0000
   LinkTopic       =   "MainForm"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MousePointer    =   4  'Symbol
   ScaleHeight     =   7560
   ScaleWidth      =   5400
   StartUpPosition =   2  'Bildschirmmitte
   Begin VB.DriveListBox drivechg 
      Appearance      =   0  '2D
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   240
      TabIndex        =   1
      Top             =   240
      Width           =   4920
   End
   Begin VB.DirListBox Dir1 
      Appearance      =   0  '2D
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3690
      Left            =   240
      TabIndex        =   0
      Top             =   720
      Width           =   4890
   End
   Begin ProgressBar2.cpvProgressBar Progress 
      Height          =   225
      Left            =   240
      Top             =   6240
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   397
      BarPicture      =   "Database.frx":08CA
      BarPictureBack  =   "Database.frx":4300
      CaptionFormat   =   7
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontColor       =   0
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   3
      Top             =   6840
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   873
      Appearance      =   15
      Caption         =   "OK"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   16777215
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton addsubs 
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   4560
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Songs hinzufügen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   16777215
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Keine Info:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Index           =   4
      Left            =   240
      TabIndex        =   12
      Top             =   6000
      Width           =   1215
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Vorhanden:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Index           =   3
      Left            =   240
      TabIndex        =   11
      Top             =   5760
      Width           =   1215
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Hinzugefügt:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   10
      Top             =   5520
      Width           =   1215
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Insgesamt:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   9
      Top             =   5280
      Width           =   1215
   End
   Begin VB.Label dbrecordsetsnoinfo 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1320
      TabIndex        =   8
      Top             =   6000
      Width           =   3855
   End
   Begin VB.Label dbrecordsetsalt 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1320
      TabIndex        =   7
      Top             =   5760
      Width           =   3855
   End
   Begin VB.Label dbrecordsetsneu 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1320
      TabIndex        =   6
      Top             =   5520
      Width           =   3615
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Informationen:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   5
      Top             =   5040
      Width           =   2055
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   5280
      Y1              =   7440
      Y2              =   7440
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   6720
      Y2              =   7440
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   5280
      X2              =   120
      Y1              =   6720
      Y2              =   6720
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   5280
      X2              =   5280
      Y1              =   7440
      Y2              =   6720
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   5280
      X2              =   120
      Y1              =   6600
      Y2              =   6600
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   5280
      X2              =   5280
      Y1              =   120
      Y2              =   6600
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   5280
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   6600
   End
   Begin VB.Label Songanzahl 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1320
      TabIndex        =   2
      Top             =   5280
      Width           =   3615
   End
End
Attribute VB_Name = "Database"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub addsubs_Click()
    Dim firstpath As String, i As Long, files() As String
    
    'Rücksetzen
    Database.Songanzahl.Caption = "0"
    Database.dbrecordsetsneu.Caption = "0"
    Database.dbrecordsetsalt.Caption = "0"
    Database.dbrecordsetsnoinfo.Caption = "0"
    
    'Verriegelung ein
    Database.OK.Enabled = "0"
    Database.OK.ForeColor = &H80000015 'Buttonfarbe ändern
    Database.addsubs.ForeColor = &H80000015 'Buttonfarbe ändern
    Database.addsubs.Enabled = "0"
    Call Werkzeuge.DisableClose(Database.hWnd)
    
    firstpath = Dir1.Path
    Call suche(extension, firstpath, files(), "1")
    If UBound(files) > 1 Then Progress.Max = UBound(files) - 1
    
    For i = 1 To UBound(files) - 1 'Anzahl der gefundenen files
        If frmMain.turbo.Value = "0" Then DoEvents
        
        Select Case datab(files(i))
            Case 0
                dbrecordsetsalt = Int(dbrecordsetsalt) + 1
            Case 1
                dbrecordsetsneu = Int(dbrecordsetsneu) + 1
            Case 2
                dbrecordsetsnoinfo = Int(dbrecordsetsnoinfo) + 1
        End Select
        
        Progress.Value = i
    Next i
    
    MsgBox "Ready"
    
    'Verriegelung aus
    Database.addsubs.ForeColor = &H80000018 'Buttonfarbe ändern
    Database.addsubs.Enabled = "1"
    Database.OK.Enabled = "1"
    Database.OK.ForeColor = &H80000018 'Buttonfarbe ändern
    Call Werkzeuge.enableClose(Database.hWnd)
End Sub
Private Sub Drivechg_Change()
    Dir1.Path = drivechg.Drive
End Sub
Private Sub Form_Load()
    drivechg.Drive = "C"
    Dir1.Path = "C:\"
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call Verriegelung.verriegelungaus
    frmMain.abbrechen.ForeColor = &H80000018 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "1"
    frmMain.Timer1.Enabled = "1"
    Database.Hide
    frmMain.Show
End Sub
Private Sub OK_Click()
    Call Form_unLoad(1)
End Sub
