VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   1905
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4020
   LinkTopic       =   "Form1"
   ScaleHeight     =   1905
   ScaleWidth      =   4020
   StartUpPosition =   3  'Windows-Standard
   Begin MSWinsockLib.Winsock Telnet 
      Left            =   120
      Top             =   720
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   8
      Left            =   3480
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   7
      Interval        =   2000
      Left            =   3000
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   6
      Interval        =   2000
      Left            =   2520
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   5
      Interval        =   2000
      Left            =   2040
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   4
      Interval        =   2000
      Left            =   1560
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   3
      Interval        =   2000
      Left            =   1080
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   2
      Interval        =   2000
      Left            =   600
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   1
      Interval        =   2000
      Left            =   120
      Top             =   1320
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Index           =   8
      Interval        =   2000
      Left            =   3480
      Top             =   1320
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   1
      Left            =   120
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   2
      Left            =   600
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   3
      Left            =   1080
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   4
      Left            =   1560
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   5
      Left            =   2040
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   6
      Left            =   2520
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Radiosender 
      Index           =   7
      Left            =   3000
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Event inittest(i As Integer)
Public Event streamdata(i As Integer)
Public Event telnetdata()
Private Sub Radiosender_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    RaiseEvent streamdata(Index)
End Sub
Private Sub Telnet_DataArrival(ByVal bytesTotal As Long)
    RaiseEvent telnetdata
End Sub
Private Sub Timer_Timer(Index As Integer)
    RaiseEvent inittest(Index)
End Sub
