object frmMain: TfrmMain
  Left = 235
  Top = 139
  Width = 770
  Height = 570
  ActiveControl = btnWishesSeekDb
  AlphaBlend = True
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'WinGrabVCR 0.83 - TuxBox'
  Color = clBtnFace
  Constraints.MaxHeight = 570
  Constraints.MaxWidth = 770
  Constraints.MinHeight = 570
  Constraints.MinWidth = 770
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object TePanel1: TTePanel
    Left = 0
    Top = 0
    Width = 762
    Height = 543
    Align = alClient
    OuterBorderWidth = 3
    HeavyBorder = True
    Caption = 'TePanel1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object pclMain: TPageControl
      Left = 0
      Top = 0
      Width = 752
      Height = 533
      ActivePage = tbsWhishes
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabIndex = 3
      TabOrder = 0
      OnChange = pclMainChange
      object tbsWelcome: TTabSheet
        Caption = 'Kan'#228'le'
        OnHide = tbsWelcomeHide
        OnShow = tbsWelcomeShow
        object TePanel4: TTePanel
          Left = 0
          Top = 464
          Width = 744
          Height = 38
          Align = alBottom
          BevelInner = bvLowered
          Caption = 'TePanel4'
          TabOrder = 0
          object btnVlcView: TTeBitBtn
            Left = 2
            Top = 2
            Width = 135
            Height = 30
            Caption = 'mit VLC ansehen'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 0
            OnClick = btnVlcViewClick
          end
          object btnRecordNow: TTeBitBtn
            Left = 141
            Top = 2
            Width = 135
            Height = 30
            Caption = 'Sofortaufnahme'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 1
            OnClick = btnRecordNowClick
          end
          object btnRefreshChannels: TTeBitBtn
            Left = 604
            Top = 3
            Width = 135
            Height = 30
            Caption = 'Aktualisieren'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 2
            OnClick = btnRefreshChannelsClick
          end
        end
        object plWelcome: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 465
          Align = alTop
          BevelInner = bvLowered
          BorderWidth = 5
          HeavyBorder = True
          Caption = 'plWelcome'
          TabOrder = 1
          object lbxChannelList: TListBox
            Left = 0
            Top = 0
            Width = 285
            Height = 232
            Style = lbOwnerDrawVariable
            Align = alLeft
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 19
            ParentFont = False
            TabOrder = 0
            OnClick = lbxChannelListClick
            OnDblClick = lbxChannelListDblClick
            OnDrawItem = lbxChannelListDrawItem
          end
          object Panel1: TPanel
            Left = 288
            Top = 0
            Width = 440
            Height = 232
            Align = alRight
            BevelInner = bvSpace
            BevelOuter = bvLowered
            BevelWidth = 2
            Caption = 'Panel1'
            TabOrder = 1
            object EpgViewer: ThtmlLite
              Left = 4
              Top = 4
              Width = 432
              Height = 224
              TabOrder = 0
              Align = alClient
              DefBackground = clWhite
              BorderStyle = htFocused
              HistoryMaxCount = 0
              DefFontName = 'Times New Roman'
              DefPreFontName = 'Courier New'
              NoSelect = False
              CharSet = DEFAULT_CHARSET
              htOptions = []
            end
          end
          object plChannelProg: TTePanel
            Left = 0
            Top = 232
            Width = 728
            Height = 217
            Align = alBottom
            BorderWidth = 5
            Caption = 'plChannelProg'
            Locked = True
            TabOrder = 2
            object lvChannelProg: TTeListView
              Left = 0
              Top = 0
              Width = 716
              Height = 205
              Align = alClient
              Color = clCaptionText
              Columns = <
                item
                  Caption = 'Eventid'
                  Width = 1
                end
                item
                  Caption = 'Zeit'
                  MaxWidth = 1
                  Width = 1
                end
                item
                  Caption = 'Datum'
                  MinWidth = 85
                  Width = 85
                end
                item
                  Caption = 'Uhrzeit'
                  MinWidth = 55
                  Width = 55
                end
                item
                  Caption = 'Dauer'
                  MinWidth = 50
                end
                item
                  Caption = 'Titel'
                  MinWidth = 300
                  Width = 500
                end
                item
                  Caption = 'EPG'
                  Width = 0
                end>
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              GridLines = True
              ReadOnly = True
              RowSelect = True
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              ViewStyle = vsReport
              OnClick = lvChannelProgClick
              OnDblClick = lvChannelProgDblClick
            end
          end
        end
      end
      object tbsTimer: TTabSheet
        Caption = 'Timer'
        ImageIndex = 6
        object plTimer: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 502
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'plTimer'
          TabOrder = 0
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 734
            Height = 489
            Align = alTop
            BevelInner = bvLowered
            TabOrder = 0
            object Timer_Splitter: TSplitter
              Left = 2
              Top = 233
              Width = 730
              Height = 5
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              ResizeStyle = rsUpdate
            end
            object Timer_WebBrowser: TWebBrowser
              Left = 2
              Top = 2
              Width = 730
              Height = 231
              Align = alTop
              TabOrder = 0
              ControlData = {
                4C000000734B0000E01700000000000000000000000000000000000000000000
                000000004C000000000000000000000001000000E0D057007335CF11AE690800
                2B2E126200000000000000004C0000000114020000000000C000000000000046
                8000000000000000000000000000000000000000000000000000000000000000
                00000000000000000100000000000000000000000000000000000000}
            end
            object lvTimer: TListView
              Left = 2
              Top = 238
              Width = 730
              Height = 249
              Align = alClient
              Columns = <
                item
                  MaxWidth = 1
                  Width = 1
                end
                item
                  Caption = 'Zeit'
                  MinWidth = 130
                  Width = 130
                end
                item
                  Alignment = taRightJustify
                  Caption = 'Dauer'
                  MinWidth = 50
                end
                item
                  Caption = 'Titel'
                  MinWidth = 350
                  Width = 350
                end
                item
                  Caption = 'Kanal'
                  MinWidth = 170
                  Width = 170
                end>
              GridLines = True
              ReadOnly = True
              RowSelect = True
              TabOrder = 1
              ViewStyle = vsReport
              OnCustomDrawItem = lvTimerCustomDrawItem
              OnDblClick = lvTimerDblClick
            end
          end
        end
      end
      object tbsRecorded: TTabSheet
        Caption = 'Filmarchiv'
        object TePanel_Recorded: TTePanel
          Left = 0
          Top = 464
          Width = 744
          Height = 38
          Align = alBottom
          BevelInner = bvLowered
          Caption = 'TePanel4'
          TabOrder = 0
          object Recorded_DBNavigator: TDBNavigator
            Left = 8
            Top = 0
            Width = 252
            Height = 33
            DataSource = Recorded_DataSource
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbRefresh]
            Flat = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object plRecorded: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 465
          Align = alTop
          BevelInner = bvLowered
          BorderWidth = 5
          HeavyBorder = True
          Caption = 'plRecorded'
          TabOrder = 1
          object Splitter1: TSplitter
            Left = 0
            Top = 217
            Width = 728
            Height = 5
            Cursor = crVSplit
            Align = alTop
          end
          object Panel3_Recorded: TPanel
            Left = 0
            Top = 0
            Width = 728
            Height = 217
            Align = alTop
            BevelInner = bvSpace
            BevelOuter = bvLowered
            BevelWidth = 2
            Caption = 'Panel3_Recorded'
            TabOrder = 0
            object Recorded_DBGrid: TDBGrid
              Left = 4
              Top = 4
              Width = 720
              Height = 209
              Align = alClient
              DataSource = Recorded_DataSource
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -13
              TitleFont.Name = 'Arial'
              TitleFont.Style = [fsBold]
              OnTitleClick = Recorded_DBGridTitleClick
              Columns = <
                item
                  Expanded = False
                  FieldName = 'Titel'
                  Width = 384
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'SubTitel'
                  Width = 246
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Platz'
                  Width = 49
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'EPG'
                  Visible = False
                end
                item
                  Expanded = False
                  FieldName = 'IDN'
                  Visible = False
                end>
            end
          end
          object Panel3: TPanel
            Left = 0
            Top = 222
            Width = 728
            Height = 227
            Align = alClient
            BevelInner = bvLowered
            Caption = 'Panel3'
            TabOrder = 1
            object Recorded_Epg_DropFiles: TPJDropFiles
              Left = 2
              Top = 2
              Width = 724
              Height = 223
              Align = alClient
              PassThrough = False
              ForegroundOnDrop = False
              OnDropFiles = Recorded_Epg_DropFilesDropFiles
              Options = [dfoIncFolders, dfoIncFiles]
              object Recorded_EpgView: ThtmlLite
                Left = 0
                Top = 0
                Width = 724
                Height = 223
                TabOrder = 0
                Align = alClient
                DefBackground = clWhite
                BorderStyle = htFocused
                HistoryMaxCount = 0
                DefFontName = 'Times New Roman'
                DefPreFontName = 'Courier New'
                NoSelect = False
                CharSet = DEFAULT_CHARSET
                htOptions = []
              end
            end
          end
        end
      end
      object tbsWhishes: TTabSheet
        Caption = 'EPG suchen'
        object TePanel_Whishes: TTePanel
          Left = 0
          Top = 464
          Width = 744
          Height = 38
          Align = alBottom
          BevelInner = bvLowered
          Caption = 'TePanel_Whishes'
          TabOrder = 0
          object lbl_check_EPG: TLabel
            Left = 8
            Top = 9
            Width = 337
            Height = 17
            AutoSize = False
          end
          object Whishes_DBNavigator: TDBNavigator
            Left = 8
            Top = 0
            Width = 259
            Height = 33
            DataSource = Whishes_DataSource
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbRefresh]
            Flat = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object btnWishesSeek: TTeBitBtn
            Left = 468
            Top = 4
            Width = 135
            Height = 30
            Caption = 'DBox neu lesen'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 2
            OnClick = btnWishesSeekClick
          end
          object btnWishesSeekDb: TTeBitBtn
            Left = 603
            Top = 4
            Width = 135
            Height = 30
            Caption = 'EPG Suchen'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 0
            OnClick = btnWishesSeekDbClick
          end
        end
        object plWhishes: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 465
          Align = alTop
          BevelInner = bvLowered
          BorderWidth = 5
          HeavyBorder = True
          Caption = 'plWhishes'
          TabOrder = 1
          object Panel3_Whishes: TPanel
            Left = 0
            Top = 0
            Width = 729
            Height = 449
            BevelInner = bvSpace
            BevelOuter = bvLowered
            BevelWidth = 2
            TabOrder = 0
            object Splitter2: TSplitter
              Left = 4
              Top = 161
              Width = 721
              Height = 5
              Cursor = crVSplit
              Align = alTop
            end
            object Whishes_DBGrid: TDBGrid
              Left = 4
              Top = 4
              Width = 721
              Height = 157
              Align = alTop
              DataSource = Whishes_DataSource
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -13
              TitleFont.Name = 'Arial'
              TitleFont.Style = [fsBold]
              Columns = <
                item
                  Expanded = False
                  FieldName = 'Titel'
                  Width = 685
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'IDN'
                  Visible = False
                end>
            end
            object Whishes_Result: TListBox
              Left = 4
              Top = 166
              Width = 721
              Height = 279
              Style = lbOwnerDrawVariable
              Align = alClient
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 19
              ParentFont = False
              TabOrder = 1
              OnDblClick = Whishes_ResultDblClick
              OnDrawItem = Whishes_ResultDrawItem
            end
          end
        end
      end
      object tbsRunning: TTabSheet
        Caption = 'Status ...'
        ImageIndex = 4
        OnHide = tbsRunningHide
        OnShow = tbsRunningShow
        object plRunning: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 464
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'plRunning'
          TabOrder = 0
          object gbxMessages: TTeGroupBox
            Left = 0
            Top = 0
            Width = 734
            Height = 265
            Align = alTop
            Caption = 'Nachrichten'
            TabOrder = 0
            object mmoMessages: TListBox
              Left = 0
              Top = 0
              Width = 715
              Height = 246
              Style = lbOwnerDrawVariable
              Align = alClient
              ItemHeight = 19
              Sorted = True
              TabOrder = 0
              OnDrawItem = mmoMessagesDrawItem
            end
          end
          object gbxState: TTeGroupBox
            Left = 0
            Top = 265
            Width = 734
            Height = 184
            Align = alTop
            Caption = 'Status'
            TabOrder = 1
            object lvwState: TListView
              Left = 0
              Top = 0
              Width = 715
              Height = 165
              Align = alClient
              Columns = <
                item
                  Caption = 'Module'
                  Width = 100
                end
                item
                  AutoSize = True
                  Caption = 'Status'
                end>
              GridLines = True
              TabOrder = 0
              ViewStyle = vsReport
            end
          end
        end
        object TePanel2: TTePanel
          Left = 0
          Top = 464
          Width = 744
          Height = 38
          Align = alBottom
          BevelInner = bvLowered
          Caption = 'TePanel2'
          TabOrder = 1
          object bnStop: TTeBitBtn
            Left = 3
            Top = 3
            Width = 135
            Height = 30
            ImageName = 'Abort'
            Caption = 'Abbrechen'
            Options = [boWordWarp]
            TabOrder = 0
            OnClick = bnStopClick
          end
        end
      end
      object tbsInFiles: TTabSheet
        Caption = 'PES'
        ImageIndex = 5
        object plInFiles: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 502
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'plOutFiles'
          TabOrder = 0
          object TePanel5: TTePanel
            Left = 0
            Top = 0
            Width = 734
            Height = 449
            Align = alTop
            BevelInner = bvLowered
            Caption = 'TePanel5'
            TabOrder = 0
            object TeGroupBox1: TTeGroupBox
              Left = 0
              Top = 388
              Width = 730
              Height = 57
              Align = alBottom
              Caption = 'Ausgabe der Programm-Stream-Datei'
              TabOrder = 0
              object edOutMux_DropFiles: TPJDropFiles
                Left = 2
                Top = 8
                Width = 703
                Height = 28
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edOutMux_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edOutMuxPes: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 705
                  Height = 24
                  TabOrder = 0
                  OnChange = edInVideoMuxPesChange
                  OnDblClick = edInAudioDblClick
                end
              end
            end
            object gbxInAudio4: TTeGroupBox
              Left = 0
              Top = 223
              Width = 730
              Height = 48
              Align = alTop
              Caption = 'Audio 4 pes stream file'
              TabOrder = 1
              object edInAudio4MuxPes: TTeEdit
                Left = 0
                Top = 0
                Width = 705
                Height = 24
                TabOrder = 0
                OnDblClick = edInAudioDblClick
              end
            end
            object gbxInAudio3: TTeGroupBox
              Left = 0
              Top = 177
              Width = 730
              Height = 46
              Align = alTop
              Caption = 'Audio 3 pes stream file'
              TabOrder = 2
              object edInAudio3MuxPes: TTeEdit
                Left = 0
                Top = 0
                Width = 705
                Height = 24
                TabOrder = 0
                OnDblClick = edInAudioDblClick
              end
            end
            object gbxInAudio2: TTeGroupBox
              Left = 0
              Top = 131
              Width = 730
              Height = 46
              Align = alTop
              Caption = 'Audio 2 pes stream file'
              TabOrder = 3
              object edInAudio2MuxPes: TTeEdit
                Left = -1
                Top = 0
                Width = 706
                Height = 24
                TabOrder = 0
                OnDblClick = edInAudioDblClick
              end
            end
            object gbxInAudio1: TTeGroupBox
              Left = 0
              Top = 81
              Width = 730
              Height = 50
              Align = alTop
              Caption = 'Audio 1 pes stream file'
              TabOrder = 4
              object edInAudio1_DropFiles: TPJDropFiles
                Left = 0
                Top = 3
                Width = 705
                Height = 27
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInAudio1_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInAudio1MuxPes: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 705
                  Height = 24
                  TabOrder = 0
                  OnChange = edInAudio1MuxPesChange
                  OnDblClick = edInAudioDblClick
                end
              end
            end
            object gbxInVideo: TTeGroupBox
              Left = 0
              Top = 0
              Width = 730
              Height = 81
              Align = alTop
              Caption = 'Video pes stream file'
              TabOrder = 5
              object Label7: TLabel
                Left = 0
                Top = 35
                Width = 85
                Height = 30
                AutoSize = False
                Caption = 'start offset'
                Layout = tlCenter
              end
              object Label8: TLabel
                Left = 187
                Top = 36
                Width = 62
                Height = 31
                AutoSize = False
                Caption = 'frames'
                Layout = tlCenter
              end
              object Label9: TLabel
                Left = 285
                Top = 36
                Width = 76
                Height = 31
                AutoSize = False
                Caption = 'end offset'
                Layout = tlCenter
              end
              object Label10: TLabel
                Left = 473
                Top = 36
                Width = 63
                Height = 31
                AutoSize = False
                Caption = 'frames'
                Layout = tlCenter
              end
              object edVideoInOffsetStart: TTeEdit
                Left = 81
                Top = 35
                Width = 102
                Height = 24
                TabOrder = 0
              end
              object edVideoInOffsetEnd: TTeEdit
                Left = 367
                Top = 36
                Width = 101
                Height = 24
                TabOrder = 1
              end
              object edInVideo_DropFiles: TPJDropFiles
                Left = -1
                Top = 4
                Width = 706
                Height = 27
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInVideo_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInVideoMuxPes: TTeEdit
                  Left = 1
                  Top = 2
                  Width = 704
                  Height = 24
                  TabOrder = 0
                  OnChange = edInVideoMuxPesChange
                  OnDblClick = edInVideoMuxPesDblClick
                end
              end
            end
          end
          object TePanel6: TTePanel
            Left = 0
            Top = 454
            Width = 734
            Height = 38
            Align = alBottom
            BevelInner = bvLowered
            Caption = 'TePanel6'
            TabOrder = 1
            object btnMuxPes: TTeBitBtn
              Left = 2
              Top = 2
              Width = 135
              Height = 30
              Caption = 'Multiplexe PES'
              Enabled = False
              Options = [boMonoDisplay, boWordWarp]
              TabOrder = 0
              OnClick = btnMuxPesClick
            end
            object btnMuxTransform: TTeBitBtn
              Left = 140
              Top = 2
              Width = 135
              Height = 30
              Caption = 'Transform PS to AVI'
              Enabled = False
              Options = [boMonoDisplay, boWordWarp]
              TabOrder = 1
              OnClick = btnMuxTransformClick
            end
          end
        end
      end
      object tbsInMux: TTabSheet
        Caption = 'PS'
        ImageIndex = 7
        object plInMux: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 502
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'plOutFiles'
          TabOrder = 0
          object TePanel7: TTePanel
            Left = 0
            Top = 454
            Width = 734
            Height = 38
            Align = alBottom
            BevelInner = bvLowered
            Caption = 'TePanel6'
            TabOrder = 0
            object btnReMuxPs: TTeBitBtn
              Left = 2
              Top = 2
              Width = 135
              Height = 30
              Caption = 'PS neu Multiplexen'
              Enabled = False
              Options = [boMonoDisplay, boWordWarp]
              TabOrder = 0
              OnClick = btnReMuxPsClick
            end
          end
          object TePanel9: TTePanel
            Left = 0
            Top = 0
            Width = 734
            Height = 449
            Align = alTop
            BevelInner = bvLowered
            Caption = 'TePanel9'
            TabOrder = 1
            object gbxInMux: TTeGroupBox
              Left = 0
              Top = 0
              Width = 730
              Height = 57
              Align = alTop
              Caption = 'Programm-Stream-Datei'
              TabOrder = 0
              object edInReMuxPs_DropFiles: TPJDropFiles
                Left = 0
                Top = 2
                Width = 705
                Height = 28
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInReMuxPs_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInReMuxPs: TTeEdit
                  Left = 1
                  Top = 0
                  Width = 704
                  Height = 24
                  TabOrder = 0
                  OnChange = edInReMuxPsChange
                  OnDblClick = edInReMuxPsDblClick
                end
              end
            end
            object TeGroupBox3: TTeGroupBox
              Left = 0
              Top = 388
              Width = 730
              Height = 57
              Align = alBottom
              Caption = 'Ausgabe-Datei'
              TabOrder = 1
              object edOutReMuxPs: TTeEdit
                Left = 3
                Top = 5
                Width = 702
                Height = 24
                TabOrder = 0
              end
            end
          end
        end
      end
      object tbsInTs: TTabSheet
        Caption = 'TS'
        ImageIndex = 8
        object plInTs: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 502
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'plOutFiles'
          TabOrder = 0
          object TePanel8: TTePanel
            Left = 0
            Top = 454
            Width = 734
            Height = 38
            Align = alBottom
            BevelInner = bvLowered
            Caption = 'TePanel6'
            TabOrder = 0
            object btnReMuxTs: TTeBitBtn
              Left = 2
              Top = 2
              Width = 135
              Height = 30
              Caption = 'TS neu Multiplexen'
              Enabled = False
              Options = [boMonoDisplay, boWordWarp]
              TabOrder = 0
              OnClick = btnReMuxTsClick
            end
          end
          object TePanel10: TTePanel
            Left = 0
            Top = 0
            Width = 734
            Height = 449
            Align = alTop
            BevelInner = bvLowered
            Caption = 'TePanel10'
            TabOrder = 1
            object gbxTsIn: TTeGroupBox
              Left = 0
              Top = 0
              Width = 730
              Height = 57
              Align = alTop
              Caption = 'Transport-Stream-Datei'
              TabOrder = 0
              object edReMuxTs_DropFiles: TPJDropFiles
                Left = 1
                Top = 2
                Width = 704
                Height = 29
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edReMuxTs_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInReMuxTs: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 705
                  Height = 24
                  TabOrder = 0
                  OnChange = edInReMuxTsChange
                  OnDblClick = edInReMuxTsDblClick
                end
              end
            end
            object TeGroupBox4: TTeGroupBox
              Left = 0
              Top = 388
              Width = 730
              Height = 57
              Align = alBottom
              Caption = 'Ausgabe-Datei'
              TabOrder = 1
              object edOutReMuxTs: TTeEdit
                Left = 3
                Top = 5
                Width = 702
                Height = 24
                TabOrder = 0
              end
            end
            object gbxTsPIDs: TTeGroupBox
              Left = 0
              Top = 57
              Width = 730
              Height = 143
              Align = alTop
              Caption = 'PIDs'
              TabOrder = 2
              object Label11: TLabel
                Left = 0
                Top = 0
                Width = 97
                Height = 24
                AutoSize = False
                Caption = 'Video'
                Layout = tlCenter
              end
              object Label12: TLabel
                Left = 0
                Top = 24
                Width = 97
                Height = 24
                AutoSize = False
                Caption = 'Audio 1'
                Layout = tlCenter
              end
              object Label13: TLabel
                Left = 0
                Top = 48
                Width = 97
                Height = 24
                AutoSize = False
                Caption = 'Audio 2'
                Layout = tlCenter
              end
              object Label14: TLabel
                Left = 0
                Top = 72
                Width = 97
                Height = 24
                AutoSize = False
                Caption = 'Audio 3'
                Layout = tlCenter
              end
              object Label15: TLabel
                Left = 0
                Top = 96
                Width = 97
                Height = 24
                AutoSize = False
                Caption = 'Audio 4'
                Layout = tlCenter
              end
              object edTsVideoPid: TTeEdit
                Left = 96
                Top = 0
                Width = 121
                Height = 24
                TabOrder = 0
              end
              object edTsAudioPid1: TTeEdit
                Left = 96
                Top = 24
                Width = 121
                Height = 24
                TabOrder = 1
              end
              object edTsAudioPid2: TTeEdit
                Left = 96
                Top = 48
                Width = 121
                Height = 24
                TabOrder = 2
              end
              object edTsAudioPid3: TTeEdit
                Left = 96
                Top = 72
                Width = 121
                Height = 24
                TabOrder = 3
              end
              object edTsAudioPid4: TTeEdit
                Left = 96
                Top = 96
                Width = 121
                Height = 24
                TabOrder = 4
              end
            end
          end
        end
      end
      object tbsDbox: TTabSheet
        Caption = 'Optionen'
        ImageIndex = 1
        OnHide = tbsDboxHide
        object plDbox: TTePanel
          Left = 0
          Top = 0
          Width = 744
          Height = 457
          HorzScrollBar.Style = ssFlat
          VertScrollBar.Style = ssFlat
          Align = alTop
          BevelInner = bvLowered
          BorderWidth = 5
          Caption = 'plDbox'
          TabOrder = 0
          object gbxDBox: TTeGroupBox
            Left = 0
            Top = 0
            Width = 730
            Height = 59
            Align = alTop
            Caption = 'Netzwerk'
            TabOrder = 0
            object Label2: TLabel
              Left = 5
              Top = 8
              Width = 11
              Height = 14
              Caption = 'IP '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object chxKillSectionsd: TTeCheckBox
              Left = 209
              Top = 0
              Width = 360
              Height = 21
              Caption = 'Transponderwechsel beim Aufnehmen verhindern'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              State = cbChecked
              TabOrder = 0
            end
            object edIp: TIPAddressControl
              Left = 24
              Top = 8
              Width = 152
              Height = 21
              Field0 = 192
              Field1 = 168
              Field2 = 1
              Field3 = 254
              TabOrder = 1
              OnChange = edIpChange
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -8
              Font.Name = 'MS Sans Serif'
              Font.Style = []
            end
            object chxSwitchChannel: TTeCheckBox
              Left = 209
              Top = 16
              Width = 360
              Height = 21
              Caption = 'automatischen Kanalwechsel beim Suchen im EPG durchf'#252'hren'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              State = cbChecked
              TabOrder = 2
            end
          end
          object gbxSplittOutput: TTeGroupBox
            Left = 0
            Top = 113
            Width = 730
            Height = 107
            Align = alTop
            TabOrder = 1
            object lblSplitt1: TLabel
              Left = 26
              Top = 0
              Width = 127
              Height = 31
              AutoSize = False
              Caption = 'Datei teilen bei'
              Enabled = False
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
              OnClick = lblSplitt1Click
            end
            object lblSplitt2: TLabel
              Left = 191
              Top = 0
              Width = 26
              Height = 31
              AutoSize = False
              Caption = 'MB'
              Enabled = False
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label3: TLabel
              Left = 224
              Top = 5
              Width = 57
              Height = 14
              Alignment = taRightJustify
              Caption = 'MPEG-Pfad '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object btnBrowseOutPath: TSpeedButton
              Left = 684
              Top = 1
              Width = 21
              Height = 22
              Caption = '...'
              OnClick = btnBrowseOutPathClick
            end
            object btnBrowseVlc: TSpeedButton
              Left = 684
              Top = 24
              Width = 21
              Height = 22
              Caption = '...'
              OnClick = btnBrowseVlcClick
            end
            object Label5: TLabel
              Left = 231
              Top = 28
              Width = 50
              Height = 14
              Alignment = taRightJustify
              Caption = 'VLC-Pfad '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object chxSplitting: TCheckBox
              Left = 9
              Top = 6
              Width = 15
              Height = 22
              TabOrder = 0
              OnClick = chxSplittingClick
            end
            object cbxSplitSize: TComboBox
              Left = 118
              Top = 0
              Width = 67
              Height = 22
              Enabled = False
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 14
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              Items.Strings = (
                '100'
                '645'
                '695'
                '779'
                '999'
                '1999'
                '3999'
                '9999')
            end
            object edOutPath: TTeEdit
              Left = 286
              Top = 0
              Width = 395
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = 'C:\Movies\'
              OnChange = edOutPathChange
            end
            object TeGroupBox2: TTeGroupBox
              Left = 0
              Top = 31
              Width = 711
              Height = 57
              Align = alBottom
              TabOrder = 3
              object Label6: TLabel
                Left = 1
                Top = 2
                Width = 91
                Height = 14
                Caption = 'stripe pes header :'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
              end
              object chxVideoStripPesHeader: TTeCheckBox
                Left = -1
                Top = 20
                Width = 157
                Height = 21
                Caption = 'video pes stream file'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object chxAudioStripPesHeader1: TTeCheckBox
                Left = 160
                Top = 3
                Width = 205
                Height = 21
                Caption = 'audio1 pes stream file'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object chxAudioStripPesHeader2: TTeCheckBox
                Left = 350
                Top = 3
                Width = 190
                Height = 21
                Caption = 'audio2 pes stream file'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 2
              end
              object chxAudioStripPesHeader3: TTeCheckBox
                Left = 160
                Top = 20
                Width = 276
                Height = 22
                Caption = 'audio3 pes stream file'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
              end
              object chxAudioStripPesHeader4: TTeCheckBox
                Left = 350
                Top = 20
                Width = 208
                Height = 22
                Caption = 'audio4 pes stream file'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 4
              end
            end
            object edVlcPath: TTeEdit
              Left = 286
              Top = 23
              Width = 395
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Text = 'C:\Programme\VideoLAN\VLC\'
              OnChange = edVlcPathChange
            end
            object chxVlc: TCheckBox
              Left = 8
              Top = 27
              Width = 197
              Height = 22
              Caption = 'mit VLC ansehen'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              OnClick = chxVlcClick
            end
          end
          object gbxGrabMode: TTeRadioGroup
            Left = 0
            Top = 59
            Width = 730
            Height = 54
            Align = alTop
            Caption = 'MPEG'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            ItemIndex = 1
            Items.Strings = (
              'Aufnahme in getrenne PES-Dateien'
              'Aufnahme in gemultiplexte PS-Datei')
          end
          object gbxDvdx: TTeGroupBox
            Left = 0
            Top = 220
            Width = 730
            Height = 47
            Align = alTop
            Caption = 'Transform'
            TabOrder = 3
            object btnBrowseDvdxPath: TSpeedButton
              Left = 684
              Top = 1
              Width = 22
              Height = 22
              Caption = '...'
              OnClick = btnBrowseDvdxPathClick
            end
            object chk_DVDx_enabled: TCheckBox
              Left = 12
              Top = 4
              Width = 274
              Height = 21
              Caption = 'Wandlung vom *.M2P zu *.AVI mit ...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = chk_DVDx_enabledExit
              OnExit = chk_DVDx_enabledExit
            end
            object edDvdxFilePath: TTeEdit
              Left = 286
              Top = 0
              Width = 395
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = 'C:\Programme\Dvdx\DVDx.exe'
              OnChange = edDvdxFilePathChange
            end
          end
          object gbxMovix: TTeGroupBox
            Left = 0
            Top = 338
            Width = 730
            Height = 105
            Align = alBottom
            Caption = 'ISO'
            TabOrder = 4
            object btnBrowseMovixPath: TSpeedButton
              Left = 684
              Top = 1
              Width = 22
              Height = 22
              Caption = '...'
              OnClick = btnBrowseMovixPathClick
            end
            object btnBrowseIsoPath: TSpeedButton
              Left = 684
              Top = 26
              Width = 22
              Height = 21
              Caption = '...'
              OnClick = btnBrowseIsoPathClick
            end
            object Label1: TLabel
              Left = 290
              Top = 53
              Width = 115
              Height = 14
              Caption = 'Ger'#228'teId f'#252'r CdRecord  '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 525
              Top = 53
              Width = 113
              Height = 14
              Caption = 'Brenngeschwindigkeit  '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label16: TLabel
              Left = 162
              Top = 32
              Width = 112
              Height = 14
              Caption = 'speichere das ISO in ...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object chk_MoviX_enabled: TCheckBox
              Left = 8
              Top = 6
              Width = 277
              Height = 22
              Caption = 'erzeuge ein ISO mit '#39'eMoviX'#39', befindlich im Ordner ...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = chk_MoviX_enabledExit
              OnExit = chk_MoviX_enabledExit
            end
            object edMovixPath: TTeEdit
              Left = 286
              Top = 0
              Width = 395
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = 'C:\Movies\MoviX\'
              OnChange = edMovixPathChange
            end
            object chk_CDRwBurn_enabled: TCheckBox
              Left = 8
              Top = 52
              Width = 276
              Height = 21
              Caption = 'brenne das erzeugte ISO mit CdRecord ...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = chk_CDRwBurn_enabledExit
              OnExit = chk_CDRwBurn_enabledExit
            end
            object edIsoPath: TTeEdit
              Left = 286
              Top = 25
              Width = 395
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = 'C:\ISO\'
              OnChange = edIsoPathChange
            end
            object edCDRWDeviceId: TTeEdit
              Left = 416
              Top = 50
              Width = 98
              Height = 22
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Text = '2,0,0'
              OnChange = edCDRWDeviceIdChange
            end
            object edCDRwSpeed: TTeEdit
              Left = 644
              Top = 50
              Width = 39
              Height = 22
              BiDiMode = bdLeftToRight
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 2
              ParentBiDiMode = False
              ParentFont = False
              TabOrder = 5
              Text = '2'
              OnChange = edCDRwSpeedChange
            end
          end
          object gbxPowersave: TTeRadioGroup
            Left = 0
            Top = 296
            Width = 730
            Height = 42
            Align = alBottom
            Caption = 'Verhalten im Leerlauf'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Columns = 4
            ItemIndex = 2
            Items.Strings = (
              'kein Energiesparen'
              'Standby'
              'Ruhezustand'
              'Herunterfahren')
          end
        end
        object TePanel3: TTePanel
          Left = 0
          Top = 464
          Width = 744
          Height = 38
          Align = alBottom
          BevelInner = bvLowered
          Caption = 'TePanel2'
          TabOrder = 1
          object btnSaveSettings: TTeBitBtn
            Left = 3
            Top = 3
            Width = 135
            Height = 30
            Caption = 'Speichern'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 0
            OnClick = btnSaveSettingsClick
          end
          object btnLoadSettings: TTeBitBtn
            Left = 140
            Top = 3
            Width = 135
            Height = 30
            Caption = 'Laden'
            Options = [boMonoDisplay, boWordWarp]
            TabOrder = 1
            OnClick = btnLoadSettingsClick
          end
        end
      end
    end
  end
  object aclMain: TActionList
    Left = 584
    Top = 510
    object acGSStart: TAction
      Caption = '&Start'
    end
  end
  object StateTimer: TTimer
    Enabled = False
    OnTimer = StateTimerTimer
    Left = 466
    Top = 462
  end
  object VCRCommandServerSocket: TServerSocket
    Active = False
    Port = 4000
    ServerType = stNonBlocking
    OnClientRead = VCRCommandServerSocketClientRead
    Left = 626
    Top = 446
  end
  object VcrEpgClientSocket: TClientSocket
    Active = False
    ClientType = ctBlocking
    Port = 0
    Left = 544
    Top = 448
  end
  object VCR_Ping: TIdIcmpClient
    Host = '192.168.1.1'
    Port = 80
    ReceiveTimeout = 1000
    OnReply = VCR_PingReply
    Left = 548
    Top = 478
  end
  object RecordNowTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = RecordNowTimerTimer
    Left = 461
    Top = 438
  end
  object Whishes_DataSource: TDataSource
    DataSet = Whishes_ADOQuery
    Left = 325
    Top = 510
  end
  object Whishes_ADOQuery: TADOQuery
    Connection = Whishes_ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from T_Whishes order by Titel;')
    Left = 357
    Top = 510
  end
  object Recorded_DataSource: TDataSource
    DataSet = Recorded_ADOQuery
    Left = 328
    Top = 480
  end
  object Recorded_ADOQuery: TADOQuery
    Connection = Recorded_ADOConnection
    CursorType = ctStatic
    AfterScroll = Recorded_ADOQueryAfterScroll
    Parameters = <>
    SQL.Strings = (
      'select * from T_Recorded order by Titel;')
    Left = 360
    Top = 480
  end
  object Recorded_ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 296
    Top = 480
  end
  object StartupTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = StartupTimerTimer
    Left = 440
    Top = 464
  end
  object RefreshTimer: TTimer
    Enabled = False
    Interval = 600000
    OnTimer = RefreshTimerTimer
    Left = 440
    Top = 440
  end
  object Whishes_ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 296
    Top = 512
  end
  object Work_ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 424
    Top = 512
  end
  object Work_ADOQuery: TADOQuery
    Connection = Work_ADOConnection
    Parameters = <>
    Left = 456
    Top = 512
  end
  object dbRefreshTimer: TTimer
    Interval = 600000
    OnTimer = dbRefreshTimerTimer
    Left = 488
    Top = 440
  end
  object Planner_ADOTable: TADOTable
    Connection = Planner_ADOConnection
    TableName = 'T_Planner'
    Left = 208
    Top = 512
  end
  object Planner_DataSource: TDataSource
    DataSet = Planner_ADOTable
    Left = 176
    Top = 512
  end
  object Planner_ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 144
    Top = 512
  end
  object VcrDBoxTelnet: TIdTelnet
    OnDisconnected = VcrDBoxTelnetDisconnected
    RecvBufferSize = 8096
    OnConnected = VcrDBoxTelnetConnected
    Port = 23
    SocksInfo.Authentication = saUsernamePassword
    SocksInfo.Port = 23
    SocksInfo.UserID = 'root'
    OnDataAvailable = VcrDBoxTelnetDataAvailable
    Terminal = 'dumb'
    OnConnect = VcrDBoxTelnetConnect
    OnDisconnect = VcrDBoxTelnetDisconnect
    Left = 576
    Top = 448
  end
end
