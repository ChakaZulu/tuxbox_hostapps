VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form Scannen 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   3975
   ClientLeft      =   6345
   ClientTop       =   3600
   ClientWidth     =   5070
   Icon            =   "Scannen.frx":0000
   LinkTopic       =   "scannen"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3975
   ScaleWidth      =   5070
   Begin ActSlider.SliderPic Slider_takt 
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   1560
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   1
      Min             =   1
      Max             =   59
      ImageSlider     =   "Scannen.frx":08CA
      ImageLeft       =   "Scannen.frx":1AC4
      ImagePointer    =   "Scannen.frx":2CBE
      BackStyle       =   0
   End
   Begin VB.OptionButton day_wahl 
      BackColor       =   &H00808080&
      Caption         =   "Tage"
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
      TabIndex        =   4
      Top             =   1200
      Width           =   3015
   End
   Begin VB.OptionButton hour_wahl 
      BackColor       =   &H00808080&
      Caption         =   "Stunden"
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
      TabIndex        =   3
      Top             =   960
      Width           =   4575
   End
   Begin VB.OptionButton min_wahl 
      BackColor       =   &H00808080&
      Caption         =   "Minuten"
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
      Top             =   720
      Value           =   -1  'True
      Width           =   4575
   End
   Begin VB.OptionButton sec_wahl 
      BackColor       =   &H00808080&
      Caption         =   "Sekunden"
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
      Top             =   480
      Width           =   4575
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   3240
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
   Begin ActSlider.SliderPic minfiles 
      Height          =   255
      Left            =   240
      TabIndex        =   9
      Top             =   2400
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   1
      Min             =   1
      Max             =   100
      ImageSlider     =   "Scannen.frx":2E64
      ImageLeft       =   "Scannen.frx":405E
      ImagePointer    =   "Scannen.frx":5258
      BackStyle       =   0
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
      Index           =   1
      Left            =   4080
      TabIndex        =   14
      Top             =   2220
      Width           =   735
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
      Index           =   0
      Left            =   4080
      TabIndex        =   13
      Top             =   1380
      Width           =   735
   End
   Begin VB.Label labelminfiles 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Ab X aufgenommenen Songs konvertieren:"
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
      TabIndex        =   12
      Top             =   2160
      Width           =   4935
   End
   Begin VB.Label label100 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "100"
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
      Left            =   3600
      TabIndex        =   11
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label label100 
      BackStyle       =   0  'Transparent
      Caption         =   "1"
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
      Index           =   0
      Left            =   240
      TabIndex        =   10
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   3120
      Y2              =   3840
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3840
      Y2              =   3840
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   3120
      Y2              =   3120
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   3120
      Y2              =   3840
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3000
      Y2              =   3000
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   120
      Y2              =   3000
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   3000
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Maximum 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "59"
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
      Left            =   3360
      TabIndex        =   6
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label Minimum 
      BackStyle       =   0  'Transparent
      Caption         =   "1"
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
      Top             =   1800
      Width           =   1215
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Interval:"
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
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   4935
   End
End
Attribute VB_Name = "Scannen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub minfiles_PositionChanged(oldPosition As Long, newPosition As Long)
    Scannen.value(1).Caption = newPosition
End Sub

Public Sub OK_Click()
    timeSeconds = 0
    timeMinutes = 0
    timehours = 0
    timedays = 0
    frmMain.countdo.Caption = "00:00:00"
    frmMain.tage.Caption = vbNullString
    Call sprach
    frmMain.Timer1.Enabled = "1"
    Scannen.Hide
    frmMain.Show
End Sub
Private Sub sec_wahl_Click()
    Scannen.Slider_takt.Min = 1
    Scannen.Slider_takt.Max = 59
    Scannen.Minimum.Caption = "1"
    Scannen.Maximum.Caption = "59"
    timeSeconds = 0
    timeMinutes = 0
    timehours = 0
    timedays = 0
End Sub
Private Sub min_wahl_Click()
    Scannen.Slider_takt.Min = 1
    Scannen.Slider_takt.Max = 59
    Scannen.Minimum.Caption = "1"
    Scannen.Maximum.Caption = "59"
    timeSeconds = 0
    timeMinutes = 0
    timehours = 0
    timedays = 0
End Sub
Private Sub hour_wahl_Click()
    Scannen.Slider_takt.Min = 1
    Scannen.Slider_takt.Max = 23
    Scannen.Minimum.Caption = "1"
    Scannen.Maximum.Caption = "23"
    timeSeconds = 0
    timeMinutes = 0
    timehours = 0
    timedays = 0
End Sub
Private Sub day_wahl_Click()
    Scannen.Slider_takt.Min = 1
    Scannen.Slider_takt.Max = 29
    Scannen.Minimum.Caption = "1"
    Scannen.Maximum.Caption = "29"
    timeSeconds = 0
    timeMinutes = 0
    timehours = 0
    timedays = 0
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub Slider_takt_PositionChanged(oldPosition As Long, newPosition As Long)
    Scannen.value(0).Caption = newPosition
End Sub
