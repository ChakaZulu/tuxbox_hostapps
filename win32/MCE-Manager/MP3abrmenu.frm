VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form MP3abrmenu 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   3390
   ClientLeft      =   5580
   ClientTop       =   3600
   ClientWidth     =   5055
   Icon            =   "MP3abrmenu.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3390
   ScaleWidth      =   5055
   Begin ActSlider.SliderPic Slider1 
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   1920
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   9
      ImageSlider     =   "MP3abrmenu.frx":08CA
      ImageLeft       =   "MP3abrmenu.frx":1AC4
      ImagePointer    =   "MP3abrmenu.frx":2CBE
      BackStyle       =   0
   End
   Begin VB.ComboBox stereomode 
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
      ItemData        =   "MP3abrmenu.frx":2E64
      Left            =   240
      List            =   "MP3abrmenu.frx":2E71
      Style           =   2  'Dropdown-Liste
      TabIndex        =   1
      Top             =   1200
      Width           =   4575
   End
   Begin VB.ComboBox abrbitrate 
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
      ItemData        =   "MP3abrmenu.frx":2E92
      Left            =   240
      List            =   "MP3abrmenu.frx":2EC0
      Style           =   2  'Dropdown-Liste
      TabIndex        =   0
      Top             =   480
      Width           =   4575
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   2640
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
   Begin VB.Label value 
      Alignment       =   1  'Rechts
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   4080
      TabIndex        =   9
      Top             =   1740
      Width           =   735
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   2400
      Y2              =   2400
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   2520
      Y2              =   3240
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   2520
      Y2              =   3240
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   2520
      Y2              =   2520
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   2400
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   120
      Y2              =   2400
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3240
      Y2              =   3240
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "Low"
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
      Left            =   4200
      TabIndex        =   6
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "High"
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
      Left            =   240
      TabIndex        =   5
      Top             =   2160
      Width           =   735
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Stereo Mode"
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
      Left            =   240
      TabIndex        =   4
      Top             =   960
      Width           =   4815
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Mittlere Bitrate"
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
      Left            =   240
      TabIndex        =   3
      Top             =   240
      Width           =   4695
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Rauschunterdrückung:"
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
      Left            =   240
      TabIndex        =   2
      Top             =   1680
      Width           =   4695
   End
End
Attribute VB_Name = "MP3abrmenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    Dim mode As String
    
    Select Case MP3abrmenu.stereomode.Text
        Case Is = "stereo"
            mode = "s"
        Case Is = "joined stereo"
            mode = "f"
        Case Is = "mono"
            mode = "m"
    End Select
    
    MP3abrparameter = "--abr " + MP3abrmenu.abrbitrate.Text + " -q " + Str$(Slider1.CurPosition) + " -m " + mode + " --priority " + shell_prio
    MP3abrmenu.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub Slider1_PositionChanged(oldPosition As Long, newPosition As Long)
    MP3abrmenu.value.Caption = newPosition
End Sub
