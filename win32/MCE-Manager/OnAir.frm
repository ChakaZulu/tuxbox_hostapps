VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form OnAir 
   BackColor       =   &H00808080&
   Caption         =   "On Air"
   ClientHeight    =   5055
   ClientLeft      =   5700
   ClientTop       =   3615
   ClientWidth     =   5025
   Icon            =   "OnAir.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5055
   ScaleWidth      =   5025
   Begin VB.ComboBox onairsender 
      BackColor       =   &H00000000&
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
      Height          =   315
      Left            =   240
      Style           =   2  'Dropdown-Liste
      TabIndex        =   6
      Top             =   480
      Width           =   4575
   End
   Begin VB.TextBox onairint 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   4
      Top             =   1320
      Width           =   4575
   End
   Begin VB.TextBox onairtit 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   3
      Top             =   1920
      Width           =   4575
   End
   Begin VB.TextBox onairalb 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   2
      Top             =   2520
      Width           =   4575
   End
   Begin VB.TextBox onairlab 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   1
      Top             =   3120
      Width           =   4575
   End
   Begin VB.TextBox onairjah 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   0
      Top             =   3720
      Width           =   4575
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   5
      Top             =   4320
      Width           =   4575
      _ExtentX        =   8070
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
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Jahr:"
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
      Index           =   5
      Left            =   240
      TabIndex        =   12
      Top             =   3480
      Width           =   4575
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Label:"
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
      Index           =   4
      Left            =   240
      TabIndex        =   11
      Top             =   2880
      Width           =   4575
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Album:"
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
      Index           =   3
      Left            =   240
      TabIndex        =   10
      Top             =   2280
      Width           =   4575
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Titel:"
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
      Index           =   2
      Left            =   240
      TabIndex        =   9
      Top             =   1680
      Width           =   4575
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Interpret:"
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
      Index           =   1
      Left            =   240
      TabIndex        =   8
      Top             =   1080
      Width           =   4575
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Sender Auswahl:"
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
      TabIndex        =   7
      Top             =   240
      Width           =   4575
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4080
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   4080
      Y2              =   120
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   4080
      Y2              =   4080
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4200
      Y2              =   4920
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   4200
      Y2              =   4200
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   4920
      Y2              =   4920
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   4200
      Y2              =   4920
   End
End
Attribute VB_Name = "OnAir"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents logger As logger
Attribute logger.VB_VarHelpID = -1
Private IDint(0 To 20) As String
Private IDtit(0 To 20) As String
Private IDalb(0 To 20) As String
Private IDlab(0 To 20) As String
Private IDjah(0 To 20) As String
Private Sub OK_Click()
    OnAir.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Public Sub loggerstart()
    Set logger = New logger
    Call senddata
    Call logger.plstart(d2set.IP.Text, d2set.Port.Text)
    frmMain.pldatenstream.Caption = "initialisiert"
End Sub
Public Sub loggerstop()
    Set logger = New logger
    Call logger.plstop
    frmMain.pldatenstream.Caption = vbNullString
    Set logger = Nothing
End Sub
Private Sub senddata()
    Dim loggerplay(0 To 20) As String, kennungplay(0 To 20) As String, i As Integer
    
    For i = 0 To 20
        loggerplay(i) = PlaylistLoggerSettings.loggerpl(i).Caption
        kennungplay(i) = PlaylistLoggerSettings.kennung(i).Text
    Next i
    
    Call logger.Daten(loggerplay(), kennungplay(), App.Path + "\playlists\Logged Playlists\")
End Sub
Private Sub logger_Newsongid(Newsongidint As String, Newsongidtit As String, Newsongidalb As String, Newsongidlab As String, Newsongidjah As String, id As Integer)
    IDint(id) = Newsongidint
    IDtit(id) = Newsongidtit
    IDalb(id) = Newsongidalb
    IDlab(id) = Newsongidlab
    IDjah(id) = Newsongidjah
    
    If onairsender.ListIndex = id Then
        OnAir.onairint.Text = Newsongidint
        OnAir.onairtit.Text = Newsongidtit
        OnAir.onairalb.Text = Newsongidalb
        OnAir.onairlab.Text = Newsongidlab
        OnAir.onairjah.Text = Newsongidjah
    End If
End Sub
Private Sub onairsender_click()
    OnAir.onairint.Text = IDint(onairsender.ListIndex)
    OnAir.onairtit.Text = IDtit(onairsender.ListIndex)
    OnAir.onairalb.Text = IDalb(onairsender.ListIndex)
    OnAir.onairlab.Text = IDlab(onairsender.ListIndex)
    OnAir.onairjah.Text = IDjah(onairsender.ListIndex)
End Sub
