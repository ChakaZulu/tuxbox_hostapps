VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form plbezeichnung 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   7560
   ClientLeft      =   6885
   ClientTop       =   2520
   ClientWidth     =   2175
   Icon            =   "plbezeichnung.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7560
   ScaleWidth      =   2175
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   21
      Top             =   6840
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   873
      Appearance      =   15
      Caption         =   "Ok"
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
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   0
      Left            =   240
      TabIndex        =   20
      Text            =   "alternative"
      Top             =   240
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   1
      Left            =   240
      TabIndex        =   19
      Text            =   "baroque"
      Top             =   540
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   2
      Left            =   240
      TabIndex        =   18
      Text            =   "chillout"
      Top             =   840
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   3
      Left            =   240
      TabIndex        =   17
      Text            =   "country"
      Top             =   1140
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   4
      Left            =   240
      TabIndex        =   16
      Text            =   "dance"
      Top             =   1440
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   5
      Left            =   240
      TabIndex        =   15
      Text            =   "easy"
      Top             =   1740
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   6
      Left            =   240
      TabIndex        =   14
      Text            =   "opera"
      Top             =   2040
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   7
      Left            =   240
      TabIndex        =   13
      Text            =   "filmusic"
      Top             =   2340
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   8
      Left            =   240
      TabIndex        =   12
      Text            =   "germanhits"
      Top             =   2640
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   9
      Left            =   240
      TabIndex        =   11
      Text            =   "gold"
      Top             =   2940
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   10
      Left            =   240
      TabIndex        =   10
      Text            =   "heavy"
      Top             =   3240
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   11
      Left            =   240
      TabIndex        =   9
      Text            =   "hiphoprb"
      Top             =   3540
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   12
      Left            =   240
      TabIndex        =   8
      Text            =   "hitlist"
      Top             =   3840
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   13
      Left            =   240
      TabIndex        =   7
      Text            =   "jazz"
      Top             =   4140
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   14
      Left            =   240
      TabIndex        =   6
      Text            =   "latin"
      Top             =   4440
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   15
      Left            =   240
      TabIndex        =   5
      Text            =   "lovesongs"
      Top             =   4740
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   16
      Left            =   240
      TabIndex        =   4
      Text            =   "newcountry"
      Top             =   5040
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   17
      Left            =   240
      TabIndex        =   3
      Text            =   "oldgold"
      Top             =   5340
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   18
      Left            =   240
      TabIndex        =   2
      Text            =   "schlager"
      Top             =   5640
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   19
      Left            =   240
      TabIndex        =   1
      Text            =   "soulclassic"
      Top             =   5940
      Width           =   1695
   End
   Begin VB.TextBox plID 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000018&
      Height          =   240
      Index           =   20
      Left            =   240
      TabIndex        =   0
      Text            =   "classic"
      Top             =   6240
      Width           =   1695
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   2040
      Y1              =   7440
      Y2              =   7440
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   2040
      X2              =   2040
      Y1              =   6720
      Y2              =   7440
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   6720
      Y2              =   7440
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   2040
      Y1              =   6720
      Y2              =   6720
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   2040
      Y1              =   6600
      Y2              =   6600
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   2040
      X2              =   2040
      Y1              =   120
      Y2              =   6600
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   6600
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   2040
      Y1              =   120
      Y2              =   120
   End
End
Attribute VB_Name = "plbezeichnung"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub OK_Click()
    Dim i As Integer, temp As Integer
    
    temp = OnAir.onairsender.ListIndex
    OnAir.onairsender.Clear
    
    For i = 0 To 20
        Genre.genrepl(i) = plbezeichnung.plID(i).Text
        d2set.d2setPL(i).Caption = plbezeichnung.plID(i).Text
        manpl.ManDLPL(i).Caption = plbezeichnung.plID(i).Text
        PlaylistLoggerSettings.loggerpl(i).Caption = plbezeichnung.plID(i).Text
        PL_Verwendung.auswahlpl(i) = plbezeichnung.plID(i).Text
        OnAir.onairsender.AddItem plbezeichnung.plID(i).Text
    Next i
    
    OnAir.onairsender.ListIndex = temp
    plbezeichnung.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
