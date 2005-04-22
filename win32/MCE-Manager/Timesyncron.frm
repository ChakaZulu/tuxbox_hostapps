VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form Timesyncron 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   3105
   ClientLeft      =   6195
   ClientTop       =   4455
   ClientWidth     =   3495
   Icon            =   "Timesyncron.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3105
   ScaleWidth      =   3495
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   3000
      Left            =   4320
      Top             =   2160
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   4200
      Top             =   480
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer Timer1 
      Interval        =   900
      Left            =   4200
      Top             =   1560
   End
   Begin KDCButton107.KDCButton command1 
      Height          =   375
      Left            =   240
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   1680
      Width           =   3015
      _ExtentX        =   5318
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Synchronisiere"
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
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   2400
      Width           =   3015
      _ExtentX        =   5318
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
   Begin VB.Label Label12 
      Alignment       =   2  'Center
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
      Left            =   240
      TabIndex        =   9
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label11 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Boxzeit:"
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
      Left            =   120
      TabIndex        =   8
      Top             =   960
      Width           =   1455
   End
   Begin VB.Label Label13 
      Alignment       =   2  'Center
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
      Left            =   1800
      TabIndex        =   7
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label10 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Boxdatum:"
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
      Left            =   1560
      TabIndex        =   6
      Top             =   960
      Width           =   1695
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   3360
      X2              =   3360
      Y1              =   2280
      Y2              =   3000
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   3360
      X2              =   120
      Y1              =   3000
      Y2              =   3000
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   3000
      Y2              =   2280
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3360
      Y1              =   2280
      Y2              =   2280
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   3360
      X2              =   120
      Y1              =   2160
      Y2              =   2160
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   2160
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   3360
      X2              =   3360
      Y1              =   2160
      Y2              =   120
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   3360
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Systemdatum:"
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
      Left            =   1560
      TabIndex        =   3
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
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
      Left            =   1800
      TabIndex        =   2
      Top             =   600
      Width           =   1335
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Systemzeit:"
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
      Left            =   120
      TabIndex        =   1
      Top             =   240
      Width           =   1455
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
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
      Left            =   240
      TabIndex        =   0
      Top             =   600
      Width           =   1095
   End
End
Attribute VB_Name = "Timesyncron"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Abweichungdate As Date
Private Abweichungtime As Date
Public Sub Command1_Click()
    Dim temp As Date
    
    temp = Time + Abweichungtime
    Time = temp
    Abweichungtime = "00:00:00"
    temp = Date + -Abweichungdate
    Date = temp
    Abweichungdate = "00:00:00"
End Sub

Private Sub OK_Click()
    Timesyncron.Hide
    frmMain.Show
End Sub
Private Sub Timer1_Timer()
    Timesyncron.Label1.Caption = Time
    Timesyncron.Label2.Caption = Date
    Timesyncron.Label12.Caption = Time + Abweichungtime
    Timesyncron.Label13.Caption = Date + -Abweichungdate
End Sub
Private Sub Timer2_Timer()
    Call Command1_Click
    Timer2.Enabled = "0"
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim inBuf As String, datum As String, monat As String
    
    Timesyncron.Winsock1.GetData inBuf, , &H10000 'Daten empfangen
    If InStr(inBuf, "login") <> 0 Then Timesyncron.Winsock1.senddata d2set.Text45.Text & vbCrLf 'Benutzername
    If InStr(inBuf, "Password") <> 0 Then Timesyncron.Winsock1.senddata d2set.pw.Text & vbCrLf  'Passwort
           
    'Image-abhängige Routine (CET)
    If InStr(inBuf, "CET") <> 0 Then  'Datum & Zeit Syncronisation
        Abweichungtime = Mid$(inBuf, InStr(inBuf, "CET") - 9, 8)
        Abweichungtime = Abweichungtime - Time
        datum = Mid$(inBuf, InStr(inBuf, "CET") - 12, 2)
        monat = Mid$(inBuf, InStr(inBuf, "CET") - 16, 3)
        If monat = "Jan" Then datum = datum + ".01."
        If monat = "Feb" Then datum = datum + ".02."
        If monat = "Mar" Then datum = datum + ".03."
        If monat = "Apr" Then datum = datum + ".04."
        If monat = "May" Then datum = datum + ".05."
        If monat = "Jun" Then datum = datum + ".06."
        If monat = "Jul" Then datum = datum + ".07."
        If monat = "Aug" Then datum = datum + ".08."
        If monat = "Sep" Then datum = datum + ".09."
        If monat = "Oct" Then datum = datum + ".10."
        If monat = "Nov" Then datum = datum + ".11."
        If monat = "Dec" Then datum = datum + ".12."
        
        'Synchrinosationsfehler werden gefiltert
        Abweichungdate = datum + Mid$(inBuf, InStr(inBuf, "CET") + 4, 4)
        Abweichungdate = Date - Abweichungdate
        Timesyncron.Winsock1.Close
        Exit Sub
    End If
    
    'Image-abhängige Routine (CEST)
    If InStr(inBuf, "CEST") <> 0 Then  'Datum & Zeit Syncronisation
        Abweichungtime = Mid$(inBuf, InStr(inBuf, "CEST") - 9, 8)
        Abweichungtime = Abweichungtime - Time
        datum = Mid$(inBuf, InStr(inBuf, "CEST") - 12, 2)
        monat = Mid$(inBuf, InStr(inBuf, "CEST") - 16, 3)
        If monat = "Jan" Then datum = datum + ".01."
        If monat = "Feb" Then datum = datum + ".02."
        If monat = "Mar" Then datum = datum + ".03."
        If monat = "Apr" Then datum = datum + ".04."
        If monat = "May" Then datum = datum + ".05."
        If monat = "Jun" Then datum = datum + ".06."
        If monat = "Jul" Then datum = datum + ".07."
        If monat = "Aug" Then datum = datum + ".08."
        If monat = "Sep" Then datum = datum + ".09."
        If monat = "Oct" Then datum = datum + ".10."
        If monat = "Nov" Then datum = datum + ".11."
        If monat = "Dec" Then datum = datum + ".12."
        
        'Synchrinosationsfehler werden gefiltert
        Abweichungdate = datum + Mid$(inBuf, InStr(inBuf, "CEST") + 5, 4)
        Abweichungdate = Date - Abweichungdate
        Timesyncron.Winsock1.Close
        Exit Sub
    End If
    
    If InStr(inBuf, "/") <> 0 And InStr(inBuf, "#") <> 0 Then Timesyncron.Winsock1.senddata "date" & vbCrLf
    If InStr(inBuf, ">") <> 0 And InStr(inBuf, "~") <> 0 Then Timesyncron.Winsock1.senddata "date" & vbCrLf
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
Public Sub syncnow()
    'Zeitsync
    If Timesyncron.Winsock1.State = "9" Then Timesyncron.Winsock1.Close
    If Timesyncron.Winsock1.State <> "6" And Timesyncron.Winsock1.State <> "7" Then Timesyncron.Winsock1.Connect (d2set.IP.Text), (23)     'Telnet aktivieren
    Timesyncron.Timer2.Enabled = "1"
End Sub
