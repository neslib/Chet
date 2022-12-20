unit Chet.HeaderTranslator;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Defaults,
  System.Generics.Collections,
  Neslib.Clang,
  Neslib.Clang.Api,
  Chet.Project,
  Chet.SourceWriter,
  Chet.CommentWriter;

type
  { Type of errors raised during header translation. }
  EHeaderTranslatorError = class(Exception);

type
  { Event type for THeaderTranslator.OnMessage to inform the client of progress.

    Parameters:
      AMessage: a progress message. }
  TMessageEvent = procedure(const AMessage: String) of object;

type
  { Class that does the actual work of translating a group of C header files to
    a Pascal file. }
  THeaderTranslator = class
  {$REGION 'Internal Declarations'}
  private type
    TMacroInfo = record
    public
      Cursor: TCursor;
      Visited: Boolean;
    public
      constructor Create(const ACursor: TCursor);
    end;
  private type
    TVarDeclInfo = record
    public
      Cursor: TCursor;
      Visited: Boolean;
      ConstDecl: Boolean;
    public
      constructor Create(const ACursor: TCursor);
    end;
  private
    FProject: TProject; // Reference
    FSymbolPrefix: String;
    FCombinedHeaderFilename: String;
    FIndex: IIndex;
    FTranslationUnit: ITranslationUnit;
    FTypes: TList<TCursor>;
    FDeclaredTypes: TList<TCursor>;
    FVisitedTypes: TDictionary<TCursor, Integer>;
    FReservedWords: TDictionary<String, Integer>;
    FTypeMap: TDictionary<String, String>;
    FTokenMap: TDictionary<String, String>;
    FMacros: TDictionary<String, TMacroInfo>;
    FVarDecls: TDictionary<String, TVarDeclInfo>;
    FMaxIndirectionCount: TDictionary<String, Integer>;
    FInvalidConstants: TDictionary<String, Integer>;
    FSymbolsToIgnore: TDictionary<String, Integer>;
    FAnonymousTypes: TDictionary<String, Integer>;
    FWrittenTypeDefs: TDictionary<String, Integer>;
    FWriter: TSourceWriter;
    FCommentWriter: TCommentWriter;
    FBuiltinTypes: array [Low(TTypeKind)..TTypeKind.LongDouble] of String;
    FOnMessage: TMessageEvent;
    FImplementation: TStrings;
  private
    procedure SetupBuiltinTypes;
    procedure SetupReservedWords;
    procedure SetupTypeMap;
    procedure SetupTokenMap;
    procedure SetupSymbolsToIgnore;
    procedure CreateCommentWriter;
    function Spelling(const ACursor: TCursor): String; overload;
    function Spelling(const AType: TType): String; overload;
    function TokenSpelling(const AToken: TToken): String; overload;
    function MakePointerType(const ATypeName: String;
      const ACount: Integer = 1): String;
    function RemoveQualifiers(const ACTypeName: String): String;
    function ValidIdentifier(const AValue: String): String;
    function GetDelphiTypeName(AType: TType; const AInParamDecl: Boolean = False;
      const AOutIsAnonymous: PBoolean = nil; const AOutIsBuiltin: PBoolean = nil): String;
    function GenerateAnonymousTypeName(const AName: String): String;
    function GenerateProcTypeNameForArg(const AFuncCursor,
      AArgCursor: TCursor): String;
    function GetArrayTypeName(const AType: TType): String;
    procedure CreateCombinedHeaderFile;
    function ParseCombinedHeaderFile: Boolean;
    procedure AnalyzeTypes;
    procedure AnalyzeDeclaredTypes;
    procedure TrackIndirections(const AType: TType);
    procedure WriteIntro;
    procedure WriteUsesClause;
    procedure WritePlatforms;
    procedure WriteConstantsRhs(Tokens: TArray<String>; StartIndex, Count : Integer; HasFloatToken : Boolean);
    procedure WriteConstants;
    procedure WriteConstants2;
    procedure WriteEnumTypes;
    procedure WriteTypes;
    procedure WriteFunctions;
    procedure WriteImplementation;
    procedure WriteForwardTypeDeclarations;
    procedure WriteType(const ACursor: TCursor);
    procedure WriteStructType(const ACursor: TCursor; const AIsUnion: Boolean);
    procedure WriteEnumType(const ACursor: TCursor);
    procedure WriteEnumTypeEnum(const ACursor: TCursor);
    procedure WriteEnumTypeConst(const ACursor: TCursor);
    procedure WriteTypedefType(const ACursor: TCursor);
    procedure WriteProceduralType(const ACursor: TCursor; const AType: TType;
      const ANamePrefix: String = '');
    procedure WriteFunctionProto(const ACursor: TCursor; const AType: TType;
      const AFunctionName: String; const AInStruct: Boolean = False);
    procedure WriteDefinedConstant(const ACursor: TCursor);
    procedure WriteTypedConstant(const ACursor: TCursor);
    procedure WriteFunction(const ACursor: TCursor);
    procedure WriteToDo(const AText: String);
    procedure WriteCommentedOutOriginalSource(const ACursor: TCursor);
    procedure WriteIndirections(ATypeName: String;
      const ADelphiTypeName: String = '');
  private
    procedure DoMessage(const AMessage: String); overload;
    procedure DoMessage(const AMessage: String;
      const AArgs: array of const); overload;
  private
    function VisitTypes(const ACursor, AParent: TCursor): TChildVisitResult;
    function VisitDefinesFirstPass(const ACursor, AParent: TCursor): TChildVisitResult;
    function VisitDefinesSecondPass(const ACursor, AParent: TCursor): TChildVisitResult;
    function VisitTypedConstants(const ACursor, AParent: TCursor): TChildVisitResult;
    function VisitFunctions(const ACursor, AParent: TCursor): TChildVisitResult;
  private
    class function IsSystemCursor(const ACursor: TCursor): Boolean; static;
    class function IsMostlyLowerCase(const AStr: String): Boolean; static;
    class function IsProceduralType(const AType: TType;
      out APointee: TType): Boolean; static;
    class function GetIndirectionCount(var AType: TType): Integer; static;
    class function Is8or16ByteStruct(const AType: TType): Boolean; static;
    class function IsAnonymous(const AName: String): Boolean; static;
    class function ConvertEscapeSequences(const ASource: String): String; static;
  {$ENDREGION 'Internal Declarations'}
  public
    { Constructor.

      Parameters:
        AProject: the project containing the translation configuration. }
    constructor Create(const AProject: TProject);
    destructor Destroy; override;

    { Runs the header translator. }
    procedure Run;

    { Gets called to inform the client of progress. }
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
  end;

implementation

uses
  Winapi.Windows,
  System.Types,
  System.IOUtils,
  System.Masks;

{ THeaderTranslator }

procedure THeaderTranslator.AnalyzeDeclaredTypes;
var
  TypeNames: TDictionary<String, Integer>;
  Cursor: TCursor;
  I: Integer;
  S: String;
begin
  { Check the cursors in FDeclaredTypes. These contain structs that were
    declared but not defined. Check if they got defined later, that is, if they
    are in the FTypes list as well. Since the cursors will be different, we
    have to compare by name. }
  if (FDeclaredTypes.Count = 0) then
    Exit;

  TypeNames := TDictionary<String, Integer>.Create;
  try
    for Cursor in FTypes do
      TypeNames.AddOrSetValue(Spelling(Cursor), 0);

    for I := FDeclaredTypes.Count - 1 downto 0 do
    begin
      if TypeNames.ContainsKey(Spelling(FDeclaredTypes[I])) then
        { Type was later defined. Remove it. }
        FDeclaredTypes.Delete(I);
    end;

    { Finally, there may be duplicate declared types. Remove these. }
    TypeNames.Clear;
    for I := FDeclaredTypes.Count - 1 downto 0 do
    begin
      S := Spelling(FDeclaredTypes[I]);
      if TypeNames.ContainsKey(S) then
        FDeclaredTypes.Delete(I)
      else
        TypeNames.Add(S, 0);
    end;
  finally
    TypeNames.Free;
  end;
end;

procedure THeaderTranslator.AnalyzeTypes;
begin
  DoMessage('Analyzing data types...');

  { Walk the AST to discover all used types. When a type depends on other types
    (eg. fields in a struct), then add those dependent types to the list BEFORE
    the type, so we can avoid having forward type declarations. }
  FTranslationUnit.Cursor.VisitChildren(VisitTypes);

  AnalyzeDeclaredTypes;
end;

class function THeaderTranslator.ConvertEscapeSequences(
  const ASource: String): String;
var
  Index, ReplaceCount: Integer;
  C: Char;
  S: String;
  B, Val: Byte;
  HasReplacements: Boolean;
begin
  Result := ASource;
  HasReplacements := False;
  Index := 0;
  while True do
  begin
    Index := Result.IndexOf('\', Index);
    if (Index < 0) or (Index >= (Result.Length - 1)) then
      Break;

    ReplaceCount := 2;
    C := Result.Chars[Index + 1];
    case C of
      'a': S := '''#7''';
      'b': S := '''#8''';
      'f': S := '''#12''';
      'n': S := '''#10''';
      'r': S := '''#13''';
      't': S := '''#9''';
      'v': S := '''#11''';
      '''': S := '''''';
      'x':
        begin
          { Convert hex byte }
          if ((Index + 3) >= Result.Length) then
            Break;
          B := StrToIntDef('$' + Result.Chars[Index + 2] + Result.Chars[Index + 3], 32);
          S := '''#' + B.ToString + '''';
          ReplaceCount := 4;
        end;
      '0'..'7':
        begin
          { Convert to octal byte }
          Val := Ord(C) - Ord('0');
          if ((Index + 2) < Result.Length) then
          begin
            C := Result.Chars[Index + 2];
            if (C >= '0') and (C <= '7') then
            begin
              Inc(ReplaceCount);
              Val := (Val shl 3) or (Ord(C) - Ord('0'));

              if ((Index + 3) < Result.Length) then
              begin
                C := Result.Chars[Index + 3];
                if (C >= '0') and (C <= '7') then
                begin
                  Inc(ReplaceCount);
                  Val := (Val shl 3) or (Ord(C) - Ord('0'));
                end;
              end;
            end;
          end;
          S := '''#' + Val.ToString + '''';
        end
    else
      { Uncommon escape sequences we currently don't support:
        * "\e": non-standard escape character
        * "\Uhhhhhhhh": 32-bit Unicode codepoint
        * "\uhhhh": 16-bit Unicode codepoint }
      S := C;
    end;

    Result := Result.Remove(Index, ReplaceCount).Insert(Index, S);
    HasReplacements := True;
    Inc(Index, S.Length);
  end;

  if (HasReplacements) then
  begin
    if (Result.Length > 3) and (Result.StartsWith('''''')) and (Result.Chars[2] <> '''') then
      Result := Result.Remove(0, 2);

    if (Result.Length > 3) and (Result.EndsWith('''''')) and (Result.Chars[Result.Length - 3] <> '''') then
      SetLength(Result, Result.Length - 2);
  end;
end;

constructor THeaderTranslator.Create(const AProject: TProject);
begin
  Assert(Assigned(AProject));
  inherited Create;
  FProject := AProject;
  FImplementation := nil;
  {$IFDEF EXPERIMENTAL}
  if (AProject.PrefixSymbolsWithUnderscore) then
    FSymbolPrefix := '_';
  {$ENDIF}
  FCombinedHeaderFilename := TPath.Combine(TPath.GetTempPath, '_chet_.h');
  FIndex := TIndex.Create(False, False);
  FTypes := TList<TCursor>.Create;
  FDeclaredTypes := TList<TCursor>.Create;
  FVisitedTypes := TDictionary<TCursor, Integer>.Create(
    TEqualityComparer<TCursor>.Construct(
      function(const ALeft, ARight: TCursor): Boolean
      begin
        Result := (ALeft = ARight);
      end,

      function(const AValue: TCursor): Integer
      begin
        Result := AValue.Hash;
      end));

  FReservedWords := TDictionary<String, Integer>.Create(TIStringComparer.Ordinal);
  FTypeMap := TDictionary<String, String>.Create;
  FTokenMap := TDictionary<String, String>.Create;
  FMacros := TDictionary<String, TMacroInfo>.Create;
  FVarDecls := TDictionary<String, TVarDeclInfo>.Create;
  FMaxIndirectionCount := TDictionary<String, Integer>.Create;
  FSymbolsToIgnore := TDictionary<String, Integer>.Create;
  FAnonymousTypes := TDictionary<String, Integer>.Create;
  FWrittenTypeDefs := TDictionary<String, Integer>.Create;

  SetupBuiltinTypes;
  SetupReservedWords;
  SetupTypeMap;
  SetupTokenMap;
  SetupSymbolsToIgnore;
end;

procedure THeaderTranslator.CreateCombinedHeaderFile;
var
  Option: TSearchOption;
  Writer: TStreamWriter;
  HeaderFiles,IgnoredFiles: TStringDynArray;
  HeaderPath, HeaderFile: String;
  I: Integer;
begin
  if (FProject.IncludeSubdirectories) then
    Option := TSearchOption.soAllDirectories
  else
    Option := TSearchOption.soTopDirectoryOnly;

  HeaderPath := IncludeTrailingPathDelimiter(FProject.HeaderFileDirectory);
  IgnoredFiles := FProject.IgnoredFiles.Split([','],'"','"',TStringSplitOptions.ExcludeEmpty);

  if Length(IgnoredFiles) = 0 then
    HeaderFiles := TDirectory.GetFiles(HeaderPath, '*.h', Option)
    else
    HeaderFiles := TDirectory.GetFiles(HeaderPath, '*.h', Option,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    var
      mask: string;
    begin
      for mask in IgnoredFiles do
      begin
        if MatchesMask(SearchRec.Name, mask) then
          Exit(False);
      end;

      Result := True;
    end
  );

  if (Length(HeaderFiles) = 0) then
    raise EHeaderTranslatorError.CreateFmt('No C header files found in directory "%s".', [FProject.HeaderFileDirectory]);

  Writer := TStreamWriter.Create(FCombinedHeaderFilename);
  try
    for I := 0 to Length(HeaderFiles) - 1 do
    begin
      HeaderFile := HeaderFiles[I];
      if (HeaderFile.StartsWith(HeaderPath, True)) then
        HeaderFile := HeaderFile.Substring(HeaderPath.Length);
      Writer.WriteLine('#include "%s"', [HeaderFile]);
    end;
  finally
    Writer.Free;
  end;
end;

procedure THeaderTranslator.CreateCommentWriter;
begin
  case FProject.CommentConvert of
    TCommentConvert.KeepAsIs:
      FCommentWriter := TCopyCommentWriter.Create(FWriter);

    TCommentConvert.XmlDoc:
      FCommentWriter := TXmlDocCommentWriter.Create(FWriter);

    TCommentConvert.PasDoc:
      FCommentWriter := TPasDocCommentWriter.Create(FWriter);
  else
    FCommentWriter := TNullCommentWriter.Create(FWriter);
  end;
end;

destructor THeaderTranslator.Destroy;
begin
  FWrittenTypeDefs.Free;
  FAnonymousTypes.Free;
  FSymbolsToIgnore.Free;
  FMaxIndirectionCount.Free;
  FTokenMap.Free;
  FTypeMap.Free;
  FReservedWords.Free;
  FVisitedTypes.Free;
  FDeclaredTypes.Free;
  FTypes.Free;
  FMacros.Free;
  FVarDecls.Free;
  FImplementation.Free;
  inherited;
end;

procedure THeaderTranslator.DoMessage(const AMessage: String;
  const AArgs: array of const);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Format(AMessage, AArgs));
end;

procedure THeaderTranslator.DoMessage(const AMessage: String);
begin
  if Assigned(FOnMessage) then
    FOnMessage(AMessage);
end;

function THeaderTranslator.GenerateAnonymousTypeName(
  const AName: String): String;
var
  I: Integer;
  Id: String;
begin
  (* Consider the following struct declaration:

       typedef struct Foo {
         int Val1;
         struct {
           int Sub1;
           int Sub2;
         } Val2;
       };

     Here, Val2 uses an unnamed in-line struct type. Libclang converts this
     sub-structure to an anonymous type with the following spelling:

       struct Foo::(anonymous at [filename:line:col])

     When the type is referenced by the Val2 field, it uses a type with the
     following spelling:

       struct (anonymous struct at [filename:line:col])

     Where [filename:line:col] is equal to the first declaration.

     We handle this is follows:
     * Extract everything after the string ' at '. This returns the filename,
       line and column number, which together uniquely identify the type.
     * Use the FAnonymousTypes dictionary to keep track of these identifiers,
       giving each identifier a unique integer value.
     * Use that integer value to generate a Delphi type name.

     NOTE: This is not really safe, since it depends on the text that libclang
     generates for anonymous types. *)
  Id := AName;
  I := Id.IndexOf(' at ');
  if (I > 0) then
    Id := Id.Substring(I + 4);

  if (not FAnonymousTypes.TryGetValue(Id, I)) then
  begin
    I := FAnonymousTypes.Count + 1;
    FAnonymousTypes.Add(Id, I);
  end;

  Result := '_anonymous_type_' + I.ToString;
end;

function THeaderTranslator.GenerateProcTypeNameForArg(const AFuncCursor,
  AArgCursor: TCursor): String;
begin
  Result := Spelling(AFuncCursor) + '_' + Spelling(AArgCursor);
end;

function THeaderTranslator.GetArrayTypeName(const AType: TType): String;
begin
  Result := Format('array [0..%d] of %s', [AType.ArraySize - 1,
    GetDelphiTypeName(AType.ArrayElementType)]);
end;

function THeaderTranslator.GetDelphiTypeName(AType: TType;
  const AInParamDecl: Boolean; const AOutIsAnonymous,
  AOutIsBuiltin: PBoolean): String;
var
  OrigType: TType;
  Kind: TTypeKind;
  StarCount: Integer;
  Conv: String;
begin
  if Assigned(AOutIsAnonymous) then
    AOutIsAnonymous^ := False;
  if Assigned(AOutIsBuiltin) then
    AOutIsBuiltin^ := False;

  OrigType := AType;
  Kind := AType.Kind;
  if (Kind = TTypeKind.ConstantArray) then
  begin
    if (AInParamDecl) then
    begin
      { Cannot have inline array declarations in a parameter. Treat these as
        pointer type instead. }
      var IsBuiltin: Boolean;
      Result := GetDelphiTypeName(AType.ArrayElementType, False, nil, @IsBuiltin);
      if (IsBuiltin) then
        Result := 'P' + Result
      else
        Result := MakePointerType(Result);
      Exit;
    end
    else
      Exit(GetArrayTypeName(AType));
  end
  else if (Kind = TTypeKind.IncompleteArray) then
    { Incomplete arrays are defined like:
        int foo[];
      Convert these to a pointer type. }
    Exit('P' + GetDelphiTypeName(AType.ArrayElementType));

  StarCount := 0;
  while (Kind = TTypeKind.Pointer) do
  begin
    Inc(StarCount);
    AType := AType.PointeeType;
    Kind := AType.Kind;
  end;

  if (Kind = TTypeKind.Unexposed) then
    { We cannot handle unexposed typed. }
    Exit('Integer { TODO : Cannot convert original type "' + OrigType.Spelling + '" }');

  if (Kind <= TTypeKind.LongDouble) then
  begin
    Result := FBuiltinTypes[Kind];
    if (Result <> '') then
    begin
      if (StarCount > 0) then
        Result := String.Create('P', StarCount) + Result;
      if Assigned(AOutIsBuiltin) then
        AOutIsBuiltin^ := True;
      Exit;
    end;
  end;

  Result := RemoveQualifiers(Spelling(AType));
  if IsAnonymous(Result) then
  begin
    Result := GenerateAnonymousTypeName(Result);
    if Assigned(AOutIsAnonymous) then
      AOutIsAnonymous^ := True;
  end;

  var SymbolPrefix := FSymbolPrefix;
  if (FTypeMap.TryGetValue(Result, Conv)) then
  begin
    Result := Conv;
    SymbolPrefix := '';
    if Assigned(AOutIsBuiltin) then
      AOutIsBuiltin^ := True;
  end;

  if (StarCount = 0) then
    Result := ValidIdentifier(Result)
  else if (Kind = TTypeKind.Void) then
  begin
    if (StarCount = 1) then
      Result := 'Pointer'
    else
      Result := String.Create('P', StarCount - 1) + 'Pointer';
  end
  else
  begin
    var SavedSymbolPrefix := FSymbolPrefix;
    FSymbolPrefix := SymbolPrefix;
    Result := MakePointerType(Result, StarCount);
    FSymbolPrefix := SavedSymbolPrefix;
  end;
end;

class function THeaderTranslator.GetIndirectionCount(
  var AType: TType): Integer;
var
  T: TType;
begin
  Result := 0;
  T := AType;
  while (T.Kind = TTypeKind.Pointer) do
  begin
    Inc(Result);
    T := T.PointeeType;
  end;
  AType := T;
end;

class function THeaderTranslator.Is8or16ByteStruct(const AType: TType): Boolean;
begin
  if (AType.SizeOf <> 8) and (AType.SizeOf <> 16) then
    Exit(False);

  Result := (AType.CanonicalType.Kind = TTypeKind.Rec);
end;

class function THeaderTranslator.IsAnonymous(const AName: String): Boolean;
begin
  { Issue #16: libclang v15 changed the name "anonymous" to "unnamed" }
  Result := (AName.IndexOf('(anonymous ') >= 0) or (AName.IndexOf('(unnamed ') >= 0);
end;

class function THeaderTranslator.IsMostlyLowerCase(const AStr: String): Boolean;
var
  C: Char;
  UpCount, LoCount: Integer;
begin
  if (AStr = '') then
    Exit(False);

  C := AStr.Chars[0];
  if (C < 'a') or (C > 'z') then
    Exit(False);

  C := AStr.Chars[AStr.Length - 1];
  if (C = '''') or (C = '"') then
    Exit(False);

  UpCount := 0;
  LoCount := 0;
  for C in AStr do
  begin
    case C of
      'a'..'z': Inc(LoCount);
      'A'..'Z': Inc(UpCount);
    end;
  end;

  Result := (LoCount > UpCount);
end;

class function THeaderTranslator.IsProceduralType(const AType: TType;
  out APointee: TType): Boolean;
begin
  APointee := AType;
  if (AType.Kind = TTypeKind.Pointer) then
  begin
    APointee := AType.PointeeType;
    if (APointee.Kind = TTypeKind.Unexposed) then
      APointee := AType.CanonicalType.PointeeType;

    if (APointee.Kind in [TTypeKind.FunctionProto, TTypeKind.FunctionNoProto]) then
      Exit(True);
  end;

  Result := False;
end;

class function THeaderTranslator.IsSystemCursor(
  const ACursor: TCursor): Boolean;
var
  Loc: TSourceLocation;
begin
  Loc := ACursor.Location;
  Result := Loc.IsInSystemHeader;
end;

function THeaderTranslator.MakePointerType(const ATypeName: String;
  const ACount: Integer): String;
begin
  if (FSymbolPrefix = '') or (not ATypeName.StartsWith('_')) then
    Result := String.Create('P', ACount) + ATypeName
  else
    Result := FSymbolPrefix + String.Create('P', ACount) + ATypeName.Substring(1);
end;

function THeaderTranslator.ParseCombinedHeaderFile: Boolean;
var
  Args: TArray<String>;
  Options: TTranslationUnitFlags;
  DiagOpts: TDiagnosticDisplayOptions;
  Diag: IDiagnostic;
  I, J, ErrorCount: Integer;
begin
  DoMessage('Parsing header files...');
  Options := [
    TTranslationUnitFlag.DetailedPreprocessingRecord,
    TTranslationUnitFlag.SkipFunctionBodies];

  if (FProject.IgnoreParseErrors) then
    Include(Options, TTranslationUnitFlag.KeepGoing);

  Args := FProject.CmdLineArgs;

  if FProject.CommentConvert in [TCommentConvert.XmlDoc, TCommentConvert.PasDoc] then
  begin
    J := -1;
    for I := 0 to Length(Args) -1 do
    begin
      if SameText(Args[I],'-fparse-all-comments') then
      begin
        J := I;
        Break;
      end;
    end;
    if J < 0 then
      Args := Args + ['-fparse-all-comments'];
  end;

  Args := Args + ['-I' + FProject.HeaderFileDirectory];

  FTranslationUnit := FIndex.ParseTranslationUnit(FCombinedHeaderFilename,
    Args, [], Options);
  if (FTranslationUnit = nil) then
    raise EHeaderTranslatorError.Create('Cannot parse header files.');

  DiagOpts := GetDefaultDiagnosticDisplayOptions;
  ErrorCount := 0;
  for I := 0 to FTranslationUnit.DiagnosticCount - 1 do
  begin
    Diag := FTranslationUnit.Diagnostics[I];
    if (Diag.Severity >= TDiagnosticSeverity.Error) then
    begin
      DoMessage(Diag.Format(DiagOpts));
      Inc(ErrorCount);
    end;
  end;

  if (ErrorCount = 0) then
  begin
    DoMessage('Parsed header files without errors');
    Result := True;
  end
  else
  begin
    DoMessage('Parsed header files with %d error(s)', [ErrorCount]);
    Result := FProject.IgnoreParseErrors;
  end;
end;

function THeaderTranslator.RemoveQualifiers(const ACTypeName: String): String;
var
  HasPrefix: Boolean;
begin
  Result := ACTypeName;

  {$IFDEF EXPERIMENTAL}
  var StartsWithUnderscore := False;
  if (FProject.PrefixSymbolsWithUnderscore) then
  begin
    StartsWithUnderscore := Result.StartsWith('_');
    if (StartsWithUnderscore) then
      Result := Result.Substring(1);
  end;
  {$ENDIF}

  { Remove leading "struct", "const" or "volatile" }
  repeat
    HasPrefix := False;

    if (Result.StartsWith('struct ')) then
    begin
      Result := Result.Substring(7);
      HasPrefix := True;
    end;

    if (Result.StartsWith('union ')) then
    begin
      Result := Result.Substring(6);
      HasPrefix := True;
    end;

    if (Result.StartsWith('enum ')) then
    begin
      Result := Result.Substring(5);
      HasPrefix := True;
    end;

    if (Result.StartsWith('const ')) then
    begin
      Result := Result.Substring(6);
      HasPrefix := True;
    end;

    if (Result.StartsWith('volatile ')) then
    begin
      Result := Result.Substring(9);
      HasPrefix := True;
    end;
  until (not HasPrefix);

  {$IFDEF EXPERIMENTAL}
  if (StartsWithUnderscore) then
    Result := '_' + Result;
  {$ENDIF}
end;

procedure THeaderTranslator.Run;
var
  CurDir, ProjectPath: String;
begin
  ProjectPath := FProject.ProjectFilename;
  if (ProjectPath <> '') then
    ProjectPath := TPath.GetDirectoryName(TPath.GetFullPath(FProject.ProjectFilename));

  CurDir := TDirectory.GetCurrentDirectory;
  try
    if (ProjectPath <> '') then
      TDirectory.SetCurrentDirectory(ProjectPath);

    CreateCombinedHeaderFile;
    if (not ParseCombinedHeaderFile) then
      Exit;

    AnalyzeTypes;

    FCommentWriter := nil;
    FWriter := TSourceWriter.Create(FProject.TargetPasFile);
    try
      CreateCommentWriter;
      FWriter.WriteLn('unit %s;', [TPath.GetFileNameWithoutExtension(FProject.TargetPasFile)]);
      WriteIntro;
      FWriter.WriteLn('{$MINENUMSIZE 4}');

      if (FProject.DelayedLoading) then
        FWriter.WriteLn('{$WARN SYMBOL_PLATFORM OFF}');

      FWriter.WriteLn;
      FWriter.WriteLn('interface');
      FWriter.WriteLn;
      WriteUsesClause;
      WritePlatforms;
      WriteConstants;
      WriteTypes;
      WriteConstants2;
      WriteFunctions;
      FWriter.WriteLn('implementation');
      WriteImplementation;
      FWriter.WriteLn;
      FWriter.Write('end.');
    finally
      FCommentWriter.Free;
      FWriter.Free;
    end;
  finally
    TDirectory.SetCurrentDirectory(CurDir);
  end;

  DoMessage('Header conversion completed!');
end;

procedure THeaderTranslator.SetupBuiltinTypes;
begin
  FBuiltinTypes[TTypeKind.Bool] := 'Boolean';

  case FProject.UnsignedCharConvert of
    TUnsignedCharConvert.UTF8Char: FBuiltinTypes[TTypeKind.Char_U] := 'UTF8Char';
    TUnsignedCharConvert.Shortint: FBuiltinTypes[TTypeKind.Char_U] := 'Shortint';
    TUnsignedCharConvert.AnsiChar: FBuiltinTypes[TTypeKind.Char_U] := 'AnsiChar';
  else
    FBuiltinTypes[TTypeKind.Char_U] := 'Byte';
  end;

  case FProject.UnsignedCharConvert of
    TUnsignedCharConvert.UTF8Char: FBuiltinTypes[TTypeKind.UChar] := 'UTF8Char';
    TUnsignedCharConvert.Shortint: FBuiltinTypes[TTypeKind.UChar] := 'Shortint';
    TUnsignedCharConvert.AnsiChar: FBuiltinTypes[TTypeKind.UChar] := 'AnsiChar';
  else
    FBuiltinTypes[TTypeKind.UChar] := 'Byte';
  end;

  FBuiltinTypes[TTypeKind.Char16] := 'WideChar';
  FBuiltinTypes[TTypeKind.Char32] := 'UCS4Char';
  FBuiltinTypes[TTypeKind.UShort] := 'Word';
  FBuiltinTypes[TTypeKind.UInt] := 'Cardinal';
  FBuiltinTypes[TTypeKind.ULong] := 'Cardinal';
  FBuiltinTypes[TTypeKind.ULongLong] := 'UInt64';

  case FProject.CharConvert of
    TCharConvert.UTF8Char: FBuiltinTypes[TTypeKind.Char_S] := 'UTF8Char';
    TCharConvert.Shortint: FBuiltinTypes[TTypeKind.Char_S] := 'Shortint';
    TCharConvert.AnsiChar: FBuiltinTypes[TTypeKind.Char_S] := 'AnsiChar';
  else
    FBuiltinTypes[TTypeKind.Char_S] := 'Byte';
  end;

  case FProject.CharConvert of
    TCharConvert.UTF8Char: FBuiltinTypes[TTypeKind.SChar] := 'UTF8Char';
    TCharConvert.Shortint: FBuiltinTypes[TTypeKind.SChar] := 'Shortint';
    TCharConvert.AnsiChar: FBuiltinTypes[TTypeKind.SChar] := 'AnsiChar';
  else
    FBuiltinTypes[TTypeKind.SChar] := 'Byte';
  end;

  FBuiltinTypes[TTypeKind.WChar] := 'WideChar';
  FBuiltinTypes[TTypeKind.Short] := 'Smallint';
  FBuiltinTypes[TTypeKind.Int] := 'Integer';
  FBuiltinTypes[TTypeKind.Long] := 'Integer';
  FBuiltinTypes[TTypeKind.LongLong] := 'Int64';
  FBuiltinTypes[TTypeKind.Float] := 'Single';
  FBuiltinTypes[TTypeKind.Double] := 'Double';
  FBuiltinTypes[TTypeKind.LongDouble] := 'Extended';
end;

procedure THeaderTranslator.SetupReservedWords;
begin
  FReservedWords.Add('and', 0);
  FReservedWords.Add('end', 0);
  FReservedWords.Add('interface', 0);
  FReservedWords.Add('record', 0);
  FReservedWords.Add('var', 0);
  FReservedWords.Add('array', 0);
  FReservedWords.Add('except', 0);
  FReservedWords.Add('is', 0);
  FReservedWords.Add('repeat', 0);
  FReservedWords.Add('while', 0);
  FReservedWords.Add('as', 0);
  FReservedWords.Add('exports', 0);
  FReservedWords.Add('label', 0);
  FReservedWords.Add('resourcestring', 0);
  FReservedWords.Add('with', 0);
  FReservedWords.Add('asm', 0);
  FReservedWords.Add('file', 0);
  FReservedWords.Add('library', 0);
  FReservedWords.Add('set', 0);
  FReservedWords.Add('xor', 0);
  FReservedWords.Add('begin', 0);
  FReservedWords.Add('finalization', 0);
  FReservedWords.Add('mod', 0);
  FReservedWords.Add('shl', 0);
  FReservedWords.Add('case', 0);
  FReservedWords.Add('finally', 0);
  FReservedWords.Add('nil', 0);
  FReservedWords.Add('shr', 0);
  FReservedWords.Add('class', 0);
  FReservedWords.Add('for', 0);
  FReservedWords.Add('not', 0);
  FReservedWords.Add('string', 0);
  FReservedWords.Add('const', 0);
  FReservedWords.Add('function', 0);
  FReservedWords.Add('object', 0);
  FReservedWords.Add('then', 0);
  FReservedWords.Add('constructor', 0);
  FReservedWords.Add('goto', 0);
  FReservedWords.Add('of', 0);
  FReservedWords.Add('threadvar', 0);
  FReservedWords.Add('destructor', 0);
  FReservedWords.Add('if', 0);
  FReservedWords.Add('or', 0);
  FReservedWords.Add('to', 0);
  FReservedWords.Add('dispinterface', 0);
  FReservedWords.Add('implementation', 0);
  FReservedWords.Add('packed', 0);
  FReservedWords.Add('try', 0);
  FReservedWords.Add('div', 0);
  FReservedWords.Add('in', 0);
  FReservedWords.Add('procedure', 0);
  FReservedWords.Add('type', 0);
  FReservedWords.Add('do', 0);
  FReservedWords.Add('inherited', 0);
  FReservedWords.Add('program', 0);
  FReservedWords.Add('unit', 0);
  FReservedWords.Add('downto', 0);
  FReservedWords.Add('initialization', 0);
  FReservedWords.Add('property', 0);
  FReservedWords.Add('until', 0);
  FReservedWords.Add('else', 0);
  FReservedWords.Add('inline', 0);
  FReservedWords.Add('raise', 0);
  FReservedWords.Add('uses', 0);

  { Always treat built-int data types as reserved words. }
  FReservedWords.Add('byte', 0);
  FReservedWords.Add('shortint', 0);
  FReservedWords.Add('smallint', 0);
  FReservedWords.Add('word', 0);
  FReservedWords.Add('cardinal', 0);
  FReservedWords.Add('integer', 0);

  if (FProject.TreatDirectivesAsReservedWords) then
  begin
    FReservedWords.Add('absolute', 0);
    FReservedWords.Add('export', 0);
    FReservedWords.Add('public', 0);
    FReservedWords.Add('stdcall', 0);
    FReservedWords.Add('abstract', 0);
    FReservedWords.Add('external', 0);
    FReservedWords.Add('near', 0);
    FReservedWords.Add('published', 0);
    FReservedWords.Add('strict', 0);
    FReservedWords.Add('assembler', 0);
    FReservedWords.Add('far', 0);
    FReservedWords.Add('automated', 0);
    FReservedWords.Add('final', 0);
    FReservedWords.Add('operator', 0);
    FReservedWords.Add('unsafe', 0);
    FReservedWords.Add('cdecl', 0);
    FReservedWords.Add('forward', 0);
    FReservedWords.Add('out', 0);
    FReservedWords.Add('varargs', 0);
    FReservedWords.Add('overload', 0);
    FReservedWords.Add('register', 0);
    FReservedWords.Add('virtual', 0);
    FReservedWords.Add('override', 0);
    FReservedWords.Add('reintroduce', 0);
    FReservedWords.Add('deprecated', 0);
    FReservedWords.Add('pascal', 0);
    FReservedWords.Add('dispid', 0);
    FReservedWords.Add('platform', 0);
    FReservedWords.Add('safecall', 0);
    FReservedWords.Add('dynamic', 0);
    FReservedWords.Add('private', 0);
    FReservedWords.Add('sealed', 0);
    FReservedWords.Add('experimental', 0);
    FReservedWords.Add('message', 0);
    FReservedWords.Add('protected', 0);
    FReservedWords.Add('static', 0);

    { These are also directives, but the Delphi IDE doesn't highlight them as
      special keywords, so we don't regard them as "special":
        name, nodefault, read, stored, readonly, reference, contains, helper,
        default, implements, winapi, delayed, index, package, requires, write,
        resident, writeonly, local }
  end;
end;

procedure THeaderTranslator.SetupSymbolsToIgnore;
var
  I: Integer;
  S: String;
begin
  for I := 0 to FProject.SymbolsToIgnore.Count - 1 do
  begin
    S := FProject.SymbolsToIgnore[I].Trim;
    if (S <> '') then
      FSymbolsToIgnore.AddOrSetValue(S, 0);
  end;
end;

procedure THeaderTranslator.SetupTokenMap;
begin
  { C-to-Delphi translations for common tokens.
    These are only used when manually converting #define macros. }

  { Surround with spaces to avoid concatenation with other tokens. }
  FTokenMap.Add('<<', ' shl ');
  FTokenMap.Add('>>', ' shr ');
  FTokenMap.Add('&', ' and ');
  FTokenMap.Add('|', ' or ');
  FTokenMap.Add('^', ' xor ');
  FTokenMap.Add('~', ' not ');
  FTokenMap.Add('&&', ' and ');
  FTokenMap.Add('||', ' or ');
  FTokenMap.Add('!', ' not ');
  FTokenMap.Add('%', ' mod ');
  FTokenMap.Add('==', '=');
  FTokenMap.Add('!=', '<>');
end;

procedure THeaderTranslator.SetupTypeMap;
var
  customTypePair: TPair<string,string>;
  customTypes: TArray<string>;
  i,n: Integer;
begin
  FTypeMap.Add('size_t', 'NativeUInt');
  FTypeMap.Add('intptr_t', 'IntPtr');
  FTypeMap.Add('uintptr_t', 'UIntPtr');
  FTypeMap.Add('ptrdiff_t', 'NativeInt');
  FTypeMap.Add('wchar_t', 'WideChar');
  FTypeMap.Add('time_t', 'Longint');

  // From stdint.h
  FTypeMap.Add('int8_t', 'Int8');
  FTypeMap.Add('int16_t', 'Int16');
  FTypeMap.Add('int32_t', 'Int32');
  FTypeMap.Add('int64_t', 'Int64');
  FTypeMap.Add('uint8_t', 'UInt8');
  FTypeMap.Add('uint16_t', 'UInt16');
  FTypeMap.Add('uint32_t', 'UInt32');
  FTypeMap.Add('uint64_t', 'UInt64');

  FTypeMap.Add('int_least8_t', 'Int8');
  FTypeMap.Add('int_least16_t', 'Int16');
  FTypeMap.Add('int_least32_t', 'Int32');
  FTypeMap.Add('int_least64_t', 'Int64');
  FTypeMap.Add('uint_least8_t', 'UInt8');
  FTypeMap.Add('uint_least16_t', 'UInt16');
  FTypeMap.Add('uint_least32_t', 'UInt32');
  FTypeMap.Add('uint_least64_t', 'UInt64');

  FTypeMap.Add('int_fast8_t', 'Int8');
  FTypeMap.Add('int_fast16_t', 'Int32');
  FTypeMap.Add('int_fast32_t', 'Int32');
  FTypeMap.Add('int_fast64_t', 'Int64');
  FTypeMap.Add('uint_fast8_t', 'UInt8');
  FTypeMap.Add('uint_fast16_t', 'UInt32');
  FTypeMap.Add('uint_fast32_t', 'UInt32');
  FTypeMap.Add('uint_fast64_t', 'UInt64');

  FTypeMap.Add('intmax_t', 'Int64');
  FTypeMap.Add('uintmax_t', 'UInt64');

  // C functions can have a parameter of type "va_list", containing a variable
  // number of arguments. We cannot really use these functions in Delphi (but
  // we CAN use "varargs" functions). We set the "va_list" type to a pointer,
  // but should probably ignore functions that use it.
  FTypeMap.Add('va_list', 'Pointer');

  // Type FILE the cannot be used in Delphi, so we convert to a Pointer.
  FTypeMap.Add('FILE', 'Pointer');

  // attempt to add user-defined types, if any.
  customTypes := FProject.CustomCTypesMap.Split([','],'"','"',TStringSplitOptions.ExcludeEmpty);
  for i := 0  to High(customTypes) do
  begin
    customTypes[i] := customTypes[i].Replace(';','',[rfReplaceAll]).Trim.DeQuotedString('"');
    n := customTypes[i].IndexOf('=');
    if n < 0 then Continue;

    customTypePair.Key := customTypes[i].Substring(0,n).DeQuotedString('"').Trim;
    customTypePair.Value := customTypes[i].Substring(1+n).DeQuotedString('"').Trim;

    if customTypePair.Key.IsEmpty or
       customTypePair.Value.IsEmpty or
       FTypeMap.ContainsKey(customTypePair.Key) then
      Continue;

    FTypeMap.TryAdd(customTypePair.Key,customTypePair.Value);
  end;
end;

function THeaderTranslator.Spelling(const AType: TType): String;
begin
  Result := AType.Spelling;
  if (Result <> '') and (not FTypeMap.ContainsKey(Result)) then
    Result := FSymbolPrefix + Result;
end;

function THeaderTranslator.Spelling(const ACursor: TCursor): String;
begin
  Result := ACursor.Spelling;
  if (Result <> '') then
    Result := FSymbolPrefix + Result;
end;

function THeaderTranslator.TokenSpelling(const AToken: TToken): String;
begin
  Result := FTranslationUnit.GetTokenSpelling(AToken);
  if (AToken.Kind = TTokenKind.Identifier) and (Result <> '') then
    Result := FSymbolPrefix + Result;
end;

procedure THeaderTranslator.TrackIndirections(const AType: TType);
var
  T: TType;
  TypeName: String;
  IndirectionCount, MaxIndirectionCount: Integer;
begin
  T := AType;
  IndirectionCount := GetIndirectionCount(T);
  if (IndirectionCount >= 1) then
  begin
    { This is a pointer-to-a-pointer(to-a-pointer*) type. We need to create
      additional forward declarations for there, so keep track of them. }
    TypeName := RemoveQualifiers(Spelling(T));
    if (FMaxIndirectionCount.TryGetValue(TypeName, MaxIndirectionCount)) then
    begin
      if (IndirectionCount > MaxIndirectionCount) then
        FMaxIndirectionCount[TypeName] := IndirectionCount;
    end
    else
      FMaxIndirectionCount.Add(TypeName, IndirectionCount);
  end;
end;

function THeaderTranslator.ValidIdentifier(const AValue: String): String;
begin
  if (not FReservedWords.ContainsKey(AValue)) then
    Exit(AValue);

  case FProject.ReservedWordHandling of
    TReservedWordHandling.PrefixUnderscore: Result := '_' + AValue;
    TReservedWordHandling.PostfixUnderscore: Result := AValue + '_';
  else
    Result := '&' + AValue;
  end;
end;

function THeaderTranslator.VisitDefinesFirstPass(const ACursor,
  AParent: TCursor): TChildVisitResult;
begin
  if (ACursor.Kind = TCursorKind.MacroDefinition) then
    { Record all #defines first, so we can reorder later based on dependencies }
    FMacros.AddOrSetValue(Spelling(ACursor), TMacroInfo.Create(ACursor));

  { Do not recurse. Only handle top-level #defines }
  Result := TChildVisitResult.Continue;
end;

function THeaderTranslator.VisitDefinesSecondPass(const ACursor,
  AParent: TCursor): TChildVisitResult;
begin
  if (ACursor.Kind = TCursorKind.MacroDefinition) and (not IsSystemCursor(ACursor)) then
    WriteDefinedConstant(ACursor);

  { Do not recurse. Only handle top-level #defines }
  Result := TChildVisitResult.Continue;
end;

function THeaderTranslator.VisitTypedConstants(const ACursor,
  AParent: TCursor): TChildVisitResult;
begin
  if (ACursor.Kind = TCursorKind.VarDecl) and (not IsSystemCursor(ACursor)) then
    WriteTypedConstant(ACursor);

  { Do not recurse. Only handle top-level #defines }
  Result := TChildVisitResult.Continue;
end;

function THeaderTranslator.VisitFunctions(const ACursor,
  AParent: TCursor): TChildVisitResult;
begin
  if (not IsSystemCursor(ACursor))
    and (ACursor.Kind = TCursorKind.FunctionDecl)
    and (not ACursor.IsFunctionInlined) // Inlined functions are never exported
  then
    WriteFunction(ACursor);

  { Do not recurse. Only handle top-level functions }
  Result := TChildVisitResult.Continue;
end;

function THeaderTranslator.VisitTypes(const ACursor,
  AParent: TCursor): TChildVisitResult;
begin
  if (not IsSystemCursor(ACursor)) then
  begin
    { Visit children BEFORE adding this type to the list }
    ACursor.VisitChildren(VisitTypes);

    if (not FVisitedTypes.ContainsKey(ACursor)) then
    begin
      TrackIndirections(ACursor.CursorType);
      TrackIndirections(ACursor.ResultType);

      if ACursor.IsDefinition then
      begin
        if (ACursor.Kind in [TCursorKind.StructDecl, TCursorKind.UnionDecl,
          TCursorKind.EnumDecl, TCursorKind.TypedefDecl, TCursorKind.ParmDecl]) then
        begin
          FTypes.Add(ACursor);
          FVisitedTypes.Add(ACursor, 0);
        end;
      end
      else if ACursor.IsDeclaration and (ACursor.Kind = TCursorKind.StructDecl) then
      begin
        { This is a struct type that is declared but not defined, as in:
            struct Foo;
          The struct MAY be defined later, but not always. If it is not defined
          later, then it is only used in a pointer reference (*Foo) and we treat
          as an opaque type later. }
        FDeclaredTypes.Add(ACursor);
      end;
    end;
  end;

  Result := TChildVisitResult.Continue;
end;

procedure THeaderTranslator.WriteCommentedOutOriginalSource(
  const ACursor: TCursor);
var
  Range: TSourceRange;
  Tokens: ITokenList;
  I: Integer;
  S: String;
begin
  if (FProject.UnconvertibleHandling = TUnconvertibleHandling.Ignore) then
    Exit;

  Range := ACursor.Extent;
  if (Range.IsNull) then
    Exit;

  Tokens := FTranslationUnit.Tokenize(Range);
  if (Tokens = nil) or (Tokens.Count = 0) then
    Exit;

  FWriter.Write('(*');
  for I := 0 to Tokens.Count - 1 do
  begin
    S := TokenSpelling(Tokens[I]);
    FWriter.Write(' ');
    FWriter.Write(S);
  end;
  FWriter.WriteLn(' *)');
end;

{ Write right-hand side expression. This procedure is used by WriteDefinedConstant() and WriteDefinedConstant() }
procedure THeaderTranslator.WriteConstantsRhs(Tokens: TArray<String>; StartIndex, Count : Integer; HasFloatToken : Boolean);
const
  SUFFICES: array [0..10] of String = ('i8', 'i16', 'i32', 'i64', 'ui8', 'ui16',
    'ui32', 'ui64', 'u', 'l', 'f');
var
  S, Conv: String;
  C: Char;
  I, J, MaxSuffix: Integer;
  HasSuffix, IsString: Boolean;
  StringConcatPlusInserted : Boolean;
begin
  StringConcatPlusInserted := False;

  for I := StartIndex to Count - 1 do
  begin
    S := Tokens[I];
    IsString := False;

    { Issue #4 (https://github.com/neslib/Chet/issues/4)
      Convert wide character string constant (L"...").
      These are the supported prefixes:
      * L (wide char/string).
      * u (UTF-16 encoded char/string).
      * U (UTF-32 encoded char/string).
      These apply to both characters (single quote) and strings (double quote).
      The contents in the string literal is *not* converted/decoded. }
    if (S.Length >= 3) then
    begin
      C := S.Chars[S.Length - 1];
      if (C = '''') or (C = '"') then
      begin
        if (S.Chars[1] = C) then
        begin
          C := S.Chars[0];
          if (C = 'L') or (C = 'u') or (C = 'U') then
            S := S.Substring(1);
        end;
      end;
    end;

    { Convert commonly used tokens }
    if (FTokenMap.TryGetValue(S, Conv)) then
      S := Conv
    else if (S = '/') then
    begin
      { Could be "/" or "div". If we found a token with a period (.) then
        assume "/", otherwise "div". }
      if (not HasFloatToken) then
        S := ' div ';
    end
    else if (S.StartsWith('.')) then
      { Floating-point values in Delphi cannot start with a period }
      S := '0' + S
    else if (S.StartsWith('0x', True)) then
      { Convert hex value }
      S := '$' + S.Substring(2)
    else if (S.StartsWith('"') and S.EndsWith('"')) then
    begin
      { Convert to single quotes and convert escape sequences }
      S := ConvertEscapeSequences('''' + S.Substring(1, S.Length - 2) + '''');
      IsString := True;
    end
    else if (S.StartsWith('''') and S.EndsWith('''')) then
    begin
      { Convert escape sequences }
      S := ConvertEscapeSequences(S);
      IsString := True;
    end;

    { Check for type suffixes (as in 123LL) and remove those }
    C := S.Chars[0];
    if ((C >= '0') and (C <= '9')) or (C = '$') then
    begin
      if (C <> '$') and (S.IndexOf('.') > 0) then
        { 'f' is only a valid suffix for floating-point values }
        MaxSuffix := LENGTH(SUFFICES) - 1
      else
        MaxSuffix := LENGTH(SUFFICES) - 2;

      repeat
        HasSuffix := False;
        for J := 0 to MaxSuffix do
        begin
          if (S.EndsWith(SUFFICES[J], True)) then
          begin
            HasSuffix := True;
            SetLength(S, S.Length - SUFFICES[J].Length);
          end;
        end;
      until (not HasSuffix);
    end;


    if IsString then
    begin
      { In macros, strings can be concatenated like this:
          FOO "str" BAR
        We need to put '+' inbetween }
      if (I > StartIndex) and (Tokens[I - 1] <> '+')
          and (not StringConcatPlusInserted) // avoid inserting two '+' chars
      then
        FWriter.Write(' + ');

      FWriter.Write(S);
      StringConcatPlusInserted := False;

      if (I < (Count - 1)) and (Tokens[I + 1] <> '+') then
      begin
        FWriter.Write(' + ');
        StringConcatPlusInserted := True;
      end;
    end
    else
    begin
      FWriter.Write(S);
      StringConcatPlusInserted := False;
    end;
  end;
end;

{ #define aName <Expression> }
procedure THeaderTranslator.WriteDefinedConstant(const ACursor: TCursor);
var
  Range: TSourceRange;
  TokenList: ITokenList;
  Tokens: TArray<String>;
  S: String;
  I: Integer;
  Info: TMacroInfo;
  HasFloatToken: Boolean;
begin
  Range := ACursor.Extent;
  if (Range.IsNull) then
    Exit;

  S := Spelling(ACursor);
  if FMacros.TryGetValue(S, Info) then
  begin
    if Info.Visited then
      Exit;
  end;
  Info.Cursor := ACursor;
  Info.Visited := True;
  FMacros.AddOrSetValue(S, Info);

  if (ACursor.IsMacroFunctionLike) then
  begin
    { This is a #define that looks like a function, as in:
        #define foo(x) (x < 0) ? -x : x
      We cannot convert these. }
    WriteToDo('Unable to convert function-like macro:');
    FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
    WriteCommentedOutOriginalSource(ACursor);
    Exit;
  end;

  { Tokenize the macro (#define) definition. This gives us a list of tokens
    that make up the definition (including the original macro name). We try to
    convert these tokens to Delphi. }

  TokenList := FTranslationUnit.Tokenize(Range);
  if (TokenList = nil) or (TokenList.Count < 2) then
    Exit;

  { Check any TokenList for symbols we do not support }
  HasFloatToken := False;
  SetLength(Tokens, TokenList.Count);
  for I := 0 to TokenList.Count - 1 do
  begin
    S := TokenSpelling(TokenList[I]);
    if (S = '{') or (S = '?') or (S = ',') then
    begin
      WriteToDo('Unable to convert macro:');
      FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
      WriteCommentedOutOriginalSource(ACursor);
      Exit;
    end
    else if (S = '*') and ((I = 0) or (I = (TokenList.Count - 1))) then
    begin
      { '*' at begin or end }
      WriteToDo('Unable to convert macro:');
      FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
      WriteCommentedOutOriginalSource(ACursor);
      Exit;
    end
    else if (S.StartsWith('__')) then
    begin
      WriteToDo(Format('Macro refers to system symbol "%s":', [S]));
      FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
      WriteCommentedOutOriginalSource(ACursor);
      Exit;
    end
    else if IsMostlyLowerCase(S) then
    begin
      WriteToDo(Format('Macro probably uses invalid symbol "%s":', [S]));
      FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
      WriteCommentedOutOriginalSource(ACursor);
      Exit;
    end
    else if FInvalidConstants.ContainsKey(S) then
    begin
      WriteToDo(Format('Macro uses commented-out symbol "%s":', [S]));
      FInvalidConstants.AddOrSetValue(Spelling(ACursor), 0);
      WriteCommentedOutOriginalSource(ACursor);
      Exit;
    end;

    if FMacros.TryGetValue(S, Info) then
    begin
      if (not Info.Visited) then
        { Write dependent macro first }
        WriteDefinedConstant(Info.Cursor);
    end;

    if (S.IndexOf('.') >= 0) then
      HasFloatToken := True;
    Tokens[I] := S;
  end;

  if (FSymbolsToIgnore.ContainsKey(Tokens[0])) then
    Exit;

  { Seems that libclang does not provide comments for #defines. Call WriteComment
    anyway in case future libclang versions do. }
  FCommentWriter.WriteComment(ACursor);

  { First token is macro (constant) name }
  FWriter.Write(Tokens[0]);
  FWriter.Write(' = ');

  { Write right-hand side. This procedure is also used by WriteTypedConstant() }
  WriteConstantsRhs(Tokens, 1, TokenList.Count, HasFloatToken);

  FWriter.WriteLn(';');
end;

{ [static] const AType AName = <Expression>; }
procedure THeaderTranslator.WriteTypedConstant(const ACursor: TCursor);
type
  TState = (statConst, statLhs, statRhs, statError);
var
  Range: TSourceRange;
  TokenList: ITokenList;
  Tokens: TArray<String>;
  S, SLast: String;
  I: Integer;
  Info: TVarDeclInfo;
  HasFloatToken: Boolean;
  State : TState;
  SType, SVarName, Rhs : String;
  RhsStart : Integer;
  CursorType : TType;
  TypeKind : TTypeKind;
  KindSpelling : String;
begin
  Range := ACursor.Extent;
  if (Range.IsNull) then
    Exit;

  S := Spelling(ACursor);
  if FVarDecls.TryGetValue(S, Info) then
  begin
    if Info.Visited then
      Exit;
  end;
  Info.Cursor := ACursor;
  Info.Visited := True;
  FVarDecls.AddOrSetValue(S, Info);

  CursorType := ACursor.CursorType;
  TypeKind := CursorType.Kind;
  KindSpelling := CursorType.KindSpelling;

  { Tokenize the const expression. This gives us a list of tokens
    that make up the definition (including the original macro name). We try to
    convert these tokens to Delphi. }

  TokenList := FTranslationUnit.Tokenize(Range);
  if (TokenList = nil) or (TokenList.Count < 3) then
    Exit;

  SetLength(Tokens, TokenList.Count);
  State := statConst;
  SType := '';
  SVarName := '';
  Rhs := '';
  S := '';
  SLast := '';
  RhsStart := 0;

  for I := 0 to TokenList.Count - 1 do
  begin
    S := TokenSpelling(TokenList[I]);
    Tokens[i] := S;

    if S = 'static' then
      Continue; // do nothing, skip

    case State of
      statConst : if S = 'const' then
                    State := statLhs
                  else
                    Exit;  // not a const expression

      statLhs   : if S = '=' then
                  begin
                    SVarName := SLast;
                    State := statRhs;
                    RhsStart := I + 1;
                  end
                  else
                  begin
                    if SType <> '' then
                      SType := SType + ' ';
                    SType := SType + SLast;
                    SLast := S;
                 end;

      statRhs   : begin
                    if Rhs <> '' then
                      Rhs := Rhs + ' ';
                    Rhs := Rhs + S;
                  end;
    end;
    if State = statError then
      Break;
  end;

  if (SVarName = '') or (SType = '') or (Rhs = '') then
    State := statError;

  if State = statError then
  begin
    WriteToDo('Unable to convert const expression:');
    WriteCommentedOutOriginalSource(ACursor);
    Exit;
  end;


  if (FSymbolsToIgnore.ContainsKey(SVarName)) then
    Exit;

  FCommentWriter.WriteComment(ACursor);

  FWriter.Write(SVarName);
  FWriter.Write(' : ');

  while TypeKind = TTypeKind.Pointer do
  begin
    CursorType := CursorType.PointeeType;
    TypeKind :=  CursorType.Kind;
    FWriter.Write('P');
  end;

  if TypeKind = TTypeKind.Typedef then
    FWriter.Write(SType)  // use type name from C code
  else if (TypeKind in [Low(FBuiltinTypes) .. High(FBuiltinTypes)]) and (FBuiltinTypes[TypeKind] <> '') then
    FWriter.Write(FBuiltinTypes[TypeKind])
  else
  begin
    // unrecognized type
    FWriter.Write(SType);  // use type name from C code
    WriteTodo('unrecognized type "' + CursorType.KindSpelling + '"');
  end;

  FWriter.Write(' = ');

  HasFloatToken := (Rhs.IndexOf('.') >= 0);

  { Write right-hand side. This procedure is also used by WriteDefinedConstant() }
  WriteConstantsRhs(Tokens, RhsStart, TokenList.Count, HasFloatToken);
  FWriter.WriteLn(';');

end;

procedure THeaderTranslator.WriteConstants;
begin
  DoMessage('Writing constants (#define)...');
  FWriter.StartSection('const');

  FTranslationUnit.Cursor.VisitChildren(VisitDefinesFirstPass);
  FInvalidConstants := TDictionary<String, Integer>.Create;
  try
    FTranslationUnit.Cursor.VisitChildren(VisitDefinesSecondPass);
  finally
    FInvalidConstants.Free;
  end;

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteConstants2;
begin
  DoMessage('Writing constants (const )...');
  FWriter.StartSection('const');

  FInvalidConstants := TDictionary<String, Integer>.Create;
  try
    FTranslationUnit.Cursor.VisitChildren(VisitTypedConstants);
  finally
    FInvalidConstants.Free;
  end;

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteEnumType(const ACursor: TCursor);
begin
  if (not FWriter.IsAtSectionStart) then
    FWriter.WriteLn;

  FCommentWriter.WriteComment(ACursor);
  if (FProject.EnumHandling = TEnumHandling.ConvertToEnum) then
    WriteEnumTypeEnum(ACursor)
  else
    WriteEnumTypeConst(ACursor);
end;

procedure THeaderTranslator.WriteEnumTypeConst(const ACursor: TCursor);
var
  T: TType;
  TypeName: String;
  IsUnsigned, IsAnonymous: Boolean;
begin
  T := ACursor.CursorType;
  TypeName := GetDelphiTypeName(T, False, @IsAnonymous);

  if (not IsAnonymous) then
  begin
    FWriter.StartSection('type');
    FWriter.Write('%s = ', [TypeName]);

    T := ACursor.EnumDeclIntegerType;
    IsUnsigned := False;
    case T.Kind of
      TTypeKind.Char_U,
      TTypeKind.UChar:
        begin
          FWriter.WriteLn('Byte;');
          IsUnsigned := True;
        end;

      TTypeKind.UShort:
        begin
          FWriter.WriteLn('Word;');
          IsUnsigned := True;
        end;

      TTypeKind.UInt,
      TTypeKind.ULong:
        begin
          FWriter.WriteLn('Cardinal;');
          IsUnsigned := True;
        end;

      TTypeKind.ULongLong:
        begin
          FWriter.WriteLn('UInt64;');
          IsUnsigned := True;
        end;

      TTypeKind.Char_S,
      TTypeKind.SChar:
        FWriter.WriteLn('Shortint;');

      TTypeKind.Short:
        FWriter.WriteLn('Smallint;');

      TTypeKind.Int,
      TTypeKind.Long:
        FWriter.WriteLn('Integer;');

      TTypeKind.LongLong:
        FWriter.WriteLn('Int64;');
    else
      FWriter.WriteLn('Integer;');
    end;
    FWriter.WriteLn('%s = ^%s;', [MakePointerType(TypeName), TypeName]);
    FWriter.EndSection;
  end;

  FWriter.StartSection('const');
  ACursor.VisitChildren(
    function(const ACursor, AParent: TCursor): TChildVisitResult
    begin
      FCommentWriter.WriteComment(ACursor);
      FWriter.Write('%s = ', [Spelling(ACursor)]);
      if IsUnsigned then
        FWriter.Write(UIntToStr(ACursor.EnumConstantDeclUnsignedValue))
      else
        FWriter.Write(IntToStr(ACursor.EnumConstantDeclValue));

      FWriter.WriteLn(';');

      { NOTE: Enum values usually have children of an expression type. However,
        we don't translate expressions. Instead, we use de constant value that
        libclang provides. }
      Result := TChildVisitResult.Continue;
    end);

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteEnumTypeEnum(const ACursor: TCursor);
var
  T: TType;
  TypeName: String;
  FirstChild: Boolean;
  IsUnsigned: Boolean;
begin
  T := ACursor.CursorType;
  TypeName := GetDelphiTypeName(T);
  FWriter.WriteLn('%s = (', [TypeName]);
  FWriter.Indent;

  { Determine whether enum values are signed or unsigned. }
  T := ACursor.EnumDeclIntegerType;
  IsUnsigned := (T.Kind in [TTypeKind.Char_U, TTypeKind.UChar,
    TTypeKind.UShort, TTypeKind.UInt, TTypeKind.ULong, TTypeKind.ULongLong]);

  FirstChild := True;
  ACursor.VisitChildren(
    function(const ACursor, AParent: TCursor): TChildVisitResult
    begin
      if (not FirstChild) then
        FWriter.WriteLn(',');

      FCommentWriter.WriteComment(ACursor);
      FWriter.Write('%s = ', [Spelling(ACursor)]);
      if IsUnsigned then
        FWriter.Write(UIntToStr(ACursor.EnumConstantDeclUnsignedValue))
      else
        FWriter.Write(IntToStr(ACursor.EnumConstantDeclValue));

      FirstChild := False;

      { NOTE: Enum values usually have children of an expression type. However,
        we don't translate expressions. Instead, we use de constant value that
        libclang provides. }
      Result := TChildVisitResult.Continue;
    end);

  FWriter.WriteLn(');');
  FWriter.Outdent;
  FWriter.WriteLn('%s = ^%s;', [MakePointerType(TypeName), TypeName]);
end;

procedure THeaderTranslator.WriteEnumTypes;
var
  Cursor: TCursor;
begin
  FWriter.StartSection('type');

  for Cursor in FTypes do
  begin
    if (Cursor.Kind = TCursorKind.EnumDecl) then
      WriteEnumType(Cursor);
  end;

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteForwardTypeDeclarations;
var
  Cursor: TCursor;
  S: String;
  First: Boolean;
  I, IndirectionCount: Integer;
  P: TPair<String, String>;

  procedure CheckFirst;
  begin
    if (First) then
    begin
      FWriter.WriteLn('// Forward declarations');
      First := False;
    end;
  end;

  procedure CheckIndirection(const ACNames: array of String;
    const APasName: String; const AStart: Integer = 2);
  var
    I, IndirectionCount, MaxIndirectionCount: Integer;
    S, CName: String;
  begin
    MaxIndirectionCount := 0;
    for CName in ACNames do
    begin
      if (FMaxIndirectionCount.TryGetValue(FSymbolPrefix + CName, IndirectionCount)) then
      begin
        if (IndirectionCount > MaxIndirectionCount) then
          MaxIndirectionCount := IndirectionCount;
      end;
    end;

    if (MaxIndirectionCount >= AStart) then
    begin
      CheckFirst;
      S := APasName;

      if (AStart = 1) then
        FWriter.WriteLn('P%s = ^%0:s;', [S]);

      for I := 2 to MaxIndirectionCount do
      begin
        S := 'P' + S;
        FWriter.WriteLn('P%s = ^%0:s;', [S]);
      end;
    end;
  end;

begin
  First := True;

  { Check if we need pointer-to-pointer declarations for some builtin types. }
  case FProject.CharConvert of
    TCharConvert.UTF8Char:
      begin
        CheckIndirection(['char', 'signed char'], 'UTF8Char');
      end;
    TCharConvert.Shortint:
      begin
        CheckIndirection(['char', 'signed char'], 'Shortint');
      end;
    TCharConvert.AnsiChar:
      begin
        CheckIndirection(['char', 'signed char'], 'AnsiChar');
      end
  else
    CheckIndirection(['char', 'signed char'], 'Byte');
  end;

  case FProject.UnsignedCharConvert of
    TUnsignedCharConvert.UTF8Char:
      begin
        CheckIndirection(['unsigned char'], 'UTF8Char');
      end;
    TUnsignedCharConvert.Shortint:
      begin
        CheckIndirection(['unsigned char'], 'Shortint');
      end;
    TUnsignedCharConvert.AnsiChar:
      begin
        CheckIndirection(['unsigned char'], 'AnsiChar');
      end
  else
    CheckIndirection(['unsigned char'], 'Byte');
  end;

  CheckIndirection(['short', 'short int'], 'Smallint');
  CheckIndirection(['unsigned short int'], 'Word');
  CheckIndirection(['long', 'int', 'long int'], 'Integer');
  CheckIndirection(['unsigned int', 'unsigned long int'], 'Cardinal');
  CheckIndirection(['long long int'], 'Int64');
  CheckIndirection(['unsigned long long int'], 'UInt64');
  CheckIndirection(['float'], 'Single');
  CheckIndirection(['double'], 'Double');
  CheckIndirection(['long double'], 'Extended');

  var SavedSymbolPrefix := FSymbolPrefix;
  FSymbolPrefix := '';
  for P in FTypeMap do
    CheckIndirection([P.Key], P.Value, 1);
  FSymbolPrefix := SavedSymbolPrefix;

  { Check any types that were declared, but not defined, as in:
      struct Foo;
    These are only used in pointer references (*Foo) and treated as opaque
    types. }
  for Cursor in FDeclaredTypes do
  begin
    S := Spelling(Cursor);
    if (S <> '') and (not FSymbolsToIgnore.ContainsKey(S)) then
    begin
      CheckFirst;
      FWriter.WriteLn('%s = Pointer;', [MakePointerType(S)]);
      FWriter.WriteLn('%s = ^%s;', [MakePointerType(S, 2), MakePointerType(S)]);
    end;
  end;

  for Cursor in FTypes do
  begin
    case Cursor.Kind of
      TCursorKind.StructDecl:
        begin
          S := Spelling(Cursor);
          if (S = '') then
          begin
            (*For typedef structs without a name:

                typedef struct {...} Alias;

              The spelling will be empty. Use the type name.*)
            S := Spelling(Cursor.CursorType);
            if (IsAnonymous(S)) then
              S := ''
            else
              S := RemoveQualifiers(S);
          end;

          if (S <> '') and (not FSymbolsToIgnore.ContainsKey(S)) then
          begin
            CheckFirst;
            FWriter.WriteLn('%s = ^%s;', [MakePointerType(S), S]);

            { Check if we need additional pointer-to-pointer declarations }
            if (FMaxIndirectionCount.TryGetValue(S, IndirectionCount)) then
            begin
              for I := 2 to IndirectionCount do
                FWriter.WriteLn('%s = ^%s;', [MakePointerType(S, I), MakePointerType(S, I - 1)]);
            end;
          end;
        end;
    end;
  end;
  if (not First) then
    FWriter.WriteLn;
end;

procedure THeaderTranslator.WriteFunction(const ACursor: TCursor);
var
  FuncCursor: TCursor;
  Name: String;
begin
  Name := Spelling(ACursor);
  if (FSymbolsToIgnore.ContainsKey(Name)) then
    Exit;

  FWriter.WriteLn;

  { Check if any of the function parameters is a procedural type. Delphi
    doesn't support inline procedural types, so we need to create declarations
    for those. }
  FuncCursor := ACursor;
  ACursor.VisitChildren(
    function(const ACursor, AParent: TCursor): TChildVisitResult
    var
      CursorType, PointeeType: TType;
    begin
      if (ACursor.Kind = TCursorKind.ParmDecl) then
      begin
        CursorType := ACursor.CursorType;
        if IsProceduralType(CursorType, PointeeType) then
        begin
          FWriter.StartSection('type');
          { Make up name for this parameter type }
          FWriter.Write(GenerateProcTypeNameForArg(FuncCursor, ACursor));
          FWriter.Write(' = ');
          WriteFunctionProto(ACursor, PointeeType, '');
          FWriter.WriteLn(';');
          FWriter.EndSection;
          FWriter.WriteLn;
        end;
      end;

      Result := TChildVisitResult.Continue;
    end);

  FCommentWriter.WriteComment(ACursor);
  WriteFunctionProto(ACursor, ACursor.CursorType, ValidIdentifier(Name));
  {$IFDEF EXPERIMENTAL}
  if (FProject.PrefixSymbolsWithUnderscore) then
    Name := Name.Substring(1);
  {$ENDIF}
  FWriter.WriteLn(';');
  FWriter.Write('  external %s%s name _PU + ''%s''',
    [FSymbolPrefix, FProject.LibraryConstant, Name]);

  if (FProject.DelayedLoading) then
    FWriter.Write(' {$IFDEF MSWINDOWS}delayed{$ENDIF}');

  FWriter.WriteLn(';');
end;

procedure THeaderTranslator.WriteFunctionProto(const ACursor: TCursor;
  const AType: TType; const AFunctionName: String;
  const AInStruct: Boolean);
var
  ProtoCursor: TCursor;
  ResType, ProtoType: TType;
  ArgIndex, ArgCount: Integer;
  HasResult: Boolean;
begin
  { AType is the function proto type (of kind FunctionProto or FunctionNoProto).
    Use its ResultType and ArgTypes properties for parameter type information.
    However, these do not provide info about the names of the parameters. Those
    are children of ACursor. Parameters do not have to have names. In that case,
    they are still children of ACursor, but Spelling will be empty.  }
  ResType := AType.ResultType;
  HasResult := (not (ResType.Kind in [TTypeKind.Invalid, TTypeKind.Void]));
  if (HasResult) then
    FWriter.Write('function')
  else
    FWriter.Write('procedure');

  { AFunctionName is empty for procedural types }
  if (AFunctionName <> '') then
  begin
    FWriter.Write(' ');
    FWriter.Write(AFunctionName);
  end;

  FWriter.Write('(');

  ProtoCursor := ACursor;
  ProtoType := AType;
  ArgIndex := 0;
  ArgCount := AType.ArgTypeCount;
  ACursor.VisitChildren(
    function(const ACursor, AParent: TCursor): TChildVisitResult
    var
      CursorType, PointeeType: TType;
      ArgName: String;
      IsProcType: Boolean;
    begin
      if (ACursor.Kind = TCursorKind.ParmDecl) then
      begin
        ArgName := ValidIdentifier(ACursor.Spelling);
        if (ArgName = '') then
          ArgName := 'p' + (ArgIndex + 1).ToString;

        CursorType := ACursor.CursorType;
        IsProcType := IsProceduralType(CursorType, PointeeType);

        if ((CursorType.IsConstQualified) or (PointeeType.IsConstQualified))
          { Don't add "const" for types that are 8 or 16 bytes in size (like
            TPointF and TRectF), since Delphi passes these differently. }
          and (not Is8or16ByteStruct(CursorType))
        then
          { Issue #2 (https://github.com/neslib/Chet/issues/2):
            Add support for const parameters. }
          FWriter.Write('const ');

        FWriter.Write(ArgName + ': ');

        if (IsProcType) then
        begin
          { The argument is a procedural type. If this is a top-level function
            (AInStruct=False), then a procedural type declaration has been
            created earlier, and we can use it here. If this function is the
            type of a field in a recurd (AInStruct=True), then we cannot create
            a procedural type declaration on-the-fly. Instead, we write a TODO
            and use a pointer as parameter type. }
          if (AInStruct) then
          begin
            WriteToDo('Create a procedural type for this parameter');
            FWriter.Write('Pointer');
          end
          else
            FWriter.Write(GenerateProcTypeNameForArg(ProtoCursor, ACursor))
        end
        else
          FWriter.Write(GetDelphiTypeName(ACursor.CursorType, True));

        if (ArgIndex < (ArgCount - 1)) then
          FWriter.Write('; ');

        Inc(ArgIndex);
      end;

      Result := TChildVisitResult.Continue;
    end);

  if (HasResult) then
  begin
    FWriter.Write('): ');
    FWriter.Write(GetDelphiTypeName(ResType));
  end
  else
    FWriter.Write(')');

  if (AType.Kind = TTypeKind.FunctionProto) and (AType.IsFunctionVariadic) then
    FWriter.Write(' varargs');

  FWriter.Write(';');

  if (FProject.CallConv = TCallConv.StdCall) then
    FWriter.Write(' stdcall')
  else
    FWriter.Write(' cdecl');
end;

procedure THeaderTranslator.WriteFunctions;
begin
  DoMessage('Writing functions...');
  FTranslationUnit.Cursor.VisitChildren(VisitFunctions);
  FWriter.WriteLn;
end;

procedure THeaderTranslator.WriteImplementation;
var
  Line: string;
begin
  if (FImplementation <> nil) and (FImplementation.Count > 0) then
  begin
    DoMessage('Writing implementation...');
    FWriter.WriteLn;
    for Line in FImplementation do
      FWriter.WriteLn(Line);
  end;
end;

procedure THeaderTranslator.WriteIndirections(ATypeName: String;
  const ADelphiTypeName: String);
var
  I, IndirectionCount: Integer;
begin
  if (FMaxIndirectionCount.TryGetValue(ATypeName, IndirectionCount)) then
  begin
    if (IndirectionCount > 0) then
    begin
      { Special case for UTF8Char. We need to convert the first indirection to
        PUTF8Char so we can use it to pass string literals in code. }
      if (ADelphiTypeName = 'UTF8Char') then
        FWriter.WriteLn('P%s = PUTF8Char;', [ATypeName])
      else
        FWriter.WriteLn('%s = ^%s;', [MakePointerType(ATypeName), ValidIdentifier(ATypeName)]);

      for I := 1 to IndirectionCount - 1 do
      begin
        ATypeName := 'P' + ATypeName;
        FWriter.WriteLn('P%s = ^%0:s;', [ATypeName]);
      end;
    end;
  end;
end;

procedure THeaderTranslator.WriteIntro;
begin
  FWriter.WriteLn('{ This unit is automatically generated by Chet:');
  FWriter.WriteLn('  https://github.com/neslib/Chet }');
  FWriter.WriteLn;
end;

procedure THeaderTranslator.WritePlatforms;
const
  PLATFORM_DEFINES: array [TPlatformType] of String = (
    'WIN32', 'WIN64', 'MACOS64', 'MACOS64', 'LINUX', 'IOS', 'ANDROID32', 'ANDROID64');
var
  First: Boolean;
  PT: TPlatformType;
  P: TPlatform;
begin
  First := True;
  FWriter.StartSection('const');

  for PT := Low(TPlatformType) to High(TPlatformType) do
  begin
    P := FProject.Platforms[PT];
    if (P.Enabled) then
    begin
      if (First) then
      begin
        FWriter.Write('{$IF Defined(');
        First := False;
      end
      else
        FWriter.Write('{$ELSEIF Defined(');

      FWriter.Write(PLATFORM_DEFINES[PT]);
      if (PT = TPlatformType.MacARM) then
        FWriter.Write(') and Defined(CPUARM64) and not Defined(IOS');
      if (PT = TPlatformType.MacIntel) then
        FWriter.Write(') and Defined(CPUX64) and not Defined(IOS');

      FWriter.WriteLn(')}');

      FWriter.WriteLn('%s%s = ''%s'';', [FSymbolPrefix, FProject.LibraryConstant, P.LibraryName]);
      FWriter.WriteLn('_PU = ''%s'';', [P.Prefix]);
    end;
  end;

  FWriter.WriteLn('{$ELSE}');
  FWriter.WriteLn('  {$MESSAGE Error ''Unsupported platform''}');
  FWriter.WriteLn('{$ENDIF}');

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteProceduralType(const ACursor: TCursor;
  const AType: TType; const ANamePrefix: String);
begin
  FWriter.WriteLn;
  FCommentWriter.WriteComment(ACursor);
  FWriter.Write('%s%s = ', [ANamePrefix, ValidIdentifier(Spelling(ACursor))]);
  WriteFunctionProto(ACursor, AType, '');
  FWriter.WriteLn(';');
end;

procedure THeaderTranslator.WriteStructType(const ACursor: TCursor; const AIsUnion: Boolean);
var
  T: TType;
  FieldIndex, BitFieldOffsetFromStructStart, BitFieldDataFieldCount, BitFieldCount: Integer;
  StructName, FieldName: String;
  IsAnonymousStruct, IsFieldInited: Boolean;
  BitFieldValueFieldName: string;
begin
  T := ACursor.CursorType;
  if (not FWriter.IsAtSectionStart) then
    FWriter.WriteLn;

  FCommentWriter.WriteComment(ACursor);
  StructName := GetDelphiTypeName(T, False, @IsAnonymousStruct);

  if IsAnonymousStruct then
    { Anonymous types aren't analyzed during the AnalyzeTypes phase, which means
      that there will not be forward declarations of pointer-to-struct types.
      So we do that here. }
    FWriter.WriteLn('P%s = ^%0:s;', [StructName]);

  FWriter.WriteLn('%s = record', [StructName]);
  FWriter.Indent;

  if (AIsUnion) then
    FWriter.WriteLn('case Integer of');

  FieldIndex := 0;
  BitFieldCount := 0;
  BitFieldOffsetFromStructStart := 0;
  IsFieldInited := True;
  BitFieldDataFieldCount := 0;

  T.VisitFields(
    function(const ACursor: TCursor): TVisitorResult
    var
      CursorType, PointeeType: TType;
      BitWidth, FieldOfset, BitIndex: Integer;
      DelphiTypeName: string;
    begin
      FCommentWriter.WriteComment(ACursor);

      CursorType := ACursor.CursorType;
      DelphiTypeName := GetDelphiTypeName(CursorType);
      FieldName := ValidIdentifier(ACursor.Spelling);
      if (FieldName = '') then
        FieldName := 'f' + (FieldIndex + 1).ToString;

      if ACursor.IsBitField then
      begin
        // https://en.cppreference.com/w/cpp/language/bit_field
        // http://www.rvelthuis.de/articles/articles-convert.html#bitfields
        // https://stackoverflow.com/questions/282019/how-to-simulate-bit-fields-in-delphi-records#282385
        BitWidth := ACursor.FieldDeclBitWidth;
        FieldOfset := BitFieldOffsetFromStructStart;
        if BitFieldDataFieldCount > 0 then
          Dec(FieldOfset, 32 * BitFieldDataFieldCount);
        BitIndex := (FieldOfset shl 8) + BitWidth;

        if (BitFieldCount = 0) or (BitFieldDataFieldCount > 0)  then
        begin
          BitFieldValueFieldName := 'Data' + BitFieldDataFieldCount.ToString;

          FWriter.WriteLn('private');
          FWriter.Indent;
          FWriter.WriteLn(BitFieldValueFieldName+': '+DelphiTypeName+';');
          FWriter.WriteLn('function Get'+BitFieldValueFieldName+'Value(const aIndex: Integer): '+DelphiTypeName+';');
          FWriter.WriteLn('procedure Set'+BitFieldValueFieldName+'Value(const aIndex: Integer; const aValue: '+DelphiTypeName+');');
          FWriter.Outdent;
          FWriter.WriteLn('public');

          if FImplementation = nil then
            FImplementation := TStringList.Create;
          // todo: compatibility with "ancient" delphi versions?
          FImplementation.Add('{'+StructName +'}');
          FImplementation.Add('function '+StructName+'.Get'+BitFieldValueFieldName+'Value(const aIndex: Integer): '+DelphiTypeName+';');
          FImplementation.Add('var');
          FImplementation.Add('  BitCount, Offset, Mask: Integer;');
          FImplementation.Add('begin');
          FImplementation.Add('// {$UNDEF Q_temp}{$IFOPT Q+}{$DEFINE Q_temp}{$ENDIF}{$Q-} // disable OverFlowChecks');
          FImplementation.Add('  BitCount := aIndex and $FF;');
          FImplementation.Add('  Offset := aIndex shr 8;');
          FImplementation.Add('  Mask := ((1 shl BitCount) - 1);');
          FImplementation.Add('  Result := ('+BitFieldValueFieldName+' shr Offset) and Mask;');
          FImplementation.Add('// {$IFDEF Q_temp}{$Q-}{$ENDIF}');
          FImplementation.Add('end;'+ sLineBreak);

          FImplementation.Add('procedure '+StructName+'.Set'+BitFieldValueFieldName+'Value(const aIndex: Integer; const aValue: '+DelphiTypeName+');');
          FImplementation.Add('var');
          FImplementation.Add('  BitCount, Offset, Mask: Integer;');
          FImplementation.Add('begin');
          FImplementation.Add('// {$UNDEF Q_temp}{$IFOPT Q+}{$DEFINE Q_temp}{$ENDIF}{$Q-} // disable OverFlowChecks');
          FImplementation.Add('  BitCount := aIndex and $FF;');
          FImplementation.Add('  Offset := aIndex shr 8;');
          FImplementation.Add('  Mask := ((1 shl BitCount) - 1);');
          FImplementation.Add('  '+BitFieldValueFieldName+' := ('+BitFieldValueFieldName+' and (not (Mask shl Offset))) or (aValue shl Offset);');
          FImplementation.Add('// {$IFDEF Q_temp}{$Q-}{$ENDIF}');
          FImplementation.Add('end;'+sLineBreak);
        end;

        FWriter.Indent;
        FWriter.WriteLn('property '+FieldName+': '+DelphiTypeName+' index $'+BitIndex.ToHexString(CursorType.Sizeof)+' read Get'+BitFieldValueFieldName+'Value write Set'+BitFieldValueFieldName+'Value; // '+BitWidth.ToString+' bits at offset '+FieldOfset.ToString +' in  '+ BitFieldValueFieldName);
        FWriter.Outdent;
        Inc(BitFieldCount);
        Inc(BitFieldOffsetFromStructStart, BitWidth);
        if BitFieldOffsetFromStructStart > 31 then
          Inc(BitFieldDataFieldCount);
        IsFieldInited := False;
      end
      else
      begin
        if (AIsUnion) then
          FWriter.Write('  %d: (', [FieldIndex]);

        if (BitFieldCount > 0) and not IsFieldInited then
        begin
          FWriter.Indent;
          FWriter.WriteLn('var'); // to avoid compile errors
          FWriter.Indent;
          IsFieldInited := True;
        end;

        FWriter.Write(FieldName);
        FWriter.Write(': ');

        if (IsProceduralType(CursorType, PointeeType)) then
          WriteFunctionProto(ACursor, PointeeType, '', True)
        else
          FWriter.Write(DelphiTypeName);

        if (AIsUnion) then
          FWriter.WriteLn(');')
        else
          FWriter.WriteLn(';');
      end;

      Inc(FieldIndex);

      Result := TVisitorResult.Continue;
    end);

  FWriter.Outdent;
  FWriter.WriteLn('end;');

  FWriter.WriteLn;
end;

procedure THeaderTranslator.WriteToDo(const AText: String);
begin
  if (FProject.UnconvertibleHandling = TUnconvertibleHandling.WriteToDo) then
    FWriter.WriteLn('{ TODO : %s }', [AText]);
end;

procedure THeaderTranslator.WriteType(const ACursor: TCursor);
begin
  if FSymbolsToIgnore.ContainsKey(Spelling(ACursor)) then
    Exit;

  case ACursor.Kind of
    TCursorKind.StructDecl:
      WriteStructType(ACursor, False);

    TCursorKind.UnionDecl:
      WriteStructType(ACursor, True);

    TCursorKind.TypedefDecl:
      WriteTypedefType(ACursor);

    TCursorKind.EnumDecl:
      if (FProject.EnumHandling = TEnumHandling.ConvertToEnum) then
        WriteEnumType(ACursor);
  end;
end;

procedure THeaderTranslator.WriteTypedefType(const ACursor: TCursor);
var
  SrcName, DstName: String;
  T, Pointee, CanonType: TType;
begin
  T := ACursor.TypedefDeclUnderlyingType;

  { There are three ways to create procedural types. The most common one:

      typedef int (*SomeProc)(int SomeParam);

    This gets handled by IsProcedural type below. There is also a variation
    without a '*':

      typedef int (SomeProc)(int SomeParam);

    In this case, libclang returns this as an "unexposed" type and its
    canonical type will be a function proto. But it can later only be
    referenced as *SomeProc, so we need to prefix with a 'P'.

    Finally there is this version without parenthesis around the name:

      typedef int SomeProc(int SomeParam);

    In this case, the type is Function(No)Proto, and again can only be used as
    a reference. }
  if (T.Kind = TTypeKind.Unexposed) then
  begin
    T := T.CanonicalType;
    if (T.Kind in [TTypeKind.FunctionNoProto, TTypeKind.FunctionProto]) then
    begin
      WriteProceduralType(ACursor, T, 'P');
      Exit;
    end;
  end
  else if (T.Kind in [TTypeKind.FunctionNoProto, TTypeKind.FunctionProto]) then
  begin
    WriteProceduralType(ACursor, T, 'P');
    Exit;
  end;

  if (IsProceduralType(T, Pointee)) then
  begin
    { This is a procedural type }
    WriteProceduralType(ACursor, Pointee);
    WriteIndirections(Spelling(ACursor));
    Exit;
  end;

  DstName := Spelling(ACursor);
  if FWrittenTypeDefs.ContainsKey(DstName) then
    Exit;

  FWrittenTypeDefs.Add(DstName, 0);

  { Check for "opaque" types, as in:
      typedef struct _Foo Foo;
    Here, Foo is never used as-is, but only as "*Foo".
    Seems like we can detect these by checking IsPodType }
  CanonType := T.CanonicalType;
  if (CanonType.Kind = TTypeKind.Rec) and (not CanonType.IsPodType) then
  begin
    FWriter.WriteLn('%s = Pointer;', [MakePointerType(DstName)]);
    FWriter.WriteLn('%s = ^%s;', [MakePointerType(DstName, 2), MakePointerType(DstName)]);
    Exit;
  end;

  { Another common declaration for an opaque type is:
      typedef struct _Foo *Foo
    Here Foo itself is a pointer type, and the pointee again is not a POD type. }
  CanonType := T.CanonicalType;
  if (CanonType.Kind = TTypeKind.Pointer) then
  begin
    Pointee := CanonType.PointeeType;
    if (Pointee.Kind = TTypeKind.Rec) and (not Pointee.IsPodType) then
    begin
      FWriter.WriteLn('%s = Pointer;', [DstName]);
      FWriter.WriteLn('P%s = ^%0:s;', [DstName]);
      Exit;
    end;
  end;

  { Check for typedefs to "void", as in:
      typedef void Foo;
    These only make sense when user later as a pointer reference (*Foo) }
  if (T.Kind = TTypeKind.Void) then
  begin
    FWriter.WriteLn('P%s = Pointer;', [DstName]);
    FWriter.WriteLn('PP%s = ^P%0:s;', [DstName]);
    Exit;
  end;

  (*Do NOT convert typedef if the name of the typedef is the same as name
    of the structure, eg.:
      typedef struct Foo {
        ..
      } Foo;
  *)
  SrcName := GetDelphiTypeName(T);
  if (DstName = SrcName) then
    Exit;

  FCommentWriter.WriteComment(ACursor);
  FWriter.WriteLn('%s = %s;', [ValidIdentifier(DstName), SrcName]);
  WriteIndirections(DstName, SrcName);
end;

procedure THeaderTranslator.WriteTypes;
var
  Cursor: TCursor;
begin
  DoMessage('Writing data types...');

  if (FProject.EnumHandling = TEnumHandling.ConvertToConst) then
    { This mixes type- and const-sections, so must be handled separately. }
    WriteEnumTypes;

  FWriter.StartSection('type');

  { Forward pointer-to-record declarations }
  WriteForwardTypeDeclarations;

  for Cursor in FTypes do
    WriteType(Cursor);

  FWriter.EndSection;
end;

procedure THeaderTranslator.WriteUsesClause;
var
  Units: TArray<String>;
  I: Integer;
begin
  Units := FProject.UseUnits.Split([',']);
  if (Units = nil) then
    Exit;

  FWriter.StartSection('uses');
  FWriter.Indent;

  for I := 0 to Length(Units) - 2 do
  begin
    FWriter.Write(Units[I]);
    FWriter.WriteLn(',');
  end;

  FWriter.Write(Units[Length(Units) - 1]);
  FWriter.WriteLn(';');

  FWriter.Outdent;
  FWriter.EndSection;
end;

{ THeaderTranslator.TMacroInfo }

constructor THeaderTranslator.TMacroInfo.Create(const ACursor: TCursor);
begin
  Cursor := ACursor;
  Visited := False;
end;

{ THeaderTranslator.TVarDeclInfo }

constructor THeaderTranslator.TVarDeclInfo.Create(const ACursor: TCursor);
begin
  Cursor    := ACursor;
  Visited   := False;
  ConstDecl := False;
end;

end.
