VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form Aktivierauswahl 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   4500
   ClientLeft      =   5970
   ClientTop       =   3600
   ClientWidth     =   5055
   Icon            =   "Aktivierauswahl.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   OLEDropMode     =   1  'Manuell
   ScaleHeight     =   4500
   ScaleWidth      =   5055
   Tag             =   "v"
   Begin VB.CheckBox plloggeraktiv 
      BackColor       =   &H00808080&
      Caption         =   "Logger aktivieren"
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
      Left            =   2520
      TabIndex        =   21
      Top             =   2160
      Width           =   2055
   End
   Begin VB.CheckBox oggnormal_aktiv 
      BackColor       =   &H00808080&
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
      Left            =   2520
      TabIndex        =   19
      Top             =   1500
      Width           =   2055
   End
   Begin VB.OptionButton mp2_vbr_aktiv 
      BackColor       =   &H00808080&
      Caption         =   "Variable Bitrate"
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
      Left            =   2520
      TabIndex        =   18
      Top             =   660
      Width           =   1815
   End
   Begin VB.OptionButton mp2_cbr_aktiv 
      BackColor       =   &H00808080&
      Caption         =   "Konstante Bitrate"
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
      Left            =   2520
      TabIndex        =   17
      Top             =   420
      Width           =   1815
   End
   Begin VB.PictureBox Picture2 
      BackColor       =   &H00808080&
      Height          =   495
      Left            =   2520
      ScaleHeight     =   435
      ScaleWidth      =   1755
      TabIndex        =   16
      Top             =   420
      Width           =   1815
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  '2D
      BackColor       =   &H00808080&
      BorderStyle     =   0  'Kein
      DrawStyle       =   5  'Transparent
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   0
      Left            =   240
      ScaleHeight     =   735
      ScaleWidth      =   2175
      TabIndex        =   12
      Top             =   2160
      Width           =   2175
      Begin VB.OptionButton mp3_abr_aktiv 
         BackColor       =   &H00808080&
         Caption         =   "Mittlere Bitrate"
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
         Left            =   0
         TabIndex        =   15
         Top             =   480
         Width           =   2175
      End
      Begin VB.OptionButton mp3_vbr_aktiv 
         BackColor       =   &H00808080&
         Caption         =   "Variable Bitrate"
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
         Left            =   0
         TabIndex        =   14
         Top             =   240
         Width           =   2175
      End
      Begin VB.OptionButton mp3_cbr_aktiv 
         BackColor       =   &H00808080&
         Caption         =   "Konstante Bitrate"
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
         Left            =   0
         TabIndex        =   13
         Top             =   0
         Width           =   2175
      End
   End
   Begin VB.CheckBox mp2normal_aktiv 
      BackColor       =   &H00808080&
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
      Left            =   2520
      TabIndex        =   11
      Top             =   900
      Width           =   2175
   End
   Begin VB.CheckBox mp3gain_aktiv 
      BackColor       =   &H00808080&
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
      Left            =   240
      TabIndex        =   10
      Top             =   3120
      Width           =   2055
   End
   Begin VB.CheckBox mp3normal_aktiv 
      BackColor       =   &H00808080&
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
      Left            =   240
      TabIndex        =   9
      Top             =   2880
      Width           =   2055
   End
   Begin VB.CheckBox timec 
      BackColor       =   &H00808080&
      Caption         =   "Zeitsteuerung aktivieren"
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
      Top             =   1560
      Width           =   2175
   End
   Begin VB.CheckBox sort_aktiv 
      BackColor       =   &H00808080&
      Caption         =   "Sortierung aktivieren"
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
      Top             =   960
      Width           =   1815
   End
   Begin VB.CheckBox scan_aktiv 
      BackColor       =   &H00808080&
      Caption         =   "Scannen aktivieren"
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
      TabIndex        =   1
      Top             =   420
      Width           =   1935
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   3780
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
   Begin VB.Label PLlogger 
      BackStyle       =   0  'Transparent
      Caption         =   "Playlist Logger:"
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
      Left            =   2520
      TabIndex        =   22
      Top             =   1920
      Width           =   2355
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000018&
      FillColor       =   &H80000018&
      Height          =   3435
      Left            =   120
      Top             =   120
      Width           =   4815
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000018&
      FillColor       =   &H80000018&
      Height          =   735
      Left            =   120
      Top             =   3660
      Width           =   4815
   End
   Begin VB.Label Label100 
      BackStyle       =   0  'Transparent
      Caption         =   "OGG-Konvertierung:"
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
      Left            =   2520
      TabIndex        =   20
      Top             =   1260
      Width           =   2355
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Zeitsteuerung:"
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
      Top             =   1320
      Width           =   2055
   End
   Begin VB.Label Label13 
      BackStyle       =   0  'Transparent
      Caption         =   "MP3-Konvertierung:"
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
      Top             =   1920
      Width           =   2355
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Sortierung:"
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
      Top             =   720
      Width           =   1995
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "Scannen:"
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
      TabIndex        =   3
      Top             =   180
      Width           =   1995
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "MP2-Konvertierung:"
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
      Left            =   2520
      TabIndex        =   0
      Top             =   180
      Width           =   2115
   End
End
Attribute VB_Name = "Aktivierauswahl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub mp3normal_aktiv_Click()
    If Aktivierauswahl.mp3normal_aktiv.value = "1" Then Aktivierauswahl.mp3gain_aktiv.value = "0"
End Sub
Private Sub mp3gain_aktiv_Click()
    If Aktivierauswahl.mp3gain_aktiv.value = "1" Then Aktivierauswahl.mp3normal_aktiv.value = "0"
End Sub
Public Sub OK_Click()
    If Aktivierauswahl.scan_aktiv.value = "1" Then
        allgemeine.quelldel.Enabled = "0"
        frmMain.Label23.Caption = aktlng
        allgemeine.quelldel.value = "1"
        frmMain.Timer1.Enabled = "1"
    Else
        allgemeine.quelldel.Enabled = "1"
        frmMain.Label23.Caption = deaktlng
        frmMain.Timer1.Enabled = "0"
        frmMain.countdo.Caption = "00:00:00"
        frmMain.tage.Caption = vbNullString
        timeSeconds = 0
        timeMinutes = 0
        timehours = 0
        timedays = 0
    End If
    
    If Aktivierauswahl.mp3normal_aktiv.value = "1" Or mp3gain_aktiv.value = "1" Then
        frmMain.Label20.Caption = aktlng
    Else
        frmMain.Label20.Caption = deaktlng
    End If
    
    If Aktivierauswahl.sort_aktiv.value = "1" Then
        frmMain.Label19.Caption = aktlng
    Else
        frmMain.Label19.Caption = deaktlng
    End If
    
    If Aktivierauswahl.plloggeraktiv.value = "1" Then
        frmMain.plloggeraktiv.Caption = aktlng
    Else
        frmMain.plloggeraktiv.Caption = deaktlng
    End If
    
    If frmMain.mp3extension.value = "1" Then
        If Aktivierauswahl.mp3_cbr_aktiv.value = "1" Then frmMain.Label26.Caption = "CBR"
        If Aktivierauswahl.mp3_vbr_aktiv.value = "1" Then frmMain.Label26.Caption = "VBR"
        If Aktivierauswahl.mp3_abr_aktiv.value = "1" Then frmMain.Label26.Caption = "ABR"
    End If
    
    If frmMain.mp2extension.value = "1" Then
        If Aktivierauswahl.mp2_cbr_aktiv.value = "1" Then frmMain.Label26.Caption = "CBR"
        If Aktivierauswahl.mp2_vbr_aktiv.value = "1" Then frmMain.Label26.Caption = "VBR"
    End If
    
    If frmMain.noextension.value = "1" Then
        frmMain.Label26.Caption = "---"
        frmMain.Label20.Caption = deaktlng
    End If
    
    If frmMain.oggextension.value = "1" Then frmMain.Label26.Caption = "VBR"
    
    If Aktivierauswahl.timec.value = "1" Then
        Zeitsteuerung.Timer1.Enabled = "1"
        frmMain.Label11.Caption = aktlng
    Else
        Zeitsteuerung.Timer1.Enabled = "0"
        frmMain.Label11.Caption = deaktlng
    End If
    
    Aktivierauswahl.Hide
    frmMain.Show
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
