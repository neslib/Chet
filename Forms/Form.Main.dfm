object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Chet - C header translator'
  ClientHeight = 674
  ClientWidth = 981
  Color = clBtnFace
  Constraints.MinHeight = 570
  Constraints.MinWidth = 870
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 144
  TextHeight = 21
  object StatusBar: TStatusBar
    Left = 0
    Top = 645
    Width = 981
    Height = 29
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Panels = <>
    ExplicitTop = 637
    ExplicitWidth = 971
  end
  object ButtonGroupCategories: TButtonGroup
    Left = 0
    Top = 0
    Width = 188
    Height = 645
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alLeft
    BorderStyle = bsNone
    ButtonHeight = 36
    ButtonWidth = 36
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
    ExplicitHeight = 637
  end
  object CardPanel: TCardPanel
    Left = 188
    Top = 0
    Width = 793
    Height = 645
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    ActiveCard = PostProcess
    BevelOuter = bvNone
    Padding.Left = 6
    Padding.Top = 6
    TabOrder = 2
    ExplicitWidth = 783
    ExplicitHeight = 637
    object CardProject: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Project'
      CardIndex = 0
      TabOrder = 0
      DesignSize = (
        787
        639)
      object LabelHeaderFileDirectory: TLabel
        Left = 3
        Top = 0
        Width = 219
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Directory with C Header files:'
      end
      object LabelPasFile: TLabel
        Left = 3
        Top = 164
        Width = 134
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Target Pascal file:'
      end
      object LabelUses: TLabel
        Left = 3
        Top = 230
        Width = 294
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Comma-separated list of units to "use":'
      end
      object LabelIgnoredHeaders: TLabel
        Left = 3
        Top = 101
        Width = 463
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Comma-separated list of files to "ignore" in headers Directory:'
      end
      object EditHeaderFileDirectory: TEdit
        Left = 3
        Top = 23
        Width = 694
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = EditHeaderFileDirectoryChange
      end
      object ButtonBrowseHeaderFileDirectory: TButton
        Left = 700
        Top = 21
        Width = 50
        Height = 35
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonBrowseHeaderFileDirectoryClick
      end
      object CheckBoxIncludeSubdiretories: TCheckBox
        Left = 3
        Top = 68
        Width = 251
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Include subdirectories'
        TabOrder = 2
        OnClick = CheckBoxIncludeSubdiretoriesClick
      end
      object EditPasFile: TEdit
        Left = 3
        Top = 186
        Width = 694
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        OnChange = EditPasFileChange
      end
      object ButtonBrowsePasFile: TButton
        Left = 700
        Top = 185
        Width = 50
        Height = 34
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 5
        OnClick = ButtonBrowsePasFileClick
      end
      object EditUseUnits: TEdit
        Left = 3
        Top = 252
        Width = 745
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        OnChange = EditUseUnitsChange
      end
      object EditIgnoredHeaders: TEdit
        Left = 3
        Top = 123
        Width = 745
        Height = 29
        Hint = 
          'eq. ".\subdir1\header1.h,subdir2\header2.h" or "header1.h,.\head' +
          'er2.h"'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = EditIgnoredHeadersChange
      end
    end
    object CardPlatforms: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Platforms'
      CardIndex = 1
      TabOrder = 4
      object LabelPlatform: TLabel
        Left = 9
        Top = 102
        Width = 68
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Platform:'
      end
      object LabelLibrary: TLabel
        Left = 177
        Top = 102
        Width = 102
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Library name:'
      end
      object LabelPrefix: TLabel
        Left = 570
        Top = 102
        Width = 95
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Prefix (_PU):'
      end
      object LabelLibConstant: TLabel
        Left = 9
        Top = 11
        Width = 125
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Library constant:'
      end
      object LabelDebugDefine: TLabel
        Left = 9
        Top = 51
        Width = 104
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Debug define:'
      end
      object LabelDebugLibraryName: TLabel
        Left = 377
        Top = 99
        Width = 154
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Debug lib (optional):'
      end
      object EditLibWin32: TEdit
        Left = 177
        Top = 125
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 3
        OnChange = EditLibraryNameChange
      end
      object CheckBoxWin32: TCheckBox
        Left = 9
        Top = 128
        Width = 165
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '32-bit Windows'
        TabOrder = 2
        OnClick = CheckBoxPlatformClick
      end
      object EditLibWin64: TEdit
        Tag = 1
        Left = 177
        Top = 165
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 7
        OnChange = EditLibraryNameChange
      end
      object CheckBoxWin64: TCheckBox
        Tag = 1
        Left = 9
        Top = 168
        Width = 165
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '64-bit Windows'
        TabOrder = 6
        OnClick = CheckBoxPlatformClick
      end
      object CheckBoxMacARM: TCheckBox
        Tag = 2
        Left = 9
        Top = 209
        Width = 165
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'ARM macOS'
        TabOrder = 10
        OnClick = CheckBoxPlatformClick
      end
      object EditLibMacARM: TEdit
        Tag = 2
        Left = 177
        Top = 206
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 11
        OnChange = EditLibraryNameChange
      end
      object CheckBoxLinux64: TCheckBox
        Tag = 4
        Left = 9
        Top = 290
        Width = 165
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '64-bit Linux'
        TabOrder = 18
        OnClick = CheckBoxPlatformClick
      end
      object EditLibLinux64: TEdit
        Tag = 4
        Left = 177
        Top = 287
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 19
        OnChange = EditLibraryNameChange
      end
      object CheckBoxIOS: TCheckBox
        Tag = 5
        Left = 9
        Top = 330
        Width = 165
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'iOS'
        TabOrder = 22
        OnClick = CheckBoxPlatformClick
      end
      object EditLibIOS: TEdit
        Tag = 5
        Left = 177
        Top = 327
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 23
        OnChange = EditLibraryNameChange
      end
      object CheckBoxAndroid32: TCheckBox
        Tag = 6
        Left = 9
        Top = 371
        Width = 165
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '32-bit Android'
        TabOrder = 26
        OnClick = CheckBoxPlatformClick
      end
      object EditLibAndroid32: TEdit
        Tag = 6
        Left = 177
        Top = 368
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 27
        OnChange = EditLibraryNameChange
      end
      object EditPrefixWin32: TEdit
        Left = 570
        Top = 125
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 5
        OnChange = EditPrefixChange
      end
      object EditPrefixWin64: TEdit
        Tag = 1
        Left = 570
        Top = 165
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 9
        OnChange = EditPrefixChange
      end
      object EditPrefixMacARM: TEdit
        Tag = 2
        Left = 570
        Top = 206
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 13
        OnChange = EditPrefixChange
      end
      object EditPrefixLinux64: TEdit
        Tag = 4
        Left = 570
        Top = 287
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 21
        OnChange = EditPrefixChange
      end
      object EditPrefixIOS: TEdit
        Tag = 5
        Left = 570
        Top = 327
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 25
        OnChange = EditPrefixChange
      end
      object EditPrefixAndroid32: TEdit
        Tag = 6
        Left = 570
        Top = 368
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 29
        OnChange = EditPrefixChange
      end
      object EditLibConstant: TEdit
        Left = 177
        Top = 6
        Width = 263
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 0
        OnChange = EditLibConstantChange
      end
      object CheckBoxMacIntel: TCheckBox
        Tag = 3
        Left = 9
        Top = 249
        Width = 165
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Intel macOS'
        TabOrder = 14
        OnClick = CheckBoxPlatformClick
      end
      object EditLibMacIntel: TEdit
        Tag = 3
        Left = 177
        Top = 246
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 15
        OnChange = EditLibraryNameChange
      end
      object EditPrefixMacIntel: TEdit
        Tag = 3
        Left = 570
        Top = 246
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 17
        OnChange = EditPrefixChange
      end
      object CheckBoxAndroid64: TCheckBox
        Tag = 7
        Left = 9
        Top = 411
        Width = 165
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '64-bit Android'
        TabOrder = 30
        OnClick = CheckBoxPlatformClick
      end
      object EditLibAndroid64: TEdit
        Tag = 7
        Left = 177
        Top = 408
        Width = 188
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 31
        OnChange = EditLibraryNameChange
      end
      object EditPrefixAndroid64: TEdit
        Tag = 7
        Left = 570
        Top = 408
        Width = 45
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 33
        OnChange = EditPrefixChange
      end
      object EditDebugDefine: TEdit
        Left = 177
        Top = 47
        Width = 263
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 1
        OnChange = EditDebugDefineChange
      end
      object EditLibDbgAndroid64: TEdit
        Tag = 7
        Left = 374
        Top = 408
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 32
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgAndroid32: TEdit
        Tag = 6
        Left = 374
        Top = 368
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 28
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgIOS: TEdit
        Tag = 5
        Left = 374
        Top = 327
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 24
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgLinux64: TEdit
        Tag = 4
        Left = 374
        Top = 287
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 20
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgMacIntel: TEdit
        Tag = 3
        Left = 374
        Top = 246
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 16
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgMacARM: TEdit
        Tag = 2
        Left = 374
        Top = 206
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 12
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgWin64: TEdit
        Tag = 1
        Left = 374
        Top = 165
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 8
        OnChange = EditDebugLibraryNameChange
      end
      object EditLibDbgWin32: TEdit
        Left = 374
        Top = 125
        Width = 187
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 4
        OnChange = EditDebugLibraryNameChange
      end
    end
    object CardParseOptions: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Parse Options'
      CardIndex = 2
      TabOrder = 1
      object LabelCmdLineArgs: TLabel
        Left = 3
        Top = 35
        Width = 320
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Command line arguments to pass to Clang:'
      end
      object CheckBoxIgnoreParseErrors: TCheckBox
        Left = 3
        Top = 0
        Width = 224
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Ignore parse errors'
        TabOrder = 0
        OnClick = CheckBoxIgnoreParseErrorsClick
      end
      object ListBoxCmdLineArgs: TListBox
        Left = 3
        Top = 57
        Width = 605
        Height = 171
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        ItemHeight = 21
        TabOrder = 1
        OnClick = ListBoxCmdLineArgsClick
      end
      object ButtonAddCmdLineArg: TButton
        Left = 3
        Top = 237
        Width = 150
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Action = ActionAddCmdLineArg
        TabOrder = 2
      end
      object ButtonDeleteArgument: TButton
        Left = 456
        Top = 237
        Width = 150
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Action = ActionDeleteCmdLineArg
        TabOrder = 5
      end
      object ButtonAddDefine: TButton
        Left = 155
        Top = 237
        Width = 150
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Action = ActionAddDefine
        TabOrder = 3
      end
      object ButtonAddIncludePath: TButton
        Left = 306
        Top = 237
        Width = 150
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Action = ActionAddIncludePath
        TabOrder = 4
      end
    end
    object CardConversionOptions: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Conversion Options'
      CardIndex = 3
      TabOrder = 3
      DesignSize = (
        787
        639)
      object LabelConvertChar: TLabel
        Left = 9
        Top = 92
        Width = 134
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Convert "char" to:'
      end
      object LabelConvertComments: TLabel
        Left = 9
        Top = 51
        Width = 144
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Comment handling:'
      end
      object LabelCallConv: TLabel
        Left = 9
        Top = 11
        Width = 140
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Calling convention:'
      end
      object LabelReservedWordHandling: TLabel
        Left = 9
        Top = 173
        Width = 184
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Reserved word handling:'
      end
      object LabelUnconvertibleHandling: TLabel
        Left = 9
        Top = 289
        Width = 202
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Unconvertible declarations:'
      end
      object LabelEnumHandling: TLabel
        Left = 9
        Top = 248
        Width = 115
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Enum handling:'
      end
      object LabelConvertUnsignedChar: TLabel
        Left = 11
        Top = 132
        Width = 205
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Convert "unsigned char" to:'
      end
      object LabelCustomTypes: TLabel
        Left = 11
        Top = 394
        Width = 144
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Custom types map:'
        FocusControl = MemoCustomTypesMap
      end
      object ComboBoxConvertChar: TComboBox
        Left = 222
        Top = 87
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 222
        Top = 47
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 222
        Top = 6
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 222
        Top = 169
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'Add leading '#39'&'#39
        OnChange = ComboBoxReservedWordHandlingChange
        Items.Strings = (
          'Add leading '#39'&'#39
          'Add leading '#39'_'#39
          'Add trailing '#39'_'#39)
      end
      object CheckBoxDirectivesAsReservedWords: TCheckBox
        Left = 9
        Top = 209
        Width = 287
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Treat directives as reserved words'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = CheckBoxDirectivesAsReservedWordsClick
      end
      object ComboBoxUnconvertibleHandling: TComboBox
        Left = 222
        Top = 284
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 7
        Text = 'Write TODO item'
        OnChange = ComboBoxUnconvertibleHandlingChange
        Items.Strings = (
          'Write TODO item'
          'Comment out original declaration'
          'Ignore declaration')
      end
      object ComboBoxEnumHandling: TComboBox
        Left = 222
        Top = 244
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 6
        Text = 'Convert to enumerated type'
        OnChange = ComboBoxEnumHandlingChange
        Items.Strings = (
          'Convert to enumerated type'
          'Convert to integer type and constants')
      end
      object ComboBoxConvertUnsignedChar: TComboBox
        Left = 222
        Top = 128
        Width = 420
        Height = 29
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Style = csDropDownList
        ItemIndex = 2
        TabOrder = 3
        Text = 'Byte'
        OnChange = ComboBoxConvertUnsignedCharChange
        Items.Strings = (
          'UTF8Char'
          'Shortint'
          'Byte'
          'AnsiString')
      end
      object CheckBoxDelayedLoading: TCheckBox
        Left = 9
        Top = 325
        Width = 497
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Add "delayed" directive to imported routines (Windows only)'
        TabOrder = 8
        OnClick = CheckBoxDelayedLoadingClick
      end
      object CheckBoxPrefixSymbolsWithUnderscore: TCheckBox
        Left = 11
        Top = 359
        Width = 496
        Height = 26
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Prefix all symbols with an underscore (experimental)'
        TabOrder = 9
        Visible = False
        OnClick = CheckBoxPrefixSymbolsWithUnderscoreClick
      end
      object MemoCustomTypesMap: TMemo
        Left = 3
        Top = 422
        Width = 756
        Height = 201
        Hint = 
          'Input format: CTypeName=DelphiTypeName. Use CTRL + ENTER to inse' +
          'rt new line.'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 10
        WantReturns = False
        WordWrap = False
      end
    end
    object CardIgnore: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Ignore'
      CardIndex = 4
      TabOrder = 5
      object LabelIgnore: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 6
        Width = 773
        Height = 42
        Margins.Left = 9
        Margins.Top = 6
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 
          'Symbols (constants, types, functions) to ignore. These will not ' +
          'be translated. Enter one symbol per line. Symbols are case-sensi' +
          'tive.'
        WordWrap = True
        ExplicitWidth = 771
      end
      object MemoIgnore: TMemo
        AlignWithMargins = True
        Left = 6
        Top = 53
        Width = 775
        Height = 580
        Margins.Left = 6
        Margins.Top = 0
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        OnExit = MemoIgnoreExit
      end
    end
    object PostProcess: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'PostProcess'
      CardIndex = 5
      TabOrder = 6
      ExplicitWidth = 777
      ExplicitHeight = 631
      DesignSize = (
        787
        639)
      object ScriptMemo: TMemo
        Left = 7
        Top = 73
        Width = 762
        Height = 553
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Consolas'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitWidth = 752
        ExplicitHeight = 545
      end
      object ButtonClearScript: TButton
        Left = 7
        Top = 8
        Width = 170
        Height = 49
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Caption = 'Clear Script'
        TabOrder = 1
        OnClick = ButtonClearScriptClick
      end
      object ButtonScriptHelp: TButton
        Left = 191
        Top = 8
        Width = 169
        Height = 49
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Caption = 'Script Help'
        TabOrder = 2
        OnClick = ButtonScriptHelpClick
      end
      object ButtonTranslate: TButton
        Left = 373
        Top = 8
        Width = 170
        Height = 49
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Translate'
        TabOrder = 3
        OnClick = ButtonTranslateClick
      end
    end
    object CardTranslate: TCard
      Left = 6
      Top = 6
      Width = 787
      Height = 639
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Translate'
      CardIndex = 6
      TabOrder = 2
      object ButtonRunTranslator: TButton
        Left = 3
        Top = 0
        Width = 227
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Action = ActionRunTranslator
        TabOrder = 0
      end
      object MemoMessages: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 42
        Width = 784
        Height = 597
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
    Left = 276
    Top = 460
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
    Left = 48
    Top = 188
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
    Left = 32
    Top = 336
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
    Left = 36
    Top = 524
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
    Top = 412
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
    Left = 44
    Top = 440
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    Left = 176
    Top = 532
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
