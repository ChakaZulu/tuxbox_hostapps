VERSION 5.00
Begin VB.Form frmNGrabSplash 
   Appearance      =   0  '2D
   BackColor       =   &H80000005&
   BorderStyle     =   0  'Kein
   ClientHeight    =   2970
   ClientLeft      =   210
   ClientTop       =   1365
   ClientWidth     =   5835
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2970
   ScaleWidth      =   5835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'Bildschirmmitte
   Begin VB.Label lblVersion 
      Alignment       =   2  'Zentriert
      AutoSize        =   -1  'True
      BackColor       =   &H80000009&
      Caption         =   "Version"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   210
      TabIndex        =   0
      Top             =   2295
      Width           =   5445
   End
   Begin VB.Image imgLogo 
      Height          =   1800
      Index           =   1
      Left            =   240
      Picture         =   "frmNGrabSplash.frx":0000
      Top             =   270
      Width           =   5400
   End
End
Attribute VB_Name = "frmNGrabSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   frmNGrabSplash.frm
' </NAME>
'
' <DESCRIPTION>
'   Splashscreen
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Reinhard Eidelsburger
' </COPYRIGHT>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' <HISTORY>
'   21.07.2002 - RE Hinzufügen des Spashscreens
'   26.07.2002 - LYNX Formularnamen geändert (Notation)
'   01.08.2002 - LYNX Funktionsgeschichte zum Fenster zentrieren rausgenommen und beim Form-Object hinterlegt.
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Private Sub Form_Load()
        
    lblVersion.Caption = "Version " & App.Major & "." & App.Minor & "." & App.Revision

End Sub

