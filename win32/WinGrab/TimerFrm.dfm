object frmTimer: TfrmTimer
  Left = 326
  Top = 248
  Width = 260
  Height = 123
  BorderIcons = []
  Caption = 'Timer...'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object plTop: TTePanel
    Left = 0
    Top = 0
    Width = 252
    Height = 60
    Align = alClient
    OuterBorderWidth = 3
    HeavyBorder = True
    Caption = 'plTop'
    TabOrder = 0
    object lblTimer: TLabel
      Left = 0
      Top = 26
      Width = 242
      Height = 24
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 242
      Height = 21
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Time remaining:'
      Layout = tlCenter
    end
  end
  object plBottom: TTePanel
    Left = 0
    Top = 60
    Width = 252
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    Caption = 'plBottom'
    TabOrder = 1
    object bnAbort: TTeBitBtn
      Left = 78
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'Abort'
      Cancel = True
      Caption = '&Abort'
      Options = [boWordWarp]
      ModalResult = 2
      TabOrder = 0
    end
  end
  object Timer: TTimer
    Interval = 500
    OnTimer = TimerTimer
    Left = 27
    Top = 39
  end
end
