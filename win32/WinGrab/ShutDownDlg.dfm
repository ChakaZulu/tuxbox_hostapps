object FrmShutdown: TFrmShutdown
  Left = 262
  Top = 185
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Shutdown'
  ClientHeight = 185
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 290
    Height = 185
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvSpace
    BevelWidth = 3
    TabOrder = 0
    DesignSize = (
      290
      185)
    object Panel2: TPanel
      Left = 20
      Top = 16
      Width = 249
      Height = 49
      Anchors = [akTop]
      BevelInner = bvSpace
      BevelOuter = bvNone
      BevelWidth = 2
      BorderStyle = bsSingle
      Caption = 'Shutdown'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Panel_CountDown: TPanel
      Left = 20
      Top = 64
      Width = 249
      Height = 49
      Anchors = [akTop]
      BevelInner = bvSpace
      BevelOuter = bvNone
      BevelWidth = 2
      BorderStyle = bsSingle
      Caption = '30'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 20
      Top = 112
      Width = 249
      Height = 57
      Anchors = [akTop]
      BevelInner = bvSpace
      BevelWidth = 2
      BorderStyle = bsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object btn_Cancel: TBitBtn
        Left = 3
        Top = 3
        Width = 239
        Height = 47
        TabOrder = 0
        OnClick = btn_CancelClick
        Kind = bkCancel
      end
    end
  end
  object CountDown: TTimer
    Enabled = False
    OnTimer = CountDownTimer
    Top = 80
  end
end
