VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows-Standard
   Begin MSWinsockLib.Winsock WS 
      Left            =   1440
      Top             =   2400
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer Timer 
      Interval        =   2000
      Left            =   360
      Top             =   2640
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Event Timer()
Public Event Loggerdata()
Private Sub Timer_Timer()
    RaiseEvent Timer
End Sub
Private Sub WS_DataArrival(ByVal bytesTotal As Long)
    RaiseEvent Loggerdata
End Sub
