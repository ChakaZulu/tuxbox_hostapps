VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form PL_Verwendung 
   BackColor       =   &H8000000C&
   BorderStyle     =   1  'Fest Einfach
   Caption         =   "Playlist Auswahl"
   ClientHeight    =   7965
   ClientLeft      =   6405
   ClientTop       =   2265
   ClientWidth     =   3975
   Icon            =   "PL_Verwendung.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7965
   ScaleWidth      =   3975
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   20
      Left            =   3120
      TabIndex        =   42
      Top             =   6585
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   19
      Left            =   3120
      TabIndex        =   41
      Top             =   6300
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   18
      Left            =   3120
      TabIndex        =   40
      Top             =   6000
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   17
      Left            =   3120
      TabIndex        =   39
      Top             =   5700
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   16
      Left            =   3120
      TabIndex        =   38
      Top             =   5400
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   15
      Left            =   3120
      TabIndex        =   37
      Top             =   5100
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   14
      Left            =   3120
      TabIndex        =   36
      Top             =   4800
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   13
      Left            =   3120
      TabIndex        =   35
      Top             =   4500
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   12
      Left            =   3120
      TabIndex        =   34
      Top             =   4200
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   11
      Left            =   3120
      TabIndex        =   33
      Top             =   3900
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   10
      Left            =   3120
      TabIndex        =   32
      Top             =   3600
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   9
      Left            =   3120
      TabIndex        =   31
      Top             =   3300
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   8
      Left            =   3120
      TabIndex        =   30
      Top             =   3000
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   7
      Left            =   3120
      TabIndex        =   29
      Top             =   2700
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   6
      Left            =   3120
      TabIndex        =   28
      Top             =   2400
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   5
      Left            =   3120
      TabIndex        =   27
      Top             =   2100
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   4
      Left            =   3120
      TabIndex        =   26
      Top             =   1770
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   3
      Left            =   3120
      TabIndex        =   25
      Top             =   1500
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   2
      Left            =   3120
      TabIndex        =   24
      Top             =   1200
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   1
      Left            =   3120
      TabIndex        =   23
      Top             =   900
      Width           =   255
   End
   Begin VB.CheckBox useonline 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   0
      Left            =   3120
      TabIndex        =   22
      Top             =   600
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   20
      Left            =   2160
      TabIndex        =   20
      Top             =   6585
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   19
      Left            =   2160
      TabIndex        =   19
      Top             =   6300
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   18
      Left            =   2160
      TabIndex        =   18
      Top             =   6000
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   17
      Left            =   2160
      TabIndex        =   17
      Top             =   5700
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   16
      Left            =   2160
      TabIndex        =   16
      Top             =   5400
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   15
      Left            =   2160
      TabIndex        =   15
      Top             =   5100
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   14
      Left            =   2160
      TabIndex        =   14
      Top             =   4800
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   13
      Left            =   2160
      TabIndex        =   13
      Top             =   4500
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   12
      Left            =   2160
      TabIndex        =   12
      Top             =   4200
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   11
      Left            =   2160
      TabIndex        =   11
      Top             =   3900
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   10
      Left            =   2160
      TabIndex        =   10
      Top             =   3600
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   9
      Left            =   2160
      TabIndex        =   9
      Top             =   3300
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   8
      Left            =   2160
      TabIndex        =   8
      Top             =   3000
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   7
      Left            =   2160
      TabIndex        =   7
      Top             =   2700
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   6
      Left            =   2160
      TabIndex        =   6
      Top             =   2400
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   5
      Left            =   2160
      TabIndex        =   5
      Top             =   2100
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   4
      Left            =   2160
      TabIndex        =   4
      Top             =   1770
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   3
      Left            =   2160
      TabIndex        =   3
      Top             =   1500
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   2
      Left            =   2160
      TabIndex        =   2
      Top             =   1200
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   1
      Left            =   2160
      TabIndex        =   1
      Top             =   900
      Width           =   255
   End
   Begin VB.CheckBox uselogged 
      BackColor       =   &H00808080&
      Height          =   255
      Index           =   0
      Left            =   2160
      TabIndex        =   0
      Top             =   600
      Width           =   255
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   21
      Top             =   7200
      Width           =   3495
      _ExtentX        =   6165
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
   Begin VB.Label Label5 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Online:"
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
      Index           =   2
      Left            =   2760
      TabIndex        =   66
      Top             =   360
      Width           =   975
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Logged:"
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
      Left            =   1680
      TabIndex        =   65
      Top             =   360
      Width           =   1215
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Playlist:"
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
      Left            =   240
      TabIndex        =   64
      Top             =   360
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "alternative"
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
      TabIndex        =   63
      Top             =   600
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label6"
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
      TabIndex        =   62
      Top             =   900
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label7"
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
      Left            =   240
      TabIndex        =   61
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label8"
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
      Left            =   240
      TabIndex        =   60
      Top             =   1500
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label9"
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
      Index           =   4
      Left            =   240
      TabIndex        =   59
      Top             =   1800
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label10"
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
      Index           =   20
      Left            =   240
      TabIndex        =   58
      Top             =   6600
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label11"
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
      Index           =   5
      Left            =   240
      TabIndex        =   57
      Top             =   2100
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label12"
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
      Index           =   6
      Left            =   240
      TabIndex        =   56
      Top             =   2400
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label13"
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
      Index           =   7
      Left            =   240
      TabIndex        =   55
      Top             =   2700
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label14"
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
      Index           =   8
      Left            =   240
      TabIndex        =   54
      Top             =   3000
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label15"
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
      Index           =   9
      Left            =   240
      TabIndex        =   53
      Top             =   3300
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label16"
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
      Index           =   10
      Left            =   240
      TabIndex        =   52
      Top             =   3600
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label17"
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
      Index           =   11
      Left            =   240
      TabIndex        =   51
      Top             =   3900
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label18"
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
      Index           =   12
      Left            =   240
      TabIndex        =   50
      Top             =   4200
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label19"
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
      Index           =   13
      Left            =   240
      TabIndex        =   49
      Top             =   4500
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label20"
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
      Index           =   14
      Left            =   240
      TabIndex        =   48
      Top             =   4800
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label21"
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
      Index           =   15
      Left            =   240
      TabIndex        =   47
      Top             =   5100
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label22"
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
      Index           =   16
      Left            =   240
      TabIndex        =   46
      Top             =   5400
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label23"
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
      Index           =   17
      Left            =   240
      TabIndex        =   45
      Top             =   5700
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label24"
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
      Index           =   18
      Left            =   240
      TabIndex        =   44
      Top             =   6000
      Width           =   1695
   End
   Begin VB.Label auswahlpl 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Label25"
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
      Index           =   19
      Left            =   240
      TabIndex        =   43
      Top             =   6300
      Width           =   1695
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3840
      Y1              =   6960
      Y2              =   6960
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   3840
      X2              =   3840
      Y1              =   6960
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   6960
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3840
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3840
      Y1              =   7800
      Y2              =   7800
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   3840
      X2              =   3840
      Y1              =   7800
      Y2              =   7080
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   7800
      Y2              =   7080
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3840
      Y1              =   7080
      Y2              =   7080
   End
End
Attribute VB_Name = "PL_Verwendung"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    PL_Verwendung.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
