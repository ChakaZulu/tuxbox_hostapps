VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form normal 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   3855
   ClientLeft      =   5685
   ClientTop       =   3720
   ClientWidth     =   5055
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "normal.frx":0000
   LinkTopic       =   "Normal"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3855
   ScaleWidth      =   5055
   Begin VB.OptionButton dbenable 
      BackColor       =   &H00808080&
      Caption         =   "Dezibel Normalisierung einschalten"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   12
      Top             =   1200
      Width           =   3495
   End
   Begin VB.OptionButton prozenable 
      BackColor       =   &H00808080&
      Caption         =   "Prozent Normalisierung einschalten"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   11
      Top             =   240
      Width           =   3855
   End
   Begin ActSlider.SliderPic peakprozslider 
      Height          =   255
      Left            =   240
      TabIndex        =   9
      Top             =   600
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   1
      Min             =   1
      Max             =   100
      ImageSlider     =   "normal.frx":08CA
      ImageLeft       =   "normal.frx":1AC4
      ImagePointer    =   "normal.frx":2CBE
      BackStyle       =   0
   End
   Begin ActSlider.SliderPic peakdbslider 
      Height          =   255
      Left            =   240
      TabIndex        =   8
      Top             =   1560
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   1
      Min             =   1
      ImageSlider     =   "normal.frx":2E64
      ImageLeft       =   "normal.frx":405E
      ImagePointer    =   "normal.frx":5258
      BackStyle       =   0
   End
   Begin ActSlider.SliderPic bufferslider 
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   2400
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      CurPosition     =   16
      Min             =   16
      Max             =   16384
      ImageSlider     =   "normal.frx":53FE
      ImageLeft       =   "normal.frx":65F8
      ImagePointer    =   "normal.frx":77F2
      BackStyle       =   0
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   10
      Top             =   3120
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
      Index           =   2
      Left            =   4080
      TabIndex        =   15
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
      Index           =   1
      Left            =   4080
      TabIndex        =   14
      Top             =   1380
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
      Top             =   420
      Width           =   735
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   3000
      Y2              =   3720
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   3720
      Y2              =   3720
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   3000
      Y2              =   3000
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   3000
      Y2              =   3720
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   2880
      Y2              =   2880
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   2880
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   2880
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label10 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "16384 kb"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   3720
      TabIndex        =   6
      Top             =   2640
      Width           =   1095
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "16 kb"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   2640
      Width           =   855
   End
   Begin VB.Label Label8 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "10 db"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   3360
      TabIndex        =   4
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "1 db"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   1800
      Width           =   1215
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "100 %"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   3960
      TabIndex        =   2
      Top             =   840
      Width           =   855
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "1 %"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   735
   End
   Begin VB.Label Label4 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Buffergröße:"
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
      TabIndex        =   0
      Top             =   2160
      Width           =   2175
   End
End
Attribute VB_Name = "normal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub bufferslider_PositionChanged(oldPosition As Long, newPosition As Long)
    normal.value(2).Caption = newPosition
End Sub
Private Sub OK_Click()
    If normal.dbenable.value = "1" Then
        normoptions = " -a " + Str$(normal.peakdbslider.CurPosition)
    Else
        normoptions = " -m " + Str$(normal.peakprozslider.CurPosition)
    End If
    
    normoptions = normoptions + " -b " + Str$(normal.bufferslider.CurPosition)
    normal.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Private Sub peakdbslider_PositionChanged(oldPosition As Long, newPosition As Long)
    normal.value(1).Caption = newPosition
End Sub
Private Sub peakprozslider_PositionChanged(oldPosition As Long, newPosition As Long)
    normal.value(0).Caption = newPosition
End Sub
