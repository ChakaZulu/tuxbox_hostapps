VERSION 5.00
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form Zeitsteuerung 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   3255
   ClientLeft      =   5970
   ClientTop       =   4455
   ClientWidth     =   3630
   ForeColor       =   &H80000017&
   Icon            =   "Zeitsteuerung.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3255
   ScaleWidth      =   3630
   Begin VB.CheckBox Sonntag 
      BackColor       =   &H00808080&
      Caption         =   "Sonntag"
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
      TabIndex        =   12
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CheckBox Samstag 
      BackColor       =   &H00808080&
      Caption         =   "Samstag"
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
      TabIndex        =   11
      Top             =   1680
      Width           =   1215
   End
   Begin VB.CheckBox Freitag 
      BackColor       =   &H00808080&
      Caption         =   "Freitag"
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
      Top             =   1440
      Width           =   975
   End
   Begin VB.CheckBox Donnerstag 
      BackColor       =   &H00808080&
      Caption         =   "Donnerstag"
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
      TabIndex        =   9
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CheckBox Mittwoch 
      BackColor       =   &H00808080&
      Caption         =   "Mittwoch"
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
      TabIndex        =   8
      Top             =   960
      Width           =   1215
   End
   Begin VB.CheckBox Dienstag 
      BackColor       =   &H00808080&
      Caption         =   "Dienstag"
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
      TabIndex        =   7
      Top             =   720
      Width           =   1215
   End
   Begin VB.CheckBox montag 
      BackColor       =   &H00808080&
      Caption         =   "Montag"
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
      TabIndex        =   6
      Top             =   480
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   3000
      Top             =   120
   End
   Begin VB.ComboBox endm 
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
      ItemData        =   "Zeitsteuerung.frx":08CA
      Left            =   1200
      List            =   "Zeitsteuerung.frx":08E0
      Style           =   2  'Dropdown-Liste
      TabIndex        =   5
      Top             =   1800
      Width           =   735
   End
   Begin VB.ComboBox endh 
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
      ItemData        =   "Zeitsteuerung.frx":08FC
      Left            =   240
      List            =   "Zeitsteuerung.frx":0948
      Style           =   2  'Dropdown-Liste
      TabIndex        =   4
      Top             =   1800
      Width           =   735
   End
   Begin VB.ComboBox startm 
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
      ItemData        =   "Zeitsteuerung.frx":09AC
      Left            =   1200
      List            =   "Zeitsteuerung.frx":09C2
      Style           =   2  'Dropdown-Liste
      TabIndex        =   1
      Top             =   720
      Width           =   735
   End
   Begin VB.ComboBox starth 
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
      ItemData        =   "Zeitsteuerung.frx":09DE
      Left            =   240
      List            =   "Zeitsteuerung.frx":0A2A
      Style           =   2  'Dropdown-Liste
      TabIndex        =   0
      Top             =   720
      Width           =   735
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   17
      Top             =   2520
      Width           =   3135
      _ExtentX        =   5530
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
   Begin VB.Label Label6 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00808080&
      Caption         =   "Minute"
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
      Left            =   1080
      TabIndex        =   16
      Top             =   480
      Width           =   975
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00808080&
      Caption         =   "Stunde"
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
      TabIndex        =   15
      Top             =   480
      Width           =   735
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   3480
      X2              =   120
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   2280
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   3480
      X2              =   3480
      Y1              =   120
      Y2              =   2280
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3480
      Y1              =   2280
      Y2              =   2280
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   3480
      X2              =   3480
      Y1              =   2400
      Y2              =   3120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3480
      Y1              =   3120
      Y2              =   3120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   3480
      X2              =   120
      Y1              =   2400
      Y2              =   2400
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   2400
      Y2              =   3120
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00808080&
      Caption         =   "Minute"
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
      Left            =   1080
      TabIndex        =   14
      Top             =   1560
      Width           =   975
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00808080&
      Caption         =   "Stunde"
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
      Left            =   120
      TabIndex        =   13
      Top             =   1560
      Width           =   975
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00808080&
      Caption         =   "Endzeit:"
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
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Zentriert
      BackStyle       =   0  'Transparent
      Caption         =   "Startzeit:"
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
      Top             =   240
      Width           =   1695
   End
End
Attribute VB_Name = "Zeitsteuerung"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub endh_click()
    If (Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm.Text + ":00") > (Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm.Text + ":00") Then MsgBox "Your settings are incorrect"
End Sub
Private Sub endm_click()
    If (Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm.Text + ":00") > (Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm.Text + ":00") Then MsgBox "Your settings are incorrect"
End Sub
Private Sub OK_Click()
    If (Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm.Text + ":00") < (Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm.Text + ":00") Then
        Zeitsteuerung.Hide
        frmMain.Show
    End If
End Sub
Private Sub starth_click()
    If (Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm.Text + ":00") > (Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm.Text + ":00") Then MsgBox "Your settings are incorrect"
End Sub
Private Sub startm_Click()
    If (Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm.Text + ":00") > (Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm.Text + ":00") Then MsgBox "Your settings are incorrect"
End Sub
Private Sub Timer1_Timer()
    If frmMain.aufnahmestart.Enabled = "1" Then
        If Weekday(Date) = "2" And Zeitsteuerung.montag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "3" And Zeitsteuerung.Dienstag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "4" And Zeitsteuerung.Mittwoch.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "5" And Zeitsteuerung.Donnerstag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "6" And Zeitsteuerung.Freitag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "7" And Zeitsteuerung.Samstag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
        If Weekday(Date) = "1" And Zeitsteuerung.Sonntag.Value = "1" And Zeitsteuerung.starth.Text + ":" + Zeitsteuerung.startm + ":00" = Time Then Call Record.recstart
    End If
    
    If frmMain.aufnahmestop.Enabled = "1" Then
        If Weekday(Date) = "2" And Zeitsteuerung.montag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "3" And Zeitsteuerung.Dienstag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "4" And Zeitsteuerung.Mittwoch.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "5" And Zeitsteuerung.Donnerstag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "6" And Zeitsteuerung.Freitag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "7" And Zeitsteuerung.Samstag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
        If Weekday(Date) = "1" And Zeitsteuerung.Sonntag.Value = "1" And Zeitsteuerung.endh.Text + ":" + Zeitsteuerung.endm + ":00" = Time Then Call Record.recstop
    End If
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
