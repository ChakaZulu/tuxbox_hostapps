VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form MP3vbrmenu 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   4725
   ClientLeft      =   5550
   ClientTop       =   3600
   ClientWidth     =   5055
   Icon            =   "MP3vbrmenu.frx":0000
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4725
   ScaleWidth      =   5055
   Begin ActSlider.SliderPic Slider1 
      Height          =   255
      Left            =   240
      TabIndex        =   11
      Top             =   3240
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   9
      ImageSlider     =   "MP3vbrmenu.frx":08CA
      ImageLeft       =   "MP3vbrmenu.frx":1AC4
      ImagePointer    =   "MP3vbrmenu.frx":2CBE
      BackStyle       =   0
   End
   Begin VB.OptionButton alt 
      BackColor       =   &H00808080&
      Caption         =   "Alte Methode"
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
      Top             =   480
      Width           =   4575
   End
   Begin VB.OptionButton neu 
      BackColor       =   &H00808080&
      Caption         =   "Neue Methode"
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
      Top             =   240
      Value           =   -1  'True
      Width           =   4575
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
      ItemData        =   "MP3vbrmenu.frx":2E64
      Left            =   240
      List            =   "MP3vbrmenu.frx":2E71
      Style           =   2  'Dropdown-Liste
      TabIndex        =   2
      Top             =   2520
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
      ItemData        =   "MP3vbrmenu.frx":2E92
      Left            =   240
      List            =   "MP3vbrmenu.frx":2EC0
      Style           =   2  'Dropdown-Liste
      TabIndex        =   1
      Top             =   1800
      Width           =   4575
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
      ItemData        =   "MP3vbrmenu.frx":2F03
      Left            =   240
      List            =   "MP3vbrmenu.frx":2F31
      Style           =   2  'Dropdown-Liste
      TabIndex        =   0
      Top             =   1080
      Width           =   4575
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   12
      Top             =   3960
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
      Top             =   3060
      Width           =   735
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   4560
      Y2              =   4560
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   4560
      Y2              =   3840
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4560
      Y2              =   3840
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3840
      Y2              =   3840
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   120
      Y2              =   3720
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   3720
      Y2              =   3720
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   3720
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Rechts
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
      Left            =   3600
      TabIndex        =   8
      Top             =   3480
      Width           =   1215
   End
   Begin VB.Label Label6 
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
      Left            =   240
      TabIndex        =   7
      Top             =   3480
      Width           =   1335
   End
   Begin VB.Label Label5 
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
      TabIndex        =   6
      Top             =   3000
      Width           =   4575
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Stereomode"
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
      TabIndex        =   5
      Top             =   2280
      Width           =   4815
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Minimum Bitrate"
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
      Top             =   1560
      Width           =   4815
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Maximum Bitrate"
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
      Top             =   840
      Width           =   4695
   End
End
Attribute VB_Name = "MP3vbrmenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    Dim mode As String, vbrmode As String
    
    Select Case MP3vbrmenu.stereomode.Text
        Case Is = "stereo"
            mode = "s"
        Case Is = "joined stereo"
            mode = "f"
        Case Is = "mono"
            mode = "m"
    End Select
    
    If Int(MP3vbrmenu.minbit.Text) > Int(MP3vbrmenu.maxbit.Text) Then
        MsgBox "Minimum is higher than maximum!"
        Exit Sub
    End If
        
    If Int(MP3vbrmenu.minbit.Text) = Int(MP3vbrmenu.maxbit.Text) Then
        MsgBox "Minimum and maximum are ident. Please use in this case, the CBR!"
        Exit Sub
    End If
    
    If MP3vbrmenu.neu.value = "1" Then
        vbrmode = "--vbr-new "
    Else
        vbrmode = "--vbr-old "
    End If
    
    MP3vbrparameter = vbrmode + "-q " + Str$(MP3vbrmenu.Slider1.CurPosition) + " -m " + mode + " -b " + MP3vbrmenu.minbit.Text + " -B " + MP3vbrmenu.maxbit.Text + " --priority " + shell_prio
    MP3vbrmenu.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub Slider1_PositionChanged(oldPosition As Long, newPosition As Long)
    MP3vbrmenu.value.Caption = newPosition
End Sub
