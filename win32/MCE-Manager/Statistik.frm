VERSION 5.00
Object = "{481E5A07-5ADE-48A7-8879-F6C70AD95B1F}#1.0#0"; "ActSlider.ocx"
Object = "{4511A08F-EA0D-4257-ADA3-A93195C5A02A}#1.0#0"; "Button.ocx"
Object = "{7A3134F8-8B34-4546-B016-D82D86DFBB3B}#1.0#0"; "ProgressBar.ocx"
Begin VB.Form Statistik 
   BackColor       =   &H00808080&
   BorderStyle     =   1  'Fest Einfach
   ClientHeight    =   5775
   ClientLeft      =   4245
   ClientTop       =   3240
   ClientWidth     =   7935
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
   Icon            =   "Statistik.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5775
   ScaleWidth      =   7935
   Begin VB.TextBox Jahr 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      ForeColor       =   &H80000018&
      Height          =   285
      Left            =   720
      TabIndex        =   21
      Text            =   "2003"
      Top             =   3120
      Width           =   615
   End
   Begin VB.TextBox monat 
      Alignment       =   2  'Zentriert
      BackColor       =   &H00000000&
      ForeColor       =   &H80000018&
      Height          =   285
      Left            =   240
      TabIndex        =   20
      Text            =   "8"
      Top             =   3120
      Width           =   375
   End
   Begin ProgressBar2.cpvProgressBar lyricsproz 
      Height          =   120
      Left            =   4920
      Top             =   4500
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":08CA
      BarPictureBack  =   "Statistik.frx":1A9C
      Enabled         =   0   'False
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
   Begin ProgressBar2.cpvProgressBar OGGBar 
      Height          =   120
      Left            =   4920
      Top             =   4020
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2C4E
      BarPictureBack  =   "Statistik.frx":3E20
      CaptionCustom   =   "OGG"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar MP2Bar 
      Height          =   120
      Left            =   4920
      Top             =   3900
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":4FD2
      BarPictureBack  =   "Statistik.frx":61A4
      CaptionCustom   =   "MP2"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar MP3Bar 
      Height          =   120
      Left            =   4920
      Top             =   3780
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":7356
      BarPictureBack  =   "Statistik.frx":8528
      CaptionCustom   =   "MP3"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   0
      Left            =   4920
      Top             =   480
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":96DA
      BarPictureBack  =   "Statistik.frx":A8AC
      CaptionCustom   =   "00:00   -   01:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   1
      Left            =   4920
      Top             =   600
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":BA5E
      BarPictureBack  =   "Statistik.frx":CC30
      CaptionCustom   =   "00:01   -   02:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   2
      Left            =   4920
      Top             =   720
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":DDE2
      BarPictureBack  =   "Statistik.frx":EFB4
      CaptionCustom   =   "02:00   -   03:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontColor       =   0
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   3
      Left            =   4920
      Top             =   840
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":10166
      BarPictureBack  =   "Statistik.frx":11338
      CaptionCustom   =   "03:00   -   04:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontColor       =   0
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   4
      Left            =   4920
      Top             =   960
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":124EA
      BarPictureBack  =   "Statistik.frx":136BC
      CaptionCustom   =   "04:00   -   05:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   5
      Left            =   4920
      Top             =   1080
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":1486E
      BarPictureBack  =   "Statistik.frx":15A40
      CaptionCustom   =   "05:00   -   06:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   6
      Left            =   4920
      Top             =   1200
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":16BF2
      BarPictureBack  =   "Statistik.frx":17DC4
      CaptionCustom   =   "06:00   -   07:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   7
      Left            =   4920
      Top             =   1320
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":18F76
      BarPictureBack  =   "Statistik.frx":1A148
      CaptionCustom   =   "07:00   -   08:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   8
      Left            =   4920
      Top             =   1440
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":1B2FA
      BarPictureBack  =   "Statistik.frx":1C4CC
      CaptionCustom   =   "08:00   -   09:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   9
      Left            =   4920
      Top             =   1560
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":1D67E
      BarPictureBack  =   "Statistik.frx":1E850
      CaptionCustom   =   "09:00   -   10:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   10
      Left            =   4920
      Top             =   1680
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":1FA02
      BarPictureBack  =   "Statistik.frx":20BD4
      CaptionCustom   =   "10:00   -   11:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   11
      Left            =   4920
      Top             =   1800
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":21D86
      BarPictureBack  =   "Statistik.frx":22F58
      CaptionCustom   =   "11:00   -   12:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   12
      Left            =   4920
      Top             =   1920
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2410A
      BarPictureBack  =   "Statistik.frx":252DC
      CaptionCustom   =   "12:00   -   13:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   13
      Left            =   4920
      Top             =   2040
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2648E
      BarPictureBack  =   "Statistik.frx":27660
      CaptionCustom   =   "13:00   -   14:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   14
      Left            =   4920
      Top             =   2160
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":28812
      BarPictureBack  =   "Statistik.frx":299E4
      CaptionCustom   =   "14:00   -   15:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   15
      Left            =   4920
      Top             =   2280
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2AB96
      BarPictureBack  =   "Statistik.frx":2BD68
      CaptionCustom   =   "15:00   -   16:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   16
      Left            =   4920
      Top             =   2400
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2CF1A
      BarPictureBack  =   "Statistik.frx":2E0EC
      CaptionCustom   =   "16:00   -   17:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   17
      Left            =   4920
      Top             =   2520
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":2F29E
      BarPictureBack  =   "Statistik.frx":30470
      CaptionCustom   =   "17:00   -   18:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   18
      Left            =   4920
      Top             =   2640
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":31622
      BarPictureBack  =   "Statistik.frx":327F4
      CaptionCustom   =   "18:00   -   19:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   19
      Left            =   4920
      Top             =   2760
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":339A6
      BarPictureBack  =   "Statistik.frx":34B78
      CaptionCustom   =   "19:00   -   20:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   20
      Left            =   4920
      Top             =   2880
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":35D2A
      BarPictureBack  =   "Statistik.frx":36EFC
      CaptionCustom   =   "20:00   -   21:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   21
      Left            =   4920
      Top             =   3000
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":380AE
      BarPictureBack  =   "Statistik.frx":39280
      CaptionCustom   =   "21:00   -   22:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   22
      Left            =   4920
      Top             =   3120
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":3A432
      BarPictureBack  =   "Statistik.frx":3B604
      CaptionCustom   =   "22:00   -   23:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ProgressBar2.cpvProgressBar rectime 
      Height          =   120
      Index           =   23
      Left            =   4920
      Top             =   3240
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   212
      BarPicture      =   "Statistik.frx":3C7B6
      BarPictureBack  =   "Statistik.frx":3D988
      CaptionCustom   =   "23:00   -   00:00"
      CaptionFormat   =   99
      Enabled         =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Max             =   1000
   End
   Begin ActSlider.SliderPic zeitraum 
      Height          =   255
      Left            =   240
      TabIndex        =   11
      Top             =   1200
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   450
      Max             =   49
      ImageSlider     =   "Statistik.frx":3EB3A
      ImageLeft       =   "Statistik.frx":3FD34
      ImagePointer    =   "Statistik.frx":40F2E
      BackStyle       =   0
   End
   Begin KDCButton107.KDCButton OK 
      Height          =   495
      Left            =   240
      TabIndex        =   17
      Top             =   5040
      Width           =   7455
      _ExtentX        =   13150
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
   Begin KDCButton107.KDCButton Aktualisieren 
      Height          =   375
      Left            =   240
      TabIndex        =   18
      Top             =   2160
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "Aktualisieren"
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
      BackColorTop    =   16777215
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin KDCButton107.KDCButton Excelanzeigen 
      Height          =   375
      Left            =   240
      TabIndex        =   22
      Top             =   3480
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   661
      Appearance      =   15
      Caption         =   "anzeigen"
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
      BackColorTop    =   16777215
      BackColorBottom =   0
      BorderColorTop  =   8421504
      BorderColorBottom=   8421504
   End
   Begin VB.Label value 
      Alignment       =   1  'Rechts
      BackColor       =   &H80000001&
      BackStyle       =   0  'Transparent
      Caption         =   "0"
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
      Left            =   4080
      TabIndex        =   23
      Top             =   1020
      Width           =   735
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Excel Statistik:"
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
      TabIndex        =   19
      Top             =   2760
      Width           =   3735
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   7800
      Y1              =   120
      Y2              =   120
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   4800
      Y2              =   120
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000018&
      X1              =   7800
      X2              =   7800
      Y1              =   4800
      Y2              =   120
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   7800
      Y1              =   4800
      Y2              =   4800
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   7800
      Y1              =   5640
      Y2              =   5640
   End
   Begin VB.Line Line7 
      BorderColor     =   &H80000018&
      X1              =   7800
      X2              =   7800
      Y1              =   5640
      Y2              =   4920
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   120
      Y1              =   5640
      Y2              =   4920
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000018&
      X1              =   120
      X2              =   7800
      Y1              =   4920
      Y2              =   4920
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Neue Songs:"
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
      TabIndex        =   16
      Top             =   1860
      Width           =   1335
   End
   Begin VB.Label Label4 
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
      Index           =   6
      Left            =   4920
      TabIndex        =   15
      Top             =   3540
      Width           =   2775
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Zeitraum:"
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
      TabIndex        =   14
      Top             =   900
      Width           =   4695
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "1"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   240
      TabIndex        =   13
      Top             =   1440
      Width           =   735
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      Caption         =   "50"
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   3240
      TabIndex        =   12
      Top             =   1440
      Width           =   1575
   End
   Begin VB.Label newsong 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1200
      TabIndex        =   10
      Top             =   1860
      Width           =   615
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Songs mit Lyrics:"
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
      Left            =   4920
      TabIndex        =   9
      Top             =   4260
      Width           =   1695
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Aufnahmezeit:"
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
      Left            =   4920
      TabIndex        =   8
      Top             =   240
      Width           =   2775
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Songs in Datenbank:"
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
      Left            =   2400
      TabIndex        =   7
      Top             =   480
      Width           =   1935
   End
   Begin VB.Label recset 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   4440
      TabIndex        =   6
      Top             =   480
      Width           =   375
   End
   Begin VB.Label pfiles 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1560
      TabIndex        =   5
      Top             =   480
      Width           =   615
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Offline Playlists:"
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
      TabIndex        =   4
      Top             =   480
      Width           =   1815
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Defekte Songs:"
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
      TabIndex        =   3
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label dfiles 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   1440
      TabIndex        =   2
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Untagged Songs:"
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
      Left            =   2400
      TabIndex        =   1
      Top             =   240
      Width           =   1935
   End
   Begin VB.Label ufiles 
      Alignment       =   1  'Rechts
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000018&
      Height          =   255
      Left            =   3960
      TabIndex        =   0
      Top             =   240
      Width           =   855
   End
End
Attribute VB_Name = "Statistik"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function FindExecutable Lib "shell32.dll" Alias "FindExecutableA" (ByVal lpFile As String, ByVal lpDirectory As String, ByVal lpResult As String) As Long
Private Sub Aktualisieren_Click()
    Dim reczeit As Date, recdate As Date, anfangdate As Date, newsongcounter As Integer, counter As Long, songtextproz As Long, j As Integer, i As Integer, vdate1 As Date, vdate2 As Date, mp3counter As Integer, mp2counter As Integer, oggcounter As Integer, files() As String
    
    Statistik.Aktualisieren.Enabled = "0" 'Verriegelung ein
    Statistik.Aktualisieren.ForeColor = &H80000015 'Buttonfarbe ändern
    Call Werkzeuge.suche("TXT", App.Path + "\playlists\", files(), "1")
    pfiles = Str$(UBound(files) - 1)
    Call Werkzeuge.suche("mp2", frmMain.work.Text + "error\", files(), "1")
    dfiles = Str$(UBound(files) - 1)
    Call Werkzeuge.suche("TXT", frmMain.work.Text + "untagged\", files(), "1")
    ufiles = Str$(UBound(files) - 1)
    anfangdate = Date - Statistik.zeitraum.CurPosition
    Set db = OpenDatabase(App.Path + "\Datenbank\Musik-Datenbank.mdb") 'Öffnet Datenbank
    Set RS = db.OpenRecordset("select * from tracks Order by " + DBdurchsuchen.Auswahl.Text) 'Tabelle auswählen
    If RS.RecordCount <= 0 Then GoTo ende
    RS.MoveFirst
    
    'Rücksetzen
    For i = 0 To 23
        Statistik.rectime(i).Max = 2
        Statistik.rectime(i).Value = 0
    Next i
    
    Statistik.lyricsproz.Value = 0
    Statistik.MP3Bar.Value = 0
    Statistik.MP2Bar.Value = 0
    Statistik.OGGBar.Value = 0
    Statistik.recset.Caption = vbNullString
    
    'Recordsets auslesen
    While Not RS.EOF
        If frmMain.turbo.Value = "0" Then DoEvents
        
        If RS.aufnahmezeit.Value <> vbNullString Then
            reczeit = Right$(RS.aufnahmezeit.Value, 8)
        Else
            GoTo nextrun
        End If
            
        recdate = Left$(RS.aufnahmezeit.Value, 10)
        If anfangdate <= recdate And recdate <= Date Then newsongcounter = newsongcounter + 1
        vdate1 = "00:00:00"
        vdate2 = "01:00:00"
        
        'Aufnahmezeit Diagramm
        For i = 0 To 23
            If reczeit > vdate1 And reczeit < vdate2 Then
                counter = rectime(i).Value + 1
                
                If rectime(i).Max <= counter Then
                    For j = 0 To 23
                        rectime(j).Max = rectime(j).Max * 2
                    Next j
                End If
                
                rectime(i) = counter
            End If
        
            vdate1 = vdate1 + "01:00:00"
            vdate2 = vdate2 + "01:00:00"
        Next i
        
        If RS.Songtext.Value <> vbNullString Then songtextproz = songtextproz + 1
        If RS.Format.Value = "mp3" Then mp3counter = mp3counter + 1
        If RS.Format.Value = "mp2" Then mp2counter = mp2counter + 1
        If RS.Format.Value = "ogg" Then oggcounter = oggcounter + 1
nextrun:
        RS.MoveNext
    Wend
    
    Statistik.newsong.Caption = Str$(newsongcounter) 'Anzahl der neuen Songs
    recset.Caption = RS.RecordCount 'Anzahl wird ermittelt
    Statistik.lyricsproz.Value = songtextproz / (RS.RecordCount / 100)
    Statistik.MP3Bar.Value = mp3counter / (RS.RecordCount / 100)
    Statistik.MP2Bar.Value = mp2counter / (RS.RecordCount / 100)
    Statistik.OGGBar.Value = oggcounter / (RS.RecordCount / 100)
    
    'Verriegelung aus
ende:
    Statistik.Aktualisieren.Enabled = "1"
    Statistik.Aktualisieren.ForeColor = &H80000018 'Buttonfarbe ändern
    RS.Close
    Set RS = Nothing
    Set db = Nothing
End Sub
Private Sub Excelanzeigen_Click()
    Dim buffer As String, position As Integer
    
    If Len(monat.Text) = 1 Then monat.Text = "0" + monat.Text
    buffer = Space$(260)
    FindExecutable jahr.Text + "-" + monat.Text + ".xls", App.Path + "\Datenbank\Statistik\", buffer
    position = InStr(1, buffer, "exe", vbTextCompare)
    
    If position = 0 Then
        MsgBox "No MS-Excel installed or not such a file"
        Exit Sub
    End If
    
    Shell Left(buffer, InStr(1, buffer, "exe", vbTextCompare) + 2) + " """ + App.Path + "\Datenbank\statistik\" + jahr.Text + "-" + monat.Text + ".xls""", vbMaximizedFocus
End Sub
Private Sub OK_Click()
    Call Form_unLoad(0)
End Sub
Private Sub zeitraum_PositionChanged(oldPosition As Long, newPosition As Long)
    Statistik.Value.Caption = newPosition + 1
End Sub
Private Sub Form_unLoad(cancel As Integer)
    Call Verriegelung.verriegelungaus
    frmMain.abbrechen.ForeColor = &H80000018 'Buttonfarbe ändern
    frmMain.abbrechen.Enabled = "1"
    frmMain.Timer1.Enabled = "1"
    Statistik.Hide
    Set Statistik = Nothing
    frmMain.Show
End Sub
Private Sub form_load()
    jahr.Text = Right(Date, 4)
    monat.Text = Mid(Date, 4, 2)
End Sub
