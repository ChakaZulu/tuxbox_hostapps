VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form oggmenu 
   BackColor       =   &H00808080&
   ClientHeight    =   4830
   ClientLeft      =   5700
   ClientTop       =   3855
   ClientWidth     =   5040
   Icon            =   "oggmenu.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4830
   ScaleWidth      =   5040
   Begin VB.ComboBox abrbit 
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
      ItemData        =   "oggmenu.frx":08CA
      Left            =   240
      List            =   "oggmenu.frx":08F5
      Style           =   2  'Dropdown-Liste
      TabIndex        =   12
      Top             =   2280
      Width           =   4575
   End
   Begin VB.CheckBox abraktiv 
      BackColor       =   &H00808080&
      Caption         =   "Mittlere Bitrate"
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
      TabIndex        =   11
      Top             =   2040
      Width           =   1935
   End
   Begin VB.CheckBox minaktiv 
      BackColor       =   &H00808080&
      Caption         =   "Minimum Bitrate"
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
      TabIndex        =   10
      Top             =   1320
      Width           =   1935
   End
   Begin VB.CheckBox maxaktiv 
      BackColor       =   &H00808080&
      Caption         =   "Maximum Bitrate"
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
      TabIndex        =   9
      Top             =   600
      Width           =   1935
   End
   Begin VB.ComboBox maxbit 
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
      ItemData        =   "oggmenu.frx":0934
      Left            =   240
      List            =   "oggmenu.frx":095F
      Style           =   2  'Dropdown-Liste
      TabIndex        =   4
      Top             =   840
      Width           =   4575
   End
   Begin VB.ComboBox minbit 
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
      ItemData        =   "oggmenu.frx":099E
      Left            =   240
      List            =   "oggmenu.frx":09C9
      Style           =   2  'Dropdown-Liste
      TabIndex        =   3
      Top             =   1560
      Width           =   4575
   End
   Begin VB.OptionButton managementengine 
      BackColor       =   &H00808080&
      Caption         =   "Bitrate Management Engine"
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
      Top             =   240
      Value           =   -1  'True
      Width           =   4575
   End
   Begin VB.OptionButton normalengine 
      BackColor       =   &H00808080&
      Caption         =   "Normale Engine"
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
      TabIndex        =   1
      Top             =   2760
      Width           =   4575
   End
   Begin ActSlider.SliderPic Slider1 
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   3360
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      ImageSlider     =   "oggmenu.frx":0A08
      ImageLeft       =   "oggmenu.frx":1C02
      ImagePointer    =   "oggmenu.frx":2DFC
      BackStyle       =   0
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   5
      Top             =   4080
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
      TabIndex        =   13
      Top             =   3180
      Width           =   735
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Qualität:"
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
      TabIndex        =   8
      Top             =   3120
      Width           =   4575
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "high"
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
      Left            =   3480
      TabIndex        =   7
      Top             =   3600
      Width           =   1335
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "low"
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
      TabIndex        =   6
      Top             =   3600
      Width           =   1215
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
      Y1              =   3840
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   3840
      Y2              =   3840
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   120
      Y2              =   3840
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3960
      Y2              =   3960
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4680
      Y2              =   3960
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   4680
      Y2              =   3960
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   4680
      Y2              =   4680
   End
End
Attribute VB_Name = "oggmenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    If managementengine = "1" Then
        If maxaktiv = "1" Then OGGparameter = "-M " + maxbit.Text
        If minaktiv = "1" Then OGGparameter = OGGparameter + " -m " + minbit.Text
        If abraktiv = "1" Then OGGparameter = OGGparameter + " -b " + abrbit.Text
    Else
        OGGparameter = "-q " + Str$(Slider1.CurPosition)
    End If

    oggmenu.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub Slider1_PositionChanged(oldPosition As Long, newPosition As Long)
    oggmenu.value.Caption = newPosition
End Sub
