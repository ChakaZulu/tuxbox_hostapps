VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form allgemeine 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   6315
   ClientLeft      =   5970
   ClientTop       =   3495
   ClientWidth     =   3885
   Icon            =   "Allgemein.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6315
   ScaleWidth      =   3885
   Begin VB.CheckBox igext 
      BackColor       =   &H00808080&
      Caption         =   "Ignore Format for Database"
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
      TabIndex        =   18
      Top             =   2880
      Width           =   3405
   End
   Begin VB.CheckBox spshow 
      BackColor       =   &H00808080&
      Caption         =   "Splashscreen anzeigen"
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
      TabIndex        =   17
      Top             =   2640
      Width           =   3405
   End
   Begin VB.CheckBox coverdownload 
      BackColor       =   &H00808080&
      Caption         =   "Covers downloaden"
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
      TabIndex        =   16
      Top             =   2160
      Width           =   3405
   End
   Begin VB.CheckBox timesync_konv 
      BackColor       =   &H00808080&
      Caption         =   "Systemzeit immer abgleichen"
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
      TabIndex        =   15
      Top             =   2400
      Width           =   3405
   End
   Begin VB.CheckBox textdownload 
      BackColor       =   &H00808080&
      Caption         =   "Songtext downloaden"
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
      TabIndex        =   14
      Top             =   1920
      Width           =   2205
   End
   Begin VB.CheckBox showdos 
      BackColor       =   &H00808080&
      Caption         =   "Zeige Dos-Tools"
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
      TabIndex        =   13
      Top             =   1440
      Width           =   3375
   End
   Begin VB.CheckBox mp2test 
      BackColor       =   &H00808080&
      Caption         =   "Defekte Files aussortieren"
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
      TabIndex        =   12
      Top             =   1680
      Width           =   3375
   End
   Begin VB.CheckBox bevorzugen 
      BackColor       =   &H00808080&
      Caption         =   "Unzensierte Song bevorzugen"
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
      Top             =   1200
      Width           =   3375
   End
   Begin VB.CheckBox ueberschreiben 
      BackColor       =   &H00808080&
      Caption         =   "Keine Konvertieren bei vorhandenen Songs"
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
      Top             =   960
      Width           =   3435
   End
   Begin VB.CheckBox autostart 
      BackColor       =   &H00808080&
      Caption         =   "Minimiert starten"
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
      Top             =   720
      Width           =   3315
   End
   Begin VB.ComboBox prio_shell 
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
      ItemData        =   "Allgemein.frx":08CA
      Left            =   240
      List            =   "Allgemein.frx":08D7
      Style           =   2  'Dropdown-Liste
      TabIndex        =   7
      Top             =   4920
      Width           =   3375
   End
   Begin VB.ComboBox Prio_mce 
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
      ItemData        =   "Allgemein.frx":08EE
      Left            =   240
      List            =   "Allgemein.frx":08FB
      Style           =   2  'Dropdown-Liste
      TabIndex        =   4
      Top             =   4200
      Width           =   3375
   End
   Begin VB.CheckBox cpuaktiv 
      BackColor       =   &H00808080&
      Caption         =   "CPU Meter einschalten"
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
      Top             =   480
      Width           =   3375
   End
   Begin VB.ComboBox sprache 
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
      ItemData        =   "Allgemein.frx":0912
      Left            =   240
      List            =   "Allgemein.frx":0914
      Style           =   2  'Dropdown-Liste
      TabIndex        =   1
      Top             =   3480
      Width           =   3375
   End
   Begin VB.CheckBox quelldel 
      BackColor       =   &H00808080&
      Caption         =   "Sollen die Quelldateien gelöscht werden?"
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
      Width           =   3375
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   10
      Top             =   5580
      Width           =   3375
      _ExtentX        =   5953
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
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000018&
      Height          =   5235
      Left            =   120
      Top             =   120
      Width           =   3615
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000018&
      Height          =   735
      Left            =   120
      Top             =   5460
      Width           =   3615
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Priotität vom Konvertierunsprozess:"
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
      Top             =   4680
      Width           =   4695
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Priotität vom MCE-Manager:"
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
      Top             =   3960
      Width           =   4695
   End
   Begin VB.Label Label7 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Sprache:"
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
      Top             =   3240
      Width           =   4695
   End
End
Attribute VB_Name = "allgemeine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    If allgemeine.cpuaktiv = "1" Then
        frmMain.tmrUpdate.Enabled = "1"
    Else
        frmMain.tmrUpdate.Enabled = "0"
        frmMain.CPUmeter.value = "0" 'Rücksetzten
    End If
    
    Call sprach 'Sprache laden
    Call Einstellungen_setzen.set_settings 'Übernehmen der Einstellungen

    'Für Sprache laden
    Call Aktivierauswahl.OK_Click
    allgemeine.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
