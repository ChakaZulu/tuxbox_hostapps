VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form manpl 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   6960
   ClientLeft      =   5670
   ClientTop       =   2055
   ClientWidth     =   4710
   Icon            =   "manpl.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6960
   ScaleWidth      =   4710
   Begin KDCButton107.KDCButton Ok 
      Height          =   495
      Left            =   240
      TabIndex        =   25
      Top             =   6240
      Width           =   4215
      _ExtentX        =   7435
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
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   20
      Left            =   3120
      TabIndex        =   24
      Top             =   5040
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   19
      Left            =   3120
      TabIndex        =   23
      Top             =   4800
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   18
      Left            =   3120
      TabIndex        =   22
      Top             =   4560
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   17
      Left            =   3120
      TabIndex        =   21
      Top             =   4320
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   16
      Left            =   3120
      TabIndex        =   20
      Top             =   4080
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   15
      Left            =   3120
      TabIndex        =   19
      Top             =   3840
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   14
      Left            =   3120
      TabIndex        =   18
      Top             =   3600
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   13
      Left            =   3120
      TabIndex        =   17
      Top             =   3360
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   12
      Left            =   3120
      TabIndex        =   16
      Top             =   3120
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   11
      Left            =   3120
      TabIndex        =   15
      Top             =   2880
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   10
      Left            =   3120
      TabIndex        =   14
      Top             =   2640
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   9
      Left            =   3120
      TabIndex        =   13
      Top             =   2400
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Index           =   8
      Left            =   3120
      TabIndex        =   12
      Top             =   2160
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   11
      Top             =   1920
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   10
      Top             =   1680
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   9
      Top             =   1440
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   8
      Top             =   1200
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   7
      Top             =   960
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   6
      Top             =   720
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   5
      Top             =   480
      Width           =   1400
   End
   Begin VB.CheckBox ManDLPL 
      BackColor       =   &H00808080&
      Caption         =   "alternative"
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
      Left            =   3120
      TabIndex        =   4
      Top             =   240
      Width           =   1400
   End
   Begin KDCButton107.KDCButton dl 
      Height          =   375
      Left            =   2400
      TabIndex        =   3
      Top             =   5520
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Download"
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
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin RichTextLib.RichTextBox Pldltextbox 
      Height          =   2655
      Left            =   240
      TabIndex        =   2
      Top             =   2760
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   4683
      _Version        =   393217
      BackColor       =   8421504
      Enabled         =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"manpl.frx":08CA
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin KDCButton107.KDCButton Listel 
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Top             =   5520
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Liste löschen"
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
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin MSComCtl2.MonthView MonthView1 
      Height          =   2370
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2625
      _ExtentX        =   4630
      _ExtentY        =   4180
      _Version        =   393216
      ForeColor       =   -2147483624
      BackColor       =   8421504
      BorderStyle     =   1
      Appearance      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      MonthBackColor  =   8421504
      ShowToday       =   0   'False
      StartOfWeek     =   52101122
      TitleBackColor  =   8421504
      TitleForeColor  =   -2147483624
      TrailingForeColor=   0
      CurrentDate     =   38295
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4560
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   4560
      X2              =   4560
      Y1              =   6000
      Y2              =   120
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   6000
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4560
      Y1              =   6000
      Y2              =   6000
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   4560
      X2              =   4560
      Y1              =   6120
      Y2              =   6840
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   6840
      Y2              =   6120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4560
      Y1              =   6120
      Y2              =   6120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   4560
      Y1              =   6840
      Y2              =   6840
   End
End
Attribute VB_Name = "manpl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub dl_Click()
    Dim pos1 As Integer, temppl As String, playl As String
    
    While manpl.Pldltextbox.Text <> vbNullString
        pos1 = InStr(manpl.Pldltextbox.Text, vbCrLf)
        temppl = Trim$(Left$(manpl.Pldltextbox.Text, pos1 - 1))
        manpl.Pldltextbox.Text = Right$(manpl.Pldltextbox.Text, Len(manpl.Pldltextbox.Text) - pos1 - 1)
        playl = App.Path + "\playlists\Online Playlists\" + Mid$(temppl, 7, 4) + "-" + Mid$(temppl, 4, 2) + "-" + Mid$(temppl, 1, 2) + "-" + Mid$(temppl, 14) + ".txt"
        If LenB(Dir$(playl, vbDirectory)) <> 0 Then Kill playl
        Call Werkzeuge.DownLoad(Mid$(temppl, 14), Left$(temppl, 10), playl)
    Wend
End Sub
Private Sub Listel_Click()
    manpl.Pldltextbox.Text = vbNullString
End Sub
Private Sub MonthView1_DateClick(ByVal DateClicked As Date)
    Dim sTemp As String, i As Integer
    
    For i = 0 To 20
        If manpl.ManDLPL(i).Value = "1" And InStr(manpl.Pldltextbox.Text, Str$(DateClicked) + " - " + manpl.ManDLPL(i).Caption & vbCrLf) = 0 Then sTemp = sTemp + Str$(DateClicked) + " - " + manpl.ManDLPL(i).Caption & vbCrLf
    Next i
    
    If sTemp = vbNullString Then Exit Sub
    
    With manpl.Pldltextbox
        .Text = .Text & sTemp
        .SelLength = Len(.Text)
        .SelColor = &H80000018
    End With
End Sub
Private Sub OK_Click()
    manpl.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
