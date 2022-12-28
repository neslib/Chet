unit Chet.Postprocessor;

interface

uses
  System.Types,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.StrUtils,
  Chet.Project;

type
  { TFilePostProcessor }

  TFilePostProcessor = class
  protected
    FScripts: TStrings;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Process(const aFilename: string; aScript: TStrings);
    class procedure Execute(aProject: TProject; aScript: TStrings);
  end;

implementation

uses
  Windows, ScriptStringList;

{ TFilePostProcessor }
constructor TFilePostProcessor.Create;
begin
  inherited;
  FScripts := TScriptStringList.Create;
end;

destructor TFilePostProcessor.Destroy;
begin
  FreeAndNil(FScripts);
  inherited;
end;

class procedure TFilePostProcessor.Execute(aProject: TProject; aScript: TStrings);
var
  LCleanHeader: TFilePostProcessor;
  LCurDir,LProjDir: string;
begin
  LCleanHeader := TFilePostProcessor.Create;
  try
    LCurDir := TDirectory.GetCurrentDirectory;
    try
      LProjDir := aProject.ProjectFilename;
      if not LProjDir.IsEmpty then
      begin
        LProjDir := TPath.GetDirectoryName(LProjDir);
        TDirectory.SetCurrentDirectory(LProjDir);
        LCleanHeader.Process(aProject.TargetPasFile, aScript);
      end;
    finally
      TDirectory.SetCurrentDirectory(LCurDir);
    end;
  finally
    FreeAndNil(LCleanHeader);
  end;
end;

procedure TFilePostProcessor.Process(const aFilename: string; aScript: TStrings);
begin
  if aFilename.IsEmpty or not TFile.Exists(aFilename) then Exit;

  TScriptStringList(FScripts).Clear;
  FScripts.LoadFromFile(aFilename);
  TScriptStringList(FScripts).AddScript(aScript);
  TScriptStringList(FScripts).RunScript;
  FScripts.SaveToFile(aFilename);
end;

end.
