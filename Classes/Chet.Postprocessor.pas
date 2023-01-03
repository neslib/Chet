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
    procedure Process(const AFilename: String; const AScript: TStrings);
    class procedure Execute(const AProject: TProject;
      const AScript: TStrings); static;
  end;

implementation

uses
  Winapi.Windows,
  ScriptStringList;

{ TFilePostProcessor }

constructor TFilePostProcessor.Create;
begin
  inherited;
  FScripts := TScriptStringList.Create;
end;

destructor TFilePostProcessor.Destroy;
begin
  FScripts.Free;
  inherited;
end;

class procedure TFilePostProcessor.Execute(const AProject: TProject;
  const AScript: TStrings);
var
  CleanHeader: TFilePostProcessor;
  CurDir, ProjDir: String;
begin
  CleanHeader := TFilePostProcessor.Create;
  try
    CurDir := TDirectory.GetCurrentDirectory;
    try
      ProjDir := AProject.ProjectFilename;
      if (not ProjDir.IsEmpty) then
      begin
        ProjDir := TPath.GetDirectoryName(ProjDir);
        TDirectory.SetCurrentDirectory(ProjDir);
        CleanHeader.Process(AProject.TargetPasFile, AScript);
      end;
    finally
      TDirectory.SetCurrentDirectory(CurDir);
    end;
  finally
    CleanHeader.Free;
  end;
end;

procedure TFilePostProcessor.Process(const AFilename: String;
  const AScript: TStrings);
begin
  if (AFilename.IsEmpty) or (not TFile.Exists(AFilename)) then
    Exit;

  TScriptStringList(FScripts).Clear;
  FScripts.LoadFromFile(AFilename);
  TScriptStringList(FScripts).AddScript(AScript);
  TScriptStringList(FScripts).RunScript;
  FScripts.SaveToFile(AFilename);
end;

end.
