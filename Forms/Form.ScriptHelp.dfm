object FormScriptHelp: TFormScriptHelp
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Script Help'
  ClientHeight = 356
  ClientWidth = 493
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object RichEdit: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 487
    Height = 331
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    HideScrollBars = False
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    ShowURLHint = True
    TabOrder = 0
    WantReturns = False
    StyleName = 'Windows'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 337
    Width = 493
    Height = 19
    Panels = <>
  end
end
