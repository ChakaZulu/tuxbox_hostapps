VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form sort 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   4695
   ClientLeft      =   6150
   ClientTop       =   3300
   ClientWidth     =   4110
   Icon            =   "Sortierung.frx":0000
   LinkTopic       =   "sort"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4695
   ScaleWidth      =   4110
   Begin VB.CheckBox artikel 
      BackColor       =   &H00808080&
      Caption         =   "Artikel abschneiden?"
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
      Top             =   3360
      Width           =   3495
   End
   Begin VB.CheckBox komma 
      BackColor       =   &H00808080&
      Caption         =   "Nach "","" bei Interpret-Ordner abschneiden?"
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
      TabIndex        =   8
      Top             =   3120
      Width           =   3600
   End
   Begin VB.ComboBox V4 
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
      ItemData        =   "Sortierung.frx":08CA
      Left            =   225
      List            =   "Sortierung.frx":08E0
      Style           =   2  'Dropdown-Liste
      TabIndex        =   3
      Top             =   2640
      Width           =   3615
   End
   Begin VB.ComboBox V3 
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
      ItemData        =   "Sortierung.frx":0914
      Left            =   225
      List            =   "Sortierung.frx":092A
      Style           =   2  'Dropdown-Liste
      TabIndex        =   2
      Top             =   1920
      Width           =   3615
   End
   Begin VB.ComboBox V2 
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
      ItemData        =   "Sortierung.frx":095E
      Left            =   225
      List            =   "Sortierung.frx":0974
      Style           =   2  'Dropdown-Liste
      TabIndex        =   1
      Top             =   1200
      Width           =   3615
   End
   Begin VB.ComboBox v1 
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
      ItemData        =   "Sortierung.frx":09A8
      Left            =   225
      List            =   "Sortierung.frx":09BE
      Style           =   2  'Dropdown-Liste
      TabIndex        =   0
      Top             =   480
      Width           =   3615
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   10
      Top             =   3960
      Width           =   3615
      _ExtentX        =   6376
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
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3960
      Y1              =   4560
      Y2              =   4560
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3960
      Y1              =   3840
      Y2              =   3840
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   3960
      X2              =   3960
      Y1              =   3840
      Y2              =   4560
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4560
      Y2              =   3840
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3960
      Y1              =   3720
      Y2              =   3720
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   3960
      X2              =   3960
      Y1              =   120
      Y2              =   3720
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   3720
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3960
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label5 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "4.Verzeichnis"
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
      Left            =   225
      TabIndex        =   7
      Top             =   2400
      Width           =   3615
   End
   Begin VB.Label Label4 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "3. Verzeichnis"
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
      Left            =   225
      TabIndex        =   6
      Top             =   1680
      Width           =   3615
   End
   Begin VB.Label Label3 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "2. Verzeichnis"
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
      Left            =   225
      TabIndex        =   5
      Top             =   960
      Width           =   3615
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "1. Verzeichnis"
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
      Top             =   240
      Width           =   3615
   End
End
Attribute VB_Name = "sort"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Sub OK_Click()
    If Aktivierauswahl.sort_aktiv.Value = "1" Then
        frmMain.Label19.Caption = aktlng
    Else
        frmMain.Label19.Caption = deaktlng
    End If
    
    sort.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
