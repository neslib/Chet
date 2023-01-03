object FormScriptHelp: TFormScriptHelp
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Script Help'
  ClientHeight = 712
  ClientWidth = 986
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 192
  TextHeight = 32
  object RichEdit: TRichEdit
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 974
    Height = 662
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    Font.Charset = ANSI_CHARSET
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
  object StatusBar: TStatusBar
    Left = 0
    Top = 674
    Width = 986
    Height = 38
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Panels = <>
  end
end
