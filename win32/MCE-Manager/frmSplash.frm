VERSION 5.00
Begin VB.Form frmSplash 
   BackColor       =   &H00404000&
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   6210
   ClientLeft      =   255
   ClientTop       =   1410
   ClientWidth     =   8190
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmSplash.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6210
   ScaleWidth      =   8190
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture1 
      Height          =   855
      Left            =   240
      Picture         =   "frmSplash.frx":000C
      ScaleHeight     =   795
      ScaleWidth      =   7635
      TabIndex        =   0
      Top             =   240
      Width           =   7695
   End
   Begin VB.Label Label23 
      BackStyle       =   0  'Transparent
      Caption         =   "Alexander:"
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
      Left            =   240
      TabIndex        =   42
      Top             =   5520
      Width           =   1695
   End
   Begin VB.Label Label24 
      BackStyle       =   0  'Transparent
      Caption         =   "Songtext.dll Modder"
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
      Left            =   1920
      TabIndex        =   41
      Top             =   5520
      Width           =   2415
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "Venus"
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
      Height          =   195
      Index           =   7
      Left            =   6360
      TabIndex        =   40
      Top             =   5280
      Width           =   1575
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "Paulefoul"
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
      Height          =   195
      Index           =   6
      Left            =   6360
      TabIndex        =   39
      Top             =   5040
      Width           =   1575
   End
   Begin VB.Label Label17 
      BackStyle       =   0  'Transparent
      Caption         =   "Hilfe:"
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
      Index           =   3
      Left            =   4680
      TabIndex        =   38
      Top             =   5040
      Width           =   1335
   End
   Begin VB.Label Label27 
      BackColor       =   &H00004000&
      BackStyle       =   0  'Transparent
      Caption         =   "Anndiksc"
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
      Index           =   3
      Left            =   6360
      TabIndex        =   37
      Top             =   4680
      Width           =   855
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "JTG"
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
      Height          =   195
      Index           =   5
      Left            =   6360
      TabIndex        =   36
      Top             =   2640
      Width           =   1575
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "Tuxbox"
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
      Height          =   195
      Index           =   4
      Left            =   6360
      TabIndex        =   35
      Top             =   2400
      Width           =   1575
   End
   Begin VB.Label Label17 
      BackStyle       =   0  'Transparent
      Caption         =   "Foren:"
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
      Left            =   4680
      TabIndex        =   34
      Top             =   2160
      Width           =   1335
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "UMP"
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
      Height          =   195
      Index           =   3
      Left            =   6360
      TabIndex        =   33
      Top             =   2160
      Width           =   1575
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "Roadrunner"
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
      Height          =   195
      Index           =   2
      Left            =   6360
      TabIndex        =   32
      Top             =   1800
      Width           =   1575
   End
   Begin VB.Label Label17 
      BackStyle       =   0  'Transparent
      Caption         =   "Excelsheet / Access Editor:"
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
      Height          =   615
      Index           =   1
      Left            =   4680
      TabIndex        =   31
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "PauleFoul"
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
      Height          =   195
      Index           =   1
      Left            =   6360
      TabIndex        =   30
      Top             =   1560
      Width           =   1575
   End
   Begin VB.Label Label27 
      BackColor       =   &H00004000&
      BackStyle       =   0  'Transparent
      Caption         =   "PauleFoul"
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
      Index           =   2
      Left            =   6360
      TabIndex        =   29
      Top             =   4440
      Width           =   855
   End
   Begin VB.Label Label27 
      BackColor       =   &H00004000&
      BackStyle       =   0  'Transparent
      Caption         =   "Viper"
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
      Left            =   6360
      TabIndex        =   28
      Top             =   4200
      Width           =   1335
   End
   Begin VB.Label Label27 
      BackColor       =   &H00004000&
      BackStyle       =   0  'Transparent
      Caption         =   "Surf04"
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
      Left            =   6360
      TabIndex        =   27
      Top             =   3960
      Width           =   855
   End
   Begin VB.Label Label26 
      BackStyle       =   0  'Transparent
      Caption         =   "Songtexte"
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
      Left            =   1920
      TabIndex        =   26
      Top             =   4440
      Width           =   2055
   End
   Begin VB.Label Label25 
      BackStyle       =   0  'Transparent
      Caption         =   "Lyricsdot:"
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
      Left            =   240
      TabIndex        =   25
      Top             =   4440
      Width           =   1455
   End
   Begin VB.Label Label24 
      BackStyle       =   0  'Transparent
      Caption         =   "planet-source-code"
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
      Left            =   1920
      TabIndex        =   24
      Top             =   5160
      Width           =   2415
   End
   Begin VB.Label Label23 
      BackStyle       =   0  'Transparent
      Caption         =   "Allen Uploadern:"
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
      Left            =   240
      TabIndex        =   23
      Top             =   5160
      Width           =   1695
   End
   Begin VB.Label Label22 
      BackStyle       =   0  'Transparent
      Caption         =   "2001"
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
      Left            =   6360
      TabIndex        =   22
      Top             =   3720
      Width           =   1755
   End
   Begin VB.Label Label21 
      BackStyle       =   0  'Transparent
      Caption         =   "Morpheusxxx"
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
      Left            =   6360
      TabIndex        =   21
      Top             =   3480
      Width           =   1755
   End
   Begin VB.Label Label20 
      BackStyle       =   0  'Transparent
      Caption         =   "Smogm"
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
      Left            =   6360
      TabIndex        =   20
      Top             =   3240
      Width           =   1755
   End
   Begin VB.Label Label19 
      BackStyle       =   0  'Transparent
      Caption         =   "F22"
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
      Height          =   195
      Index           =   0
      Left            =   6360
      TabIndex        =   19
      Top             =   3000
      Width           =   1575
   End
   Begin VB.Label Label18 
      BackStyle       =   0  'Transparent
      Caption         =   "Entwickler Crew:"
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
      Height          =   195
      Left            =   240
      TabIndex        =   18
      Top             =   4800
      Width           =   1635
   End
   Begin VB.Label Label17 
      BackStyle       =   0  'Transparent
      Caption         =   "Betatester / Infos / Vorschläge:"
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
      Height          =   615
      Index           =   0
      Left            =   4680
      TabIndex        =   17
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
      Caption         =   "Normalize"
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
      Left            =   1920
      TabIndex        =   16
      Top             =   4080
      Width           =   2535
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "MP3-Gain"
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
      Left            =   1920
      TabIndex        =   15
      Top             =   3720
      Width           =   2535
   End
   Begin VB.Label Label15 
      BackStyle       =   0  'Transparent
      Caption         =   "Leth / Roadrunner:"
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
      Height          =   375
      Left            =   240
      TabIndex        =   14
      Top             =   3120
      Width           =   1575
   End
   Begin VB.Label Label14 
      BackStyle       =   0  'Transparent
      Caption         =   "Stefan Töngi:"
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
      Left            =   240
      TabIndex        =   13
      Top             =   2760
      Width           =   1335
   End
   Begin VB.Label Label13 
      BackStyle       =   0  'Transparent
      Caption         =   "Joe Turner:"
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
      Left            =   240
      TabIndex        =   12
      Top             =   2400
      Width           =   1095
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Venus:"
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
      Left            =   240
      TabIndex        =   11
      Top             =   1680
      Width           =   735
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "Glen Sawyer:"
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
      Left            =   240
      TabIndex        =   10
      Top             =   3720
      Width           =   3135
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Manual Kasper:"
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
      Left            =   240
      TabIndex        =   9
      Top             =   4080
      Width           =   3135
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "Lame"
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
      Left            =   1920
      TabIndex        =   8
      Top             =   4800
      Width           =   2355
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      BackColor       =   &H80000018&
      BackStyle       =   0  'Transparent
      Caption         =   "RMS-Tuning by Quickmic"
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   6135
      TabIndex        =   7
      Top             =   5835
      Width           =   1785
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Alle User, die mich unterstützt haben"
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
      Left            =   195
      TabIndex        =   6
      Top             =   5820
      Width           =   6255
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Hilfe bei der Aufnahmefunktion"
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
      Height          =   495
      Left            =   1920
      TabIndex        =   5
      Top             =   3120
      Width           =   2415
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Audiogenie"
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
      Left            =   1920
      TabIndex        =   4
      Top             =   2760
      Width           =   2415
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "MCE-Plugin für DVB PCI Karten"
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
      Left            =   1920
      TabIndex        =   3
      Top             =   2400
      Width           =   2535
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Playlisten,Infos zum Playlistenloggen, diverse Hilfestellungen"
      ForeColor       =   &H80000018&
      Height          =   735
      Left            =   1920
      TabIndex        =   2
      Top             =   1680
      Width           =   2655
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Mitwirkende:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Left            =   240
      TabIndex        =   1
      Top             =   1335
      Width           =   4215
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   8040
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   8040
      X2              =   8040
      Y1              =   120
      Y2              =   6060
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   8040
      X2              =   120
      Y1              =   6060
      Y2              =   6060
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   6060
   End
End
Attribute VB_Name = "frmSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
