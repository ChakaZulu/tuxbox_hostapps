VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form mp3gain 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   2445
   ClientLeft      =   5445
   ClientTop       =   4455
   ClientWidth     =   5055
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "MP3Gain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2445
   ScaleWidth      =   5055
   Begin ActSlider.SliderPic Slider1 
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   960
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   1
      Min             =   1
      ImageSlider     =   "MP3Gain.frx":08CA
      ImageLeft       =   "MP3Gain.frx":1AC4
      ImagePointer    =   "MP3Gain.frx":2CBE
      BackStyle       =   0
   End
   Begin VB.OptionButton constant 
      BackColor       =   &H00808080&
      Caption         =   "Verstärkung über db Einstellung"
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
      TabIndex        =   1
      Top             =   600
      Width           =   3735
   End
   Begin VB.OptionButton auto 
      BackColor       =   &H00808080&
      Caption         =   "Automatische Anpassung"
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
      TabIndex        =   0
      Top             =   240
      Width           =   4575
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   5
      Top             =   1680
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
      TabIndex        =   6
      Top             =   780
      Width           =   735
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   1560
      Y2              =   2280
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   2280
      Y2              =   2280
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   1560
      Y2              =   1560
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   1560
      Y2              =   2280
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   1440
      Y2              =   1440
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   1440
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   1440
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "10 db"
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
      Left            =   4080
      TabIndex        =   3
      Top             =   1200
      Width           =   735
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "1 db"
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
      TabIndex        =   2
      Top             =   1200
      Width           =   615
   End
End
Attribute VB_Name = "mp3gain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    If mp3gain.constant.value = "1" Then
        mp3gainstring = " /c /d " + Str$(mp3gain.Slider1.CurPosition)
    Else
        mp3gainstring = " /c /r "
    End If
    
    mp3gain.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub Slider1_PositionChanged(oldPosition As Long, newPosition As Long)
    mp3gain.value.Caption = newPosition
End Sub
