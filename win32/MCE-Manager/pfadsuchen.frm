VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form Pfadsuchen 
   BackColor       =   &H00808080&
   BorderStyle     =   3  'Fester Dialog
   Caption         =   "Pfad suchen"
   ClientHeight    =   6030
   ClientLeft      =   6345
   ClientTop       =   3600
   ClientWidth     =   5550
   Icon            =   "pfadsuchen.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6030
   ScaleWidth      =   5550
   ShowInTaskbar   =   0   'False
   Begin VB.TextBox pfad 
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
      Height          =   285
      Left            =   240
      TabIndex        =   5
      Top             =   4800
      Width           =   5055
   End
   Begin VB.FileListBox File1 
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
      Height          =   1065
      Left            =   240
      TabIndex        =   2
      Top             =   3600
      Width           =   5055
   End
   Begin VB.DirListBox Dir1 
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
      Height          =   2790
      Left            =   240
      TabIndex        =   1
      Top             =   720
      Width           =   5055
   End
   Begin VB.DriveListBox qlauf 
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
      TabIndex        =   0
      Top             =   240
      Width           =   5055
   End
   Begin KDCButton107.KDCButton Abbrechen 
      Height          =   495
      Left            =   2760
      TabIndex        =   3
      Top             =   5220
      Width           =   2535
      _ExtentX        =   4471
      _ExtentY        =   873
      Appearance      =   15
      Caption         =   "Abbrechen"
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
   Begin KDCButton107.KDCButton Command1 
      Height          =   495
      Left            =   240
      TabIndex        =   4
      Top             =   5220
      Width           =   2415
      _ExtentX        =   4260
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
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   5400
      Y1              =   5880
      Y2              =   5880
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   5400
      X2              =   5400
      Y1              =   120
      Y2              =   5880
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   5880
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   5400
      Y1              =   120
      Y2              =   120
   End
End
Attribute VB_Name = "Pfadsuchen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub Abbrechen_Click()
    Pfadsuchen.Hide
    frmMain.Show
End Sub
Private Sub Command1_Click()
    If Pfadsuchen.Caption = "Quelle" Then frmMain.Quelle.Text = Pfadsuchen.Dir1.Path
    If Pfadsuchen.Caption = "Ziel" Then frmMain.Ziel.Text = Pfadsuchen.Dir1.Path
    If Pfadsuchen.Caption = "Arbeit" Then frmMain.work.Text = Pfadsuchen.Dir1.Path
    Pfadsuchen.Hide
    frmMain.Show
End Sub
Private Sub Dir1_Change()
    Pfadsuchen.File1.Path = Pfadsuchen.Dir1.Path
    Pfadsuchen.pfad.Text = Dir1.Path
End Sub
Private Sub qlauf_Change()
    Pfadsuchen.Dir1.Path = Left$(Pfadsuchen.qlauf.Drive, 2)
    Pfadsuchen.pfad.Text = Dir1.Path
End Sub
Private Sub Form_Load()
    Pfadsuchen.Dir1.Path = "c:\"
    Pfadsuchen.File1.Path = "c:\"
    Pfadsuchen.qlauf.Drive = "c:"
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call Command1_Click
End Sub
