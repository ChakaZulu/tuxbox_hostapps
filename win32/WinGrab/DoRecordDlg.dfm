object FrmDoRecord: TFrmDoRecord
  Left = 243
  Top = 170
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'neue Aufnahme'
  ClientHeight = 379
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblHinweis: TLabel
    Left = 60
    Top = 304
    Width = 381
    Height = 65
    AutoSize = False
    Caption = 'Titel wurde bereits aufgenommen !'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object lblHinweisTitel: TLabel
    Left = 8
    Top = 304
    Width = 49
    Height = 17
    AutoSize = False
    Caption = 'Hinweis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object BtnOk: TBitBtn
    Left = 452
    Top = 300
    Width = 97
    Height = 33
    TabOrder = 0
    OnClick = BtnOkClick
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 452
    Top = 340
    Width = 97
    Height = 33
    TabOrder = 1
    OnClick = BtnCancelClick
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 2
    Top = 4
    Width = 547
    Height = 293
    BevelInner = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 49
      Height = 17
      AutoSize = False
      Caption = 'Kanal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 49
      Height = 17
      AutoSize = False
      Caption = 'Dauer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTitel: TLabel
      Left = 68
      Top = 8
      Width = 469
      Height = 17
      AutoSize = False
      Caption = 'lblTitel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDauer: TLabel
      Left = 68
      Top = 40
      Width = 89
      Height = 17
      AutoSize = False
      Caption = 'lblDauer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblStartZeit: TLabel
      Left = 68
      Top = 24
      Width = 157
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 24
      Width = 49
      Height = 17
      AutoSize = False
      Caption = 'Termin'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object htmlEPG: ThtmlLite
      Left = 8
      Top = 60
      Width = 533
      Height = 229
      TabOrder = 0
      BorderStyle = htFocused
      HistoryMaxCount = 0
      DefFontName = 'Times New Roman'
      DefPreFontName = 'Courier New'
      NoSelect = False
      CharSet = DEFAULT_CHARSET
      htOptions = []
    end
    object cb_Zielformat: TCheckBox
      Left = 260
      Top = 20
      Width = 129
      Height = 17
      Caption = 'Ziel ist eine DVD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object cb_FreeTV: TCheckBox
      Left = 260
      Top = 40
      Width = 169
      Height = 17
      Caption = '5 min l'#228'nger aufnehmen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
end
