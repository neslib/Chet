unit Chet.CleanHeader;

interface

uses
  System.Types,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.StrUtils,
  Chet.Project;

type
  { TScriptStringList }
  TScriptStringList = class(TStringList)
  protected
    FScript: TStringList;
    function ValidIndex(aIndex: Integer): Boolean;
    function GetScriptParams(const aScript: string; const aRoutineName: string; aParamCount: Cardinal; var aParams: TStringDynArray): Boolean;
  public
    destructor Destroy; override;
    function GetLineIndex(aOccurence: Cardinal; const aLine: string): Integer;
    function ReplaceLine(aOccurence: Cardinal; const aOldLine: string; const aNewLine: string; aOffset: Integer): Boolean;
    function RemoveLines(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; aCount: Cardinal): Boolean;
    function RemoveLineRange(aOccurence: Cardinal; const aStartLine: string; const aEndLine: string): Boolean;
    function RemoveLineRangeAll(const aStartLine: string; const aEndLine: string): Boolean;
    function InsertLine(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aNewLine: string): Boolean;
    function InsertTextFile(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aTextFilename: string): Boolean;
    function RemoveAllLines(const aStartText: string; aCount: Integer): Boolean;
    function RegEx(const aPattern: string; const aValue: string; const aOperation: string): Boolean;
    function SaveToFileEx(const aFilename: string): Boolean;
    function LoadFromFileEx(const aFilename: string): Boolean;
    function CreateDynamicImport: Boolean;
    function Evaluate(const aScript: string): Boolean;
    function LoadScript(const aFilename: string): Boolean;
    function AddScript(const aStrings: TStrings): Boolean; overload;
    function AddScript(const aScript: string): Boolean; overload;
    function RunScript: Boolean;
  end;

  { TCleanHeader }
  TCleanHeader = class
  protected
    FCode: TScriptStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Process(const aFilename: string; aScript: TStrings);
  end;

procedure DoCleanHeader(aProject: TProject; aScript: TStrings);

implementation

uses
  System.RegularExpressions,
  WinApi.Windows;

procedure DoCleanHeader(aProject: TProject; aScript: TStrings);
var
  LCleanHeader: TCleanHeader;
  LCurDir: string;
  LProjDir: string;
begin
  LCleanHeader := TCleanHeader.Create;
  try
    LCurDir := TDirectory.GetCurrentDirectory;
    LProjDir := aProject.ProjectFilename;
    if not LProjDir.IsEmpty then
    begin
      LProjDir := TPath.GetDirectoryName(LProjDir);
      TDirectory.SetCurrentDirectory(LProjDir);
    end;
    LCleanHeader.Process(aProject.TargetPasFile, aScript);
    TDirectory.SetCurrentDirectory(LCurDir);
  finally
    FreeAndNil(LCleanHeader);
  end;
end;

{ TScriptStringList }
function TScriptStringList.ValidIndex(aIndex: Integer): Boolean;
begin
  Result := False;
  if aIndex < 0 then Exit;
  if aIndex > Self.Count-1 then Exit;
  Result := True;
end;

function TScriptStringList.GetScriptParams(const aScript: string; const aRoutineName: string; aParamCount: Cardinal; var aParams: TStringDynArray): Boolean;
var
  LScript: string;
  LParams: TStringDynArray;
  LItems: TStringList;
  LIndex: Integer;
begin
  Result := False;
  LScript := aScript;
  if not LScript.StartsWith(aRoutineName) then Exit;
  LScript := LScript.Replace(aRoutineName, '', [rfIgnoreCase]);
  if not LScript.StartsWith('(') then Exit;
  if not LScript.EndsWith(')') then Exit;
  LScript := LScript.Replace('(', '', []);
  LScript := LScript.Remove(LScript.LastIndexOf(')'), 1);

  if aParamCount = 0 then
  begin
    aParams := nil;
    Result := True;
    Exit;
  end;

  LItems := TStringList.Create;
  try
    ExtractStrings([','], [' '], PChar(LScript), LItems);
    if Cardinal(LItems.Count) = aParamCount then
    begin
      SetLength(LParams, LItems.Count);
      for LIndex := 0 to LItems.Count-1 do
        LParams[LIndex] := LItems[LIndex];
      aParams := LParams;
      Result := True;
    end;
  finally
    FreeAndNil(LItems);
  end;



end;

destructor TScriptStringList.Destroy;
begin
  if FScript <> nil then
    FreeAndNil(FScript);
  inherited;
end;

function TScriptStringList.GetLineIndex(aOccurence: Cardinal; const aLine: string): Integer;
var
  LIndex: Integer;
  LText: string;
  LOccurence: Cardinal;
begin
  Result := -1;
  if aOccurence = 0 then Exit;
  LOccurence := 0;
  for LIndex := 0 to Self.Count-1 do
  begin
    LText := Self[LIndex].Trim;
    if SameText(aLine, LText) then
    begin
      Inc(LOccurence);
      if LOccurence = aOccurence then
      begin
        Result := LIndex;
        Exit;
      end;
    end;
  end;
end;

function TScriptStringList.ReplaceLine(aOccurence: Cardinal; const aOldLine: string; const aNewLine: string; aOffset: Integer): Boolean;
var
  LIndex: Integer;
begin
  Result := False;
  LIndex := GetLineIndex(aOccurence, aOldLine);
  if LIndex = -1 then Exit;
  LIndex := LIndex + aOffset;
  if not ValidIndex(LIndex) then Exit;
  Self[LIndex] := aNewLine;
  Result := True;
end;

function TScriptStringList.RemoveLines(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; aCount: Cardinal): Boolean;
var
  LIndex: Integer;
  LStartIndex: Integer;
begin
  Result := False;
  LStartIndex := GetLineIndex(aOccurence, aReferenceLine);
  if LStartIndex = -1 then Exit;
  LStartIndex := LStartIndex + aOffset;
  if not ValidIndex(LStartIndex) then Exit;
  for LIndex := 1 to aCount do
    Self.Delete(LStartIndex);
  Result := True;
end;

function TScriptStringList.RemoveLineRange(aOccurence: Cardinal; const aStartLine: string; const aEndLine: string): Boolean;
var
  LIndex: Integer;
  LStartIndex: Integer;
  LEndIndex: Integer;
  LText: string;
begin
  Result := False;
  LStartIndex := GetLineIndex(aOccurence, aStartLine);
  if LStartIndex = -1 then Exit;
  for LEndIndex := LStartIndex to Self.Count-1 do
  begin
    LText := Self[LEndIndex].Trim;
    if SameText(LText, aEndLine) then
    begin
      //for LIndex := LStartIndex to LEndIndex do
      for LIndex := LEndIndex downto LStartIndex do
        Self.Delete(LIndex);
      Result := True;
      Exit;
    end;
  end;
end;

function TScriptStringList.RemoveLineRangeAll(const aStartLine: string; const aEndLine: string): Boolean;
begin
  while RemoveLineRange(1, aStartLine, aEndLine) do;
  Result := True;
end;

function TScriptStringList.InsertLine(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aNewLine: string): Boolean;
var
  LIndex: Integer;
begin
  Result := False;
  LIndex := GetLineIndex(aOccurence, aReferenceLine);
  if LIndex = -1 then Exit;
  LIndex := LIndex + aOffset;
  if not ValidIndex(LIndex) then Exit;
  Self.Insert(LIndex, aNewLine);
  Result := True;
end;

function TScriptStringList.InsertTextFile(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aTextFilename: string): Boolean;
var
  LStartIndex: Integer;
  LIndex: Integer;
  LTextFile: TStringList;
begin
  Result := False;
  if not TFile.Exists(aTextFilename) then Exit;
  LStartIndex := GetLineIndex(aOccurence, aReferenceLine);
  if LStartIndex = -1 then Exit;
  LStartIndex := LStartIndex + aOffset;
  if not ValidIndex(LStartIndex) then Exit;

  LTextFile := TStringList.Create;
  try
    LTextFile.LoadFromFile(aTextFilename);
    for LIndex := LTextFile.Count-1 downto 0 do
    begin
      Self.Insert(LStartIndex, LTextFile[LIndex]);
    end;
  finally
    FreeAndNil(LTextFile);
  end;
  Result := True;
end;

function TScriptStringList.RemoveAllLines(const aStartText: string; aCount: Integer): Boolean;
var
  LIndex: Integer;
  LText: string;
  LCount: Integer;
begin
  Result := False;
  if aStartText.IsEmpty then Exit;

  for LIndex := Self.Count-1 downto 0 do
  begin
    LText := Self[LIndex].Trim;
    if LText.StartsWith(aStartText) then
    begin
      for LCount := 0 to aCount-1 do
        Self.Delete(LIndex);
    end;
  end;

  Result := True;
end;


function TScriptStringList.RegEx(const aPattern: string; const aValue: string; const aOperation: string): Boolean;
var
  LMatch: TMatch;
  LValue: string;
  LOperation: Integer;
  LIndex: Integer;
begin
  Result := True;
//  LOperation := -1;
  if SameText(aOperation, 'Replace') then
    LOperation := 0
  else
  if SameText(aOperation, 'Prepend') then
    LOperation := 1
  else
  if SameText(aOperation, 'Append') then
    LOperation := 2
  else
    begin
      Result := False;
      Exit;
    end;

  for LIndex := 0 to Self.Count-1 do
  begin
    LMatch := TRegEx.Match(Self[LIndex], aPattern);
    if not LMatch.Success then continue;
    case LOperation of
      0: LValue := aValue;
      1: LValue := aValue + LMatch.Value;
      2 : LValue := LMatch.Value + aValue;
    end;
    try
      Self[LIndex] := TRegEx.Replace(Self[LIndex], aPattern, LValue);
    except
      // TODO: handle this properly
      Result := False;
    end;
  end;
end;

function TScriptStringList.SaveToFileEx(const aFilename: string): Boolean;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  Self.SaveToFile(aFilename);
  Result := TFile.Exists(aFilename);
end;

function TScriptStringList.LoadFromFileEx(const aFilename: string): Boolean;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;
  Self.LoadFromFile(aFilename);
  Result := True;
end;

function TScriptStringList.CreateDynamicImport: Boolean;
var
  LLine: string;
  LName: string;
  LIndex: Integer;
  LIndexStart: Integer;
  LImportList: TStringList;

  procedure IL(const aLine: string);
  begin
    Inc(LIndexStart);
    Self.Insert(LIndexStart, aLine);
  end;

begin
  Result := False;

  LIndexStart := Self.GetLineIndex(1, 'implementation');
  if LIndexStart = -1 then Exit;

  LImportList := TStringList.Create(dupIgnore, True, False);

  for LIndex := 0 to Self.Count-1 do
  begin
    LLine := Self[LIndex].Trim;
    if LLine.StartsWith('procedure ', True) then
      begin
        LLine := LLine.Replace('procedure ', '').Trim;
        LLine := LLine.Replace('(', ': procedure(');
        LLine := '  ' + LLine;
        Self[LIndex] := LLine;
        LName := LLine.Substring(0, LLine.IndexOf(':')).Trim;
        LImportList.Add(LName);
      end
    else
    if LLine.StartsWith('function ', True) then
      begin
        LLine := LLine.Replace('function ', '').Trim;
        LLine := LLine.Replace('(', ': function(');
        LLine := '  ' + LLine;
        Self[LIndex] := LLine;
        LName := LLine.Substring(0, LLine.IndexOf(':')).Trim;
        LImportList.Add(LName);
      end
  end;

  IL('');
  IL('uses');
  IL('  WinApi.Windows;');
  IL('');
  IL('procedure GetExports(aDLLHandle: THandle);');
  IL('begin');
  IL('  if aDLLHandle = 0 then Exit;');
  IL('  {$REGION ''Exports''}');
  //for LIndex := LImportList.Count-1 downto 0 do
  for LIndex := 0 to LImportList.Count-1 do
  begin
    LName := LImportList[LIndex];
    if LName.EndsWith('_rtn') then
      LName := LName.Remove(LName.IndexOf('_rtn'));
    LLine := Format('  %s := GetProcAddress(aDLLHandle, ''%s'');', [LImportList[LIndex], LName]);
    IL(LLine);
  end;
  IL('  {$ENDREGION}');
  IL('end;');
  IL('');

  LIndexStart := Self.GetLineIndex(1, 'implementation');
  if LIndexStart = -1 then Exit;
  Self.Insert(LIndexStart, '');
  Self.Insert(LIndexStart, 'procedure GetExports(aDLLHandle: THandle);');
  Self.Insert(LIndexStart, '');

  FreeAndNil(LImportList);
end;

function TScriptStringList.Evaluate(const aScript: string): Boolean;
var
  LScript: string;
  LParams: TStringDynArray;
  LOccurence: Cardinal;
  LText1: string;
  LText2: string;
  LText3: string;
  LOffset: Integer;
  LCount: Cardinal;

  function RemoveDoubleQuotes(const aString: string): string;
  begin
    Result := aString.Replace('"', '');
  end;

begin
  Result := False;
  if aScript.IsEmpty then Exit;
  LScript := aScript.Trim;

  // ReplaceLine(aOccurence: Cardinal; const aOldLine: string; const aNewLine: string; aOffset: Integer)
  // ReplaceLine(1, "oldline", "new line", 0)
  if GetScriptParams(LScript, 'ReplaceLine', 4, LParams) then
    begin
      //
      LOccurence := LParams[0].ToInteger;
      LText1 := RemoveDoubleQuotes(LParams[1]).Trim;
      LText2 := RemoveDoubleQuotes(LParams[2]);
      LOffset := LParams[3].ToInteger;
      Result := Self.ReplaceLine(LOccurence, LText1, LText2, LOffset);
    end
  else
  // RemoveLines(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; aCount: Cardinal)
  // RemoveLines(1, "refline", 1, 1)
  if GetScriptParams(LScript, 'RemoveLines', 4, LParams) then
    begin
      LOccurence := LParams[0].ToInteger;
      LText1 := RemoveDoubleQuotes(LParams[1]).Trim;
      LOffset := LParams[2].ToInteger;
      LCount := LParams[3].ToInteger;
      Result := Self.RemoveLines(LOccurence, LText1, LOffset, LCount);
    end
  else
  // InsertLine(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aNewLine: string)
  // InsertLine(1, "refline", 1, "new line")
  if GetScriptParams(LScript, 'InsertLine', 4, LParams) then
    begin
      LOccurence := LParams[0].ToInteger;
      LText1 := RemoveDoubleQuotes(LParams[1]).Trim;
      LOffset := LParams[2].ToInteger;
      LText2 := RemoveDoubleQuotes(LParams[3]);
      Result := Self.InsertLine(LOccurence, LText1, LOffset, LText2);
    end
  else
  //InsertTextFile(aOccurence: Cardinal; const aReferenceLine: string; aOffset: Integer; const aTextFilename: string): Boolean
  //InsertTextFile(1, "refline", -1, "textfile.txt")
  if GetScriptParams(LScript, 'InsertTextFile', 4, LParams) then
    begin
      LOccurence := LParams[0].ToInteger;
      LText1 := RemoveDoubleQuotes(LParams[1]).Trim;
      LOffset := LParams[2].ToInteger;
      LText2 := RemoveDoubleQuotes(LParams[3]).Trim;
      Result := Self.InsertTextFile(LOccurence, LText1, LOffset, LText2);
    end
  else
  //RemoveAllLines(const aStartText: string; aCount: Integer): Boolean
  //RemoveAllLines("///", 1)
  if GetScriptParams(LScript, 'RemoveAllLines', 2, LParams) then
    begin
      LText1 := RemoveDoubleQuotes(LParams[0]).Trim;
      LCount := LParams[1].ToInteger;
      Result := Self.RemoveAllLines(LText1, LCount);
    end
  else
  //RemoveLineRangeAll(const aStartLine: string; const aEndLine: string): Boolean;
  //RemoveLineRangeAll("startline", "endline")
  if GetScriptParams(LScript, 'RemoveLineRangeAll', 2, LParams) then
    begin
      LText1 := RemoveDoubleQuotes(LParams[0]).Trim;
      LText2 := RemoveDoubleQuotes(LParams[1]).Trim;
      Result := Self.RemoveLineRangeAll(LText1, LText2);
    end
  else
  //RegEx(const aPattern: string; const aValue: string; const aOperation: string): Boolean;
  //RegEx("pattern", "value", "operation")
  if GetScriptParams(LScript, 'RegEx', 3, LParams) then
    begin
      LText1 := RemoveDoubleQuotes(LParams[0]).Trim;
      LText2 := RemoveDoubleQuotes(LParams[1]).Trim;
      LText3 := RemoveDoubleQuotes(LParams[2]).Trim;
      Result := Self.RegEx(LText1, LText2, LText3);
    end
  else
  //SaveToFileEx(const aFilename: string): Boolean;
  //SaveToFileEx("filename")
  if GetScriptParams(LScript, 'SaveToFile', 1, LParams) then
    begin
      LText1 := RemoveDoubleQuotes(LParams[0]).Trim;
      Result := Self.SaveToFileEx(LText1);
    end
  else
  //LoadFromFileEx(const aFilename: string): Boolean
  //LoadFromFileEx("filename")
  if GetScriptParams(LScript, 'LoadFromFile', 1, LParams) then
    begin
      LText1 := RemoveDoubleQuotes(LParams[0]).Trim;
      Result := Self.LoadFromFileEx(LText1);
    end
  else
  //CreateDynamicImport(): Boolean
  //LoadFromFileEx()
  if GetScriptParams(LScript, 'CreateDynamicImport', 0, LParams) then
    begin
      Result := Self.CreateDynamicImport;
    end
end;

function TScriptStringList.LoadScript(const aFilename: string): Boolean;
begin
  Result := False;
  if not TFile.Exists(aFilename) then Exit;
  if FScript = nil then
    FScript := TStringList.Create;
  FScript.LoadFromFile(aFilename);
  Result := True;
end;

function TScriptStringList.AddScript(const aStrings: TStrings): Boolean;
begin
  Result := False;
  if aStrings = nil then Exit;
  if FScript = nil then
    FScript := TStringList.Create;
  FScript.AddStrings(aStrings);
  Result := True;
end;

function TScriptStringList.AddScript(const aScript: string): Boolean;
begin
  Result := False;
  if aScript.IsEmpty then Exit;
  if FScript = nil then
    FScript := TStringList.Create;
  FScript.Add(aScript);
end;

function TScriptStringList.RunScript: Boolean;
var
  LLine: string;
begin
  Result := False;
  if FScript = nil then Exit;
  for LLine in FScript do
  begin
    Evaluate(LLine);
  end;
  Result := True;
end;

{ TCleanHeader }
constructor TCleanHeader.Create;
begin
  inherited;
  FCode := TScriptStringList.Create;
end;

destructor TCleanHeader.Destroy;
begin
  FreeAndNil(FCode);
  inherited;
end;

procedure TCleanHeader.Process(const aFilename: string; aScript: TStrings);
begin
  if aFilename.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;
  FCode.Clear;
  FCode.LoadFromFile(aFilename);
  FCode.AddScript(aScript);
  FCode.RunScript;
  FCode.SaveToFile(aFilename);
end;

end.