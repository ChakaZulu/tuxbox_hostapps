object frmMain: TfrmMain
  Left = 39
  Top = 1
  Width = 770
  Height = 570
  ActiveControl = lvChannelProg
  AlphaBlend = True
  AutoSize = True
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
      ActivePage = tbsWelcome
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabIndex = 0
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
            Width = 353
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
            Left = 360
            Top = 0
            Width = 368
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
              Width = 360
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
            object Timer_WebBrowser: TWebBrowser
              Left = 2
              Top = 2
              Width = 730
              Height = 463
              Align = alTop
              TabOrder = 0
              ControlData = {
                4C000000734B0000DA2F00000000000000000000000000000000000000000000
                000000004C000000000000000000000001000000E0D057007335CF11AE690800
                2B2E126200000000000000004C0000000114020000000000C000000000000046
                8000000000000000000000000000000000000000000000000000000000000000
                00000000000000000100000000000000000000000000000000000000}
            end
            object Record_Planner: TDBPlanner
              Left = 2
              Top = 464
              Width = 730
              Height = 23
              ActiveDisplay = True
              Align = alBottom
              AttachementGlyph.Data = {
                F6000000424DF600000000000000760000002800000010000000100000000100
                0400000000008000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
                8888888888700078888888888708880788888888808808808888888880808080
                8888888880808080888888888080808088888888808080808888888880808080
                8888888880808080888888888080808088888888808080808888888888808080
                8888888888808880888888888888000888888888888888888888}
              Bands.ActivePrimary = 16705483
              Bands.ActiveSecondary = 16439727
              Bands.NonActivePrimary = clSilver
              Bands.NonActiveSecondary = 11053224
              Caption.Title = 'Record Planner'
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWhite
              Caption.Font.Height = -13
              Caption.Font.Name = 'MS Sans Serif'
              Caption.Font.Style = [fsBold]
              Caption.Alignment = taLeftJustify
              Caption.Background = clGray
              Caption.Height = 32
              Caption.Visible = False
              Color = clWindow
              DayNames.Strings = (
                'Sun'
                'Mon'
                'Tue'
                'Wed'
                'Thu'
                'Fri'
                'Sat')
              DefaultItem.Alarm.Active = False
              DefaultItem.Alarm.ID = 0
              DefaultItem.Alarm.NotifyType = anCaption
              DefaultItem.Alarm.Tag = 0
              DefaultItem.Alarm.Time = atBefore
              DefaultItem.Alignment = taLeftJustify
              DefaultItem.AllowOverlap = True
              DefaultItem.Background = False
              DefaultItem.BrushStyle = bsSolid
              DefaultItem.CaptionAlign = taLeftJustify
              DefaultItem.CaptionBkg = clWhite
              DefaultItem.CaptionFont.Charset = DEFAULT_CHARSET
              DefaultItem.CaptionFont.Color = clWindowText
              DefaultItem.CaptionFont.Height = -11
              DefaultItem.CaptionFont.Name = 'MS Sans Serif'
              DefaultItem.CaptionFont.Style = []
              DefaultItem.CaptionType = ctNone
              DefaultItem.Color = clWhite
              DefaultItem.ColorTo = clBtnFace
              DefaultItem.Completion = 0
              DefaultItem.CompletionDisplay = cdNone
              DefaultItem.Cursor = -1
              DefaultItem.DBTag = 0
              DefaultItem.FixedPos = False
              DefaultItem.FixedPosition = False
              DefaultItem.FixedSize = False
              DefaultItem.FixedTime = False
              DefaultItem.Font.Charset = DEFAULT_CHARSET
              DefaultItem.Font.Color = clWindowText
              DefaultItem.Font.Height = -11
              DefaultItem.Font.Name = 'MS Sans Serif'
              DefaultItem.Font.Style = []
              DefaultItem.ImageID = -1
              DefaultItem.ImagePosition = ipHorizontal
              DefaultItem.InHeader = False
              DefaultItem.InplaceEdit = peMemo
              DefaultItem.ItemBegin = 16
              DefaultItem.ItemEnd = 17
              DefaultItem.ItemPos = 0
              DefaultItem.Layer = 0
              DefaultItem.Name = 'PlannerItem0'
              DefaultItem.OwnsItemObject = False
              DefaultItem.ReadOnly = False
              DefaultItem.SelectColor = clInfoBk
              DefaultItem.SelectColorTo = clNone
              DefaultItem.SelectFontColor = clRed
              DefaultItem.Selected = False
              DefaultItem.Shadow = True
              DefaultItem.Tag = 0
              DefaultItem.TrackColor = clBlue
              DefaultItem.TrackSelectColor = clBlue
              DeleteGlyph.Data = {
                36050000424D3605000000000000360400002800000010000000100000000100
                0800000000000001000000000000000000000001000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                A6000020400000206000002080000020A0000020C0000020E000004000000040
                20000040400000406000004080000040A0000040C0000040E000006000000060
                20000060400000606000006080000060A0000060C0000060E000008000000080
                20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                20004000400040006000400080004000A0004000C0004000E000402000004020
                20004020400040206000402080004020A0004020C0004020E000404000004040
                20004040400040406000404080004040A0004040C0004040E000406000004060
                20004060400040606000406080004060A0004060C0004060E000408000004080
                20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                20008000400080006000800080008000A0008000C0008000E000802000008020
                20008020400080206000802080008020A0008020C0008020E000804000008040
                20008040400080406000804080008040A0008040C0008040E000806000008060
                20008060400080606000806080008060A0008060C0008060E000808000008080
                20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D9ED07070707
                0707070707070707ECD9EC5E5E5E5E5E5E5E5E5E5E5E5E5E5DED070D0E161616
                161616160E0E0E0E5E07070D161656561616161616160E0E5E07070D16AF075E
                56561657B7EF0E0E5E07070D56AFF6075F565FAFF6AF160E5E07070D565EAFF6
                075FEFF6AF17160E5E07070D5E5E5EAFF607F6AF161616165E07070D5E5E5E5E
                EFF60756161616165E07070D5E5E5FEFF6EFF6075E1616165E07070D5F5F07F6
                EF5EAFF6075616165E07070D6707F6075E5656AFF60716165E07070DA7AF075F
                5E5E5E5EAFAF56165E07070DA7A7675F5F5E5E5E5E5E56165E07EDAF0D0D0D0D
                0D0D0D0D0D0D0D0D5EECD9ED070707070707070707070707EDD1}
              DirectMove = False
              DisjunctSelect = False
              DisjunctSelectColor = clHighlight
              Display.ActiveStart = 96
              Display.ActiveEnd = 240
              Display.CurrentPosFrom = -1
              Display.CurrentPosTo = -1
              Display.DisplayStart = 0
              Display.DisplayEnd = 287
              Display.DisplayOffset = 0
              Display.DisplayScale = 18
              Display.DisplayUnit = 5
              Display.DisplayText = 0
              Display.ColorActive = clWhite
              Display.ColorNonActive = clSilver
              Display.ColorCurrent = clYellow
              Display.ColorCurrentItem = clLime
              Display.ScaleToFit = False
              Display.ShowCurrent = True
              Display.ShowCurrentItem = True
              DragItem = False
              EditRTF = False
              EditDirect = False
              EditScroll = ssNone
              EnableAlarms = False
              EnableFlashing = False
              FlashColor = clRed
              FlashFontColor = clWhite
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Footer.Alignment = taLeftJustify
              Footer.Color = clBtnFace
              Footer.ColorTo = clWhite
              Footer.Completion.Level2Color = 50943
              Footer.Completion.Font.Charset = DEFAULT_CHARSET
              Footer.Completion.Font.Color = clWindowText
              Footer.Completion.Font.Height = -11
              Footer.Completion.Font.Name = 'Arial'
              Footer.Completion.Font.Style = []
              Footer.CustomCompletionValue = False
              Footer.Font.Charset = DEFAULT_CHARSET
              Footer.Font.Color = clWindowText
              Footer.Font.Height = -11
              Footer.Font.Name = 'MS Sans Serif'
              Footer.Font.Style = []
              Footer.ImagePosition = ipLeft
              Footer.LineColor = clBlack
              Footer.ShowCompletion = False
              Footer.VAlignment = vtaCenter
              Footer.Visible = False
              GradientHorizontal = False
              GridLeftCol = 1
              GridTopRow = 40
              GroupGapOnly = False
              Header.Alignment = taLeftJustify
              Header.Color = clBtnFace
              Header.ColorTo = clWhite
              Header.Height = 24
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'MS Sans Serif'
              Header.Font.Style = []
              Header.ImagePosition = ipLeft
              Header.ItemColor = clGray
              Header.ItemHeight = 32
              Header.LineColor = clGray
              Header.TextHeight = 32
              Header.VAlignment = vtaCenter
              Header.Visible = True
              HintOnItemChange = True
              HourType = ht24hrs
              HTMLHint = False
              HTMLOptions.Width = 100
              HTMLOptions.CellFontStyle = []
              HTMLOptions.HeaderFontStyle = []
              HTMLOptions.SidebarFontStyle = []
              HTMLOptions.ShowCaption = False
              InActiveDays.Sat = False
              InActiveDays.Sun = False
              InActiveDays.Mon = False
              InActiveDays.Tue = False
              InActiveDays.Wed = False
              InActiveDays.Thu = False
              InActiveDays.Fri = False
              IndicateNonVisibleItems = False
              InplaceEdit = ieAlways
              InsertAlways = True
              ItemGap = 11
              Items = <>
              ItemSelection.AutoUnSelect = True
              ItemSelection.Button = sbLeft
              Layer = 0
              Mode.Clip = False
              Mode.Month = 5
              Mode.PeriodStartDay = 3
              Mode.PeriodStartMonth = 5
              Mode.PeriodStartYear = 2004
              Mode.PeriodEndDay = 20
              Mode.PeriodEndMonth = 6
              Mode.PeriodEndYear = 2004
              Mode.PlannerType = plDay
              Mode.TimeLineStart = 38110
              Mode.TimeLineNVUBegin = 0
              Mode.TimeLineNVUEnd = 0
              Mode.WeekStart = 0
              Mode.Year = 2004
              MultiSelect = False
              NavigatorButtons.Visible = False
              NavigatorButtons.ShowHint = True
              ShadowColor = clGray
              ShowHint = False
              Sidebar.ActiveColor = clNone
              Sidebar.Alignment = taLeftJustify
              Sidebar.AMPMPos = apUnderTime
              Sidebar.Background = clBtnFace
              Sidebar.BackgroundTo = clWhite
              Sidebar.Font.Charset = DEFAULT_CHARSET
              Sidebar.Font.Color = clWindowText
              Sidebar.Font.Height = -11
              Sidebar.Font.Name = 'Arial'
              Sidebar.Font.Style = []
              Sidebar.OccupiedFontColor = clWhite
              Sidebar.Position = spLeft
              Sidebar.SeparatorLineColor = clGray
              Sidebar.ShowInPositionGap = False
              Sidebar.ShowOccupied = False
              Sidebar.Width = 40
              Positions = 3
              PositionGap = 0
              PositionGroup = 0
              PositionProps = <>
              PositionWidth = 0
              PositionZoomWidth = 0
              PrintOptions.FooterAlignment = taLeftJustify
              PrintOptions.FooterFont.Charset = DEFAULT_CHARSET
              PrintOptions.FooterFont.Color = clWindowText
              PrintOptions.FooterFont.Height = -11
              PrintOptions.FooterFont.Name = 'MS Sans Serif'
              PrintOptions.FooterFont.Style = []
              PrintOptions.FooterSize = 0
              PrintOptions.HeaderAlignment = taLeftJustify
              PrintOptions.HeaderFont.Charset = DEFAULT_CHARSET
              PrintOptions.HeaderFont.Color = clWindowText
              PrintOptions.HeaderFont.Height = -11
              PrintOptions.HeaderFont.Name = 'MS Sans Serif'
              PrintOptions.HeaderFont.Style = []
              PrintOptions.HeaderSize = 0
              PrintOptions.LeftMargin = 0
              PrintOptions.Orientation = poPortrait
              PrintOptions.RightMargin = 0
              ScrollSmooth = False
              ScrollSynch = True
              ScrollBarStyle.Color = clNone
              ScrollBarStyle.Style = ssNormal
              ScrollBarStyle.Width = 16
              SelectBackground = False
              SelectColor = clHighlight
              TrackWidth = 4
              URLGlyph.Data = {
                F6000000424DF600000000000000760000002800000010000000100000000100
                0400000000008000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888880000800
                0088888808F8F0F8F80888808000000000808880F070888070F0888080000000
                0080880408F8F0F8F80880CCC0000400008874CCC2222C4788887CCCC22226C0
                88887CC822222CC088887C822224642088887C888422C220888877CF8CCCC227
                888887F8F8222208888888776888208888888887777778888888}
              Skin.SkinCaptionX = 0
              Skin.SkinCaptionY = 0
              Skin.SkinX = 0
              Skin.SkinY = 0
              ItemSource = Planner_DBDaySource
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
            Width = 270
            Height = 33
            DataSource = Recorded_DataSource
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
          object Panel3_Recorded: TPanel
            Left = 0
            Top = 0
            Width = 729
            Height = 225
            BevelInner = bvSpace
            BevelOuter = bvLowered
            BevelWidth = 2
            Caption = 'Panel3_Recorded'
            TabOrder = 0
            object Recorded_DBGrid: TDBGrid
              Left = 4
              Top = 4
              Width = 721
              Height = 217
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
            Top = 232
            Width = 729
            Height = 217
            BevelInner = bvLowered
            Caption = 'Panel3'
            TabOrder = 1
            object Recorded_Epg_DropFiles: TPJDropFiles
              Left = 2
              Top = 2
              Width = 725
              Height = 213
              Align = alClient
              PassThrough = False
              ForegroundOnDrop = False
              OnDropFiles = Recorded_Epg_DropFilesDropFiles
              Options = [dfoIncFolders, dfoIncFiles]
              object Recorded_EpgView: ThtmlLite
                Left = 0
                Top = 0
                Width = 725
                Height = 213
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
            Width = 270
            Height = 33
            DataSource = Whishes_DataSource
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
            object Whishes_DBGrid: TDBGrid
              Left = 4
              Top = 4
              Width = 721
              Height = 133
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
              Top = 137
              Width = 721
              Height = 308
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
                Width = 572
                Height = 28
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edOutMux_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edOutMuxPes: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 570
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
                Width = 570
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
                Width = 570
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
                Width = 570
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
                Width = 570
                Height = 27
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInAudio1_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInAudio1MuxPes: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 570
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
                Width = 570
                Height = 27
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInVideo_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInVideoMuxPes: TTeEdit
                  Left = 1
                  Top = 2
                  Width = 570
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
                Width = 577
                Height = 28
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edInReMuxPs_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInReMuxPs: TTeEdit
                  Left = 1
                  Top = 0
                  Width = 575
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
                Width = 577
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
                Width = 578
                Height = 29
                PassThrough = False
                ForegroundOnDrop = False
                OnDropFiles = edReMuxTs_DropFilesDropFiles
                Options = [dfoIncFolders, dfoIncFiles]
                object edInReMuxTs: TTeEdit
                  Left = 0
                  Top = 1
                  Width = 577
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
                Width = 577
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
            Height = 121
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
              Width = 25
              Height = 14
              Caption = 'Pfad '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object btnBrowseOutPath: TSpeedButton
              Left = 540
              Top = 1
              Width = 21
              Height = 22
              Caption = '...'
              OnClick = btnBrowseOutPathClick
            end
            object btnBrowseVlc: TSpeedButton
              Left = 540
              Top = 24
              Width = 21
              Height = 22
              Caption = '...'
              OnClick = btnBrowseVlcClick
            end
            object Label5: TLabel
              Left = 224
              Top = 28
              Width = 25
              Height = 14
              Caption = 'Pfad '
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
              Width = 250
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
              Top = 45
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
              Width = 250
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
            Top = 234
            Width = 730
            Height = 47
            Align = alTop
            TabOrder = 3
            object btnBrowseDvdxPath: TSpeedButton
              Left = 540
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
              Caption = 'Wandlung vom *.m2p mit ...'
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
              Width = 250
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
            Top = 288
            Width = 730
            Height = 155
            Align = alBottom
            TabOrder = 4
            object btnBrowseMovixPath: TSpeedButton
              Left = 540
              Top = 1
              Width = 22
              Height = 22
              Caption = '...'
              OnClick = btnBrowseMovixPathClick
            end
            object btnBrowseIsoPath: TSpeedButton
              Left = 540
              Top = 26
              Width = 22
              Height = 21
              Caption = '...'
              OnClick = btnBrowseIsoPathClick
            end
            object Label1: TLabel
              Left = 26
              Top = 52
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
              Left = 285
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
              Width = 250
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
              Top = 28
              Width = 276
              Height = 21
              Caption = 'brenne das erzeugte ISO aus dem Ordner ...'
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
              Width = 250
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
              Left = 176
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
              Left = 428
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
  object Planner_DBDaySource: TDBDaySource
    AutoIncKey = False
    DataSource = Planner_DataSource
    ResourceMap = <>
    StartTimeField = 'Starttime'
    EndTimeField = 'Endtime'
    KeyField = 'Key'
    ReadOnly = False
    ResourceField = 'Resource'
    SubjectField = 'Subject'
    NotesField = 'Notes'
    UpdateByQuery = False
    OnFieldsToItem = Planner_DBDaySourceFieldsToItem
    OnItemToFields = Planner_DBDaySourceItemToFields
    DateFormat = 'dd.mm.yyyy'
    Mode = dmMultiDay
    Left = 240
    Top = 512
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
end
