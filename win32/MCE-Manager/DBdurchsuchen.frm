VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Begin VB.Form DBdurchsuchen 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   6870
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   12135
   Icon            =   "DBdurchsuchen.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6870
   ScaleWidth      =   12135
   StartUpPosition =   3  'Windows-Standard
   Begin VB.TextBox suchtext 
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
      Left            =   480
      TabIndex        =   44
      Top             =   5160
      Width           =   3075
   End
   Begin VB.ComboBox Suchen 
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
      ItemData        =   "DBdurchsuchen.frx":08CA
      Left            =   480
      List            =   "DBdurchsuchen.frx":0901
      Style           =   2  'Dropdown-Liste
      TabIndex        =   41
      Top             =   4560
      Width           =   3135
   End
   Begin VB.TextBox number 
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
      Left            =   240
      TabIndex        =   20
      Text            =   "number"
      Top             =   480
      Width           =   2355
   End
   Begin RichTextLib.RichTextBox Songtext 
      Height          =   5295
      Left            =   7800
      TabIndex        =   19
      Top             =   480
      Width           =   4095
      _ExtentX        =   7223
      _ExtentY        =   9340
      _Version        =   393217
      BackColor       =   8421504
      BorderStyle     =   0
      Enabled         =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"DBdurchsuchen.frx":09B6
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
   Begin VB.ComboBox Auswahl 
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
      ItemData        =   "DBdurchsuchen.frx":0A31
      Left            =   480
      List            =   "DBdurchsuchen.frx":0A68
      Style           =   2  'Dropdown-Liste
      TabIndex        =   18
      Top             =   3840
      Width           =   3135
   End
   Begin VB.TextBox EncoderEinstellungen 
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
      Left            =   5280
      TabIndex        =   17
      Text            =   "Encoder Einstellungen"
      Top             =   1920
      Width           =   2355
   End
   Begin VB.TextBox format 
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
      Left            =   5280
      TabIndex        =   16
      Text            =   "Format"
      Top             =   480
      Width           =   2355
   End
   Begin VB.TextBox version 
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
      Left            =   2760
      TabIndex        =   15
      Text            =   "Version"
      Top             =   1440
      Width           =   2355
   End
   Begin VB.TextBox layer 
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
      Left            =   5280
      TabIndex        =   14
      Text            =   "Layer"
      Top             =   1440
      Width           =   2355
   End
   Begin VB.TextBox samplerate 
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
      Left            =   5280
      TabIndex        =   13
      Text            =   "Sample Rate"
      Top             =   2400
      Width           =   2355
   End
   Begin VB.TextBox Encoder 
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
      Left            =   5280
      TabIndex        =   12
      Text            =   "Encoder"
      Top             =   2880
      Width           =   2355
   End
   Begin VB.TextBox Kanalmode 
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
      Left            =   2760
      TabIndex        =   11
      Text            =   "Kanalmode"
      Top             =   960
      Width           =   2355
   End
   Begin VB.TextBox bitrate 
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
      Left            =   2760
      TabIndex        =   10
      Text            =   "Bitrate"
      Top             =   2400
      Width           =   2355
   End
   Begin VB.TextBox aufnahmezeit 
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
      Left            =   5280
      TabIndex        =   9
      Text            =   "Aufnahme Zeit"
      Top             =   960
      Width           =   2355
   End
   Begin VB.TextBox abspieldauer 
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
      Left            =   2760
      TabIndex        =   8
      Text            =   "Abspieldauer"
      Top             =   2880
      Width           =   2355
   End
   Begin VB.TextBox dateigroesse 
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
      Left            =   2760
      TabIndex        =   7
      Text            =   "Datei Grösse"
      Top             =   1920
      Width           =   2355
   End
   Begin VB.TextBox Genre 
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
      Left            =   2760
      TabIndex        =   6
      Text            =   "Genre"
      Top             =   480
      Width           =   2355
   End
   Begin VB.TextBox kommentar 
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
      Left            =   240
      TabIndex        =   5
      Text            =   "Kommentar"
      Top             =   2880
      Width           =   2355
   End
   Begin VB.TextBox jahr 
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
      Left            =   240
      TabIndex        =   4
      Text            =   "Jahr"
      Top             =   2400
      Width           =   2355
   End
   Begin VB.TextBox album 
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
      Left            =   240
      TabIndex        =   3
      Text            =   "Album"
      Top             =   1920
      Width           =   2355
   End
   Begin VB.TextBox titel 
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
      Left            =   240
      TabIndex        =   2
      Text            =   "Titel"
      Top             =   1440
      Width           =   2355
   End
   Begin VB.TextBox Interpret 
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
      Left            =   240
      TabIndex        =   1
      Text            =   "Interpret"
      Top             =   960
      Width           =   2355
   End
   Begin KDCButton107.KDCButton ok 
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Top             =   6120
      Width           =   11655
      _ExtentX        =   20558
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
   Begin KDCButton107.KDCButton dbnext 
      Height          =   255
      Left            =   3960
      TabIndex        =   45
      Top             =   3240
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "vor"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dbback 
      Height          =   255
      Left            =   2160
      TabIndex        =   46
      Top             =   3240
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "zurück"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dbfirst 
      Height          =   255
      Left            =   240
      TabIndex        =   47
      Top             =   3240
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Anfang"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dblast 
      Height          =   255
      Left            =   5760
      TabIndex        =   48
      Top             =   3240
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Ende"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton suchenext 
      Height          =   255
      Left            =   2040
      TabIndex        =   49
      Top             =   5520
      Width           =   735
      _ExtentX        =   1296
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "vor"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton sucheback 
      Height          =   255
      Left            =   1320
      TabIndex        =   50
      Top             =   5520
      Width           =   735
      _ExtentX        =   1296
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "zurück"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton suchefirst 
      Height          =   255
      Left            =   480
      TabIndex        =   51
      Top             =   5520
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Anfang"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton suchelast 
      Height          =   255
      Left            =   2760
      TabIndex        =   52
      Top             =   5520
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Ende"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dbkill 
      Height          =   255
      Left            =   4320
      TabIndex        =   53
      Top             =   3840
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Datensatz löschen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dbnew 
      Height          =   255
      Left            =   4320
      TabIndex        =   54
      Top             =   4200
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Leeren Datensatz erstellen"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin KDCButton107.KDCButton dbsave 
      Height          =   255
      Left            =   4320
      TabIndex        =   55
      Top             =   4560
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   450
      Appearance      =   15
      Caption         =   "Datensatz Editierung speichern"
      ForeColor       =   -2147483624
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   6.75
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
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Datenbank bearbeiten:"
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
      Index           =   22
      Left            =   4320
      TabIndex        =   56
      Top             =   3600
      Width           =   2535
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Suchen nach:"
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
      Index           =   21
      Left            =   480
      TabIndex        =   43
      Top             =   4920
      Width           =   2535
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Suchen in:"
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
      Index           =   20
      Left            =   480
      TabIndex        =   42
      Top             =   4320
      Width           =   2535
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Datenbank Sortieren:"
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
      Index           =   19
      Left            =   480
      TabIndex        =   40
      Top             =   3600
      Width           =   2535
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Songtext:"
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
      Index           =   18
      Left            =   7800
      TabIndex        =   39
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Encoder Eigenschaften:"
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
      Index           =   17
      Left            =   5280
      TabIndex        =   38
      Top             =   1680
      Width           =   2535
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Layer:"
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
      Index           =   16
      Left            =   5280
      TabIndex        =   37
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Sample Rate:"
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
      Index           =   15
      Left            =   5280
      TabIndex        =   36
      Top             =   2160
      Width           =   1695
   End
   Begin VB.Label Label3 
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
      Index           =   14
      Left            =   5280
      TabIndex        =   35
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Erstellungszeit:"
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
      Index           =   13
      Left            =   5280
      TabIndex        =   34
      Top             =   720
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Abspieldauer:"
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
      Index           =   12
      Left            =   2760
      TabIndex        =   33
      Top             =   2640
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Bitrate:"
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
      Index           =   11
      Left            =   2760
      TabIndex        =   32
      Top             =   2160
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Datei Grösse:"
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
      Index           =   10
      Left            =   2760
      TabIndex        =   31
      Top             =   1680
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Version:"
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
      Index           =   9
      Left            =   2760
      TabIndex        =   30
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Kanalmode:"
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
      Index           =   8
      Left            =   2760
      TabIndex        =   29
      Top             =   720
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Encoder:"
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
      Index           =   7
      Left            =   5280
      TabIndex        =   28
      Top             =   2640
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Nummer:"
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
      Index           =   6
      Left            =   240
      TabIndex        =   27
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Genre:"
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
      Index           =   5
      Left            =   2760
      TabIndex        =   26
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Kommentar:"
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
      Index           =   4
      Left            =   240
      TabIndex        =   25
      Top             =   2640
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Jahr:"
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
      Index           =   3
      Left            =   240
      TabIndex        =   24
      Top             =   2160
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Album:"
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
      Left            =   240
      TabIndex        =   23
      Top             =   1680
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Titel:"
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
      Left            =   240
      TabIndex        =   22
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Interpret:"
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
      TabIndex        =   21
      Top             =   720
      Width           =   1695
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   12000
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      Index           =   0
      X1              =   12000
      X2              =   12000
      Y1              =   5880
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   120
      Y2              =   5880
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      Index           =   0
      X1              =   12000
      X2              =   120
      Y1              =   5880
      Y2              =   5880
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   12000
      X2              =   12000
      Y1              =   6720
      Y2              =   6000
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   12000
      Y1              =   6000
      Y2              =   6000
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   6720
      Y2              =   6000
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   12000
      X2              =   120
      Y1              =   6720
      Y2              =   6720
   End
End
Attribute VB_Name = "DBdurchsuchen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub Auswahl_click()
    Set RS = db.OpenRecordset("select * from tracks Order by " + DBdurchsuchen.Auswahl.Text) 'Tabelle auswählen
    Call datenauslesen
End Sub
Private Sub dbback_Click()
    If Not RS.BOF Then RS.MovePrevious
    
    If RS.BOF Then
        If RS.RecordCount > 0 Then RS.MoveNext
        Exit Sub
    End If
    
    Call datenauslesen
End Sub
Private Sub dbfirst_Click()
    If RS.RecordCount > 0 Then
        RS.MoveFirst
        Call datenauslesen
    End If
End Sub
Private Sub dbkill_Click()
    If RS.RecordCount > 0 Then
        With RS
            .Delete
            .MoveNext
            If .EOF And RS.RecordCount > 0 Then .MoveLast
            Call datenauslesen
        End With
    End If
End Sub
Private Sub dblast_Click()
    If RS.RecordCount > 0 Then
        RS.MoveLast
        Call datenauslesen
    End If
End Sub
Private Sub dbnew_Click()
    RS.AddNew
    RS.Update
    RS.MoveLast
    Call datenauslesen
    Songtext.SelColor = &H80000018
End Sub
Private Sub dbnext_Click()
    If Not RS.EOF Then RS.MoveNext
    
    If RS.EOF Then
        If RS.RecordCount > 0 Then RS.MoveLast
        Exit Sub
    End If
    
    Call datenauslesen
End Sub
Private Sub dbsave_Click()
    Call dateneinspielen
End Sub
Private Sub OK_Click()
    Call Verriegelung.verriegelungaus
    frmMain.abbrechen.ForeColor = &H80000018 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "1"
    frmMain.Timer1.Enabled = "1"
    Set RS = Nothing
    Set db = Nothing
    DBdurchsuchen.Hide
    frmMain.Show
End Sub
Private Sub datenauslesen()
    If RS.RecordCount = 0 Then
        Call felderloeschen
        DBdurchsuchen.number.Text = "No Data"
        GoTo ende
    End If
    
    Call felderloeschen
    
    With DBdurchsuchen
        If RS!Interpret <> vbNullString Then .Interpret.Text = RS!Interpret
        If RS!titel <> vbNullString Then .titel.Text = RS!titel
        If RS!jahr <> vbNullString Then .jahr.Text = RS!jahr
        If RS!album <> vbNullString Then .album.Text = RS!album
        If RS!kommentar <> vbNullString Then .kommentar.Text = RS!kommentar
        If RS!Genre <> vbNullString Then .Genre.Text = RS!Genre
        
        If RS!Songtext <> vbNullString Then
            .Songtext.Text = RS!Songtext
            .Songtext.SelLength = Len(RS!Songtext)
            .Songtext.SelColor = &H80000018
            .Songtext.SelStart = .Songtext.SelLength - 1
        End If
        
        If RS!Dateigrösse <> vbNullString Then .dateigroesse.Text = RS!Dateigrösse
        If RS!abspieldauer <> vbNullString Then .abspieldauer.Text = RS!abspieldauer
        If RS!aufnahmezeit <> vbNullString Then .aufnahmezeit.Text = RS!aufnahmezeit
        If RS!Kanalmode <> vbNullString Then .Kanalmode.Text = RS!Kanalmode
        If RS!bitrate <> vbNullString Then .bitrate.Text = RS!bitrate
        If RS!Encoder <> vbNullString Then .Encoder.Text = RS!Encoder
        If RS!layer <> vbNullString Then .layer.Text = RS!layer
        If RS!samplerate <> vbNullString Then .samplerate.Text = RS!samplerate
        If RS!version <> vbNullString Then .version.Text = RS!version
        If RS!Encodereigenschaften <> vbNullString Then .EncoderEinstellungen.Text = RS!Encodereigenschaften
        If RS!format <> vbNullString Then .format.Text = RS!format
        .number.Text = RS.AbsolutePosition + 1
    End With
ende:
End Sub
Private Sub dateneinspielen()
    If RS.RecordCount = 0 Then
        Call felderloeschen
        DBdurchsuchen.number.Text = "No Data"
        Exit Sub
    End If
    
    RS.Edit
    
    With DBdurchsuchen
        If .Interpret.Text <> vbNullString Then RS!Interpret = .Interpret.Text
        If .titel.Text <> vbNullString Then RS!titel = .titel.Text
        If .jahr.Text <> vbNullString Then RS!jahr = .jahr.Text
        If .album.Text <> vbNullString Then RS!album = .album.Text
        If .kommentar.Text <> vbNullString Then RS!kommentar = .kommentar.Text
        If .Genre.Text <> vbNullString Then RS!Genre = .Genre.Text
        If .Songtext.Text <> vbNullString Then RS!Songtext = .Songtext.Text
        If .dateigroesse.Text <> vbNullString Then RS!Dateigrösse = .dateigroesse.Text
        If .abspieldauer.Text <> vbNullString Then RS!abspieldauer = .abspieldauer.Text
        If .aufnahmezeit.Text <> vbNullString Then RS!aufnahmezeit = .aufnahmezeit.Text
        If .Kanalmode.Text <> vbNullString Then RS!Kanalmode = .Kanalmode.Text
        If .bitrate.Text <> vbNullString Then RS!bitrate = .bitrate.Text
        If .Encoder.Text <> vbNullString Then RS!Encoder = .Encoder.Text
        If .layer.Text <> vbNullString Then RS!layer = .layer.Text
        If .samplerate.Text <> vbNullString Then RS!samplerate = .samplerate.Text
        If .version.Text <> vbNullString Then RS!version = .version.Text
        If .EncoderEinstellungen.Text <> vbNullString Then RS!Encodereigenschaften = .EncoderEinstellungen.Text
        If .format.Text <> vbNullString Then RS!format = .format.Text
    End With
    
    RS.Update
End Sub
Public Sub rundb()
    Set db = OpenDatabase(App.Path + "\Datenbank\Musik-Datenbank.mdb") 'Öffnet Datenbank
    Set RS = db.OpenRecordset("select * from tracks Order by " + DBdurchsuchen.Auswahl.Text) 'Tabelle auswählen
    
    If RS.RecordCount = 0 Then
        Call felderloeschen
        DBdurchsuchen.number.Text = "No Data"
    Else
        RS.MoveFirst
        Call datenauslesen
    End If
End Sub
Private Sub felderloeschen()
    With DBdurchsuchen
        .Interpret.Text = vbNullString
        .titel.Text = vbNullString
        .jahr.Text = vbNullString
        .album.Text = vbNullString
        .kommentar.Text = vbNullString
        .Genre.Text = vbNullString
        .Songtext.Text = vbNullString
        .dateigroesse.Text = vbNullString
        .abspieldauer.Text = vbNullString
        .aufnahmezeit.Text = vbNullString
        .Kanalmode.Text = vbNullString
        .layer.Text = vbNullString
        .samplerate.Text = vbNullString
        .version.Text = vbNullString
        .bitrate.Text = vbNullString
        .EncoderEinstellungen.Text = vbNullString
        .format.Text = vbNullString
        .Encoder.Text = vbNullString
        .number.Text = vbNullString
    End With
End Sub
Private Sub sucheback_Click()
    Dim such As String
    
    such = "*" + suchtext.Text + "*"
    RS.FindPrevious Suchen.Text + " LIKE """ + such + """" 'Suche nach Daten
    Call datenauslesen
End Sub
Private Sub suchefirst_Click()
    Dim such As String
    
    such = "*" + suchtext.Text + "*"
    RS.FindFirst Suchen.Text + " LIKE """ + such + """" 'Suche nach Daten
    Call datenauslesen
End Sub
Private Sub suchelast_Click()
    Dim such As String
    
    such = "*" + suchtext.Text + "*"
    RS.FindLast Suchen.Text + " LIKE """ + such + """" 'Suche nach Daten
    Call datenauslesen
End Sub
Private Sub suchenext_Click()
    Dim such As String
    
    such = "*" + suchtext.Text + "*"
    RS.FindNext Suchen.Text + " LIKE """ + such + """" 'Suche nach Daten
    Call datenauslesen
End Sub
Private Sub Form_unLoad(cancel As Integer)
    cancel = 1
    Call OK_Click
End Sub
