object frmMain: TfrmMain
  Left = 50
  Top = 134
  Width = 640
  Height = 512
  Caption = 'frmMain'
  Color = clBtnFace
  Constraints.MinHeight = 512
  Constraints.MinWidth = 640
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  TextHeight = 14
  object TePanel1: TTePanel
    Left = 0
    Top = 0
    Width = 632
    Height = 449
    Align = alClient
    OuterBorderWidth = 3
    HeavyBorder = True
    Caption = 'TePanel1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblCaption: TLabel
      Left = 0
      Top = 0
      Width = 622
      Height = 26
      Align = alTop
      AutoSize = False
      Caption = 'MainCaption...'
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnHighlight
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object pclMain: TPageControl
      Left = 0
      Top = 26
      Width = 622
      Height = 413
      ActivePage = tbsDbox
      Align = alClient
      Style = tsFlatButtons
      TabIndex = 1
      TabOrder = 0
      OnChange = pclMainChange
      object tbsWelcome: TTabSheet
        Caption = 'Welcome!'
        object gbxSelect: TTeRadioGroup
          Left = 120
          Top = 48
          Width = 378
          Height = 157
          Caption = 'Select a function:'
          TabOrder = 0
          ItemIndex = 1
          Items.Strings = (
            'Grab into audio and video pes steam files'
            'Grab into a program stream file'
            'Mux audio and video pes stream files into a program stream file'
            'Remux a transport stream file into a program stream file'
            'Remux a program stream file'
            'Zap!'
            'Send pes stream to box')
        end
      end
      object tbsDbox: TTabSheet
        Caption = 'dbox Settings'
        ImageIndex = 1
        object plDbox: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 379
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plDbox'
          TabOrder = 0
          object Bevel1: TBevel
            Left = 0
            Top = 43
            Width = 594
            Height = 10
            Align = alTop
            Shape = bsSpacer
          end
          object gbxChannelList: TTeGroupBox
            Left = 0
            Top = 196
            Width = 594
            Height = 163
            Align = alClient
            Caption = 'Channel'
            TabOrder = 0
            Visible = False
            DesignSize = (
              575
              144)
            object lbxChannelList: TListBox
              Left = 0
              Top = 0
              Width = 575
              Height = 93
              Style = lbOwnerDrawVariable
              Align = alClient
              ItemHeight = 19
              TabOrder = 0
              OnClick = lbxChannelListClick
              OnDblClick = lbxChannelListDblClick
              OnDrawItem = lbxChannelListDrawItem
            end
            object chxKillZap: TTeCheckBox
              Left = 0
              Top = 110
              Width = 575
              Height = 17
              Caption = 'kill playback before streaming'
              TabOrder = 1
              OnClick = chxKillZapClick
              Align = alBottom
            end
            object chxAutoZap: TTeCheckBox
              Left = 0
              Top = 93
              Width = 575
              Height = 17
              Caption = 'AutoZap(tm)'
              TabOrder = 2
              OnClick = chxKillZapClick
              Align = alBottom
            end
            object chxKillSectionsd: TTeCheckBox
              Left = 0
              Top = 127
              Width = 575
              Height = 17
              Caption = 'pause sectionsd before streaming'
              TabOrder = 3
              OnClick = chxKillZapClick
              Align = alBottom
            end
            object bnFromBox: TButton
              Left = 499
              Top = 114
              Width = 75
              Height = 25
              Anchors = [akRight, akBottom]
              Caption = 'From Box'
              TabOrder = 4
              Visible = False
              OnClick = bnFromBoxClick
            end
          end
          object gbxIp: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 43
            Align = alTop
            Caption = 'dbox IP'
            TabOrder = 1
            object edIp: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = '192.168.40.4'
              Align = alTop
            end
          end
          object gbxPids: TTeGroupBox
            Left = 0
            Top = 53
            Width = 594
            Height = 143
            Align = alTop
            Caption = 'PIDs'
            TabOrder = 2
            Visible = False
            object Label2: TLabel
              Left = 0
              Top = 0
              Width = 97
              Height = 24
              AutoSize = False
              Caption = 'Video'
              Layout = tlCenter
            end
            object Label3: TLabel
              Left = 0
              Top = 24
              Width = 97
              Height = 24
              AutoSize = False
              Caption = 'Audio 1'
              Layout = tlCenter
            end
            object Label4: TLabel
              Left = 0
              Top = 48
              Width = 97
              Height = 24
              AutoSize = False
              Caption = 'Audio 2'
              Layout = tlCenter
            end
            object Label5: TLabel
              Left = 0
              Top = 72
              Width = 97
              Height = 24
              AutoSize = False
              Caption = 'Audio 3'
              Layout = tlCenter
            end
            object Label6: TLabel
              Left = 0
              Top = 96
              Width = 97
              Height = 24
              AutoSize = False
              Caption = 'Audio 4'
              Layout = tlCenter
            end
            object edVideoPID: TTeEdit
              Left = 96
              Top = 0
              Width = 121
              Height = 24
              TabOrder = 0
            end
            object edAudioPID1: TTeEdit
              Left = 96
              Top = 24
              Width = 121
              Height = 24
              TabOrder = 1
            end
            object rbnPidHex: TRadioButton
              Left = 232
              Top = 44
              Width = 113
              Height = 17
              Caption = 'HEX'
              TabOrder = 2
            end
            object rbnPidDezimal: TRadioButton
              Left = 232
              Top = 60
              Width = 113
              Height = 17
              Caption = 'Dezimal'
              Checked = True
              TabOrder = 3
              TabStop = True
            end
            object edAudioPID2: TTeEdit
              Left = 96
              Top = 48
              Width = 121
              Height = 24
              TabOrder = 4
            end
            object edAudioPID3: TTeEdit
              Left = 96
              Top = 72
              Width = 121
              Height = 24
              TabOrder = 5
            end
            object edAudioPID4: TTeEdit
              Left = 96
              Top = 96
              Width = 121
              Height = 24
              TabOrder = 6
            end
          end
        end
      end
      object tbsInFiles: TTabSheet
        Caption = 'Input files'
        ImageIndex = 5
        object plInFiles: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 372
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plOutFiles'
          TabOrder = 0
          object gbxInVideo: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 76
            Align = alTop
            Caption = 'Video pes stream file'
            TabOrder = 0
            object Label7: TLabel
              Left = 0
              Top = 32
              Width = 67
              Height = 24
              AutoSize = False
              Caption = 'start offset'
              Layout = tlCenter
            end
            object Label8: TLabel
              Left = 147
              Top = 33
              Width = 49
              Height = 24
              AutoSize = False
              Caption = 'frames'
              Layout = tlCenter
            end
            object Label9: TLabel
              Left = 224
              Top = 33
              Width = 60
              Height = 24
              AutoSize = False
              Caption = 'end offset'
              Layout = tlCenter
            end
            object Label10: TLabel
              Left = 372
              Top = 33
              Width = 49
              Height = 24
              AutoSize = False
              Caption = 'frames'
              Layout = tlCenter
            end
            object edInVideo: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.video'
              OnDblClick = edInVideoDblClick
              Align = alTop
            end
            object edVideoInOffsetStart: TTeEdit
              Left = 64
              Top = 32
              Width = 80
              Height = 24
              TabOrder = 1
            end
            object edVideoInOffsetEnd: TTeEdit
              Left = 288
              Top = 33
              Width = 80
              Height = 24
              TabOrder = 2
            end
          end
          object gbxInAudio1: TTeGroupBox
            Left = 0
            Top = 76
            Width = 594
            Height = 48
            Align = alTop
            Caption = 'Audio 1 pes stream file'
            TabOrder = 1
            object edInAudio1: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.audio'
              OnDblClick = edInAudioDblClick
              Align = alTop
            end
          end
          object gbxInAudio4: TTeGroupBox
            Left = 0
            Top = 220
            Width = 594
            Height = 48
            Align = alTop
            Caption = 'Audio 4 pes stream file'
            TabOrder = 4
            object edInAudio4: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.audio'
              OnDblClick = edInAudioDblClick
              Align = alTop
            end
          end
          object gbxInAudio3: TTeGroupBox
            Left = 0
            Top = 172
            Width = 594
            Height = 48
            Align = alTop
            Caption = 'Audio 3 pes stream file'
            TabOrder = 3
            object edInAudio3: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.audio'
              OnDblClick = edInAudioDblClick
              Align = alTop
            end
          end
          object gbxInAudio2: TTeGroupBox
            Left = 0
            Top = 124
            Width = 594
            Height = 48
            Align = alTop
            Caption = 'Audio 2 pes stream file'
            TabOrder = 2
            object edInAudio2: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.audio'
              OnDblClick = edInAudioDblClick
              Align = alTop
            end
          end
        end
      end
      object tbsInMux: TTabSheet
        Caption = 'Input file'
        ImageIndex = 7
        object plInMux: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 372
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plOutFiles'
          TabOrder = 0
          object gbxInMux: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 43
            Align = alTop
            Caption = 'Program stream file'
            TabOrder = 0
            object edInMux: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.vob'
              OnDblClick = edInMuxDblClick
              Align = alTop
            end
          end
        end
      end
      object tbsInTs: TTabSheet
        Caption = 'Input file'
        ImageIndex = 8
        object plInTs: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 379
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plOutFiles'
          TabOrder = 0
          object Bevel3: TBevel
            Left = 0
            Top = 43
            Width = 594
            Height = 10
            Align = alTop
            Shape = bsSpacer
          end
          object gbxTsIn: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 43
            Align = alTop
            Caption = 'Transport stream file'
            TabOrder = 0
            object edInTs: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.ts'
              OnDblClick = edInTsDblClick
              Align = alTop
            end
          end
          object gbxTsPIDs: TTeGroupBox
            Left = 0
            Top = 53
            Width = 594
            Height = 143
            Align = alTop
            Caption = 'PIDs'
            TabOrder = 1
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
            object rbnTsPidHex: TRadioButton
              Left = 232
              Top = 44
              Width = 113
              Height = 17
              Caption = 'HEX'
              TabOrder = 2
            end
            object rbnTsPidDezimal: TRadioButton
              Left = 232
              Top = 60
              Width = 113
              Height = 17
              Caption = 'Dezimal'
              Checked = True
              TabOrder = 3
              TabStop = True
            end
            object edTsAudioPid2: TTeEdit
              Left = 96
              Top = 48
              Width = 121
              Height = 24
              TabOrder = 4
            end
            object edTsAudioPid3: TTeEdit
              Left = 96
              Top = 72
              Width = 121
              Height = 24
              TabOrder = 5
            end
            object edTsAudioPid4: TTeEdit
              Left = 96
              Top = 96
              Width = 121
              Height = 24
              TabOrder = 6
            end
          end
        end
      end
      object tbsOutFiles: TTabSheet
        Caption = 'Output files'
        ImageIndex = 2
        OnShow = tbsOutFilesShow
        object plOutFiles: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 372
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plOutFiles'
          TabOrder = 0
          object gbxVideoOut: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 68
            Align = alTop
            Caption = 'Video pes stream file'
            TabOrder = 0
            object edOutVideo: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.video'
              OnDblClick = edOutVideoDblClick
              Align = alTop
            end
            object chxVideoStripPesHeader: TTeCheckBox
              Left = 0
              Top = 24
              Width = 217
              Height = 17
              Caption = 'strip PES header'
              TabOrder = 1
            end
          end
          object gbxOutAudio1: TTeGroupBox
            Left = 0
            Top = 68
            Width = 594
            Height = 68
            Align = alTop
            Caption = 'Audio1 pes stream file'
            TabOrder = 1
            object edOutAudio1: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.audio'
              OnDblClick = edOutAudioDblClick
              Align = alTop
            end
            object chxAudioStripPesHeader1: TTeCheckBox
              Left = 0
              Top = 24
              Width = 217
              Height = 17
              Caption = 'strip PES header'
              TabOrder = 1
            end
          end
          object gbxOutAudio4: TTeGroupBox
            Left = 0
            Top = 272
            Width = 594
            Height = 68
            Align = alTop
            Caption = 'Audio4 pes stream file'
            TabOrder = 4
            object edOutAudio4: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.video'
              OnDblClick = edOutAudioDblClick
              Align = alTop
            end
            object chxAudioStripPesHeader4: TTeCheckBox
              Left = 0
              Top = 24
              Width = 217
              Height = 17
              Caption = 'strip PES header'
              TabOrder = 1
            end
          end
          object gbxOutAudio3: TTeGroupBox
            Left = 0
            Top = 204
            Width = 594
            Height = 68
            Align = alTop
            Caption = 'Audio3 pes stream file'
            TabOrder = 3
            object edOutAudio3: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.video'
              OnDblClick = edOutAudioDblClick
              Align = alTop
            end
            object chxAudioStripPesHeader3: TTeCheckBox
              Left = 0
              Top = 24
              Width = 217
              Height = 17
              Caption = 'strip PES header'
              TabOrder = 1
            end
          end
          object gbxOutAudio2: TTeGroupBox
            Left = 0
            Top = 136
            Width = 594
            Height = 68
            Align = alTop
            Caption = 'Audio2 pes stream file'
            TabOrder = 2
            object edOutAudio2: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.video'
              OnDblClick = edOutAudioDblClick
              Align = alTop
            end
            object chxAudioStripPesHeader2: TTeCheckBox
              Left = 0
              Top = 24
              Width = 217
              Height = 17
              Caption = 'strip PES header'
              TabOrder = 1
            end
          end
        end
      end
      object tbsOutMux: TTabSheet
        Caption = 'Output file'
        ImageIndex = 3
        OnShow = tbsOutMuxShow
        object plOutMux: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 379
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plOutFiles'
          TabOrder = 0
          object Bevel5: TBevel
            Left = 0
            Top = 43
            Width = 594
            Height = 10
            Align = alTop
            Shape = bsSpacer
          end
          object gbxOutMux: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 43
            Align = alTop
            Caption = 'Program stram file'
            TabOrder = 0
            object edOutMux: TTeEdit
              Left = 0
              Top = 0
              Width = 575
              Height = 24
              TabOrder = 0
              Text = 'c:\grab.vob'
              OnDblClick = edOutMuxDblClick
              Align = alTop
            end
          end
          object gbxSplittOutput: TTeGroupBox
            Left = 0
            Top = 53
            Width = 594
            Height = 81
            Align = alTop
            Caption = 'Splitt output file'
            TabOrder = 1
            object lblSplitt1: TLabel
              Left = 24
              Top = 0
              Width = 53
              Height = 24
              AutoSize = False
              Caption = 'split after'
              Enabled = False
              Layout = tlCenter
              OnClick = lblSplitt1Click
            end
            object lblSplitt2: TLabel
              Left = 144
              Top = 0
              Width = 25
              Height = 24
              AutoSize = False
              Caption = 'MB'
              Enabled = False
              Layout = tlCenter
            end
            object chxSplitting: TCheckBox
              Left = 7
              Top = 5
              Width = 17
              Height = 17
              TabOrder = 0
              OnClick = chxSplittingClick
            end
            object cbxSplitSize: TComboBox
              Left = 80
              Top = 0
              Width = 57
              Height = 24
              Enabled = False
              ItemHeight = 16
              ParentColor = True
              TabOrder = 1
              OnChange = cbxSplitSizeChange
              Items.Strings = (
                '100'
                '645'
                '695'
                '779'
                '999'
                '1999'
                '3999')
            end
            object plWarningNeedSplitt: TPanel
              Left = 0
              Top = 32
              Width = 575
              Height = 30
              Align = alBottom
              BevelOuter = bvNone
              Caption = 'plWarningNeedSplitt'
              TabOrder = 2
              object shpWarningNeedSplitt: TShape
                Left = 0
                Top = 0
                Width = 575
                Height = 30
                Align = alClient
                Brush.Color = clInfoBk
              end
              object Label1: TLabel
                Left = 0
                Top = 0
                Width = 431
                Height = 16
                Align = alClient
                Alignment = taCenter
                Caption = 
                  'Warning: Some programs have trouble with program stream files > ' +
                  '999 MB'
                Color = clInfoBk
                Font.Charset = ANSI_CHARSET
                Font.Color = clInfoText
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
                Layout = tlCenter
              end
            end
          end
        end
      end
      object tbsTimer: TTabSheet
        Caption = 'Timed recording'
        ImageIndex = 6
        object plTimer: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 373
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plTimer'
          TabOrder = 0
          object gbxTimer: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 105
            Align = alTop
            Caption = 'Timer settings'
            TabOrder = 0
            object lblTimerStart: TLabel
              Left = 0
              Top = 24
              Width = 56
              Height = 24
              AutoSize = False
              Caption = 'Start:'
              Enabled = False
              Layout = tlCenter
            end
            object lblTimerEnd: TLabel
              Left = 0
              Top = 56
              Width = 56
              Height = 24
              AutoSize = False
              Caption = 'End:'
              Enabled = False
              Layout = tlCenter
            end
            object chxTimer: TTeCheckBox
              Left = 0
              Top = 0
              Width = 185
              Height = 17
              Caption = 'Activate Timer'
              TabOrder = 0
              OnClick = chxTimerClick
            end
            object edTimerStart: TTeEdit
              Left = 56
              Top = 24
              Width = 121
              Height = 24
              Enabled = False
              ParentColor = True
              TabOrder = 1
            end
            object edTimerEnd: TTeEdit
              Left = 56
              Top = 56
              Width = 121
              Height = 24
              Enabled = False
              ParentColor = True
              TabOrder = 2
            end
          end
        end
      end
      object tbsRunning: TTabSheet
        Caption = 'Running...'
        ImageIndex = 4
        OnHide = tbsRunningHide
        OnShow = tbsRunningShow
        object plRunning: TTePanel
          Left = 0
          Top = 0
          Width = 614
          Height = 379
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = 'plRunning'
          TabOrder = 0
          object Bevel6: TBevel
            Left = 0
            Top = 162
            Width = 594
            Height = 10
            Align = alBottom
            Shape = bsSpacer
          end
          object gbxMessages: TTeGroupBox
            Left = 0
            Top = 0
            Width = 594
            Height = 162
            Align = alClient
            Caption = 'Messages'
            TabOrder = 0
            object mmoMessages: TMemo
              Left = 0
              Top = 0
              Width = 575
              Height = 137
              Align = alClient
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 0
              WordWrap = False
            end
          end
          object gbxState: TTeGroupBox
            Left = 0
            Top = 172
            Width = 594
            Height = 187
            Align = alBottom
            Caption = 'State'
            TabOrder = 1
            object lvwState: TListView
              Left = 0
              Top = 0
              Width = 575
              Height = 168
              Align = alClient
              Columns = <
                item
                  Caption = 'Thread'
                  Width = 150
                end
                item
                  AutoSize = True
                  Caption = 'State'
                end>
              TabOrder = 0
              ViewStyle = vsReport
            end
          end
        end
      end
    end
  end
  object TePanel2: TTePanel
    Left = 0
    Top = 449
    Width = 632
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    Caption = 'plButton'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Bevel2: TBevel
      Left = 90
      Top = 0
      Width = 3
      Height = 30
      Align = alLeft
      Shape = bsSpacer
    end
    object bnNext: TTeBitBtn
      Left = 93
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'Next'
      Align = alLeft
      Caption = '&Next'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Options = [boWordWarp]
      ParentFont = False
      TabOrder = 1
      OnClick = bnNextClick
    end
    object bnRestart: TTeBitBtn
      Left = 0
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'FastBack'
      Align = alLeft
      Cancel = True
      Caption = 'Restart'
      Options = [boWordWarp]
      TabOrder = 0
      OnClick = bnRestartClick
    end
    object bnClose: TTeBitBtn
      Left = 536
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'Close'
      Align = alRight
      Caption = 'Close'
      Options = [boWordWarp]
      ModalResult = 2
      TabOrder = 2
      OnClick = bnCloseClick
    end
    object Button1: TButton
      Left = 344
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 3
      Visible = False
      OnClick = Button1Click
    end
    object bnStop: TTeBitBtn
      Left = 183
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'Abort'
      Align = alLeft
      Caption = 'Stop'
      Options = [boWordWarp]
      TabOrder = 4
      Visible = False
      OnClick = bnStopClick
    end
  end
  object aclMain: TActionList
    Left = 590
    Top = 156
    object acGSStart: TAction
      Caption = '&Start'
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 431
    Top = 223
  end
  object DecommitTimer: TTimer
    Interval = 200
    OnTimer = DecommitTimerTimer
    Left = 393
    Top = 225
  end
  object StateTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = StateTimerTimer
    Left = 466
    Top = 224
  end
  object IdHTTPServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 31337
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = IdThreadMgrPool
    OnCommandOther = IdHTTPServerCommandOther
    Left = 323
    Top = 387
  end
  object IdThreadMgrPool: TIdThreadMgrPool
    PoolSize = 5
    Left = 391
    Top = 387
  end
end
