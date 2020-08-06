unit Chet.Project;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  System.TypInfo;

{$SCOPEDENUMS ON}

type
  { The calling convention to use for translated functions. }
  TCallConv = (
    { Use "cdecl" calling convention }
    Cdecl,

    { Use "stdcall" calling convention }
    StdCall);

  { How to convert the C "char" type }
  TCharConvert = (
    { Convert to UTF8Char }
    UTF8Char,

    { Convert to signed 8-bit integer }
    Shortint,

    { Convert to unsigned 8-bit integer }
    Byte);

  { How to treat documentation comments }
  TCommentConvert = (
    { Keep comments as-is (that is, in Doxygen format) }
    KeepAsIs,

    { Remove all documentation comments }
    Remove,

    { Convert to XmlDoc format (experimental) }
    XmlDoc,

    { Convert to PasDoc format (experimental) }
    PasDoc);
  TReservedWordHandling = (PrefixAmpersand, PrefixUnderscore, PostfixUnderscore);

  { How to treat unconvertible declarations }
  TUnconvertibleHandling = (
    { Write a TODO comment and comment-out the declaration }
    WriteToDo,

    { Comment-out the declaration }
    CommentOut,

    { Ignore (remove) the declaration }
    Ignore);

  { How to treat enums }
  TEnumHandling = (
    { Convert to Delphi-style enumerated types }
    ConvertToEnum,

    { Convert to integer type, with each value converted to a constant }
    ConvertToConst);

  { Platforms available for configuration }
  TPlatformType = (
    { 32-bit Windows }
    Win32,

    { 64-bit Windows }
    Win64,

    { 32-bit macOS }
    Mac32,

    { 64-bit macOS }
    Mac64,

    { 64-bit Linux }
    Linux64,

    { iOS (32- and/or 64-bit) }
    iOS,

    { 32-bit Android }
    Android32,

    { 64-bit Android }
    Android64);

type
  TProject = class;

  { Represents a platform inside a TProject }
  TPlatform = class
  {$REGION 'Internal Declarations'}
  private
    [unsafe] FProject: TProject;
    FPlatformType: TPlatformType;
    FEnabled: Boolean;
    FLibraryName: String;
    FPrefix: String;
    procedure SetEnabled(const AValue: Boolean);
    procedure SetLibraryName(const AValue: String);
    procedure SetPrefix(const AValue: String);
  public
    constructor Create(const AProject: TProject;
      const AType: TPlatformType);
  {$ENDREGION 'Internal Declarations'}
  public
    { Resets all platform settings to their default values. }
    procedure Reset;

    { Loads the platform settings from a project file.

      Parameters:
        AIniFile: settings file. }
    procedure Load(const AIniFile: TMemIniFile);

    { Saves the platform settings to a project file.

      Parameters:
        AIniFile: settings file. }
    procedure Save(const AIniFile: TMemIniFile);

    { Whether the platform is enabled (that is, whether its library name will
      be included in the generated Pascal file) }
    property Enabled: Boolean read FEnabled write SetEnabled;

    { The name of the (dynamic or static) library for this platform. }
    property LibraryName: String read FLibraryName write SetLibraryName;

    { The function name prefix to use for this platform. Usually an empty
      string, but on some platforms, each function will have a '_' prefix. }
    property Prefix: String read FPrefix write SetPrefix;
  end;

  { A header translation project }
  TProject = class
  {$REGION 'Internal Declarations'}
  private
    FProjectFilename: String;
    FModified: Boolean;

    FHeaderFileDirectory: String;
    FIncludeSubdirectories: Boolean;
    FTargetPasFile: String;
    FUseUnits: String;

    FLibraryConstant: String;
    FPlatforms: array [TPlatformType] of TPlatform;

    FIgnoreParseErrors: Boolean;
    FCmdLineArgs: TStringList;

    FCallConv: TCallConv;
    FCharConvert: TCharConvert;
    FCommentConvert: TCommentConvert;
    FReservedWordHandling: TReservedWordHandling;
    FTreatDirectivesAsReservedWords: Boolean;
    FEnumHandling: TEnumHandling;
    FUnconvertibleHandling: TUnconvertibleHandling;

    FSymbolsToIgnore: TStrings;

    procedure SetHeaderFileDirectory(const Value: String);
    procedure SetIncludeSubdirectories(const Value: Boolean);
    procedure SetIgnoreParseErrors(const Value: Boolean);
    function GetDelimitedCmdLineArgs: String;
    function GetCmdLineArgs: TArray<String>;
    procedure SetTargetPasFile(const Value: String);
    procedure SetCharConvert(const Value: TCharConvert);
    procedure SetCommentConvert(const Value: TCommentConvert);
    procedure SetCallConv(const Value: TCallConv);
    procedure SetReservedWordHandling(const Value: TReservedWordHandling);
    procedure SetTreatDirectivesAsReservedWords(const Value: Boolean);
    procedure SetUnconvertibleHandling(const Value: TUnconvertibleHandling);
    function GetPlatform(const AIndex: TPlatformType): TPlatform;
    procedure SetLibraryConstant(const Value: String);
    procedure SetEnumHandling(const Value: TEnumHandling);
    procedure SetUseUnits(const Value: String);
    procedure SetSymbolsToIgnore(const Value: TStrings);
  private
    procedure SymbolsToIgnoreChange(Sender: TObject);
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create;
    destructor Destroy; override;

    { Resets the project to default settings. }
    procedure Reset;

    { Creates a new project.

      Parameters:
        AProjectName: (initial) name of the project.

      Some project settings will be pre-filled based on the given project name
      (although these can always be modified later). }
    procedure New(const AProjectName: String);

    { Loads the project from a file.

      Parameters:
        AFilename: name of the file to load. }
    procedure Load(const AFilename: String);

    { Saves the project.

      Parameters:
        AFilename: name of the file to save to. }
    procedure Save(const AFilename: String);

    { Adds a command line argument to pass to the Clang compiler.

      Parameters:
        AArg: the command line argument to add.

      Common command line arguments that you may need to provide are:
      * -D<name>: add a conditional define with the given name.
      * -I<dir>: add <dir> to the include file search path. }
    procedure AddCmdLineArg(const AArg: String);

    { Deletes a command line argument.

      Parameters:
        AIndex: index of the command line argument to delete. }
    procedure DeleteCmdLineArg(const AIndex: Integer);

    { Name of the project file containing the configuration settings for this
      project. }
    property ProjectFilename: String read FProjectFilename;

    { Whether project has been modified (whether any of its properties have
      changed since the last load or save) }
    property Modified: Boolean read FModified;

    { Directory with header files.
      May be a directory relative to the current directory. }
    property HeaderFileDirectory: String read FHeaderFileDirectory write SetHeaderFileDirectory;

    { Whether to include subdirectories while scanning for header files in
      HeaderFileDirectory. }
    property IncludeSubdirectories: Boolean read FIncludeSubdirectories write SetIncludeSubdirectories;

    { Name of the Pascal file that will be generated.
      May contain a path relative to the current directory. }
    property TargetPasFile: String read FTargetPasFile write SetTargetPasFile;

    { A comma-separated list of units that will be added to the uses clause
      of the generated Pascal file. }
    property UseUnits: String read FUseUnits write SetUseUnits;

    { The name of the constant to use for the library name.
      For example, for a DLL called 'mylib.dll', the name of this constant could
      be 'LIB_MYLIB', so it will be generated like this:

      const
        LIB_MYLIB = 'mylib.dll' }
    property LibraryConstant: String read FLibraryConstant write SetLibraryConstant;

    { Information about each of the supported platforms }
    property Platforms[const AIndex: TPlatformType]: TPlatform read GetPlatform;

    { Whether to ignore parse errors and try to convert header files anyway. }
    property IgnoreParseErrors: Boolean read FIgnoreParseErrors write SetIgnoreParseErrors;

    { The calling convention to use for translated function. }
    property CallConv: TCallConv read FCallConv write SetCallConv;

    { Specifies how the C "char" type should be handled. }
    property CharConvert: TCharConvert read FCharConvert write SetCharConvert;

    { How to handle comments.
      Note that Clang only parses Doxygen style documentation comments in these
      formats:
      * /// comment
      * /** comment */
      * /*! comment */
      * ///< comment
      * /**< comment */
      * /*!< comment */
      In the first 3 cases, the comment is attached to the node AFTER the
      comment. In the last 3 cases, the comment applies to the node BEFORE the
      comment.

      Clang does currently not provide comments for #define's}
    property CommentConvert: TCommentConvert read FCommentConvert write SetCommentConvert;

    { How identifiers that equal Delphi reserved words should be handled. }
    property ReservedWordHandling: TReservedWordHandling read FReservedWordHandling write SetReservedWordHandling;

    { Whether to treat Delphi directives as reserved words as well. }
    property TreatDirectivesAsReservedWords: Boolean read FTreatDirectivesAsReservedWords write SetTreatDirectivesAsReservedWords;

    { How C enums should be handled. }
    property EnumHandling: TEnumHandling read FEnumHandling write SetEnumHandling;

    { How unconvertible declarations should be handled. }
    property UnconvertibleHandling: TUnconvertibleHandling read FUnconvertibleHandling write SetUnconvertibleHandling;

    { The current list of command line arguments to pass to Clang.
      This list is in TStrings.DelimitedText format }
    property DelimitedCmdLineArgs: String read GetDelimitedCmdLineArgs;

    { The current list of command line arguments to pass to Clang. }
    property CmdLineArgs: TArray<String> read GetCmdLineArgs;

    { List of symbols (constants, types, functions) to ignore. These will not
      be translated. Symbols are case-sensitive. }
    property SymbolsToIgnore: TStrings read FSymbolsToIgnore write SetSymbolsToIgnore;
  end;

implementation

const // Ini Sections
  IS_PROJECT = 'Project';
  IS_PLATFORM_PREFIX = 'Platform.';
  IS_PARSE_OPTIONS = 'ParseOptions';
  IS_CONVERT_OPTIONS = 'ConvertOptions';
  IS_IGNORE = 'Ignore';

const // Ini Identifiers
  ID_HEADER_FILE_DIRECTORY = 'HeaderFileDirectory';
  ID_INCLUDE_SUBDIRS = 'IncludeSubdirs';
  ID_USE_UNITS = 'UseUnits';
  ID_TARGET_PAS_FILE = 'TargetPasFile';
  ID_IGNORE_PARSE_ERRORS = 'IgnoreParseErrors';
  ID_CMD_LINE_ARGS = 'CmdLineArgs';
  ID_CALL_CONV = 'CallConv';
  ID_CHAR_CONVERT = 'CharConvert';
  ID_COMMENT_CONVERT = 'CommentConvert';
  ID_RESERVED_WORD_HANDLING = 'ReservedWordHandling';
  ID_TREAT_DIRECTIVES_AS_RESERVED_WORDS = 'TreatDirectivesAsReservedWords';
  ID_ENUM_HANDLING = 'EnumHandling';
  ID_UNCONVERTIBLE_HANDLING = 'UnconvertibleHandling';
  ID_ENABLED = 'Enabled';
  ID_LIBRARY_NAME = 'LibraryName';
  ID_PREFIX = 'Prefix';
  ID_LIBRARY_CONSTANT = 'LibraryConstant';
  ID_COUNT = 'Count';
  ID_ITEM = 'Item';

type
  TCustomIniFileHelper = class helper for TCustomIniFile
  public
    function ReadEnum<T>(const ASection, AIdent: String; const ADefault: T): T;
    procedure WriteEnum<T>(const ASection, AIdent: String; const AValue: T);
  end;

{ TCustomIniFileHelper }

function TCustomIniFileHelper.ReadEnum<T>(const ASection, AIdent: String;
  const ADefault: T): T;
var
  S: String;
  I: Integer;
begin
  Assert(GetTypeKind(T) = tkEnumeration);

  S := ReadString(ASection, AIdent, '');
  if (S = '') then
    Exit(ADefault);

  I := GetEnumValue(TypeInfo(T), S);
  if (I < 0) then
    Exit(ADefault);

  Move(I, Result, SizeOf(T));
end;

procedure TCustomIniFileHelper.WriteEnum<T>(const ASection, AIdent: String;
  const AValue: T);
var
  S: String;
  I: Integer;
begin
  Assert(GetTypeKind(T) = tkEnumeration);

  I := 0;
  Move(AValue, I, SizeOf(T));
  S := GetEnumName(TypeInfo(T), I);

  WriteString(ASection, AIdent, S);
end;

{ TProject }

procedure TProject.AddCmdLineArg(const AArg: String);
begin
  FCmdLineArgs.Add(AArg);
  FModified := True;
end;

constructor TProject.Create;
var
  P: TPlatformType;
begin
  inherited;
  FCmdLineArgs := TStringList.Create;
  FSymbolsToIgnore := TStringList.Create;
  TStringList(FSymbolsToIgnore).OnChange := SymbolsToIgnoreChange;

  for P := Low(TPlatformType) to High(TPlatformType) do
    FPlatforms[P] := TPlatform.Create(Self, P);

  Reset;
end;

procedure TProject.DeleteCmdLineArg(const AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FCmdLineArgs.Count) then
  begin
    FCmdLineArgs.Delete(AIndex);
    FModified := True;
  end;
end;

destructor TProject.Destroy;
var
  P: TPlatformType;
begin
  for P := Low(TPlatformType) to High(TPlatformType) do
    FPlatforms[P].Free;

  FSymbolsToIgnore.Free;
  FCmdLineArgs.Free;
  inherited;
end;

function TProject.GetCmdLineArgs: TArray<String>;
begin
  Result := FCmdLineArgs.ToStringArray;
end;

function TProject.GetDelimitedCmdLineArgs: String;
begin
  Result := FCmdLineArgs.DelimitedText;
end;

function TProject.GetPlatform(const AIndex: TPlatformType): TPlatform;
begin
  Result := FPlatforms[AIndex];
end;

procedure TProject.Load(const AFilename: String);
var
  IniFile: TMemIniFile;
  P: TPlatformType;
  I, Count: Integer;
begin
  IniFile := TMemIniFile.Create(AFilename);
  try
    Reset;

    FHeaderFileDirectory := IniFile.ReadString(IS_PROJECT, ID_HEADER_FILE_DIRECTORY, '');
    FIncludeSubdirectories := IniFile.ReadBool(IS_PROJECT, ID_INCLUDE_SUBDIRS, False);
    FTargetPasFile := IniFile.ReadString(IS_PROJECT, ID_TARGET_PAS_FILE, '');
    FUseUnits := IniFile.ReadString(IS_PROJECT, ID_USE_UNITS, '');
    FLibraryConstant := IniFile.ReadString(IS_PROJECT, ID_LIBRARY_CONSTANT, '');

    for P := Low(TPlatformType) to High(TPlatformType) do
      FPlatforms[P].Load(IniFile);

    FIgnoreParseErrors := IniFile.ReadBool(IS_PARSE_OPTIONS, ID_IGNORE_PARSE_ERRORS, False);
    FCmdLineArgs.DelimitedText := IniFile.ReadString(IS_PARSE_OPTIONS, ID_CMD_LINE_ARGS, '');

    FCallConv := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_CALL_CONV, TCallConv.Cdecl);
    FCharConvert := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_CHAR_CONVERT, TCharConvert.UTF8Char);
    FCommentConvert := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_COMMENT_CONVERT, TCommentConvert.KeepAsIs);
    FReservedWordHandling := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_RESERVED_WORD_HANDLING, TReservedWordHandling.PrefixAmpersand);
    FTreatDirectivesAsReservedWords := IniFile.ReadBool(IS_CONVERT_OPTIONS, ID_TREAT_DIRECTIVES_AS_RESERVED_WORDS, True);
    FEnumHandling := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_ENUM_HANDLING, TEnumHandling.ConvertToEnum);
    FUnconvertibleHandling := IniFile.ReadEnum(IS_CONVERT_OPTIONS, ID_UNCONVERTIBLE_HANDLING, TUnconvertibleHandling.WriteToDo);

    Count := IniFile.ReadInteger(IS_IGNORE, ID_COUNT, 0);
    for I := 0 to Count - 1 do
      FSymbolsToIgnore.Add(IniFile.ReadString(IS_IGNORE, ID_ITEM + I.ToString, ''));

    if (FHeaderFileDirectory = '') then
      FHeaderFileDirectory := '.\';

    FModified := False;
    FProjectFilename := AFilename;
  finally
    IniFile.Free;
  end;
end;

procedure TProject.New(const AProjectName: String);
begin
  Reset;
  FLibraryConstant := 'LIB_' + AProjectName.ToUpperInvariant;

  FPlatforms[TPlatformType.Win32].LibraryName := AProjectName + '_win32.dll';
  FPlatforms[TPlatformType.Win64].LibraryName := AProjectName + '_win64.dll';
  FPlatforms[TPlatformType.Mac32].LibraryName := 'lib' + AProjectName + '.dylib';
  FPlatforms[TPlatformType.Mac64].LibraryName := 'lib' + AProjectName + '_macos.a';
  FPlatforms[TPlatformType.Linux64].LibraryName := 'lib' + AProjectName + '.so';
  FPlatforms[TPlatformType.iOS].LibraryName := 'lib' + AProjectName + '_ios.a';
  FPlatforms[TPlatformType.Android32].LibraryName := 'lib' + AProjectName + '_android32.a';
  FPlatforms[TPlatformType.Android64].LibraryName := 'lib' + AProjectName + '_android64.a';
end;

procedure TProject.Reset;
var
  P: TPlatformType;
begin
  FProjectFilename := '';
  FHeaderFileDirectory := '';
  FIncludeSubdirectories := False;
  FTargetPasFile := '';
  FUseUnits := '';
  FLibraryConstant := '';

  for P := Low(TPlatformType) to High(TPlatformType) do
    FPlatforms[P].Reset;

  FIgnoreParseErrors := False;
  FCmdLineArgs.Clear;

  FCallConv := TCallConv.Cdecl;
  FCharConvert := TCharConvert.UTF8Char;
  FCommentConvert := TCommentConvert.KeepAsIs;
  FReservedWordHandling := TReservedWordHandling.PrefixAmpersand;
  FTreatDirectivesAsReservedWords := True;
  FEnumHandling := TEnumHandling.ConvertToEnum;
  FUnconvertibleHandling := TUnconvertibleHandling.WriteToDo;

  FSymbolsToIgnore.Clear;
end;

procedure TProject.Save(const AFilename: String);
var
  IniFile: TMemIniFile;
  P: TPlatformType;
  I: Integer;
begin
  IniFile := TMemIniFile.Create(AFilename);
  try
    IniFile.Clear;

    IniFile.WriteString(IS_PROJECT, ID_HEADER_FILE_DIRECTORY, FHeaderFileDirectory);
    IniFile.WriteBool(IS_PROJECT, ID_INCLUDE_SUBDIRS, FIncludeSubdirectories);
    IniFile.WriteString(IS_PROJECT, ID_TARGET_PAS_FILE, FTargetPasFile);
    IniFile.WriteString(IS_PROJECT, ID_USE_UNITS, FUseUnits);
    IniFile.WriteString(IS_PROJECT, ID_LIBRARY_CONSTANT, FLibraryConstant);

    for P := Low(TPlatformType) to High(TPlatformType) do
      FPlatforms[P].Save(IniFile);

    IniFile.WriteBool(IS_PARSE_OPTIONS, ID_IGNORE_PARSE_ERRORS, FIgnoreParseErrors);
    IniFile.WriteString(IS_PARSE_OPTIONS, ID_CMD_LINE_ARGS, FCmdLineArgs.DelimitedText);

    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_CALL_CONV, FCallConv);
    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_CHAR_CONVERT, FCharConvert);
    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_COMMENT_CONVERT, FCommentConvert);
    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_RESERVED_WORD_HANDLING, FReservedWordHandling);
    IniFile.WriteBool(IS_CONVERT_OPTIONS, ID_TREAT_DIRECTIVES_AS_RESERVED_WORDS, FTreatDirectivesAsReservedWords);
    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_ENUM_HANDLING, FEnumHandling);
    IniFile.WriteEnum(IS_CONVERT_OPTIONS, ID_UNCONVERTIBLE_HANDLING, FUnconvertibleHandling);

    IniFile.WriteInteger(IS_IGNORE, ID_COUNT, FSymbolsToIgnore.Count);
    for I := 0 to FSymbolsToIgnore.Count - 1 do
      IniFile.WriteString(IS_IGNORE, ID_ITEM + I.ToString, FSymbolsToIgnore[I]);

    IniFile.UpdateFile;
    FModified := False;
    FProjectFilename := AFilename;
  finally
    IniFile.Free;
  end;
end;

procedure TProject.SetCallConv(const Value: TCallConv);
begin
  if (Value <> FCallConv) then
  begin
    FCallConv := Value;
    FModified := True;
  end;
end;

procedure TProject.SetCharConvert(const Value: TCharConvert);
begin
  if (Value <> FCharConvert) then
  begin
    FCharConvert := Value;
    FModified := True;
  end;
end;

procedure TProject.SetCommentConvert(const Value: TCommentConvert);
begin
  if (Value <> FCommentConvert) then
  begin
    FCommentConvert := Value;
    FModified := True;
  end;
end;

procedure TProject.SetEnumHandling(const Value: TEnumHandling);
begin
  if (Value <> FEnumHandling) then
  begin
    FEnumHandling := Value;
    FModified := True;
  end;
end;

procedure TProject.SetHeaderFileDirectory(const Value: String);
var
  Dir: String;
begin
  Dir := Value;
  if (Dir = '') then
    Dir := '.\';

  if (Dir <> FHeaderFileDirectory) then
  begin
    FHeaderFileDirectory := Dir;
    FModified := True;
  end;
end;

procedure TProject.SetIgnoreParseErrors(const Value: Boolean);
begin
  if (Value <> FIgnoreParseErrors) then
  begin
    FIgnoreParseErrors := Value;
    FModified := True;
  end;
end;

procedure TProject.SetIncludeSubdirectories(const Value: Boolean);
begin
  if (Value <> FIncludeSubdirectories) then
  begin
    FIncludeSubdirectories := Value;
    FModified := True;
  end;
end;

procedure TProject.SetLibraryConstant(const Value: String);
begin
  if (Value <> FLibraryConstant) then
  begin
    FLibraryConstant := Value;
    FModified := True;
  end;
end;

procedure TProject.SetReservedWordHandling(const Value: TReservedWordHandling);
begin
  if (Value <> FReservedWordHandling) then
  begin
    FReservedWordHandling := Value;
    FModified := True;
  end;
end;

procedure TProject.SetSymbolsToIgnore(const Value: TStrings);
begin
  FSymbolsToIgnore.Assign(Value);
  FModified := True;
end;

procedure TProject.SetTargetPasFile(const Value: String);
begin
  if (Value <> FTargetPasFile) then
  begin
    FTargetPasFile := Value;
    FModified := True;
  end;
end;

procedure TProject.SetTreatDirectivesAsReservedWords(const Value: Boolean);
begin
  if (Value <> FTreatDirectivesAsReservedWords) then
  begin
    FTreatDirectivesAsReservedWords := Value;
    FModified := True;
  end;
end;

procedure TProject.SetUnconvertibleHandling(
  const Value: TUnconvertibleHandling);
begin
  if (Value <> FUnconvertibleHandling) then
  begin
    FUnconvertibleHandling := Value;
    FModified := True;
  end;
end;

procedure TProject.SetUseUnits(const Value: String);
begin
  if (Value <> FUseUnits) then
  begin
    FUseUnits := Value;
    FModified := True;
  end;
end;

procedure TProject.SymbolsToIgnoreChange(Sender: TObject);
begin
  FModified := True;
end;

{ TPlatform }

constructor TPlatform.Create(const AProject: TProject;
  const AType: TPlatformType);
begin
  Assert(Assigned(AProject));
  inherited Create;
  FProject := AProject;
  FPlatformType := AType;
end;

procedure TPlatform.Load(const AIniFile: TMemIniFile);
var
  Section: String;
begin
  Section := IS_PLATFORM_PREFIX + GetEnumName(TypeInfo(TPlatformType), Ord(FPlatformType));
  FEnabled := AIniFile.ReadBool(Section, ID_ENABLED, False);
  FLibraryName := AIniFile.ReadString(Section, ID_LIBRARY_NAME, '');
  FPrefix := AIniFile.ReadString(Section, ID_PREFIX, '');
end;

procedure TPlatform.Reset;
begin
  FEnabled := (FPlatformType = TPlatformType.Win32);
  FLibraryName := '';
  if (FPlatformType = TPlatformType.Mac32) then
    FPrefix := '_'
  else
    FPrefix := '';
end;

procedure TPlatform.Save(const AIniFile: TMemIniFile);
var
  Section: String;
begin
  Section := IS_PLATFORM_PREFIX + GetEnumName(TypeInfo(TPlatformType), Ord(FPlatformType));
  AIniFile.WriteBool(Section, ID_ENABLED, FEnabled);
  AIniFile.WriteString(Section, ID_LIBRARY_NAME, FLibraryName);
  AIniFile.WriteString(Section, ID_PREFIX, FPrefix);
end;

procedure TPlatform.SetEnabled(const AValue: Boolean);
begin
  if (AValue <> FEnabled) then
  begin
    FEnabled := AValue;
    FProject.FModified := True;
  end;
end;

procedure TPlatform.SetLibraryName(const AValue: String);
begin
  if (AValue <> FLibraryName) then
  begin
    FLibraryName := AValue;
    FProject.FModified := True;
  end;
end;

procedure TPlatform.SetPrefix(const AValue: String);
begin
  if (AValue <> FPrefix) then
  begin
    FPrefix := AValue;
    FProject.FModified := True;
  end;
end;

end.
