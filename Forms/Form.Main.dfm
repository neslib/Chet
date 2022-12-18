object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Chet - C header translator'
  ClientHeight = 397
  ClientWidth = 569
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 580
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OnCloseQuery = FormCloseQuery
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 378
    Width = 569
    Height = 19
    Panels = <>
  end
  object ButtonGroupCategories: TButtonGroup
    Left = 0
    Top = 0
    Width = 125
    Height = 378
    Align = alLeft
    BorderStyle = bsNone
    ButtonOptions = [gboFullSize, gboGroupStyle, gboShowCaptions]
    Items = <
      item
        Caption = 'Project'
      end
      item
        Caption = 'Platforms'
      end
      item
        Caption = 'Parse Options'
      end
      item
        Caption = 'Conversion Options'
      end
      item
        Caption = 'Ignore'
      end
      item
        Caption = 'Post Process'
      end
      item
        Caption = 'Translate'
      end>
    ItemIndex = 0
    TabOrder = 1
    OnButtonClicked = ButtonGroupCategoriesButtonClicked
    ExplicitTop = -6
  end
  object CardPanel: TCardPanel
    Left = 125
    Top = 0
    Width = 444
    Height = 378
    Align = alClient
    ActiveCard = PostProcess
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 4
    TabOrder = 2
    object CardProject: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Project'
      CardIndex = 0
      TabOrder = 0
      DesignSize = (
        440
        374)
      object LabelHeaderFileDirectory: TLabel
        Left = 2
        Top = 0
        Width = 141
        Height = 13
        Caption = 'Directory with C Header files:'
      end
      object LabelPasFile: TLabel
        Left = 2
        Top = 76
        Width = 86
        Height = 13
        Caption = 'Target Pascal file:'
      end
      object LabelUses: TLabel
        Left = 2
        Top = 120
        Width = 188
        Height = 13
        Caption = 'Comma-separated list of units to "use":'
      end
      object EditHeaderFileDirectory: TEdit
        Left = 2
        Top = 15
        Width = 384
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = EditHeaderFileDirectoryChange
      end
      object ButtonBrowseHeaderFileDirectory: TButton
        Left = 389
        Top = 14
        Width = 33
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonBrowseHeaderFileDirectoryClick
      end
      object CheckBoxIncludeSubdiretories: TCheckBox
        Left = 2
        Top = 42
        Width = 167
        Height = 17
        Caption = 'Include subdirectories'
        TabOrder = 2
        OnClick = CheckBoxIncludeSubdiretoriesClick
      end
      object EditPasFile: TEdit
        Left = 2
        Top = 91
        Width = 384
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = EditPasFileChange
      end
      object ButtonBrowsePasFile: TButton
        Left = 389
        Top = 90
        Width = 33
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 4
        OnClick = ButtonBrowsePasFileClick
      end
      object EditUseUnits: TEdit
        Left = 2
        Top = 135
        Width = 418
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnChange = EditUseUnitsChange
      end
    end
    object CardPlatforms: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Platforms'
      CardIndex = 1
      TabOrder = 4
      object LabelPlatform: TLabel
        Left = 6
        Top = 36
        Width = 44
        Height = 13
        Caption = 'Platform:'
      end
      object LabelLibrary: TLabel
        Left = 120
        Top = 36
        Width = 66
        Height = 13
        Caption = 'Library name:'
      end
      object LabelPrefix: TLabel
        Left = 308
        Top = 36
        Width = 62
        Height = 13
        Caption = 'Prefix (_PU):'
      end
      object LabelLibConstant: TLabel
        Left = 6
        Top = 7
        Width = 82
        Height = 13
        Caption = 'Library constant:'
      end
      object EditLibWin32: TEdit
        Left = 118
        Top = 51
        Width = 175
        Height = 21
        TabOrder = 2
        OnChange = EditLibraryNameChange
      end
      object CheckBoxWin32: TCheckBox
        Left = 6
        Top = 53
        Width = 110
        Height = 17
        Caption = '32-bit Windows'
        TabOrder = 1
        OnClick = CheckBoxPlatformClick
      end
      object EditLibWin64: TEdit
        Tag = 1
        Left = 118
        Top = 78
        Width = 175
        Height = 21
        TabOrder = 5
        OnChange = EditLibraryNameChange
      end
      object CheckBoxWin64: TCheckBox
        Tag = 1
        Left = 6
        Top = 80
        Width = 110
        Height = 17
        Caption = '64-bit Windows'
        TabOrder = 4
        OnClick = CheckBoxPlatformClick
      end
      object CheckBoxMacARM: TCheckBox
        Tag = 2
        Left = 6
        Top = 107
        Width = 110
        Height = 17
        Caption = 'ARM macOS'
        TabOrder = 7
        OnClick = CheckBoxPlatformClick
      end
      object EditLibMacARM: TEdit
        Tag = 2
        Left = 118
        Top = 105
        Width = 175
        Height = 21
        TabOrder = 8
        OnChange = EditLibraryNameChange
      end
      object CheckBoxLinux64: TCheckBox
        Tag = 4
        Left = 6
        Top = 161
        Width = 110
        Height = 17
        Caption = '64-bit Linux'
        TabOrder = 13
        OnClick = CheckBoxPlatformClick
      end
      object EditLibLinux64: TEdit
        Tag = 4
        Left = 118
        Top = 159
        Width = 175
        Height = 21
        TabOrder = 14
        OnChange = EditLibraryNameChange
      end
      object CheckBoxIOS: TCheckBox
        Tag = 5
        Left = 6
        Top = 188
        Width = 110
        Height = 17
        Caption = 'iOS'
        TabOrder = 16
        OnClick = CheckBoxPlatformClick
      end
      object EditLibIOS: TEdit
        Tag = 5
        Left = 118
        Top = 186
        Width = 175
        Height = 21
        TabOrder = 17
        OnChange = EditLibraryNameChange
      end
      object CheckBoxAndroid32: TCheckBox
        Tag = 6
        Left = 6
        Top = 215
        Width = 110
        Height = 17
        Caption = '32-bit Android'
        TabOrder = 19
        OnClick = CheckBoxPlatformClick
      end
      object EditLibAndroid32: TEdit
        Tag = 6
        Left = 118
        Top = 213
        Width = 175
        Height = 21
        TabOrder = 20
        OnChange = EditLibraryNameChange
      end
      object EditPrefixWin32: TEdit
        Left = 306
        Top = 51
        Width = 30
        Height = 21
        TabOrder = 3
        OnChange = EditPrefixChange
      end
      object EditPrefixWin64: TEdit
        Tag = 1
        Left = 306
        Top = 78
        Width = 30
        Height = 21
        TabOrder = 6
        OnChange = EditPrefixChange
      end
      object EditPrefixMacARM: TEdit
        Tag = 2
        Left = 306
        Top = 105
        Width = 30
        Height = 21
        TabOrder = 9
        OnChange = EditPrefixChange
      end
      object EditPrefixLinux64: TEdit
        Tag = 4
        Left = 306
        Top = 159
        Width = 30
        Height = 21
        TabOrder = 15
        OnChange = EditPrefixChange
      end
      object EditPrefixIOS: TEdit
        Tag = 5
        Left = 306
        Top = 186
        Width = 30
        Height = 21
        TabOrder = 18
        OnChange = EditPrefixChange
      end
      object EditPrefixAndroid32: TEdit
        Tag = 6
        Left = 306
        Top = 213
        Width = 30
        Height = 21
        TabOrder = 21
        OnChange = EditPrefixChange
      end
      object EditLibConstant: TEdit
        Left = 118
        Top = 4
        Width = 175
        Height = 21
        TabOrder = 0
        OnChange = EditLibConstantChange
      end
      object CheckBoxMacIntel: TCheckBox
        Tag = 3
        Left = 6
        Top = 134
        Width = 110
        Height = 17
        Caption = 'Intel macOS'
        TabOrder = 10
        OnClick = CheckBoxPlatformClick
      end
      object EditLibMacIntel: TEdit
        Tag = 3
        Left = 118
        Top = 132
        Width = 175
        Height = 21
        TabOrder = 11
        OnChange = EditLibraryNameChange
      end
      object EditPrefixMacIntel: TEdit
        Tag = 3
        Left = 306
        Top = 132
        Width = 30
        Height = 21
        TabOrder = 12
        OnChange = EditPrefixChange
      end
      object CheckBoxAndroid64: TCheckBox
        Tag = 7
        Left = 6
        Top = 242
        Width = 110
        Height = 17
        Caption = '64-bit Android'
        TabOrder = 22
        OnClick = CheckBoxPlatformClick
      end
      object EditLibAndroid64: TEdit
        Tag = 7
        Left = 118
        Top = 240
        Width = 175
        Height = 21
        TabOrder = 23
        OnChange = EditLibraryNameChange
      end
      object EditPrefixAndroid64: TEdit
        Tag = 7
        Left = 306
        Top = 240
        Width = 30
        Height = 21
        TabOrder = 24
        OnChange = EditPrefixChange
      end
    end
    object CardParseOptions: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Parse Options'
      CardIndex = 2
      TabOrder = 1
      object LabelCmdLineArgs: TLabel
        Left = 2
        Top = 23
        Width = 205
        Height = 13
        Caption = 'Command line arguments to pass to Clang:'
      end
      object CheckBoxIgnoreParseErrors: TCheckBox
        Left = 2
        Top = 0
        Width = 149
        Height = 17
        Caption = 'Ignore parse errors'
        TabOrder = 0
        OnClick = CheckBoxIgnoreParseErrorsClick
      end
      object ListBoxCmdLineArgs: TListBox
        Left = 2
        Top = 38
        Width = 403
        Height = 114
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListBoxCmdLineArgsClick
      end
      object ButtonAddCmdLineArg: TButton
        Left = 2
        Top = 158
        Width = 100
        Height = 25
        Action = ActionAddCmdLineArg
        TabOrder = 2
      end
      object ButtonDeleteArgument: TButton
        Left = 304
        Top = 158
        Width = 100
        Height = 25
        Action = ActionDeleteCmdLineArg
        TabOrder = 5
      end
      object ButtonAddDefine: TButton
        Left = 103
        Top = 158
        Width = 100
        Height = 25
        Action = ActionAddDefine
        TabOrder = 3
      end
      object ButtonAddIncludePath: TButton
        Left = 204
        Top = 158
        Width = 100
        Height = 25
        Action = ActionAddIncludePath
        TabOrder = 4
      end
    end
    object CardConversionOptions: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Conversion Options'
      CardIndex = 3
      TabOrder = 3
      object LabelConvertChar: TLabel
        Left = 6
        Top = 61
        Width = 88
        Height = 13
        Caption = 'Convert "char" to:'
      end
      object LabelConvertComments: TLabel
        Left = 6
        Top = 34
        Width = 92
        Height = 13
        Caption = 'Comment handling:'
      end
      object LabelCallConv: TLabel
        Left = 6
        Top = 7
        Width = 91
        Height = 13
        Caption = 'Calling convention:'
      end
      object LabelReservedWordHandling: TLabel
        Left = 6
        Top = 120
        Width = 120
        Height = 13
        Caption = 'Reserved word handling:'
      end
      object LabelUnconvertibleHandling: TLabel
        Left = 6
        Top = 197
        Width = 131
        Height = 13
        Caption = 'Unconvertible declarations:'
      end
      object LabelEnumHandling: TLabel
        Left = 6
        Top = 170
        Width = 73
        Height = 13
        Caption = 'Enum handling:'
      end
      object LabelConvertUnsignedChar: TLabel
        Left = 7
        Top = 88
        Width = 134
        Height = 13
        Caption = 'Convert "unsigned char" to:'
      end
      object ComboBoxConvertChar: TComboBox
        Left = 148
        Top = 58
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'UTF8Char'
        OnChange = ComboBoxConvertCharChange
        Items.Strings = (
          'UTF8Char'
          'Shortint'
          'Byte'
          'AnsiString')
      end
      object ComboBoxConvertComments: TComboBox
        Left = 148
        Top = 31
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = 'Keep comments as-is'
        OnChange = ComboBoxConvertCommentsChange
        Items.Strings = (
          'Keep comments as-is'
          'Remove comments'
          'Convert comments to XmlDoc style (experimental)'
          'Convert comments to PasDoc style (experimental)')
      end
      object ComboBoxCallConv: TComboBox
        Left = 148
        Top = 4
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'cdecl'
        OnChange = ComboBoxCallConvChange
        Items.Strings = (
          'cdecl'
          'stdcall')
      end
      object ComboBoxReservedWordHandling: TComboBox
        Left = 148
        Top = 117
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'Add leading '#39'&'#39
        OnChange = ComboBoxReservedWordHandlingChange
        Items.Strings = (
          'Add leading '#39'&'#39
          'Add leading '#39'_'#39
          'Add trailing '#39'_'#39)
      end
      object CheckBoxDirectivesAsReservedWords: TCheckBox
        Left = 6
        Top = 144
        Width = 191
        Height = 17
        Caption = 'Treat directives as reserved words'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBoxDirectivesAsReservedWordsClick
      end
      object ComboBoxUnconvertibleHandling: TComboBox
        Left = 148
        Top = 194
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 6
        Text = 'Write TODO item'
        OnChange = ComboBoxUnconvertibleHandlingChange
        Items.Strings = (
          'Write TODO item'
          'Comment out original declaration'
          'Ignore declaration')
      end
      object ComboBoxEnumHandling: TComboBox
        Left = 148
        Top = 167
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = 'Convert to enumerated type'
        OnChange = ComboBoxEnumHandlingChange
        Items.Strings = (
          'Convert to enumerated type'
          'Convert to integer type and constants')
      end
      object ComboBoxConvertUnsignedChar: TComboBox
        Left = 148
        Top = 85
        Width = 280
        Height = 21
        Style = csDropDownList
        ItemIndex = 2
        TabOrder = 7
        Text = 'Byte'
        OnChange = ComboBoxConvertUnsignedCharChange
        Items.Strings = (
          'UTF8Char'
          'Shortint'
          'Byte'
          'AnsiString')
      end
      object CheckBoxDelayedLoading: TCheckBox
        Left = 6
        Top = 221
        Width = 331
        Height = 17
        Caption = 'Add "delayed" directive to imported routines (Windows only)'
        TabOrder = 8
        OnClick = CheckBoxDelayedLoadingClick
      end
      object CheckBoxPrefixSymbolsWithUnderscore: TCheckBox
        Left = 7
        Top = 244
        Width = 331
        Height = 17
        Caption = 'Prefix all symbols with an underscore (experimental)'
        TabOrder = 9
        Visible = False
        OnClick = CheckBoxPrefixSymbolsWithUnderscoreClick
      end
    end
    object CardIgnore: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Ignore'
      CardIndex = 4
      TabOrder = 5
      object LabelIgnore: TLabel
        AlignWithMargins = True
        Left = 6
        Top = 4
        Width = 431
        Height = 26
        Margins.Left = 6
        Margins.Top = 4
        Align = alTop
        Caption = 
          'Symbols (constants, types, functions) to ignore. These will not ' +
          'be translated. Enter one symbol per line. Symbols are case-sensi' +
          'tive.'
        WordWrap = True
        ExplicitWidth = 424
      end
      object MemoIgnore: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 33
        Width = 432
        Height = 337
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        OnExit = MemoIgnoreExit
      end
    end
    object PostProcess: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'PostProcess'
      CardIndex = 5
      TabOrder = 6
      DesignSize = (
        440
        374)
      object ScriptMemo: TMemo
        Left = 0
        Top = 42
        Width = 660
        Height = 519
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Consolas'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object ButtonClearScript: TButton
        Left = 4
        Top = 0
        Width = 113
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Clear Script'
        TabOrder = 1
        OnClick = ButtonClearScriptClick
      end
      object ButtonScriptHelp: TButton
        Left = 127
        Top = 0
        Width = 113
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Script Help'
        TabOrder = 2
        OnClick = ButtonScriptHelpClick
      end
    end
    object CardTranslate: TCard
      Left = 4
      Top = 4
      Width = 440
      Height = 374
      Caption = 'Translate'
      CardIndex = 6
      TabOrder = 2
      object ButtonRunTranslator: TButton
        Left = 2
        Top = 0
        Width = 151
        Height = 25
        Action = ActionRunTranslator
        TabOrder = 0
      end
      object MemoMessages: TMemo
        AlignWithMargins = True
        Left = 2
        Top = 28
        Width = 438
        Height = 346
        Margins.Left = 2
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 60
    Top = 652
    object MenuFile: TMenuItem
      Caption = 'File'
      object MenuNew: TMenuItem
        Action = ActionNew
      end
      object MenuOpen: TMenuItem
        Action = ActionOpen
      end
      object MenuSave: TMenuItem
        Action = ActionSave
      end
      object MenuSaveAs: TMenuItem
        Action = ActionSaveAs
      end
      object MenuSeparator: TMenuItem
        Caption = '-'
      end
      object MenuExit: TMenuItem
        Action = ActionExit
      end
    end
    object MenuRun: TMenuItem
      Caption = 'Run'
      object MenuRunTranslator: TMenuItem
        Action = ActionRunTranslator
      end
    end
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 168
    Top = 652
    object ActionAddCmdLineArg: TAction
      Category = 'Parse Options'
      Caption = 'Add Argument'
      OnExecute = ActionAddCmdLineArgExecute
    end
    object ActionAddIncludePath: TAction
      Category = 'Parse Options'
      Caption = 'Add Include Path'
      OnExecute = ActionAddIncludePathExecute
    end
    object ActionAddDefine: TAction
      Category = 'Parse Options'
      Caption = 'Add Define'
      OnExecute = ActionAddDefineExecute
    end
    object ActionDeleteCmdLineArg: TAction
      Category = 'Parse Options'
      Caption = 'Delete Argument'
      Enabled = False
      OnExecute = ActionDeleteCmdLineArgExecute
    end
    object ActionRunTranslator: TAction
      Category = 'Translate'
      Caption = 'Run Header Translator'
      ImageIndex = 4
      ShortCut = 120
      OnExecute = ActionRunTranslatorExecute
    end
    object ActionNew: TAction
      Category = 'File'
      Caption = 'New Project...'
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = ActionNewExecute
    end
    object ActionOpen: TAction
      Category = 'File'
      Caption = 'Open Project...'
      ImageIndex = 1
      ShortCut = 16463
      OnExecute = ActionOpenExecute
    end
    object ActionSave: TAction
      Category = 'File'
      Caption = 'Save'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = ActionSaveExecute
    end
    object ActionSaveAs: TAction
      Category = 'File'
      Caption = 'Save As...'
      ShortCut = 49235
      OnExecute = ActionSaveAsExecute
    end
    object ActionExit: TAction
      Category = 'File'
      Caption = 'Exit'
      ImageIndex = 3
      ShortCut = 32883
      OnExecute = ActionExitExecute
    end
  end
  object OpenDirectoryDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Header files'
        FileMask = '*.h;*.hpp'
      end>
    Options = [fdoPickFolders, fdoPathMustExist]
    Left = 168
    Top = 544
  end
  object SaveDialogProject: TFileSaveDialog
    DefaultExtension = 'htrans'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Chet Project Files'
        FileMask = '*.chet'
      end>
    Options = [fdoOverWritePrompt, fdoPathMustExist]
    Title = 'Save project file'
    Left = 60
    Top = 596
  end
  object SaveDialogPasFile: TFileSaveDialog
    DefaultExtension = 'htrans'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Delphi Pascal Files'
        FileMask = '*.pas'
      end>
    Options = [fdoOverWritePrompt, fdoPathMustExist]
    Title = 'Target Pascal file'
    Left = 168
    Top = 596
  end
  object OpenDialogProject: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Chet Project Files'
        FileMask = '*.chet'
      end>
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Open project file'
    Left = 60
    Top = 544
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    Left = 256
    Top = 652
    Bitmap = {
      494C010105004000040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000767676AE0202
      021A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFE1E1
      E1F0292929670000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFF959595C306060628000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF3F3F3F93F3F3F7F0000000600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB3B3B3D60D0D0D3B000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFE585858960000
      000E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDCD
      CDE5191919510000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDCD
      CDE5191919510000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFE595959970000
      000E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB3B3B3D60D0D0D3B000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF3F3F3F9404040800000000600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFF959595C306060629000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFE1E1
      E1F02A2A2A680000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000767676AE0202
      021A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000F0F0F3EA1A1A1CBFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFA0A0A0CA0E0E0E3D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1A1A1CBFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFA0A0A0CA000000000707072C8C8C8CBD0101
      0115000000000000000000000000000000000000000000000000000000000000
      0000010101158C8C8CBD0707072C00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF5F5F5FA6363639F0A0A0A340A0A0A346363639FF5F5F5FAFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000008C8C8CBDFFFFFFFFAEAE
      AED3010101150000000000000000000000000000000000000000000000000101
      0115AEAEAED3FFFFFFFF8C8C8CBD00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF6363639F00000000000000000000000000000000646464A0FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000001010115AEAEAED3FFFF
      FFFFAEAEAED3010101150000000000000000000000000000000001010115AEAE
      AED3FFFFFFFFAEAEAED30101011500000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0A0A0A35000000000000000000000000000000000A0A0A35FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001010115AEAE
      AED3FFFFFFFFAEAEAED301010115000000000000000001010115AEAEAED3FFFF
      FFFFAEAEAED3010101150000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0A0A0A35000000000000000000000000000000000A0A0A35FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000101
      0115AEAEAED3FFFFFFFFAEAEAED30101011501010115AEAEAED3FFFFFFFFAEAE
      AED301010115000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF6363639F00000000000000000000000000000000646464A0FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      000001010115AEAEAED3FFFFFFFFAEAEAED3AEAEAED3FFFFFFFFAEAEAED30101
      011500000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF5F5F5FA6363639F0A0A0A350A0A0A356363639FF5F5F5FAFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000001010115AEAEAED3FFFFFFFFFFFFFFFFAEAEAED3010101150000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000001010115AEAEAED3FFFFFFFFFFFFFFFFAEAEAED3010101150000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      000001010115AEAEAED3FFFFFFFFAEAEAED3AEAEAED3FFFFFFFFAEAEAED30101
      011500000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000101
      0115AEAEAED3FFFFFFFFAEAEAED30101011501010115AEAEAED3FFFFFFFFAEAE
      AED301010115000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001010115AEAE
      AED3FFFFFFFFAEAEAED301010115000000000000000001010115AEAEAED3FFFF
      FFFFAEAEAED3010101150000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000001010115AEAEAED3FFFF
      FFFFAEAEAED3010101150000000000000000000000000000000001010115AEAE
      AED3FFFFFFFFAEAEAED30101011500000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF404040800000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF404040800000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFF40404080000000008C8C8CBDFFFFFFFFAEAE
      AED3010101150000000000000000000000000000000000000000000000000101
      0115AEAEAED3FFFFFFFF8C8C8CBD00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF40404080000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF40404080000000000000000000000000000000000000
      000000000000000000000000000000000000A1A1A1CBFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4040408000000000000000000707072C8C8C8CBD0101
      0115000000000000000000000000000000000000000000000000000000000000
      0000010101158C8C8CBD0707072C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000F0F0F3EA1A1A1CBFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF4040408000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
