object FrmDivXchk: TFrmDivXchk
  Left = 317
  Top = 198
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 1
  Caption = 'pr'#252'fe AVI / DivX - Datei'
  ClientHeight = 66
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 66
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object lblFileName: TLabel
      Left = 2
      Top = 2
      Width = 546
      Height = 39
      Align = alTop
      Alignment = taCenter
      AutoSize = False
    end
    object ProgressBar: TProgressBar
      Left = 2
      Top = 40
      Width = 546
      Height = 24
      Align = alBottom
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
  object StartupTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = StartupTimerTimer
    Left = 8
    Top = 8
  end
end
