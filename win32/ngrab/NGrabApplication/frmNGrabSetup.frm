VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{2ACF2994-E200-4068-AD91-110AD88BA048}#1.0#0"; "NGrabButton10.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmNgrabSetup 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "Einstellungen"
   ClientHeight    =   6285
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   10515
   Icon            =   "frmNGrabSetup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6285
   ScaleWidth      =   10515
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'Bildschirmmitte
   Visible         =   0   'False
   Begin MSComctlLib.TreeView tvTreeView 
      Height          =   5610
      Left            =   75
      TabIndex        =   34
      Top             =   165
      Width           =   2670
      _ExtentX        =   4710
      _ExtentY        =   9895
      _Version        =   393217
      Indentation     =   353
      Style           =   7
      Appearance      =   0
   End
   Begin NOXButton10.NOXButton cmdOK 
      Height          =   345
      Left            =   8205
      TabIndex        =   32
      Top             =   5850
      Width           =   795
      _ExtentX        =   1402
      _ExtentY        =   609
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Image           =   "frmNGrabSetup.frx":22A2
      ImageMouseOver  =   "frmNGrabSetup.frx":23FC
      Caption         =   "&OK"
   End
   Begin NOXButton10.NOXButton cmdCancel 
      Height          =   345
      Left            =   9135
      TabIndex        =   33
      Top             =   5850
      Width           =   1260
      _ExtentX        =   2223
      _ExtentY        =   609
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Image           =   "frmNGrabSetup.frx":2556
      ImageMouseOver  =   "frmNGrabSetup.frx":26B0
      Caption         =   "&Abbrechen"
   End
   Begin MSComDlg.CommonDialog mcdDialog 
      Left            =   105
      Top             =   5820
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame frmD2SBitrate 
      Appearance      =   0  '2D
      Caption         =   "Bitrate Einstellungen"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   48
      Top             =   60
      Width           =   7560
      Begin VB.TextBox txtZW1 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   119
         Top             =   1680
         Width           =   495
      End
      Begin VB.TextBox txtZW2 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   118
         Top             =   2040
         Width           =   495
      End
      Begin VB.TextBox txtZW3 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   117
         Top             =   2400
         Width           =   495
      End
      Begin VB.TextBox txtZW4 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   116
         Top             =   2760
         Width           =   495
      End
      Begin VB.TextBox txtZW5 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   115
         Top             =   3120
         Width           =   495
      End
      Begin VB.TextBox txtZW6 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   1200
         TabIndex        =   114
         Top             =   3480
         Width           =   495
      End
      Begin VB.TextBox txtUnd1 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2160
         TabIndex        =   113
         Top             =   1680
         Width           =   495
      End
      Begin VB.TextBox txtUnd2 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2160
         TabIndex        =   112
         Top             =   2040
         Width           =   495
      End
      Begin VB.TextBox txtUnd3 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2160
         TabIndex        =   111
         Top             =   2400
         Width           =   495
      End
      Begin VB.TextBox txtUnd4 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2160
         TabIndex        =   110
         Top             =   2760
         Width           =   495
      End
      Begin VB.TextBox txtUnd5 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2145
         TabIndex        =   109
         Top             =   3120
         Width           =   495
      End
      Begin VB.TextBox txtUnd6 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   285
         Left            =   2160
         TabIndex        =   108
         Top             =   3480
         Width           =   495
      End
      Begin VB.TextBox txtCD1 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   107
         Top             =   1680
         Width           =   375
      End
      Begin VB.TextBox txtCD2 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   106
         Top             =   2040
         Width           =   375
      End
      Begin VB.TextBox txtCD3 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   105
         Top             =   2400
         Width           =   375
      End
      Begin VB.TextBox txtCD4 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   104
         Top             =   2760
         Width           =   375
      End
      Begin VB.TextBox txtCD5 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   103
         Top             =   3105
         Width           =   375
      End
      Begin VB.TextBox txtCD6 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   4560
         TabIndex        =   102
         Top             =   3480
         Width           =   375
      End
      Begin VB.ComboBox comCDSize1 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":280A
         Left            =   6000
         List            =   "frmNGrabSetup.frx":2818
         TabIndex        =   101
         Top             =   1650
         Width           =   735
      End
      Begin VB.ComboBox comCDSize2 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":2826
         Left            =   6000
         List            =   "frmNGrabSetup.frx":2834
         TabIndex        =   100
         Top             =   2040
         Width           =   735
      End
      Begin VB.ComboBox comCDSize3 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":2842
         Left            =   6000
         List            =   "frmNGrabSetup.frx":2850
         TabIndex        =   99
         Top             =   2400
         Width           =   735
      End
      Begin VB.ComboBox comCDSize4 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":285E
         Left            =   6000
         List            =   "frmNGrabSetup.frx":286C
         TabIndex        =   98
         Top             =   2790
         Width           =   735
      End
      Begin VB.ComboBox comCDSize5 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":287A
         Left            =   6000
         List            =   "frmNGrabSetup.frx":2888
         TabIndex        =   97
         Top             =   3120
         Width           =   735
      End
      Begin VB.ComboBox comCDSize6 
         Appearance      =   0  '2D
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   1
         EndProperty
         Height          =   315
         ItemData        =   "frmNGrabSetup.frx":2896
         Left            =   6000
         List            =   "frmNGrabSetup.frx":28A4
         TabIndex        =   96
         Top             =   3480
         Width           =   735
      End
      Begin VB.TextBox txtMinAvg 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   6480
         TabIndex        =   55
         Top             =   930
         Width           =   855
      End
      Begin VB.TextBox txtMaxAvg 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2745
         TabIndex        =   53
         Top             =   945
         Width           =   855
      End
      Begin VB.TextBox txtMinBitrate 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   6480
         TabIndex        =   52
         Top             =   465
         Width           =   855
      End
      Begin VB.TextBox txtMaxBitrate 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2745
         TabIndex        =   50
         Top             =   465
         Width           =   855
      End
      Begin VB.Label Label23 
         Caption         =   "Max. Durchschnittliche Bitrate:"
         Height          =   255
         Left            =   360
         TabIndex        =   150
         Top             =   960
         Width           =   2175
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   149
         Top             =   1680
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   1
         Left            =   360
         TabIndex        =   148
         Top             =   2040
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   2
         Left            =   360
         TabIndex        =   147
         Top             =   2400
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   3
         Left            =   360
         TabIndex        =   146
         Top             =   2760
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   4
         Left            =   360
         TabIndex        =   145
         Top             =   3120
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Zwischen"
         Height          =   255
         Index           =   5
         Left            =   360
         TabIndex        =   144
         Top             =   3480
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   6
         Left            =   1800
         TabIndex        =   143
         Top             =   1680
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   7
         Left            =   1800
         TabIndex        =   142
         Top             =   2040
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   8
         Left            =   1800
         TabIndex        =   141
         Top             =   2400
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   9
         Left            =   1800
         TabIndex        =   140
         Top             =   2760
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   10
         Left            =   1800
         TabIndex        =   139
         Top             =   3120
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "und"
         Height          =   255
         Index           =   11
         Left            =   1800
         TabIndex        =   138
         Top             =   3480
         Width           =   375
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   12
         Left            =   2760
         TabIndex        =   137
         Top             =   1680
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   13
         Left            =   2760
         TabIndex        =   136
         Top             =   2040
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   14
         Left            =   2760
         TabIndex        =   135
         Top             =   2400
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   15
         Left            =   2760
         TabIndex        =   134
         Top             =   2760
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   16
         Left            =   2760
         TabIndex        =   133
         Top             =   3120
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Minuten"
         Height          =   255
         Index           =   17
         Left            =   2760
         TabIndex        =   132
         Top             =   3480
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   18
         Left            =   3840
         TabIndex        =   131
         Top             =   1680
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   19
         Left            =   3840
         TabIndex        =   130
         Top             =   2040
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   20
         Left            =   3840
         TabIndex        =   129
         Top             =   2400
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   21
         Left            =   3840
         TabIndex        =   128
         Top             =   2760
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   22
         Left            =   3840
         TabIndex        =   127
         Top             =   3120
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "Benutze"
         Height          =   255
         Index           =   23
         Left            =   3840
         TabIndex        =   126
         Top             =   3480
         Width           =   735
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   24
         Left            =   5040
         TabIndex        =   125
         Top             =   1680
         Width           =   1005
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   25
         Left            =   5040
         TabIndex        =   124
         Top             =   2040
         Width           =   1005
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   26
         Left            =   5040
         TabIndex        =   123
         Top             =   2400
         Width           =   1005
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   27
         Left            =   5040
         TabIndex        =   122
         Top             =   2760
         Width           =   1005
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   28
         Left            =   5040
         TabIndex        =   121
         Top             =   3120
         Width           =   1005
      End
      Begin VB.Label Label33 
         Caption         =   "CD(s) Größe:"
         Height          =   255
         Index           =   29
         Left            =   5040
         TabIndex        =   120
         Top             =   3480
         Width           =   1005
      End
      Begin VB.Label Label24 
         Caption         =   "Min. Durchschnittliche Bitrate:"
         Height          =   255
         Left            =   4080
         TabIndex        =   54
         Top             =   960
         Width           =   2175
      End
      Begin VB.Label Label22 
         Caption         =   "Minimale Bitrate:"
         Height          =   255
         Left            =   4080
         TabIndex        =   51
         Top             =   480
         Width           =   1215
      End
      Begin VB.Label Label21 
         Caption         =   "Maximale Bitrate:"
         Height          =   255
         Left            =   360
         TabIndex        =   49
         Top             =   480
         Width           =   1335
      End
   End
   Begin VB.Frame frmD2SVideoSettings 
      Appearance      =   0  '2D
      Caption         =   "Video Einstellugnen"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   76
      Top             =   60
      Width           =   7560
      Begin VB.TextBox txtEncoderEXE 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2295
         TabIndex        =   153
         Top             =   2100
         Width           =   4245
      End
      Begin VB.ComboBox comAspectRate 
         Appearance      =   0  '2D
         Height          =   315
         Left            =   2310
         TabIndex        =   79
         Top             =   375
         Width           =   3615
      End
      Begin VB.OptionButton optEncoder 
         Caption         =   "Cinema Craft Encoder"
         Height          =   375
         Index           =   0
         Left            =   165
         TabIndex        =   78
         Tag             =   "frmD2SCCESettings"
         Top             =   1215
         Width           =   1935
      End
      Begin VB.OptionButton optEncoder 
         Caption         =   "TMPGEnc"
         Height          =   375
         Index           =   1
         Left            =   165
         TabIndex        =   77
         Tag             =   "frmD2STMPGSettings"
         Top             =   1560
         Width           =   1935
      End
      Begin NOXButton10.NOXButton cmdEncoderEXE 
         Height          =   345
         Left            =   6630
         TabIndex        =   162
         Top             =   2070
         Width           =   390
         _ExtentX        =   688
         _ExtentY        =   609
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":28B2
         ImageMouseOver  =   "frmNGrabSetup.frx":2E4C
         Caption         =   ""
      End
      Begin VB.Frame frmD2STMPGSettings 
         Appearance      =   0  '2D
         Caption         =   "TMPGEnc Einstellungen"
         ForeColor       =   &H80000008&
         Height          =   2865
         Left            =   165
         TabIndex        =   82
         Top             =   2655
         Width           =   6795
         Begin VB.ComboBox comRateControl 
            Appearance      =   0  '2D
            Height          =   315
            Left            =   150
            TabIndex        =   84
            Top             =   585
            Width           =   3615
         End
         Begin VB.ComboBox comMotion 
            Appearance      =   0  '2D
            Height          =   315
            Left            =   150
            TabIndex        =   83
            Top             =   1290
            Width           =   3615
         End
         Begin VB.Label Label19 
            Caption         =   "RateControl Mode:"
            Height          =   255
            Left            =   150
            TabIndex        =   86
            Top             =   345
            Width           =   2295
         End
         Begin VB.Label Label20 
            Caption         =   "Motion Search Precision:"
            Height          =   255
            Left            =   150
            TabIndex        =   85
            Top             =   1050
            Width           =   2655
         End
      End
      Begin VB.Frame frmD2SCCESettings 
         Appearance      =   0  '2D
         Caption         =   "Cinema Craft Encoder Einstellungen"
         ForeColor       =   &H80000008&
         Height          =   2865
         Left            =   165
         TabIndex        =   87
         Top             =   2655
         Width           =   6795
         Begin VB.CheckBox chkSafeMode 
            Caption         =   "Safe Mode (für CCE > 2.50)"
            Height          =   255
            Left            =   240
            TabIndex        =   92
            Top             =   420
            Width           =   2340
         End
         Begin VB.OptionButton optCCEVEM 
            Caption         =   "Controlled Bitrate"
            Height          =   255
            Index           =   0
            Left            =   255
            TabIndex        =   91
            Top             =   1425
            Width           =   1695
         End
         Begin VB.OptionButton optCCEVEM 
            Caption         =   "Varible Bitrate Single Pass"
            Height          =   255
            Index           =   1
            Left            =   255
            TabIndex        =   90
            Top             =   1785
            Width           =   2415
         End
         Begin VB.OptionButton optCCEVEM 
            Caption         =   "Variable Bitrate Multi Pass"
            Height          =   255
            Index           =   2
            Left            =   255
            TabIndex        =   89
            Top             =   2145
            Width           =   2175
         End
         Begin VB.TextBox txtCCEVBR 
            Appearance      =   0  '2D
            BorderStyle     =   0  'Kein
            Height          =   255
            Left            =   2535
            TabIndex        =   88
            Top             =   2130
            Width           =   615
         End
         Begin VB.Label Label17 
            Caption         =   "Video Encoding Mode:"
            Height          =   255
            Left            =   255
            TabIndex        =   93
            Top             =   1065
            Width           =   1935
         End
      End
      Begin VB.Label lblEncoderEXE 
         Caption         =   "Encoder Ausführbare Datei"
         Height          =   285
         Left            =   180
         TabIndex        =   152
         Top             =   2130
         Width           =   2100
      End
      Begin VB.Label Label12 
         Caption         =   "Seitenverhätlnis"
         Height          =   255
         Left            =   150
         TabIndex        =   81
         Top             =   420
         Width           =   1335
      End
      Begin VB.Label Label11 
         Caption         =   "Encoder"
         Height          =   255
         Left            =   180
         TabIndex        =   80
         Top             =   960
         Width           =   1695
      End
   End
   Begin VB.Frame frmD2SPrograms 
      Appearance      =   0  '2D
      Caption         =   "Encoding Programme"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   61
      Top             =   60
      Width           =   7560
      Begin VB.TextBox txtDVD2AVI 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   75
         Top             =   3255
         Width           =   5250
      End
      Begin VB.TextBox txtBeSweet 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   73
         Top             =   2775
         Width           =   5250
      End
      Begin VB.TextBox txtSimpleResize 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   71
         Top             =   2280
         Width           =   5250
      End
      Begin VB.TextBox txtInverse 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   69
         Top             =   1815
         Width           =   5250
      End
      Begin VB.TextBox txtMPEG2Dec 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   67
         Top             =   1305
         Width           =   5250
      End
      Begin VB.TextBox txtPulldown 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1545
         TabIndex        =   65
         Top             =   810
         Width           =   5250
      End
      Begin VB.TextBox txtbbMPEG 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   1560
         TabIndex        =   63
         Top             =   345
         Width           =   5250
      End
      Begin NOXButton10.NOXButton cmdbbmpeg 
         Height          =   330
         Left            =   6915
         TabIndex        =   155
         Top             =   315
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":33E6
         ImageMouseOver  =   "frmNGrabSetup.frx":3980
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdPulldown 
         Height          =   330
         Left            =   6915
         TabIndex        =   156
         Top             =   780
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":3F1A
         ImageMouseOver  =   "frmNGrabSetup.frx":44B4
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdMPEG2Dec 
         Height          =   330
         Left            =   6930
         TabIndex        =   157
         Top             =   1275
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":4A4E
         ImageMouseOver  =   "frmNGrabSetup.frx":4FE8
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdInversTelecine 
         Height          =   330
         Left            =   6930
         TabIndex        =   158
         Top             =   1770
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":5582
         ImageMouseOver  =   "frmNGrabSetup.frx":5B1C
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdSimpleResize 
         Height          =   330
         Left            =   6930
         TabIndex        =   159
         Top             =   2250
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":60B6
         ImageMouseOver  =   "frmNGrabSetup.frx":6650
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdBeSweet 
         Height          =   330
         Left            =   6930
         TabIndex        =   160
         Top             =   2730
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":6BEA
         ImageMouseOver  =   "frmNGrabSetup.frx":7184
         Caption         =   ""
      End
      Begin NOXButton10.NOXButton cmdDVD2AVI 
         Height          =   330
         Left            =   6930
         TabIndex        =   161
         Top             =   3210
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":771E
         ImageMouseOver  =   "frmNGrabSetup.frx":7CB8
         Caption         =   ""
      End
      Begin VB.Label Label32 
         Caption         =   "DVD2AVI:"
         Height          =   255
         Left            =   120
         TabIndex        =   74
         Top             =   3270
         Width           =   855
      End
      Begin VB.Label Label30 
         Caption         =   "BeSweet:"
         Height          =   255
         Left            =   120
         TabIndex        =   72
         Top             =   2790
         Width           =   1095
      End
      Begin VB.Label Label29 
         Caption         =   "SimpleResize:"
         Height          =   255
         Left            =   120
         TabIndex        =   70
         Top             =   2310
         Width           =   1215
      End
      Begin VB.Label Label28 
         Caption         =   "Inverse telecine:"
         Height          =   375
         Left            =   120
         TabIndex        =   68
         Top             =   1830
         Width           =   1335
      End
      Begin VB.Label Label27 
         Caption         =   "MPEG2Dec:"
         Height          =   255
         Left            =   120
         TabIndex        =   66
         Top             =   1350
         Width           =   975
      End
      Begin VB.Label Label26 
         Caption         =   "PullDown:"
         Height          =   255
         Left            =   120
         TabIndex        =   64
         Top             =   870
         Width           =   735
      End
      Begin VB.Label Label25 
         Caption         =   "bbMPEG:"
         Height          =   255
         Left            =   120
         TabIndex        =   62
         Top             =   390
         Width           =   735
      End
   End
   Begin VB.Frame frmNGrabFileExtensions 
      Appearance      =   0  '2D
      Caption         =   "Erweiterungen der Grab-Dateien"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   20
      Top             =   60
      Width           =   7560
      Begin VB.TextBox txtLOG 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2250
         TabIndex        =   29
         Top             =   1215
         Width           =   480
      End
      Begin VB.TextBox txtM2A 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   5085
         TabIndex        =   27
         Top             =   735
         Width           =   465
      End
      Begin VB.TextBox txtM2V 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   5070
         TabIndex        =   25
         Top             =   285
         Width           =   465
      End
      Begin VB.TextBox txtTXT 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2250
         TabIndex        =   23
         Top             =   765
         Width           =   465
      End
      Begin VB.TextBox txtM2P 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   2250
         TabIndex        =   21
         Top             =   330
         Width           =   465
      End
      Begin VB.Label Label10 
         Caption         =   "Log Datei"
         Height          =   255
         Left            =   150
         TabIndex        =   30
         Top             =   1260
         Width           =   1935
      End
      Begin VB.Label Label9 
         Caption         =   "Audio PES Datei"
         Height          =   255
         Left            =   3270
         TabIndex        =   28
         Top             =   735
         Width           =   1935
      End
      Begin VB.Label Label6 
         Caption         =   "Video PES Datei"
         Height          =   255
         Left            =   3270
         TabIndex        =   26
         Top             =   330
         Width           =   1935
      End
      Begin VB.Label lblTXT 
         Caption         =   "EPG Informations Datei"
         Height          =   255
         Left            =   135
         TabIndex        =   24
         Top             =   780
         Width           =   1980
      End
      Begin VB.Label Label8 
         Caption         =   "Program Stream Datei"
         Height          =   255
         Left            =   135
         TabIndex        =   22
         Top             =   360
         Width           =   2070
      End
   End
   Begin VB.Frame frmWinGrabEngine 
      Appearance      =   0  '2D
      Caption         =   "WinGrabEngine"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   12
      Top             =   60
      Visible         =   0   'False
      Width           =   7560
      Begin VB.OptionButton optStreamingArt 
         Appearance      =   0  '2D
         Caption         =   "Audio und Video Pes File"
         ForeColor       =   &H80000008&
         Height          =   375
         Index           =   1
         Left            =   180
         TabIndex        =   17
         Top             =   990
         Width           =   2655
      End
      Begin VB.OptionButton optStreamingArt 
         Appearance      =   0  '2D
         Caption         =   "Program Stream File"
         ForeColor       =   &H80000008&
         Height          =   375
         Index           =   0
         Left            =   180
         TabIndex        =   16
         Top             =   645
         Width           =   2655
      End
      Begin VB.TextBox txtExrasOptionenSplitGroesse 
         Appearance      =   0  '2D
         Height          =   285
         Left            =   4980
         TabIndex        =   13
         Top             =   360
         Width           =   795
      End
      Begin VB.Label Label5 
         Caption         =   "Split-Größe funktioniert nur mit ""Program Stream File"", es ist noch ein Bug in der WinGrabEngine.DLL"
         Height          =   615
         Left            =   3570
         TabIndex        =   19
         Top             =   780
         Width           =   3375
      End
      Begin VB.Label Label4 
         Caption         =   "Streaming-Typ"
         Height          =   255
         Left            =   195
         TabIndex        =   18
         Top             =   375
         Width           =   2055
      End
      Begin VB.Label Label3 
         Caption         =   "MB"
         Height          =   255
         Left            =   5850
         TabIndex        =   15
         Top             =   405
         Width           =   495
      End
      Begin VB.Label Label1 
         Caption         =   "Split-Größe (Datei):"
         Height          =   255
         Left            =   3570
         TabIndex        =   14
         Top             =   390
         Width           =   2415
      End
   End
   Begin VB.Frame frmD2SAudioSettings 
      Appearance      =   0  '2D
      Caption         =   "Encoder Audio Einstellungen"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   42
      Top             =   60
      Width           =   7560
      Begin VB.CheckBox chkAudioDownsample 
         Caption         =   "Audio Frequenz auf 44.1 samplen"
         Height          =   375
         Left            =   3120
         TabIndex        =   47
         Top             =   540
         Width           =   2895
      End
      Begin VB.ComboBox comAudioBitrate 
         Appearance      =   0  '2D
         Height          =   315
         Left            =   240
         TabIndex        =   46
         Top             =   1320
         Width           =   2055
      End
      Begin VB.ComboBox comAudioMode 
         Appearance      =   0  '2D
         Height          =   315
         Left            =   240
         TabIndex        =   43
         Top             =   585
         Width           =   2055
      End
      Begin VB.Label Label14 
         Caption         =   "Audio Bitrate:"
         Height          =   255
         Left            =   240
         TabIndex        =   45
         Top             =   1080
         Width           =   1335
      End
      Begin VB.Label Label13 
         Caption         =   "Audio Modus:"
         Height          =   255
         Left            =   240
         TabIndex        =   44
         Top             =   360
         Width           =   1815
      End
   End
   Begin VB.Frame frmD2SSettings 
      Appearance      =   0  '2D
      Caption         =   "Allgemeine Encoder Einstellungen"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   35
      Top             =   60
      Width           =   7560
      Begin VB.CheckBox chkNoDelete 
         Caption         =   "Keine Dateien löschen"
         Height          =   255
         Left            =   4860
         TabIndex        =   41
         Top             =   1635
         Width           =   2295
      End
      Begin VB.CheckBox chkAutoShutdown 
         Caption         =   "Automatisch Herunterfahren"
         Height          =   255
         Left            =   4860
         TabIndex        =   40
         Top             =   1155
         Width           =   2535
      End
      Begin VB.DriveListBox DriveD2S 
         Appearance      =   0  '2D
         Height          =   315
         Left            =   195
         TabIndex        =   37
         Top             =   615
         Width           =   2505
      End
      Begin VB.DirListBox DirD2S 
         Appearance      =   0  '2D
         Height          =   4365
         Left            =   180
         TabIndex        =   36
         Top             =   1095
         Width           =   4065
      End
      Begin NOXButton10.NOXButton cmdNeuerOrdnerD2S 
         Height          =   345
         Left            =   2760
         TabIndex        =   38
         Top             =   585
         Width           =   1440
         _ExtentX        =   2540
         _ExtentY        =   609
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":8252
         ImageMouseOver  =   "frmNGrabSetup.frx":87EC
         Caption         =   "&Neuer Ordner"
      End
      Begin VB.Label Label2 
         Caption         =   "Ausgabe Verzeichnis:"
         Height          =   255
         Index           =   0
         Left            =   195
         TabIndex        =   39
         Top             =   360
         Width           =   2295
      End
   End
   Begin VB.Frame frmDBoxSettings 
      Appearance      =   0  '2D
      Caption         =   "DBox-Einstellungen"
      ForeColor       =   &H80000008&
      Height          =   5685
      Left            =   2850
      TabIndex        =   0
      Top             =   75
      Width           =   7560
      Begin MSComctlLib.TreeView tvDBoxInfo 
         Height          =   4260
         Left            =   165
         TabIndex        =   163
         Top             =   1245
         Width           =   4140
         _ExtentX        =   7303
         _ExtentY        =   7514
         _Version        =   393217
         Indentation     =   353
         Style           =   7
         Appearance      =   0
         Enabled         =   0   'False
      End
      Begin VB.TextBox txtExtrasOptionenPort 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   225
         Left            =   1830
         TabIndex        =   2
         Top             =   840
         Width           =   2475
      End
      Begin VB.TextBox txtdBoxIPAdress 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   225
         Left            =   1830
         TabIndex        =   1
         Top             =   420
         Width           =   2475
      End
      Begin VB.Label lblListenGrab_Port 
         Caption         =   "Port (Listen-Grab)"
         Height          =   255
         Left            =   165
         TabIndex        =   4
         Top             =   825
         Width           =   1575
      End
      Begin VB.Label Label7 
         Caption         =   "IP-Adresse Ihrer dBox"
         Height          =   255
         Left            =   165
         TabIndex        =   3
         Top             =   420
         Width           =   1935
      End
   End
   Begin VB.Frame frmNGrabSettings 
      Appearance      =   0  '2D
      Caption         =   "Einstellung"
      ForeColor       =   &H80000008&
      Height          =   5685
      Left            =   2850
      TabIndex        =   6
      Top             =   75
      Visible         =   0   'False
      Width           =   7560
      Begin VB.CheckBox chkExtrasOptionenSyncTime 
         Caption         =   "Systemzeit mit der dBox syncronisieren"
         Height          =   300
         Left            =   150
         TabIndex        =   11
         Top             =   960
         Width           =   3075
      End
      Begin VB.CheckBox chkExtrasOptionenLOG 
         Caption         =   "LOG speichern"
         Height          =   240
         Left            =   150
         TabIndex        =   10
         Top             =   645
         Width           =   3075
      End
      Begin VB.CheckBox chkExtrasOptionenEPG 
         Caption         =   "EPG Information speichern"
         Height          =   300
         Left            =   150
         TabIndex        =   9
         Top             =   270
         Width           =   3315
      End
   End
   Begin VB.Frame frmMPEG2Encoder 
      Appearance      =   0  '2D
      Caption         =   "MPEG2 Encoder"
      ForeColor       =   &H80000008&
      Height          =   5685
      Left            =   2850
      TabIndex        =   56
      Top             =   75
      Width           =   7560
      Begin NOXButton10.NOXButton cmdDVD2SVCDEXE 
         Height          =   330
         Left            =   5115
         TabIndex        =   151
         Top             =   435
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":8D86
         ImageMouseOver  =   "frmNGrabSetup.frx":9320
         Caption         =   ""
      End
      Begin VB.TextBox txtPVAStrumento 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   120
         TabIndex        =   94
         Top             =   1110
         Width           =   4935
      End
      Begin VB.TextBox txtDVD2SVCDEXE 
         Appearance      =   0  '2D
         BorderStyle     =   0  'Kein
         Height          =   255
         Left            =   120
         TabIndex        =   59
         Top             =   495
         Width           =   4935
      End
      Begin VB.CheckBox chkStartEnc 
         Caption         =   "Encoder nach Grabvorgang starten"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   58
         Top             =   5160
         Width           =   2895
      End
      Begin NOXButton10.NOXButton cmdPVAStrumentoEXE 
         Height          =   330
         Left            =   5115
         TabIndex        =   154
         Top             =   1050
         Width           =   405
         _ExtentX        =   714
         _ExtentY        =   582
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":98BA
         ImageMouseOver  =   "frmNGrabSetup.frx":9E54
         Caption         =   ""
      End
      Begin VB.TextBox txtEncCheck 
         Appearance      =   0  '2D
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'Kein
         Enabled         =   0   'False
         Height          =   3480
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   60
         Top             =   1470
         Width           =   5535
      End
      Begin VB.Label Label15 
         Caption         =   "PVAStrumento Startdatei:"
         Height          =   255
         Left            =   120
         TabIndex        =   95
         Top             =   840
         Width           =   1935
      End
      Begin VB.Label Label2 
         Caption         =   "DVD2SVCD Startdatei:"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   57
         Top             =   240
         Width           =   1695
      End
   End
   Begin VB.Frame frmNGrabPaths 
      Appearance      =   0  '2D
      Caption         =   "Grab Pfad"
      ForeColor       =   &H80000008&
      Height          =   5700
      Left            =   2850
      TabIndex        =   5
      Top             =   60
      Width           =   7560
      Begin NOXButton10.NOXButton cmdNeuerOrdner 
         Height          =   345
         Left            =   2670
         TabIndex        =   31
         Top             =   390
         Width           =   1440
         _ExtentX        =   2540
         _ExtentY        =   609
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Image           =   "frmNGrabSetup.frx":A3EE
         ImageMouseOver  =   "frmNGrabSetup.frx":A988
         Caption         =   "&Neuer Ordner"
      End
      Begin VB.DirListBox Dir1 
         Appearance      =   0  '2D
         Height          =   4590
         Left            =   135
         TabIndex        =   8
         Top             =   960
         Width           =   3975
      End
      Begin VB.DriveListBox Drive1 
         Appearance      =   0  '2D
         Height          =   315
         Left            =   135
         TabIndex        =   7
         Top             =   405
         Width           =   2445
      End
   End
End
Attribute VB_Name = "frmNgrabSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   frmNGrabSetup.frm
' </NAME>
'
' <DESCRIPTION>
'   nGrab Optionsdialog
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
'   RE, LYNX, ZERO
' </AUTHOR>
'
' <HISTORY>
'   09.07.2002 - RE Hinzufügen der Dokumentation
'   24.07.2002 - LYNX Änderungen am Formulardesign
'   26.07.2002 - LYNX Änderungen am Formulardesign, Icon hinzugefügt, Neuer Ordner Bug behoben, Formularnamen geändert (Notation)
'   31.07.2002 - LYNX Umstellung! Einstellungen werden jetzt in der Registry gespeichert. Es gibt jetzt globale Funktionen um die Einstellungen zu laden und zu Speichern.
'   21.10.2002 - LYNX TreeView hinzugefügt
'   23.10.2002 - ZERO D2S Einstellungen in Tree hinzugefügt. D2S Frames hinzugefügt. Änderungen am Design (Forms geschachtelt)
'   27.10.2002 - LYNX Refactoring der D2S Anpassungen => Integration der neuen RegistryKeys in die Installationsroutine
'   29.10.2002 - ZERO Behebung möglicher Fehlerquellen
'   30.10.2002 - LYNX Abstraktion der Einblendung von Frames. Einzelne Elemente einer OptionGroup können jetzt
'                     im Tag den Namen eines Frames stehen haben.
'                     Diese Frames werden bei Aktivierung eines OptionGroup Elements sichtbar ;)
'                     Alles in allem finde ich diesen Einstellungsdialog noch ziemlich suckend ;)
'   30.10.2002 - ZERO Plausi in dem "suckendem" Video Einstellungs Dialog hinzugefügt
'   01.11.2002 - LYNX Buttons durch NGrabButton10.control ersetzt. Folder Icons hinzugefügt. MouseOver Events hinzugefügt.
'                     OptionGroup Handling erneut verbessert. Solangsam wirds was...
'   10.11.2002 - LYNX Methoden zum Connectionhandling zur Box hinzugefügt!
'   13.11.2002 - ZERO Ab Sofort Unterstützung für D2S 1.1
'                     Variablen und Steuerelemente für Madplay rausgeflogen (-> d2s 1.1)

' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Dim moTreeView As TreeView

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   chkStartEnc_Click
' </NAME>
'
' <DESCRIPTION>
'   Plausis
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub chkStartEnc_Click()
    
    If chkStartEnc = 1 Then
        
        If Not InStr(1, txtEncCheck, "!", vbTextCompare) = 0 Then
            chkStartEnc = 0
            MsgBox "Es wurden nicht alle benötigten Angaben gemacht!"
        End If
        
    End If
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdbbMPEG_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für bbMPEG Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdbbMPEG_Click()

    mcdDialog.Filter = "bbMPEG StartDatei (RunbbMPEG.exe)|RunbbMPEG.exe"
    mcdDialog.ShowOpen
    txtbbMPEG = mcdDialog.filename
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdBeSweet_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für BeSweet Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdBeSweet_Click()

    mcdDialog.Filter = "BeSweet (BeSweet.exe)|BeSweet.exe"
    mcdDialog.ShowOpen
    txtBeSweet = mcdDialog.filename

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdCCEFile_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für CCE Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdEncoderEXE_Click()

    If optEncoder(0) = True Then
        mcdDialog.Filter = "CCE (cctsp(t).exe)|cctsp.exe; cctspt.exe"
    Else
        mcdDialog.Filter = "TMPGEnc (TMPGEnc.exe)|TMPGEnc.exe"
    End If
    
    mcdDialog.ShowOpen
    txtEncoderEXE = mcdDialog.filename
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdDVD2AVI_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für DVD2AVI Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdDVD2AVI_Click()

    mcdDialog.Filter = "DVD2AVI (DVD2AVI.exe)|DVD2AVI.exe"
    mcdDialog.ShowOpen
    txtDVD2AVI = mcdDialog.filename

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdDVD2SVCDEXE_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für DVD2SVCD Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdDVD2SVCDEXE_Click()

    mcdDialog.Filter = "DVD2SVCD (dvd2svcd.exe)|dvd2svcd.exe"
    mcdDialog.ShowOpen
    txtDVD2SVCDEXE = mcdDialog.filename

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdInverse_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für Inverse telecine DLL Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdInversTelecine_Click()

    mcdDialog.Filter = "Inverse telecine (decomb.dll)|decomb.dll"
    mcdDialog.ShowOpen
    txtInverse = mcdDialog.filename

End Sub



'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdMPEG2Dec_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für MPEG2Dec DLL Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdMPEG2Dec_Click()

    mcdDialog.Filter = "Mpeg2DEC (mpeg2dec.dll)|mpeg2dec.dll"
    mcdDialog.ShowOpen
    txtMPEG2Dec = mcdDialog.filename

End Sub

Private Sub cmdOK_Click()

    goSettings.sItem(NLSDBoxIPAdress) = Trim$(txtdBoxIPAdress.Text)
    goSettings.sItem(NLSDBoxPort) = Trim$(txtExtrasOptionenPort.Text)
    goSettings.sItem(NLSEncFile) = Trim$(txtDVD2SVCDEXE.Text)
    
    If Mid$(Dir1.Path, 2, 1) = ":" And Len(Dir1.Path) <= 3 Then
        goSettings.sItem(NLSGrabPath) = Trim$(Dir1.Path)
    Else
        goSettings.sItem(NLSGrabPath) = Trim$(Dir1.Path & "\")
    End If
    
    goSettings.nItem(NLSStartEnc) = Trim$(chkStartEnc.Value)
    goSettings.nItem(NLSWriteEPG) = Trim$(chkExtrasOptionenEPG.Value)
    goSettings.nItem(NLSWriteLog) = Trim$(chkExtrasOptionenLOG.Value)
    goSettings.nItem(NLSSyncTime) = Trim$(chkExtrasOptionenSyncTime.Value)
    goSettings.nItem(NLSWGESplitFile) = Trim$(Me.txtExrasOptionenSplitGroesse)
    
    goSettings.sItem(NLSFileExtM2P) = Trim$(Me.txtM2P)
    goSettings.sItem(NLSFileExtTXT) = Trim$(Me.txtTXT)
    goSettings.sItem(NLSFileExtM2V) = Trim$(Me.txtM2V)
    goSettings.sItem(NLSFileExtM2A) = Trim$(Me.txtM2A)
    goSettings.sItem(NLSFileExtLOG) = Trim$(Me.txtLOG)
    
    If optStreamingArt(0).Value = True Then
        goSettings.nItem(NLSWGEStreamType) = 1
    Else
        goSettings.nItem(NLSWGEStreamType) = 0
    End If

    Call gRegistrySettingsSave
    
    'D2S Save
    Call D2SSettingsSave
    
    Unload Me

End Sub

Private Sub cmdCancel_Click()
    
    Call gRegistrySettingsRead
    goEngine.Connect
    
    Unload Me
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdNeuerOrdner_Click
' </NAME>
'
' <DESCRIPTION>
'   Wenn ein neuer Ordner auf der HDD erstellt werden soll, hier lang!
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdNeuerOrdner_Click()
    
    Dim sPath As String
    
    sPath = InputBox$("Neuer Ordner", "Neuer Ordner", Dir1.Path)
    
    If Right$(sPath, 1) = "\" Or Len(sPath) = 0 Then Exit Sub
    FileSystem.MkDir sPath
    Dir1.Refresh

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdPulldown_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für Pulldown Startdatei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdPulldown_Click()

    mcdDialog.Filter = "PullDown (pulldown.exe)|pulldown.exe"
    mcdDialog.ShowOpen
    txtPulldown = mcdDialog.filename

End Sub

Private Sub cmdPVAStrumentoEXE_Click()

    mcdDialog.Filter = "PVAStrumento StartDatei (cPVAS.EXE)|cPVAS.EXE"
    mcdDialog.ShowOpen
    txtPVAStrumento = mcdDialog.filename

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdSimpleResize_Click
' </NAME>
'
' <DESCRIPTION>
'   Öffnen des Commondialogs für Simple Resize DLL Datei
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdSimpleResize_Click()

    mcdDialog.Filter = "SimpleResize (SimpleResize.dll)|SimpleResize.dll"
    mcdDialog.ShowOpen
    txtSimpleResize = mcdDialog.filename

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   Dir1_Change
' </NAME>
'
' <DESCRIPTION>
'   Synchronisieren der DriveListBox und der DirListBox
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub Dir1_Change()

    On Error GoTo DriveHandler
    Drive1.Drive = Dir1.Path
    Exit Sub

DriveHandler:
    Dir1.Path = Drive1.Drive
    Exit Sub

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   Drive1_Change
' </NAME>
'
' <DESCRIPTION>
'   Synchronisieren der DriveListBox und der DirListBox
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub Drive1_Change()

    On Error GoTo DriveHandler
    Dir1.Path = Drive1.Drive
    Exit Sub

DriveHandler:
    Drive1.Drive = Dir1.Path
    Exit Sub

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   Form_Load
' </NAME>
'
' <DESCRIPTION>
'   Form_Load der Optionsform
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub Form_Load()
        
    Call mFormInit
    Call mD2SInit
        
    txtdBoxIPAdress.Text = goSettings.sItem(NLSDBoxIPAdress)
    txtExtrasOptionenPort.Text = goSettings.sItem(NLSDBoxPort)
    txtDVD2SVCDEXE.Text = goSettings.sItem(NLSEncFile)
        
    If Not Mid$(goSettings.sItem(NLSGrabPath), 2, 1) = ":" And Not Len(goSettings.sItem(NLSGrabPath)) <= 3 Then
        If Dir(goSettings.sItem(NLSGrabPath), vbDirectory) = "" Then
            MkDir (goSettings.sItem(NLSGrabPath))
        End If
    End If
        
    Dir1.Path = goSettings.sItem(NLSGrabPath)
    
    chkExtrasOptionenEPG.Value = goSettings.sItem(NLSWriteEPG)
    chkExtrasOptionenLOG.Value = goSettings.sItem(NLSWriteLog)
    chkExtrasOptionenSyncTime.Value = goSettings.sItem(NLSSyncTime)
    txtExrasOptionenSplitGroesse.Text = goSettings.sItem(NLSWGESplitFile)
    
    Me.txtM2P = goSettings.sItem(NLSFileExtM2P)
    Me.txtTXT = goSettings.sItem(NLSFileExtTXT)
    Me.txtM2V = goSettings.sItem(NLSFileExtM2V)
    Me.txtM2A = goSettings.sItem(NLSFileExtM2A)
    Me.txtLOG = goSettings.sItem(NLSFileExtLOG)
    
    ' DirectGrab oder DirectMuxGrab
    If goSettings.sItem(NLSWGEStreamType) = 1 Then
        optStreamingArt(0).Value = True
        optStreamingArt(1).Value = False
        txtExrasOptionenSplitGroesse.Enabled = True
    ElseIf goSettings.sItem(NLSWGEStreamType) = 0 Then
        optStreamingArt(0).Value = False
        optStreamingArt(1).Value = True
        txtExrasOptionenSplitGroesse.Enabled = False
    End If
        
    'D2S
    'globale Verzeichnisse
    gsProjectFile = App.Path & "\D2S\" & NLSND2SProjectFile
    gsINIFile = App.Path & "\D2S\" & NLSND2SINIFile
    
    Call D2SSettingsLoad
    
    chkStartEnc.Value = goSettings.sItem(NLSStartEnc)
    
'    Call mEncodingOptionsCheck
                        
End Sub

Private Sub mFormInit()

    Dim oNode As Node
        
    Set moTreeView = Me.tvTreeView
    
    Set oNode = moTreeView.Nodes.Add(, tvwFirst, "ROOT", "NGrab Einstellungen")
        
    oNode.Expanded = True
    
    Call mTreeViewInit(oNode, NLSNGrabRegKey & NLSNGrabRegKeySettings)
    
    Call mItemClicked(oNode)
    
End Sub

Private Sub mTreeViewInit(oNode As Node, sKey As String)

    Dim oSubNode As Node
    Dim colSettings As Collection
    Dim nCnt As Integer
    Dim sName As String
    Dim sFrame As String

    Set colSettings = gcolRegistryValues(HKEY_LOCAL_MACHINE, sKey)
    
    If Not colSettings Is Nothing Then
    
        For nCnt = 1 To colSettings.Count
            
            If colSettings(nCnt)(2) = 3 Then
            
                sName = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, sKey & colSettings(nCnt)(0) & "\", "Name")
                sFrame = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, sKey & colSettings(nCnt)(0) & "\", "Frame")
                
                Set oSubNode = moTreeView.Nodes.Add(oNode, tvwChild, colSettings(nCnt)(0), sName)
                oSubNode.Tag = sFrame
            
                Call mTreeViewInit(oSubNode, sKey & colSettings(nCnt)(0) & "\")
        
            End If
        
        Next

    End If

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   optCCEVEM_Click
' </NAME>
'
' <DESCRIPTION>
'   Wählt MPEG2 Encoder
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub optCCEVEM_Click(Index As Integer)

    If Index = 2 Then
        txtCCEVBR.Enabled = True
    Else
        txtCCEVBR.Enabled = False
    End If

End Sub

Private Sub optEncoder_Click(Index As Integer)
    
    Call mFrameOptionFrameEnable(Me.optEncoder)
    Call mEncoderExecutableLoad
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   optStreamingArt_Click
' </NAME>
'
' <DESCRIPTION>
'   Wenn der Optionbutton ausgewählt wird müssen Felder enabled und
'   disabled werden!
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub optStreamingArt_Click(Index As Integer)

    Select Case Index
        Case 0
            txtExrasOptionenSplitGroesse.Enabled = True
        
        Case 1
            txtExrasOptionenSplitGroesse.Enabled = False
    End Select

End Sub

Private Sub tvTreeView_NodeClick(ByVal Node As MSComctlLib.Node)

    Call mItemClicked(Node)

End Sub

Private Sub mItemClicked(oNode As Node)
    
    Dim oControl As Control
    
    For Each oControl In Me.Controls
        If TypeName(oControl) = "Frame" Then
            oControl.Visible = False
        End If
    Next
    
    If Len(oNode.Tag) > 0 Then
        Me.Controls(moTreeView.SelectedItem.Tag).Visible = True
        Call mItemFrameInit(moTreeView.SelectedItem)
    End If
        
End Sub

Private Sub mItemFrameInit(oNode As Node)

    Select Case oNode.Tag
        Case "frmDBoxSettings"
            Call mFrameDBoxSettings
    
        Case "frmD2SVideoSettings"
            Call mFrameOptionFrameEnable(Me.optEncoder)
        
    End Select

End Sub

Private Sub mFrameOptionFrameEnable(oOptionGroup As Object)

    Dim nCnt As Integer
    
    For nCnt = 0 To oOptionGroup.Count - 1
        If oOptionGroup.Item(nCnt) Then
            Me.Controls(oOptionGroup.Item(nCnt).Tag).Visible = True
        Else
            Me.Controls(oOptionGroup.Item(nCnt).Tag).Visible = False
        End If
    Next

End Sub

Private Sub mFrameDBoxSettings()
    
    Dim odBoxTreeView As TreeView
    Dim oNode As Node
    Dim oSubNode As Node
    Dim oInfoNode As Node
    Dim nCnt As Integer
    Dim sBuffer As String
    
    Set odBoxTreeView = Me.tvDBoxInfo
    
    odBoxTreeView.Nodes.Clear
    
    If Not gbNull(goEngine.dBoxInfo.sItem(Info)) Then
    
        Set oNode = odBoxTreeView.Nodes.Add(, tvwFirst, "ROOT", "dBox Information")
        oNode.Expanded = True
        
        Set oSubNode = odBoxTreeView.Nodes.Add(oNode, tvwChild, "Info", "Info")
        oSubNode.Expanded = True
        For nCnt = 1 To gnCount(goEngine.dBoxInfo.sItem(Info), vbLf)
            Set oInfoNode = odBoxTreeView.Nodes.Add(oSubNode, tvwChild, "InfoText" & nCnt, gsParse(goEngine.dBoxInfo.sItem(Info), nCnt, vbLf))
        Next
    
        Set oSubNode = odBoxTreeView.Nodes.Add(oNode, tvwChild, "Version", "Version")
        oSubNode.Expanded = True
        For nCnt = 1 To gnCount(goEngine.dBoxInfo.sItem(Version), vbLf)
            Set oInfoNode = odBoxTreeView.Nodes.Add(oSubNode, tvwChild, "VersionText" & nCnt, gsParse(goEngine.dBoxInfo.sItem(Version), nCnt, vbLf))
        Next
    
        Set oSubNode = odBoxTreeView.Nodes.Add(oNode, tvwChild, "Settings", "Settings")
        oSubNode.Expanded = True
        For nCnt = 1 To gnCount(goEngine.dBoxInfo.sItem(Settings), vbLf)
            Set oInfoNode = odBoxTreeView.Nodes.Add(oSubNode, tvwChild, "SettingsText" & nCnt, gsParse(goEngine.dBoxInfo.sItem(Settings), nCnt, vbLf))
        Next
    
        Set oSubNode = odBoxTreeView.Nodes.Add(oNode, tvwChild, "httpdVersion", "httpdVersion")
        oSubNode.Expanded = True
        For nCnt = 1 To gnCount(goEngine.dBoxInfo.sItem(httpdversion), vbLf)
            Set oInfoNode = odBoxTreeView.Nodes.Add(oSubNode, tvwChild, "httpdVersionText" & nCnt, gsParse(goEngine.dBoxInfo.sItem(httpdversion), nCnt, vbLf))
        Next
    
    End If

End Sub

Private Sub txtdBoxIPAdress_Change()

    goSettings.sItem(NLSDBoxIPAdress) = Trim$(txtdBoxIPAdress.Text)
    goEngine.Connect
    
    Call mFrameDBoxSettings

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   cmdNeuerOrdnerD2S_Click
' </NAME>
'
' <DESCRIPTION>
'   Wenn ein neuer Ordner auf der HDD erstellt werden soll, hier lang!
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub cmdNeuerOrdnerD2S_Click()
    
    Dim sPath As String
    
    sPath = InputBox$("Neuer Ordner", "Neuer Ordner", DirD2S.Path)
    
    If Right$(sPath, 1) = "\" Or Len(sPath) = 0 Then Exit Sub
    FileSystem.MkDir sPath
    DirD2S.Refresh

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   DirD2S_Change
' </NAME>
'
' <DESCRIPTION>
'   Synchronisieren der DriveListBox und der DirListBox
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub DirD2S_Change()

    On Error GoTo DriveHandler
    DriveD2S.Drive = DirD2S.Path
    Exit Sub

DriveHandler:
    DirD2S.Path = DriveD2S.Drive
    Exit Sub

End Sub


'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   DriveD2S_Change
' </NAME>
'
' <DESCRIPTION>
'   Synchronisieren der DriveListBox und der DirListBox
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub DriveD2S_Change()

    On Error GoTo DriveHandler
    DirD2S.Path = DriveD2S.Drive
    Exit Sub

DriveHandler:
    DriveD2S.Drive = DirD2S.Path
    Exit Sub

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   mD2SInit
' </NAME>
'
' <DESCRIPTION>
'   Initialisieriung der D2S Steuerelemente
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub mD2SInit()

' ComboBox comAspectRate
    comAspectRate.AddItem "4:3 (Keine Ränder)", 0
    comAspectRate.AddItem "16:9 (mit Ränder)", 1

' ComboBox comAudioMode
    comAudioMode.AddItem "Stereo", 0
    comAudioMode.AddItem "Dual Channel", 1
    comAudioMode.AddItem "Joint Stereo", 2
    comAudioMode.AddItem "MPEG 5.1", 3

' ComboBox comAudioBitrate
    comAudioBitrate.AddItem "32", 0
    comAudioBitrate.AddItem "48", 1
    comAudioBitrate.AddItem "56", 2
    comAudioBitrate.AddItem "64", 3
    comAudioBitrate.AddItem "80", 4
    comAudioBitrate.AddItem "96", 5
    comAudioBitrate.AddItem "112", 6
    comAudioBitrate.AddItem "128", 7
    comAudioBitrate.AddItem "160", 8
    comAudioBitrate.AddItem "192", 9
    comAudioBitrate.AddItem "224", 10
    comAudioBitrate.AddItem "256", 11
    comAudioBitrate.AddItem "320", 12
    comAudioBitrate.AddItem "384", 13
    
' ComboBox comRateControl
    comRateControl.AddItem "Constant Bitrate (CBR)", 0
    comRateControl.AddItem "2Pass VBR", 1
    comRateControl.AddItem "Constant Quality (CQ)", 2
    
' ComboBox comMotion
    comMotion.AddItem "Lowest Quality (Very Fast)", 0
    comMotion.AddItem "Low Quality (Fast)", 1
    comMotion.AddItem "Normal", 2
    comMotion.AddItem "High Quality (Slow)", 3
    comMotion.AddItem "Highest Quality (Very Slow)", 4
    comMotion.AddItem "Motion estimate search (Fast)", 5

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2SSettingsSave
' </NAME>
'
' <DESCRIPTION>
'   Speichert aktuelle D2S Einstellungen
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub D2SSettingsSave()

    'Project Info
    SaveINISetting gsProjectFile, NLSND2SFilenames, NLSND2STargetFolder, DirD2S.Path
    SaveINISetting gsProjectFile, NLSND2SSettings, NLSND2SAspectRatio, comAspectRate.ListIndex
    
    'Settings
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SAutoShutdown, chkAutoShutdown
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SDontDelete, chkNoDelete
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SUseCCE, pInt(optEncoder(0))
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SUseTMPG, pInt(optEncoder(1))
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SAudioMode, comAudioMode.ListIndex
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SAudioBitrate, comAudioBitrate.ListIndex
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SAudioResample, chkAudioDownsample
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SSafeMode, chkSafeMode
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCCECBR, pInt(optCCEVEM(0))
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCCEOneVBR, pInt(optCCEVEM(1))
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCCEMultiVBR, pInt(optCCEVEM(2))
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCCEPasses, txtCCEVBR
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2STMPGRateControl, comRateControl.ListIndex
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2STMPGMotionSearch, comMotion.ListIndex
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMaxBitrate, txtMaxBitrate
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinBitrate, txtMinBitrate
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMaxAvg, txtMaxAvg
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinAvg, txtMinAvg
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinsHigh1, txtUnd1
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinsHigh2, txtUnd2
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinsHigh3, txtUnd3
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinsHigh4, txtUnd4
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SMinsHigh5, txtUnd5
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD1, txtCD1
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD2, txtCD2
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD3, txtCD3
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD4, txtCD4
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD5, txtCD5
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SNumCD6, txtCD6
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize1, comCDSize1.Text
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize2, comCDSize2.Text
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize3, comCDSize3.Text
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize4, comCDSize4.Text
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize5, comCDSize5.Text
    SaveINISetting gsINIFile, NLSND2SSettings, NLSND2SCDSize6, comCDSize6.Text
    
    'Executables
    If optEncoder(0) = True Then
        SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SCCEExecutable, txtEncoderEXE
    Else
        SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2STMPGExecutable, txtEncoderEXE
    End If

    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SPVAExecutable, txtPVAStrumento
    
    'Programs
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SDVD2AVIEx, txtDVD2AVI
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SBeSweetEx, txtBeSweet
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SPulldownEx, txtPulldown
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SbbMPEGEx, txtbbMPEG
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SMPG2DecDLL, txtMPEG2Dec
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SInverseTelecineDLL, txtInverse
    SaveINISetting gsINIFile, NLSND2SExecutables, NLSND2SSimpleResizeDLL, txtSimpleResize
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2SSettingsLoad
' </NAME>
'
' <DESCRIPTION>
'   Lädt aktuelle D2S Einstellungen
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub D2SSettingsLoad()

    'Settings
    chkAutoShutdown = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SAutoShutdown, "0")
    chkNoDelete = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SDontDelete, "0")
    optEncoder(0) = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SUseCCE, "1")
    optEncoder(1) = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SUseTMPG, "0")
    comAudioMode.ListIndex = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SAudioMode, "0")
    comAudioBitrate.ListIndex = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SAudioBitrate, "7")
    chkAudioDownsample = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SAudioResample, "1")
    chkSafeMode = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SSafeMode, "0")
    optCCEVEM(0) = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCCECBR, "1")
    optCCEVEM(1) = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCCEOneVBR, "0")
    optCCEVEM(2) = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCCEMultiVBR, "0")
    txtCCEVBR = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCCEPasses, "2")
    comRateControl.ListIndex = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2STMPGRateControl, "0")
    comMotion.ListIndex = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2STMPGMotionSearch, "0")
    txtMaxBitrate = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMaxBitrate, "2530")
    txtMinBitrate = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinBitrate, "300")
    txtMaxAvg = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMaxAvg, "2230")
    txtMinAvg = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinAvg, "1600")
    txtUnd1 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinsHigh1, "0")
    txtUnd2 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinsHigh2, "0")
    txtUnd3 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinsHigh3, "0")
    txtUnd4 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinsHigh4, "0")
    txtUnd5 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SMinsHigh5, "0")
    txtCD1 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD1, "0")
    txtCD2 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD2, "0")
    txtCD3 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD3, "0")
    txtCD4 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD4, "0")
    txtCD5 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD5, "0")
    txtCD6 = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SNumCD6, "0")
    comCDSize1.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize1, "0")
    comCDSize2.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize2, "0")
    comCDSize3.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize3, "0")
    comCDSize4.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize4, "0")
    comCDSize5.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize5, "0")
    comCDSize6.Text = GetINISetting(gsINIFile, NLSND2SSettings, NLSND2SCDSize6, "0")
    
    'Executables
    txtPVAStrumento = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SPVAExecutable, " ")
    
    Call mEncoderExecutableLoad
    
    'Programs
    Call D2S_ProgramsLoad
    
    'Project Settings
    comAspectRate.ListIndex = GetINISetting(gsProjectFile, NLSND2SSettings, NLSND2SAspectRatio, "0")
    On Error GoTo DriveHandler
    DirD2S.Path = GetINISetting(gsProjectFile, NLSND2SFilenames, NLSND2STargetFolder, "C:\")

    Exit Sub

DriveHandler:
    DriveD2S.Drive = DirD2S.Path
    Exit Sub
    
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   D2S_LoadPrograms
' </NAME>
'
' <DESCRIPTION>
'   Läd D2S Programme von der lokalen Project File in die Steuerelemente
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub D2S_ProgramsLoad()

    'Programs
    txtbbMPEG = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SbbMPEGEx, " ")
    txtPulldown = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SPulldownEx, " ")
    txtMPEG2Dec = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SMPG2DecDLL, " ")
    txtInverse = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SInverseTelecineDLL, "1 ")
    txtSimpleResize = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SSimpleResizeDLL, " ")
    txtBeSweet = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SBeSweetEx, " ")
    txtDVD2AVI = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SDVD2AVIEx, " ")

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   txtDVD2SVCDEXE_Change
' </NAME>
'
' <DESCRIPTION>
'   Prüft, ob Adresse der Startdatei verändert worden ist und
'   prüft Abhängigkeiten
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub txtDVD2SVCDEXE_Change()
    
    Call mEncodingOptionsCheck
    
End Sub

Private Sub txtEncoderEXE_Change()

    Call mEncodingOptionsCheck

End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   txtPVAStrumento_Change
' </NAME>
'
' <DESCRIPTION>
'   Wie txtDVD2SVCDEXE Change
'   Prüft Programme sowie PVAStrumento
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub txtPVAStrumento_Change()
    
    Call mEncodingOptionsCheck
        
End Sub


'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   txtUnd?_Change
' </NAME>
'
' <DESCRIPTION>
'   Belegt BitrateBeginn automatisch
' </DESCRIPTION>
'
' <AUTHOR>
'   ZE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Private Sub txtUnd1_Change()

    ' Bitrate Settings:
    txtZW1 = 0
    txtZW2 = txtUnd1
    txtZW3 = txtUnd2
    txtZW4 = txtUnd3
    txtZW5 = txtUnd4
    txtZW6 = txtUnd5
    txtUnd6 = 9999

End Sub
Private Sub txtUnd2_Change()

    Call txtUnd1_Change

End Sub
Private Sub txtUnd3_Change()

    Call txtUnd1_Change

End Sub
Private Sub txtUnd4_Change()

    Call txtUnd1_Change

End Sub
Private Sub txtUnd5_Change()

    Call txtUnd1_Change

End Sub

Private Sub mEncodingOptionsCheck()

  gsD2SINIFile = Replace(txtDVD2SVCDEXE, "DVD2SVCD.exe", NLSND2SINIFile)
  txtEncCheck = D2S_CheckPrograms(gsD2SINIFile, NLSND2SExecutables, txtPVAStrumento, Me.txtEncoderEXE)
  
  If InStr(1, txtEncCheck, "!", vbTextCompare) = 0 Then
        
        chkStartEnc.Enabled = True
        If InStr(1, D2S_CheckPrograms(gsINIFile, NLSND2SExecutables), "!", vbTextCompare) <> 0 Then
            
            Call D2S_ImportLinks
            Call D2S_ProgramsLoad
        
        End If
        
  Else
        
        chkStartEnc.Enabled = False
        chkStartEnc.Value = 0
  
  End If

End Sub

Private Sub mEncoderExecutableLoad()

    If optEncoder(0) = True Then
        txtEncoderEXE = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2SCCEExecutable, " ")
    Else
        txtEncoderEXE = GetINISetting(gsINIFile, NLSND2SExecutables, NLSND2STMPGExecutable, " ")
    End If

End Sub
