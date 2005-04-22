VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Object = "{835A1DB1-C969-4BDB-B9C9-4D0C83ACDDA4}#1.0#0"; "ActSlider.ocx"
Begin VB.Form tagging 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   4950
   ClientLeft      =   5340
   ClientTop       =   3075
   ClientWidth     =   5070
   Icon            =   "tagging.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4950
   ScaleWidth      =   5070
   Begin ActSlider.SliderPic delsize 
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   13
      TabStop         =   0   'False
      Top             =   1200
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   2000
      ImageSlider     =   "tagging.frx":08CA
      ImageLeft       =   "tagging.frx":1AC4
      ImagePointer    =   "tagging.frx":2CBE
      BackStyle       =   0
      MaskColor       =   8421504
   End
   Begin ActSlider.SliderPic drift 
      Height          =   255
      Left            =   240
      TabIndex        =   12
      TabStop         =   0   'False
      Top             =   480
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   119
      ImageSlider     =   "tagging.frx":2E64
      ImageLeft       =   "tagging.frx":405E
      ImagePointer    =   "tagging.frx":5258
      BackStyle       =   0
      MaskColor       =   8421504
   End
   Begin VB.ComboBox zeitauswahl 
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
      ItemData        =   "tagging.frx":53FE
      Left            =   240
      List            =   "tagging.frx":5408
      Style           =   2  'Dropdown List
      TabIndex        =   10
      TabStop         =   0   'False
      Top             =   3480
      Width           =   4605
   End
   Begin VB.ComboBox korrsymbol 
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
      ItemData        =   "tagging.frx":5422
      Left            =   240
      List            =   "tagging.frx":542F
      Style           =   2  'Dropdown List
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   2760
      Width           =   4605
   End
   Begin ActSlider.SliderPic dauerslider 
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   18
      TabStop         =   0   'False
      Top             =   1920
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   20
      ImageSlider     =   "tagging.frx":5467
      ImageLeft       =   "tagging.frx":6661
      ImagePointer    =   "tagging.frx":785B
      BackStyle       =   0
      MaskColor       =   8421504
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   25
      TabStop         =   0   'False
      Top             =   4200
      Width           =   4605
      _ExtentX        =   8123
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
      Alignment       =   1  'Right Justify
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
      TabIndex        =   28
      Top             =   1740
      Width           =   735
   End
   Begin VB.Label value 
      Alignment       =   1  'Right Justify
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
      TabIndex        =   27
      Top             =   960
      Width           =   735
   End
   Begin VB.Label value 
      Alignment       =   1  'Right Justify
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
      Left            =   3960
      TabIndex        =   26
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label20 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "20"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   4200
      TabIndex        =   24
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label19 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "15"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Left            =   3360
      TabIndex        =   23
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label18 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "10"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   2160
      TabIndex        =   22
      Top             =   2160
      Width           =   735
   End
   Begin VB.Label Label17 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "5"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   1200
      TabIndex        =   21
      Top             =   2160
      Width           =   375
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "0"
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
      TabIndex        =   20
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Driftrate / MP2 Längenabweichung"
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
      TabIndex        =   19
      Top             =   1680
      Width           =   3735
   End
   Begin VB.Label Label16 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "1500"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Left            =   3240
      TabIndex        =   17
      Top             =   1440
      Width           =   855
   End
   Begin VB.Label Label15 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "500"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   1080
      TabIndex        =   16
      Top             =   1440
      Width           =   735
   End
   Begin VB.Label Label14 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "30"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   1080
      TabIndex        =   15
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label13 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "90"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Left            =   3360
      TabIndex        =   14
      Top             =   720
      Width           =   615
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   4080
      Y2              =   4800
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   4800
      Y2              =   4800
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   120
      Y1              =   4080
      Y2              =   4080
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4080
      Y2              =   4800
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   4920
      X2              =   4920
      Y1              =   120
      Y2              =   3960
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   3960
      Y2              =   3960
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   3960
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4920
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Nach welcher Zeit soll getagget werden?"
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
      TabIndex        =   11
      Top             =   3240
      Width           =   4935
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "2000"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   4440
      TabIndex        =   9
      Top             =   1440
      Width           =   495
   End
   Begin VB.Label Label8 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "1000"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   2160
      TabIndex        =   8
      Top             =   1440
      Width           =   735
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "0"
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
      Top             =   1440
      Width           =   255
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "MP2s unter <kb> löschen"
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
      Top             =   960
      Width           =   4695
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Korrertur Symbol"
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
      Top             =   2520
      Width           =   4935
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "120"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   4080
      TabIndex        =   4
      Top             =   720
      Width           =   735
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "60"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   2280
      TabIndex        =   3
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "0"
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
      Width           =   1335
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Driftrate in sekunden:"
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
      TabIndex        =   1
      Top             =   240
      Width           =   4695
   End
End
Attribute VB_Name = "tagging"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub dauerslider_PositionChanged(Index As Integer, oldPosition As Long, newPosition As Long)
    tagging.value(2).Caption = newPosition
End Sub
Private Sub delsize_PositionChanged(Index As Integer, oldPosition As Long, newPosition As Long)
    tagging.value(1).Caption = newPosition
End Sub
Private Sub drift_PositionChanged(oldPosition As Long, newPosition As Long)
    tagging.value(0).Caption = newPosition
End Sub
Private Sub OK_Click()
    tagging.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
