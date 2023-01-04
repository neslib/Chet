object FormScriptHelp: TFormScriptHelp
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Script Help'
  ClientHeight = 534
  ClientWidth = 747
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 25
  object RichEdit: TRichEdit
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 737
    Height = 496
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
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
    ExplicitWidth = 727
    ExplicitHeight = 488
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 506
    Width = 747
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Panels = <>
    ExplicitTop = 498
    ExplicitWidth = 737
  end
end
