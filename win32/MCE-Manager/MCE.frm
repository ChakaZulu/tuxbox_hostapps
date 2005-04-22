VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Object = "{7A3134F8-8B34-4546-B016-D82D86DFBB3B}#1.0#0"; "ProgressBar.ocx"
Object = "{4FD60454-1E7E-4AF1-A122-48E51ED3C92E}#1.0#0"; "Downloader.ocx"
Object = "{407CC720-A122-450D-A8EF-DF969BF6063E}#1.6#0"; "AudioGenie.ocx"
Begin VB.Form frmMain 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   8430
   ClientLeft      =   660
   ClientTop       =   1665
   ClientWidth     =   13830
   Icon            =   "MCE.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   517.757
   ScaleMode       =   0  'User
   ScaleWidth      =   868.72
   Begin Downloader.DownLoad DownL 
      Left            =   14160
      Top             =   2040
      _ExtentX        =   847
      _ExtentY        =   847
   End
   Begin VB.CheckBox turbo 
      BackColor       =   &H00000000&
      Caption         =   "Turbo"
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
      TabIndex        =   102
      TabStop         =   0   'False
      Top             =   5400
      Width           =   2775
   End
   Begin VB.OptionButton mp3extension 
      BackColor       =   &H00000000&
      Caption         =   "MP3"
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
      Left            =   10800
      TabIndex        =   101
      TabStop         =   0   'False
      Top             =   5160
      Width           =   1695
   End
   Begin VB.ComboBox senderauswahl 
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
      Left            =   10800
      Style           =   2  'Dropdown List
      TabIndex        =   94
      TabStop         =   0   'False
      Top             =   1320
      Width           =   2775
   End
   Begin VB.OptionButton noextension 
      BackColor       =   &H00000000&
      Caption         =   "Keine Konvertierung"
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
      Left            =   10800
      TabIndex        =   88
      TabStop         =   0   'False
      Top             =   4920
      Width           =   1815
   End
   Begin VB.TextBox work 
      BackColor       =   &H00808080&
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
      IMEMode         =   3  'DISABLE
      Left            =   10800
      TabIndex        =   69
      TabStop         =   0   'False
      Text            =   "c:\"
      Top             =   6720
      Width           =   2775
   End
   Begin VB.OptionButton mp2extension 
      BackColor       =   &H00000000&
      Caption         =   "MP2"
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
      Left            =   12840
      TabIndex        =   68
      TabStop         =   0   'False
      Top             =   4920
      Width           =   735
   End
   Begin VB.OptionButton oggextension 
      BackColor       =   &H00000000&
      Caption         =   "OGG"
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
      Left            =   12840
      TabIndex        =   67
      TabStop         =   0   'False
      Top             =   5160
      Width           =   735
   End
   Begin VB.TextBox Quelle 
      BackColor       =   &H00808080&
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
      IMEMode         =   3  'DISABLE
      Left            =   10800
      TabIndex        =   31
      TabStop         =   0   'False
      Text            =   "c:\"
      Top             =   5805
      Width           =   2775
   End
   Begin VB.TextBox Ziel 
      BackColor       =   &H00808080&
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
      Left            =   10800
      TabIndex        =   30
      TabStop         =   0   'False
      Text            =   "c:\"
      Top             =   7605
      Width           =   2770
   End
   Begin RichTextLib.RichTextBox RichTextBox2 
      Height          =   2715
      Left            =   3360
      TabIndex        =   20
      Top             =   5520
      Width           =   3375
      _ExtentX        =   5953
      _ExtentY        =   4789
      _Version        =   393217
      BackColor       =   0
      Enabled         =   -1  'True
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      Appearance      =   0
      TextRTF         =   $"MCE.frx":08CA
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   3645
      Left            =   3360
      TabIndex        =   18
      Top             =   1320
      Width           =   7095
      _ExtentX        =   12515
      _ExtentY        =   6429
      _Version        =   393217
      BackColor       =   0
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      Appearance      =   0
      TextRTF         =   $"MCE.frx":0945
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Timer tmrUpdate 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   14520
      Top             =   3480
   End
   Begin VB.PictureBox MCEpicture 
      Height          =   495
      Left            =   14040
      Picture         =   "MCE.frx":09C0
      ScaleHeight     =   435
      ScaleWidth      =   435
      TabIndex        =   13
      Top             =   2880
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   14040
      Top             =   3480
   End
   Begin KDCButton107.KDCButton Command1 
      Height          =   375
      Left            =   240
      TabIndex        =   23
      TabStop         =   0   'False
      Top             =   7800
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Exit"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton abbrechen 
      Height          =   375
      Left            =   240
      TabIndex        =   24
      TabStop         =   0   'False
      Top             =   7320
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "abbrechen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton Nachsortierung 
      Height          =   375
      Left            =   240
      TabIndex        =   25
      TabStop         =   0   'False
      Top             =   6360
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Nachsortieren"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton untaggedtaggen 
      Height          =   375
      Left            =   240
      TabIndex        =   26
      TabStop         =   0   'False
      Top             =   6840
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Untagged nachtaggen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton start 
      Height          =   375
      Left            =   240
      TabIndex        =   27
      TabStop         =   0   'False
      Top             =   5880
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Konvertierung starten"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin ProgressBar2.cpvProgressBar CPUmeter 
      Height          =   120
      Left            =   240
      Top             =   5100
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "MCE.frx":128A
      BarPictureBack  =   "MCE.frx":245C
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar statusnachtag 
      Height          =   120
      Left            =   240
      Top             =   4680
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "MCE.frx":360E
      BarPictureBack  =   "MCE.frx":47E0
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar Sortstatus 
      Height          =   120
      Left            =   240
      Top             =   4260
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "MCE.frx":5992
      BarPictureBack  =   "MCE.frx":6B64
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar statuscon 
      Height          =   120
      Left            =   240
      Top             =   3840
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "MCE.frx":7D16
      BarPictureBack  =   "MCE.frx":8EE8
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin KDCButton107.KDCButton zsuchen 
      Height          =   225
      Left            =   10800
      TabIndex        =   32
      TabStop         =   0   'False
      Top             =   7935
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   397
      Appearance      =   15
      Caption         =   "Suchen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton qsuchen 
      Height          =   225
      Left            =   10800
      TabIndex        =   33
      TabStop         =   0   'False
      Top             =   6135
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   397
      Appearance      =   15
      Caption         =   "Suchen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton wsuchen 
      Height          =   225
      Left            =   10800
      TabIndex        =   70
      TabStop         =   0   'False
      Top             =   7050
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   397
      Appearance      =   15
      Caption         =   "Suchen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColorTop    =   14737632
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton aufnahmestop 
      Height          =   255
      Left            =   10800
      TabIndex        =   95
      TabStop         =   0   'False
      Top             =   2040
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Stop"
      ForeColor       =   -2147483627
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   0   'False
      BackColorTop    =   16777215
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton aufnahmestart 
      Height          =   255
      Left            =   10800
      TabIndex        =   96
      TabStop         =   0   'False
      Top             =   1680
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Start"
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
   Begin AUDIOGENIELib.AudioGenie AudioGenie 
      Left            =   14040
      Top             =   4200
      _Version        =   65542
      _ExtentX        =   661
      _ExtentY        =   450
      _StockProps     =   0
   End
   Begin VB.Label plloggerdaten 
      BackStyle       =   0  'Transparent
      Caption         =   "Playlist Logger Daten:"
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
      TabIndex        =   100
      Top             =   3240
      Width           =   1695
   End
   Begin VB.Label pldatenstream 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      TabIndex        =   99
      Top             =   3240
      Width           =   1095
   End
   Begin VB.Label plloggerlabel 
      BackStyle       =   0  'Transparent
      Caption         =   "Playlist Logger:"
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
      TabIndex        =   98
      Top             =   3000
      Width           =   1695
   End
   Begin VB.Label plloggeraktiv 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      TabIndex        =   97
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Senderauswahl:"
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
      Index           =   1
      Left            =   10800
      TabIndex        =   93
      Top             =   1080
      Width           =   2655
   End
   Begin VB.Label infoplaylist 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7800
      TabIndex        =   92
      Top             =   8040
      Width           =   2655
   End
   Begin VB.Label Label38 
      BackStyle       =   0  'Transparent
      Caption         =   "Playlist:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   2
      Left            =   7080
      TabIndex        =   91
      Top             =   8040
      Width           =   1215
   End
   Begin VB.Label infocount 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7800
      TabIndex        =   90
      Top             =   7860
      Width           =   2655
   End
   Begin VB.Label Label38 
      BackStyle       =   0  'Transparent
      Caption         =   "In Arbeit:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   0
      Left            =   7080
      TabIndex        =   89
      Top             =   7860
      Width           =   1215
   End
   Begin VB.Label Label102 
      BackStyle       =   0  'Transparent
      Caption         =   "Format:"
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
      Index           =   0
      Left            =   10800
      TabIndex        =   87
      Top             =   4680
      Width           =   2415
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Index           =   7
      Left            =   12480
      TabIndex        =   86
      Top             =   4320
      Width           =   1095
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Index           =   6
      Left            =   12360
      TabIndex        =   85
      Top             =   4080
      Width           =   1215
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Index           =   5
      Left            =   12840
      TabIndex        =   84
      Top             =   3840
      Width           =   735
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Index           =   4
      Left            =   12480
      TabIndex        =   83
      Top             =   3600
      Width           =   1095
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Left            =   12600
      TabIndex        =   82
      Top             =   3360
      Width           =   975
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Left            =   12480
      TabIndex        =   81
      Top             =   3120
      Width           =   1095
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Left            =   12480
      TabIndex        =   80
      Top             =   2880
      Width           =   1095
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Index           =   7
      Left            =   10800
      TabIndex        =   79
      Top             =   4320
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Index           =   6
      Left            =   10800
      TabIndex        =   78
      Top             =   4080
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Index           =   5
      Left            =   10800
      TabIndex        =   77
      Top             =   3840
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Index           =   4
      Left            =   10800
      TabIndex        =   76
      Top             =   3600
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Left            =   10800
      TabIndex        =   75
      Top             =   3360
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Left            =   10800
      TabIndex        =   74
      Top             =   3120
      Width           =   2175
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Left            =   10800
      TabIndex        =   73
      Top             =   2880
      Width           =   2175
   End
   Begin VB.Label Label101 
      BackStyle       =   0  'Transparent
      Caption         =   "Recording:"
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
      Left            =   10800
      TabIndex        =   72
      Top             =   2400
      Width           =   2775
   End
   Begin VB.Label Label100 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Arbeitsverzeichnis:"
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
      Left            =   10800
      TabIndex        =   71
      Top             =   6480
      Width           =   2775
   End
   Begin VB.Label mp3size 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   8160
      TabIndex        =   66
      Top             =   6780
      Width           =   2295
   End
   Begin VB.Label Label36 
      BackStyle       =   0  'Transparent
      Caption         =   "Dateigrösse Ziel:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   1
      Left            =   7080
      TabIndex        =   65
      Top             =   6780
      Width           =   1575
   End
   Begin VB.Label normset 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   8400
      TabIndex        =   64
      Top             =   7680
      Width           =   2055
   End
   Begin VB.Label Label38 
      BackStyle       =   0  'Transparent
      Caption         =   "Normalisierung:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   7
      Left            =   7080
      TabIndex        =   63
      Top             =   7680
      Width           =   1215
   End
   Begin VB.Label Labeltag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7800
      TabIndex        =   62
      Top             =   6420
      Width           =   2655
   End
   Begin VB.Label aktdate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   9480
      TabIndex        =   61
      Top             =   7320
      Width           =   975
   End
   Begin VB.Label Label38 
      BackStyle       =   0  'Transparent
      Caption         =   "Label:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   3
      Left            =   7080
      TabIndex        =   60
      Top             =   6420
      Width           =   975
   End
   Begin VB.Label Label52 
      BackStyle       =   0  'Transparent
      Caption         =   "Aufnahme Datum:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   0
      Left            =   7080
      TabIndex        =   59
      Top             =   7320
      Width           =   1575
   End
   Begin VB.Label akttime 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7920
      TabIndex        =   58
      Top             =   7140
      Width           =   2535
   End
   Begin VB.Label encoderset 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   9120
      TabIndex        =   57
      Top             =   6960
      Width           =   1335
   End
   Begin VB.Label mp2size 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   8160
      TabIndex        =   56
      Top             =   6600
      Width           =   2295
   End
   Begin VB.Label mp2zeit 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7920
      TabIndex        =   55
      Top             =   7500
      Width           =   2535
   End
   Begin VB.Label yeartag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7800
      TabIndex        =   54
      Top             =   6240
      Width           =   2655
   End
   Begin VB.Label genretag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7560
      TabIndex        =   53
      Top             =   6060
      Width           =   2895
   End
   Begin VB.Label Albumtag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7560
      TabIndex        =   52
      Top             =   5880
      Width           =   2895
   End
   Begin VB.Label titeltag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7440
      TabIndex        =   51
      Top             =   5700
      Width           =   3015
   End
   Begin VB.Label interprettag 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7800
      TabIndex        =   50
      Top             =   5520
      Width           =   2655
   End
   Begin VB.Label Label50 
      BackStyle       =   0  'Transparent
      Caption         =   "Aufnahme Zeit:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   49
      Top             =   7140
      Width           =   975
   End
   Begin VB.Label Label37 
      BackStyle       =   0  'Transparent
      Caption         =   "Encoder Einstellungen:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   48
      Top             =   6960
      Width           =   1935
   End
   Begin VB.Label Label36 
      BackStyle       =   0  'Transparent
      Caption         =   "Dateigrösse Quelle:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Index           =   0
      Left            =   7080
      TabIndex        =   47
      Top             =   6600
      Width           =   1815
   End
   Begin VB.Label Label35 
      BackStyle       =   0  'Transparent
      Caption         =   "Dauer:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   46
      Top             =   7500
      Width           =   735
   End
   Begin VB.Label Label34 
      BackStyle       =   0  'Transparent
      Caption         =   "Jahr:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   45
      Top             =   6240
      Width           =   615
   End
   Begin VB.Label Label33 
      BackStyle       =   0  'Transparent
      Caption         =   "Genre:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   44
      Top             =   6060
      Width           =   975
   End
   Begin VB.Label Label32 
      BackStyle       =   0  'Transparent
      Caption         =   "Album:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   43
      Top             =   5880
      Width           =   975
   End
   Begin VB.Label Label31 
      BackStyle       =   0  'Transparent
      Caption         =   "Titel:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   42
      Top             =   5700
      Width           =   975
   End
   Begin VB.Label Label27 
      BackStyle       =   0  'Transparent
      Caption         =   "Interpret:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   195
      Left            =   7080
      TabIndex        =   41
      Top             =   5520
      Width           =   975
   End
   Begin VB.Label Label21 
      BackStyle       =   0  'Transparent
      Caption         =   "Infos:"
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
      Left            =   7080
      TabIndex        =   40
      Top             =   5280
      Width           =   3375
   End
   Begin VB.Line Line18 
      BorderColor     =   &H80000018&
      X1              =   663.318
      X2              =   663.318
      Y1              =   508.544
      Y2              =   316.919
   End
   Begin VB.Line Line17 
      BorderColor     =   &H80000018&
      X1              =   663.318
      X2              =   437.187
      Y1              =   316.919
      Y2              =   316.919
   End
   Begin VB.Line Line11 
      BorderColor     =   &H80000018&
      X1              =   437.187
      X2              =   437.187
      Y1              =   316.919
      Y2              =   508.544
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   429.649
      Y1              =   316.919
      Y2              =   316.919
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Quellpfad:"
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
      Left            =   10800
      TabIndex        =   39
      Top             =   5565
      Width           =   2775
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Zielpfad:"
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
      Index           =   0
      Left            =   10800
      TabIndex        =   38
      Top             =   7365
      Width           =   2775
   End
   Begin VB.Label Label3 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Konvertierung Status:"
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
      TabIndex        =   37
      Top             =   3600
      Width           =   2775
   End
   Begin VB.Label Label12 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Nachtaggen Status:"
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
      TabIndex        =   36
      Top             =   4440
      Width           =   2775
   End
   Begin VB.Label Label13 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Sortierung Status:"
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
      TabIndex        =   35
      Top             =   4020
      Width           =   2535
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "CPU-Meter:"
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
      TabIndex        =   34
      Top             =   4860
      Width           =   2775
   End
   Begin VB.Label Label18 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Left            =   12480
      TabIndex        =   29
      Top             =   2640
      Width           =   1095
   End
   Begin VB.Label Label16 
      BackStyle       =   0  'Transparent
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
      Left            =   10800
      TabIndex        =   28
      Top             =   2640
      Width           =   2175
   End
   Begin VB.Label Label11 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      Left            =   2040
      TabIndex        =   22
      Top             =   2520
      Width           =   975
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Zeitsteuerung:"
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
      TabIndex        =   21
      Top             =   2520
      Width           =   1335
   End
   Begin VB.Image Image1 
      Height          =   870
      Left            =   -240
      Picture         =   "MCE.frx":A09A
      Top             =   -60
      Width           =   14580
   End
   Begin VB.Line Line22 
      BorderColor     =   &H80000018&
      X1              =   663.318
      X2              =   663.318
      Y1              =   58.962
      Y2              =   309.549
   End
   Begin VB.Line Line21 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   203.518
      Y1              =   309.549
      Y2              =   58.962
   End
   Begin VB.Line Line20 
      BorderColor     =   &H80000018&
      X1              =   437.187
      X2              =   663.318
      Y1              =   508.544
      Y2              =   508.544
   End
   Begin VB.Line Line19 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   663.318
      Y1              =   309.549
      Y2              =   309.549
   End
   Begin VB.Label Label30 
      BackStyle       =   0  'Transparent
      Caption         =   "Recording:"
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
      Left            =   3360
      TabIndex        =   19
      Top             =   5280
      Width           =   3375
   End
   Begin VB.Line Line10 
      BorderColor     =   &H80000018&
      Index           =   0
      X1              =   670.855
      X2              =   859.298
      Y1              =   508.544
      Y2              =   508.544
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "Version 3.45"
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
      Height          =   120
      Left            =   120
      TabIndex        =   17
      Top             =   795
      Width           =   4455
   End
   Begin VB.Label Label1000 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "powered by Quickmic"
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
      Height          =   180
      Left            =   12000
      TabIndex        =   16
      Top             =   795
      Width           =   1635
   End
   Begin VB.Label Label29 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      Top             =   2760
      Width           =   1095
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Aufnahme:"
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
      Top             =   2760
      Width           =   1695
   End
   Begin VB.Line Line16 
      BorderColor     =   &H80000018&
      Index           =   0
      X1              =   670.855
      X2              =   670.855
      Y1              =   58.962
      Y2              =   508.544
   End
   Begin VB.Line Line14 
      BorderColor     =   &H80000018&
      X1              =   859.298
      X2              =   859.298
      Y1              =   508.544
      Y2              =   58.962
   End
   Begin VB.Line Line13 
      BorderColor     =   &H80000018&
      X1              =   670.855
      X2              =   859.298
      Y1              =   58.962
      Y2              =   58.962
   End
   Begin VB.Line Line12 
      BorderColor     =   &H80000018&
      X1              =   195.98
      X2              =   7.538
      Y1              =   508.544
      Y2              =   508.544
   End
   Begin VB.Label Label5 
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "Bereits konvertiert:"
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
      Left            =   3360
      TabIndex        =   12
      Top             =   1080
      Width           =   7095
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   203.518
      Y1              =   316.919
      Y2              =   508.544
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   429.649
      Y1              =   508.544
      Y2              =   508.544
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   429.649
      X2              =   429.649
      Y1              =   316.919
      Y2              =   508.544
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   203.518
      X2              =   663.318
      Y1              =   58.962
      Y2              =   58.962
   End
   Begin VB.Label tage 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "17 days"
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
      Left            =   1560
      TabIndex        =   11
      Top             =   1320
      Width           =   735
   End
   Begin VB.Label Label26 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "CBR"
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
      Left            =   2160
      TabIndex        =   10
      Top             =   1560
      Width           =   855
   End
   Begin VB.Label Label25 
      BackStyle       =   0  'Transparent
      Caption         =   "Konvertierung:"
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
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   7.538
      X2              =   7.538
      Y1              =   58.962
      Y2              =   508.544
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   195.98
      X2              =   195.98
      Y1              =   508.544
      Y2              =   58.962
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   7.538
      X2              =   195.98
      Y1              =   58.962
      Y2              =   58.962
   End
   Begin VB.Label Label24 
      BackStyle       =   0  'Transparent
      Caption         =   "Scan Countdown:"
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
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label23 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      Left            =   1800
      TabIndex        =   7
      Top             =   1800
      Width           =   1215
   End
   Begin VB.Label Label22 
      BackStyle       =   0  'Transparent
      Caption         =   "Scannen:"
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
      Top             =   1800
      Width           =   975
   End
   Begin VB.Label Label20 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      Left            =   1800
      TabIndex        =   5
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label Label19 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "deaktiviert"
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
      Left            =   1815
      TabIndex        =   4
      Top             =   2040
      Width           =   1215
   End
   Begin VB.Label Label15 
      BackStyle       =   0  'Transparent
      Caption         =   "Normalisierung:"
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
      Top             =   2280
      Width           =   1575
   End
   Begin VB.Label Label14 
      BackStyle       =   0  'Transparent
      Caption         =   "Sortierung:"
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
      Top             =   2040
      Width           =   1575
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Status:"
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
      Top             =   1080
      Width           =   2775
   End
   Begin VB.Label countdo 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "00:00:00"
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
      Left            =   2280
      TabIndex        =   0
      Top             =   1320
      Width           =   735
   End
   Begin VB.Menu setting_menu 
      Caption         =   "&Einstellungen"
      Begin VB.Menu aktivir_menu 
         Caption         =   "Aktivierungs Auswahl"
      End
      Begin VB.Menu allgemein_menu 
         Caption         =   "Allgemeines"
      End
      Begin VB.Menu tagging_menu 
         Caption         =   "TagID"
         Begin VB.Menu id3v2 
            Caption         =   "ID3v2.4"
         End
         Begin VB.Menu genre_menu 
            Caption         =   "Genre Zuordnung"
         End
      End
      Begin VB.Menu sortierung_menu 
         Caption         =   "Sortierung"
      End
      Begin VB.Menu normalisierung_menu 
         Caption         =   "&Normalisierung"
         Begin VB.Menu mormalize_menu 
            Caption         =   "Normalize"
         End
         Begin VB.Menu mp3gain_menu 
            Caption         =   "MP3 Gain"
         End
      End
      Begin VB.Menu scan_menu 
         Caption         =   "Scannen"
      End
      Begin VB.Menu plsettings_mnu 
         Caption         =   "Playlist Einstellungen"
         Begin VB.Menu plbez 
            Caption         =   "Playlist Bezeichnung"
         End
         Begin VB.Menu usepl_mnu 
            Caption         =   "Playlist Auswahl"
         End
         Begin VB.Menu pllogger_mnu 
            Caption         =   "Playlist Logger"
         End
      End
      Begin VB.Menu d2settings 
         Caption         =   "Box Einstellungen"
      End
      Begin VB.Menu mnu_convert 
         Caption         =   "Konvertierung"
         Begin VB.Menu Konvertierung_menu 
            Caption         =   "MP3-Konvertierung"
            WindowList      =   -1  'True
            Begin VB.Menu cbr_menu 
               Caption         =   "Konstante Bitrate"
            End
            Begin VB.Menu vbr_menu 
               Caption         =   "Variable Bitrate"
            End
            Begin VB.Menu abr_menu 
               Caption         =   "Mittlere Bitrate"
            End
         End
         Begin VB.Menu mnu_mp2convert 
            Caption         =   "MP2-Konvertierung"
            Begin VB.Menu mp2cbr_mnu 
               Caption         =   "Konstante Bitrate"
            End
            Begin VB.Menu mp2vbr_mnu 
               Caption         =   "Variable Bitrate"
            End
         End
         Begin VB.Menu ogg_menu 
            Caption         =   "OGG-Konvertierung"
         End
      End
   End
   Begin VB.Menu Tools 
      Caption         =   "Tools"
      Begin VB.Menu timesync 
         Caption         =   "Zeitsyncronisation"
      End
      Begin VB.Menu mnu_db 
         Caption         =   "Datenbank"
         Begin VB.Menu Statisik 
            Caption         =   "Statistik"
         End
         Begin VB.Menu dadab 
            Caption         =   "Songs hinzufügen"
         End
         Begin VB.Menu mnu_dbsuche 
            Caption         =   "Durchsuchen"
         End
         Begin VB.Menu editdb 
            Caption         =   "Editor"
         End
      End
      Begin VB.Menu timecontrol 
         Caption         =   "Zeitsteuerung"
      End
      Begin VB.Menu pldl 
         Caption         =   "Playlist Downloader"
      End
      Begin VB.Menu onair_mnu 
         Caption         =   "On Air"
      End
   End
   Begin VB.Menu Popupmen 
      Caption         =   "Popupm"
      Visible         =   0   'False
      Begin VB.Menu popsetting 
         Caption         =   "Einstellungen"
      End
      Begin VB.Menu poptools 
         Caption         =   "Tool"
      End
      Begin VB.Menu popexit 
         Caption         =   "Exit Menü"
         Visible         =   0   'False
      End
      Begin VB.Menu toolexit 
         Caption         =   "Exit Program"
         Visible         =   0   'False
      End
   End
   Begin VB.Menu kontakt_menu 
      Caption         =   "&Online Kontakt"
      Begin VB.Menu access_menu 
         Caption         =   "Access-Musik-DB"
      End
      Begin VB.Menu board_menu 
         Caption         =   "Board"
      End
      Begin VB.Menu email_menu 
         Caption         =   "E-mail"
      End
      Begin VB.Menu sp_mnu 
         Caption         =   "Splashscreen"
      End
   End
   Begin VB.Menu save_menu 
      Caption         =   "Speichern"
   End
   Begin VB.Menu minim 
      Caption         =   "Minimieren"
   End
   Begin VB.Menu help 
      Caption         =   "Hilfe"
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private conferm As Boolean
Private WithEvents cTray As SysTrayDll.SysTray 'Für Tray Icon
Attribute cTray.VB_VarHelpID = -1
Private m_clsCPUUsage As New CPULoad
Private Declare Function FindExecutable Lib "shell32.dll" Alias "FindExecutableA" (ByVal lpFile As String, ByVal lpDirectory As String, ByVal lpResult As String) As Long
Private Sub Abbrechen_Click() 'Abbrechen (Cancel) Button
    If untaggedtaggen.Enabled = "0" Then
        frmMain.abbrechen.Appearance = 10 'Buttonfarbe ändern
        frmMain.abbrechen.ForeColor = &H0&
        frmMain.abbrechen.Enabled = "0"
    End If
End Sub
Private Sub abr_menu_Click()
    MP3abrmenu.Value.Caption = MP3abrmenu.Slider1.CurPosition
    MP3abrmenu.Show
End Sub
Private Sub access_menu_Click() 'Link zu Homepage
    Call Werkzeuge.Browser("http://www.access-musik-db.de.vu/")
End Sub
Private Sub aktivir_menu_Click() 'Aktiviermenü
    Aktivierauswahl.Show 'öffnen des Menüs
End Sub
Private Sub allgemein_menu_Click() 'Allgemeine Einstellungen Menü
    allgemeine.Show 'Menü wird angezeigt
End Sub
Private Sub aufnahmestart_Click()
    httpinterface.nhttp.Navigate "http://" & d2set.IP.Text & "/fb/controlpanel.dbox2?radiomode"
    frmMain.Quelle.Enabled = "0" 'Button abschalten
    frmMain.qsuchen.Enabled = "0"
    frmMain.qsuchen.ForeColor = &H80000015 'Buttonfarbe ändern
    Call record.recstart
    httpinterface.nhttp.Navigate "http://" & d2set.IP.Text & "/control/message?popup=Audio Recording started"
    d2set.db2.Enabled = "0"
    d2set.dreamb.Enabled = "0"
End Sub
Private Sub aufnahmestop_Click()
    If frmMain.Ziel.Enabled = "1" Then
        frmMain.Quelle.Enabled = "1"  'Button abschalten
        frmMain.qsuchen.Enabled = "1"
        frmMain.qsuchen.ForeColor = &H80000018 'Buttonfarbe ändern
    End If
    
    Call record.recstop
    httpinterface.nhttp.Navigate "http://" & d2set.IP.Text & "/control/message?popup=Audio Recording stopped"
    d2set.db2.Enabled = "1"
    d2set.dreamb.Enabled = "1"
End Sub
Private Sub board_menu_Click() 'I-Net-Forum starten
    Call Werkzeuge.Browser("http://3281.rapidforum.com/")
End Sub
Private Sub cbr_menu_Click() 'CBR-Menü
    MP3cbrmenu.Value.Caption = MP3cbrmenu.Slider1.CurPosition
    MP3cbrmenu.Show 'Menü anzeigen
End Sub

Private Sub dadab_Click()
    Database.dbrecordsetsneu.Caption = "0"
    Database.dbrecordsetsalt.Caption = "0"
    Database.dbrecordsetsnoinfo.Caption = "0"
    Database.Songanzahl.Caption = "0"
    frmMain.abbrechen.ForeColor = &H80000015 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "0"
    Call Verriegelung.verriegelungein
    frmMain.Timer1.Enabled = "0"
    Database.Show
End Sub
Private Sub Command1_Click()
    Call Form_unLoad(1)
End Sub
Private Sub d2settings_Click() 'Dbox2 Einstellungen
    d2set.Show
End Sub
Private Sub editdb_Click()
    Dim oAccess As Object
    
    On Error GoTo ende
    Set oAccess = CreateObject("Access.Application")

    With oAccess
        .OpenCurrentDatabase filepath:=App.Path + "\Datenbank\Trackfinder.mdb"
        .Visible = True
    End With
ende:
End Sub
Private Sub email_menu_Click() 'Email Anzeige
    Dim ret As String
    
    ret = InputBox(vbNullString, "E-Mail:", "quickmic_the_rms_tuner@hotmail.com")
End Sub
Private Sub genre_menu_Click()
    Genre.Show
End Sub

Private Sub help_Click()
    Call Werkzeuge.Browser("http://wiki.tuxbox.org/MCE-Manager")
End Sub
Private Sub id3v2_Click()
    tagging.Value(0).Caption = tagging.drift.CurPosition
    tagging.Value(1).Caption = tagging.delsize(0).CurPosition
    tagging.Value(2).Caption = tagging.dauerslider(1).CurPosition
    tagging.Show
End Sub
Private Sub mnu_dbsuche_Click()
    Database.dbrecordsetsneu.Caption = "0"
    Database.dbrecordsetsalt.Caption = "0"
    Database.dbrecordsetsnoinfo.Caption = "0"
    Database.Songanzahl.Caption = "0"
    frmMain.abbrechen.ForeColor = &H80000015 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "0"
    Call Verriegelung.verriegelungein
    frmMain.Timer1.Enabled = "0"
    DBdurchsuchen.Suchen.ListIndex = 0
    Call DBdurchsuchen.rundb
    DBdurchsuchen.Show
End Sub
Private Sub mormalize_menu_Click() 'Normalize Menü
    normal.Value(0).Caption = normal.peakprozslider.CurPosition
    normal.Value(1).Caption = normal.peakdbslider.CurPosition
    normal.Value(2).Caption = normal.bufferslider.CurPosition
    normal.Show 'anzeigen
End Sub
Private Sub mp2cbr_mnu_Click()
    MP2cbrmenu.Show
End Sub
Private Sub mp2extension_Click()
    extension = "mp2"
    Call Einstellungen_setzen.set_settings
End Sub
Private Sub mp2vbr_mnu_Click()
    MP2vbrmenu.Value.Caption = MP2vbrmenu.Slider1.CurPosition
    MP2vbrmenu.Show
End Sub
Private Sub mp3extension_Click()
    extension = "mp3"
    Call Einstellungen_setzen.set_settings
End Sub
Private Sub mp3gain_menu_Click() 'mp3gain Menü
    mp3gain.Value.Caption = mp3gain.Slider1.CurPosition
    mp3gain.Show 'anzeigen
End Sub
Private Sub Nachsortierung_Click() 'Nachsortierung wird gestartet
    Call Ausgabe.textbox("----------------------------------   " + Str(Time) + " / " + Str(Date) + "   ----   " + Nachsortierung.Caption + "   ----------------------------------")
    Call nachs 'ausführen
End Sub
Private Sub form_load() 'Hauptformular wird geladen
    Set cTray = SysTrayDll.SysTray 'Für Minimieren nötig
    cTray.TrayFormStyle = stHideFormWhenMin + stHideTrayWhenNotMin 'Für Minimieren nötig
    cTray.Icon = frmMain.MCEpicture 'Für Minimieren nötig
End Sub
Private Sub Form_unLoad(cancel As Integer) 'Entladen des Formulars (beim schliessen)
    Dim Fo As Form, ret As Integer
    
    If conferm = "0" Then ret = MsgBox("Exit?", vbYesNo, vbNullString, vbNullString, 1)
    
    If ret = 7 Then
        cancel = 1
        Exit Sub
    End If
    
    conferm = "1"
    cancel = 1
    Set RS = Nothing
    Set db = Nothing
    Set m_clsCPUUsage = Nothing
    Set cTray = Nothing
    
    For Each Fo In Forms
        Unload Fo
        Set Fo = Nothing
    Next Fo
    
    Call Werkzeuge.Browser("http://home.arcor.de/karl/v2/menu.htm")
    End 'Exit Programm
End Sub
Private Sub noextension_Click()
    extension = "mp2"
    Call Einstellungen_setzen.set_settings
End Sub
Private Sub ogg_menu_Click()
    oggmenu.Value.Caption = oggmenu.Slider1.CurPosition
    oggmenu.Show
End Sub
Private Sub oggextension_Click()
    extension = "ogg"
    Call Einstellungen_setzen.set_settings
End Sub
Private Sub onair_mnu_Click()
    OnAir.Show
End Sub
Private Sub plbez_Click()
    plbezeichnung.Show
End Sub
Private Sub pldl_Click()
    manpl.MonthView1.Month = Mid$(Date, 4, 2)
    manpl.MonthView1.year = Right$(Date, 4)
    manpl.Show
End Sub
Private Sub pllogger_mnu_Click()
    PlaylistLoggerSettings.Show
End Sub
Private Sub qsuchen_Click() 'Quellpfad
    Pfadsuchen.pfad.Text = frmMain.Quelle.Text
    Pfadsuchen.Caption = "Quelle"
    Pfadsuchen.Show
End Sub
Private Sub recstop_Click()
    Call record.recstop
End Sub
Private Sub save_menu_Click() 'Einstellungen speichern
    Call Speichern.save 'speichern
End Sub
Private Sub scan_menu_Click() 'Scan-Menü
    frmMain.Timer1.Enabled = "0"
    Scannen.Value(0).Caption = Scannen.Slider_takt.CurPosition
    Scannen.Value(1).Caption = Scannen.minfiles.CurPosition
    Scannen.Show 'anzeigen
End Sub
Private Sub sortierung_menu_Click() 'Sortierungsmenü
    sort.Show 'anzeigen
End Sub
Private Sub sp_mnu_Click()
    frmSplash.Show
    record.sptimer.Interval = 10000
    record.sptimer.Enabled = "1"
End Sub
Public Sub Start_Click() 'Konvertierung
    Call Ausgabe.textbox("----------------------------------   " + Str(Time) + " / " + Str(Date) + "   ----   " + start.Caption + "   ----------------------------------")
    Call Konvertierung.Konvert 'starten
End Sub
Private Sub Statisik_Click()
    Database.dbrecordsetsneu.Caption = "0"
    Database.dbrecordsetsalt.Caption = "0"
    Database.dbrecordsetsnoinfo.Caption = "0"
    Database.Songanzahl.Caption = "0"
    frmMain.abbrechen.ForeColor = &H80000015 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "0"
    Call Verriegelung.verriegelungein
    frmMain.Timer1.Enabled = "0"
    Statistik.Value.Caption = Statistik.zeitraum.CurPosition + 1
    Statistik.Show
End Sub
Private Sub timecontrol_Click()
    Zeitsteuerung.Show
End Sub
Private Sub Timer1_Timer() 'scanfunktion
    Call Werkzeuge.scantimer
End Sub
Private Sub timesync_Click()
    If Timesyncron.Winsock1.State = "9" Then Timesyncron.Winsock1.Close
    If Timesyncron.Winsock1.State <> "6" And Timesyncron.Winsock1.State <> "7" Then Timesyncron.Winsock1.Connect (d2set.IP.Text), (23)     'Telnet aktivieren
    Timesyncron.Show
End Sub
Private Sub toolexit_Click()
    Call Form_unLoad(1)
End Sub
Private Sub turbo_Click()
    If frmMain.turbo.Value = "1" Then
        allgemeine.Prio_mce.Tag = allgemeine.Prio_mce.ListIndex
        allgemeine.prio_shell.Tag = allgemeine.prio_shell.ListIndex
        allgemeine.Prio_mce.ListIndex = 0
        allgemeine.prio_shell.ListIndex = 0
    Else
        allgemeine.Prio_mce.ListIndex = allgemeine.Prio_mce.Tag
        allgemeine.prio_shell.ListIndex = allgemeine.prio_shell.Tag
    End If
    
    Call Einstellungen_setzen.set_settings 'Übernehmen der Einstellungen
End Sub
Private Sub untaggedtaggen_Click() 'Nachtaggen
    Call Ausgabe.textbox("----------------------------------   " + Str(Time) + " / " + Str(Date) + "   ----   " + untaggedtaggen.Caption + "   ----------------------------------")
    Call Nachtaggen.nachtag 'starten
End Sub
Private Sub usepl_mnu_Click()
    PL_Verwendung.Show
End Sub
Private Sub vbr_menu_Click() 'VBR-Menü
    MP3vbrmenu.Value.Caption = MP3vbrmenu.Slider1.CurPosition
    MP3vbrmenu.Show
End Sub
Private Sub wsuchen_Click()
    Pfadsuchen.pfad.Text = frmMain.work.Text
    Pfadsuchen.Caption = "Arbeit"
    Pfadsuchen.Show
End Sub
Private Sub zsuchen_Click() 'Zielpfad ändern
    Pfadsuchen.pfad.Text = frmMain.Ziel.Text
    Pfadsuchen.Caption = "Ziel"
    Pfadsuchen.Show
End Sub
Public Sub minim_Click() 'minimieren
    cTray.Form = Me 'Für Minimieren nötig
    Me.WindowState = 1
End Sub
Private Sub tmrUpdate_Timer()
    On Error Resume Next
    CPUmeter = m_clsCPUUsage.CurrentCPUUsage
End Sub
Private Sub cTray_DblClick(button As Integer)
    cTray.Form = Nothing 'Für Minimieren nötig
    Me.WindowState = 0
End Sub
Private Sub cTray_Click(button As Integer)
    If button = 2 Then PopupMenu frmMain.Popupmen
    
    If frmMain.popsetting.Checked = "1" Then
        PopupMenu frmMain.setting_menu
        frmMain.popsetting.Checked = "0"
    End If
    
    If frmMain.poptools.Checked = "1" Then
        frmMain.poptools.Checked = "0"
        PopupMenu frmMain.Tools
    End If
End Sub
Private Sub popsetting_Click()
    frmMain.popsetting.Checked = "1"
End Sub
Private Sub poptools_Click()
    frmMain.poptools.Checked = "1"
End Sub

