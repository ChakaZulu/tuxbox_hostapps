object frmChannelSelect: TfrmChannelSelect
  Left = 269
  Top = 136
  Width = 380
  Height = 380
  Caption = 'Channel selection...'
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object plButtons: TTePanel
    Left = 0
    Top = 317
    Width = 372
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    Caption = 'plButtons'
    TabOrder = 0
    object Bevel1: TBevel
      Left = 273
      Top = 0
      Width = 3
      Height = 30
      Align = alRight
      Shape = bsSpacer
    end
    object bnAbbruch: TTeBitBtn
      Left = 276
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'Abort'
      Align = alRight
      Cancel = True
      Caption = '&Cancel'
      Options = [boWordWarp]
      ModalResult = 2
      TabOrder = 0
    end
    object bnOK: TTeBitBtn
      Left = 183
      Top = 0
      Width = 90
      Height = 30
      ImageName = 'OK'
      Align = alRight
      Caption = '&OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Options = [boWordWarp]
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
    end
  end
  object plChannelList: TTePanel
    Left = 0
    Top = 0
    Width = 372
    Height = 317
    Align = alClient
    BorderWidth = 10
    OuterBorderWidth = 3
    HeavyBorder = True
    Caption = 'plChannelList'
    TabOrder = 1
    object gbxChannelList: TTeGroupBox
      Left = 0
      Top = 0
      Width = 342
      Height = 287
      Align = alClient
      Caption = 'Select a channel:'
      TabOrder = 0
      object lbxChannelList: TListBox
        Left = 0
        Top = 0
        Width = 323
        Height = 271
        Align = alClient
        ItemHeight = 18
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClick = lbxChannelListClick
        OnDblClick = lbxChannelListDblClick
        OnDrawItem = lbxChannelListDrawItem
      end
    end
  end
end
