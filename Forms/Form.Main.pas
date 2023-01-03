unit Form.Main;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  System.UITypes,
  System.IOUtils,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ButtonGroup,
  Vcl.StdCtrls,
  Vcl.WinXPanels,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.ActnList,
  Chet.Project,
  Chet.HeaderTranslator
  ;

type
  TFormMain = class(TForm)
    StatusBar: TStatusBar;
    ButtonGroupCategories: TButtonGroup;
    CardPanel: TCardPanel;
    CardProject: TCard;
    CardParseOptions: TCard;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    ActionList: TActionList;
    OpenDirectoryDialog: TFileOpenDialog;
    SaveDialogProject: TFileSaveDialog;
    CheckBoxIgnoreParseErrors: TCheckBox;
    ActionAddCmdLineArg: TAction;
    ActionAddIncludePath: TAction;
    ActionAddDefine: TAction;
    ActionDeleteCmdLineArg: TAction;
    LabelHeaderFileDirectory: TLabel;
    EditHeaderFileDirectory: TEdit;
    ButtonBrowseHeaderFileDirectory: TButton;
    CheckBoxIncludeSubdiretories: TCheckBox;
    ListBoxCmdLineArgs: TListBox;
    LabelCmdLineArgs: TLabel;
    ButtonAddCmdLineArg: TButton;
    ButtonDeleteArgument: TButton;
    ButtonAddDefine: TButton;
    ButtonAddIncludePath: TButton;
    CardTranslate: TCard;
    ButtonRunTranslator: TButton;
    ActionRunTranslator: TAction;
    MemoMessages: TMemo;
    LabelPasFile: TLabel;
    EditPasFile: TEdit;
    ButtonBrowsePasFile: TButton;
    SaveDialogPasFile: TFileSaveDialog;
    CardConversionOptions: TCard;
    LabelConvertChar: TLabel;
    ComboBoxConvertChar: TComboBox;
    LabelConvertComments: TLabel;
    ComboBoxConvertComments: TComboBox;
    LabelCallConv: TLabel;
    ComboBoxCallConv: TComboBox;
    LabelReservedWordHandling: TLabel;
    ComboBoxReservedWordHandling: TComboBox;
    CheckBoxDirectivesAsReservedWords: TCheckBox;
    LabelUnconvertibleHandling: TLabel;
    ComboBoxUnconvertibleHandling: TComboBox;
    CardPlatforms: TCard;
    LabelPlatform: TLabel;
    EditLibWin32: TEdit;
    CheckBoxWin32: TCheckBox;
    EditLibWin64: TEdit;
    CheckBoxWin64: TCheckBox;
    CheckBoxMacARM: TCheckBox;
    EditLibMacARM: TEdit;
    CheckBoxLinux64: TCheckBox;
    EditLibLinux64: TEdit;
    CheckBoxIOS: TCheckBox;
    EditLibIOS: TEdit;
    CheckBoxAndroid32: TCheckBox;
    EditLibAndroid32: TEdit;
    LabelLibrary: TLabel;
    LabelPrefix: TLabel;
    EditPrefixWin32: TEdit;
    EditPrefixWin64: TEdit;
    EditPrefixMacARM: TEdit;
    EditPrefixLinux64: TEdit;
    EditPrefixIOS: TEdit;
    EditPrefixAndroid32: TEdit;
    LabelLibConstant: TLabel;
    EditLibConstant: TEdit;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionSaveAs: TAction;
    ActionExit: TAction;
    MenuOpen: TMenuItem;
    MenuSave: TMenuItem;
    MenuSaveAs: TMenuItem;
    MenuSeparator: TMenuItem;
    MenuExit: TMenuItem;
    MenuRun: TMenuItem;
    MenuRunTranslator: TMenuItem;
    ActionNew: TAction;
    MenuNew: TMenuItem;
    OpenDialogProject: TFileOpenDialog;
    LabelEnumHandling: TLabel;
    ComboBoxEnumHandling: TComboBox;
    LabelUses: TLabel;
    EditUseUnits: TEdit;
    CardIgnore: TCard;
    LabelIgnore: TLabel;
    MemoIgnore: TMemo;
    ImageList: TImageList;
    CheckBoxMacIntel: TCheckBox;
    EditLibMacIntel: TEdit;
    EditPrefixMacIntel: TEdit;
    CheckBoxAndroid64: TCheckBox;
    EditLibAndroid64: TEdit;
    EditPrefixAndroid64: TEdit;
    LabelConvertUnsignedChar: TLabel;
    ComboBoxConvertUnsignedChar: TComboBox;
    CheckBoxDelayedLoading: TCheckBox;
    CheckBoxPrefixSymbolsWithUnderscore: TCheckBox;
    PostProcess: TCard;
    ScriptMemo: TMemo;
    ButtonClearScript: TButton;
    ButtonScriptHelp: TButton;
    LabelIgnoredHeaders: TLabel;
    EditIgnoredHeaders: TEdit;
    LabelCustomTypes: TLabel;
    MemoCustomTypesMap: TMemo;
    procedure ButtonGroupCategoriesButtonClicked(Sender: TObject; Index: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionAddCmdLineArgExecute(Sender: TObject);
    procedure EditHeaderFileDirectoryChange(Sender: TObject);
    procedure ButtonBrowseHeaderFileDirectoryClick(Sender: TObject);
    procedure CheckBoxIncludeSubdiretoriesClick(Sender: TObject);
    procedure CheckBoxIgnoreParseErrorsClick(Sender: TObject);
    procedure ActionAddDefineExecute(Sender: TObject);
    procedure ActionAddIncludePathExecute(Sender: TObject);
    procedure ListBoxCmdLineArgsClick(Sender: TObject);
    procedure ActionDeleteCmdLineArgExecute(Sender: TObject);
    procedure ActionRunTranslatorExecute(Sender: TObject);
    procedure ButtonBrowsePasFileClick(Sender: TObject);
    procedure EditPasFileChange(Sender: TObject);
    procedure ComboBoxConvertCharChange(Sender: TObject);
    procedure ComboBoxConvertCommentsChange(Sender: TObject);
    procedure ComboBoxCallConvChange(Sender: TObject);
    procedure ComboBoxReservedWordHandlingChange(Sender: TObject);
    procedure CheckBoxDirectivesAsReservedWordsClick(Sender: TObject);
    procedure ComboBoxUnconvertibleHandlingChange(Sender: TObject);
    procedure CheckBoxPlatformClick(Sender: TObject);
    procedure EditLibraryNameChange(Sender: TObject);
    procedure EditPrefixChange(Sender: TObject);
    procedure EditLibConstantChange(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionSaveAsExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure ComboBoxEnumHandlingChange(Sender: TObject);
    procedure EditUseUnitsChange(Sender: TObject);
    procedure MemoIgnoreExit(Sender: TObject);
    procedure ComboBoxConvertUnsignedCharChange(Sender: TObject);
    procedure CheckBoxDelayedLoadingClick(Sender: TObject);
    procedure CheckBoxPrefixSymbolsWithUnderscoreClick(Sender: TObject);
    procedure ButtonClearScriptClick(Sender: TObject);
    procedure ButtonScriptHelpClick(Sender: TObject);    
    procedure EditIgnoredHeadersChange(Sender: TObject);
    procedure MemoCustomTypesMapChange(Sender: TObject);
  private
    { Private declarations }
    FProject: TProject;
    FPlatformEnabled: array [TPlatformType] of TCheckBox;
    FPlatformLibraryName: array [TPlatformType] of TEdit;
    FPlatformPrefix: array [TPlatformType] of TEdit;
    procedure NewProject(const AProjectName: String);
    function CheckSave: Boolean;
    function Save: Boolean;
    function SaveAs: Boolean;
    procedure Load(const AFilename: String);
    procedure SetControls;
    procedure SetPlatformControls;
    procedure UpdateCaption;
    procedure UpdateControls;
    procedure UpdatePlatformControls; overload;
    procedure UpdatePlatformControls(const APlatform: TPlatformType); overload;
    procedure AddCommandLineArgument(const AArgument: String);
    procedure ConfigError(const AMessage: String;
      const AControlToFocus: TWinControl = nil);
    procedure HandleTranslatorMessage(const AMessage: String);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
uses
  Chet.Postprocessor, Form.ScriptHelp;

procedure TFormMain.ActionAddCmdLineArgExecute(Sender: TObject);
begin
  AddCommandLineArgument(InputBox('Add command line argument', 'Argument', ''));
end;

procedure TFormMain.ActionAddDefineExecute(Sender: TObject);
var
  Define: String;
begin
  Define := InputBox('Add preprocessor definition', 'Define', '').Trim;
  if (Define <> '') then
    AddCommandLineArgument('-D' + Define);
end;

procedure TFormMain.ActionAddIncludePathExecute(Sender: TObject);
begin
  OpenDirectoryDialog.Title := 'Select include directory';
  if OpenDirectoryDialog.Execute then
    AddCommandLineArgument('-I' + OpenDirectoryDialog.FileName);
end;

procedure TFormMain.ActionDeleteCmdLineArgExecute(Sender: TObject);
var
  I: Integer;
begin
  I := ListBoxCmdLineArgs.ItemIndex;
  if (I >= 0) then
  begin
    FProject.DeleteCmdLineArg(I);
    ListBoxCmdLineArgs.Items.Delete(I);
    UpdateControls;
  end;
end;

procedure TFormMain.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ActionNewExecute(Sender: TObject);
var
  ProjectName: String;
begin
  if CheckSave then
  begin
    ProjectName := InputBox('Enter name for project', 'Project name', '').Trim;
    if (ProjectName <> '') then
      NewProject(ProjectName);
  end;
end;

procedure TFormMain.ActionOpenExecute(Sender: TObject);
begin
  if CheckSave and OpenDialogProject.Execute then
    Load(OpenDialogProject.FileName);
end;

procedure TFormMain.ActionRunTranslatorExecute(Sender: TObject);
var
  Translator: THeaderTranslator;
  Directory: String;
  PT: TPlatformType;
  P: TPlatform;
  PlatformCount: Integer;
begin
  if (FProject.HeaderFileDirectory <> '') and (not TDirectory.Exists(FProject.HeaderFileDirectory)) then
  begin
    ConfigError('Header file directory does not exist', EditHeaderFileDirectory);
    Exit;
  end;

  if (FProject.TargetPasFile = '') then
  begin
    ConfigError('Target Pascal file not provided', EditPasFile);
    Exit;
  end;

  Directory := TPath.GetDirectoryName(FProject.TargetPasFile);
  if (Directory <> '') and (not TDirectory.Exists(Directory)) then
  begin
    ConfigError('Directory for target Pascal file does not exist', EditPasFile);
    Exit;
  end;

  if (FProject.LibraryConstant = '') then
  begin
    ConfigError('Library constant not specified', EditLibConstant);
    Exit;
  end;

  PlatformCount := 0;
  for PT := Low(TPlatformType) to High(TPlatformType) do
  begin
    P := FProject.Platforms[PT];
    if (P.Enabled) then
    begin
      if (P.LibraryName = '') then
      begin
        ConfigError('Library name for platform not specified', FPlatformLibraryName[PT]);
        Exit;
      end;
      Inc(PlatformCount);
    end;
  end;

  if (PlatformCount = 0) then
  begin
    ConfigError('At least 1 platform must be enabled', CheckBoxWin32);
    Exit;
  end;

  CardPanel.ActiveCard := CardTranslate;
  ButtonGroupCategories.ItemIndex := CardTranslate.CardIndex;
  MemoMessages.Clear;
  Application.ProcessMessages; // Ugh
  Translator := THeaderTranslator.Create(FProject);
  try
    Translator.OnMessage := HandleTranslatorMessage;
    Translator.Run;
    TFilePostProcessor.Execute(FProject, ScriptMemo.Lines);
  finally
    Translator.Free;
  end;
end;

procedure TFormMain.ActionSaveAsExecute(Sender: TObject);
begin
  SaveAs;
end;

procedure TFormMain.ActionSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TFormMain.AddCommandLineArgument(const AArgument: String);
var
  Arg: String;
begin
  Arg := AArgument.Trim;
  if (Arg <> '') then
  begin
    FProject.AddCmdLineArg(Arg);
    ListBoxCmdLineArgs.Items.Add(Arg)
  end;
end;

procedure TFormMain.ButtonBrowseHeaderFileDirectoryClick(Sender: TObject);
begin
  OpenDirectoryDialog.Title := 'Select header file directory';
  if OpenDirectoryDialog.Execute then
    EditHeaderFileDirectory.Text := OpenDirectoryDialog.FileName;
end;

procedure TFormMain.ButtonBrowsePasFileClick(Sender: TObject);
begin
  if SaveDialogPasFile.Execute then
    EditPasFile.Text := SaveDialogPasFile.FileName;
end;

procedure TFormMain.ButtonClearScriptClick(Sender: TObject);
begin
  ScriptMemo.Clear;
end;

procedure TFormMain.ButtonScriptHelpClick(Sender: TObject);
var
  LForm: TFormScriptHelp;
begin
  LForm := TFormScriptHelp.Create(nil);
  try
    LForm.ShowModal;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TFormMain.ButtonGroupCategoriesButtonClicked(Sender: TObject;
  Index: Integer);
begin
  CardPanel.ActiveCardIndex := Index;
end;

procedure TFormMain.CheckBoxDelayedLoadingClick(Sender: TObject);
begin
  FProject.DelayedLoading := CheckBoxDelayedLoading.Checked;
end;

procedure TFormMain.CheckBoxDirectivesAsReservedWordsClick(Sender: TObject);
begin
  FProject.TreatDirectivesAsReservedWords := CheckBoxDirectivesAsReservedWords.Checked;
end;

procedure TFormMain.CheckBoxIgnoreParseErrorsClick(Sender: TObject);
begin
  FProject.IgnoreParseErrors := CheckBoxIgnoreParseErrors.Checked;
end;

procedure TFormMain.CheckBoxIncludeSubdiretoriesClick(Sender: TObject);
begin
  FProject.IncludeSubdirectories := CheckBoxIncludeSubdiretories.Checked;
end;

procedure TFormMain.CheckBoxPlatformClick(Sender: TObject);
var
  CB: TCheckBox;
  PT: TPlatformType;
begin
  CB := Sender as TCheckBox;
  PT := TPlatformType(CB.Tag);
  FProject.Platforms[PT].Enabled := CB.Checked;
  UpdatePlatformControls(PT);
end;

procedure TFormMain.CheckBoxPrefixSymbolsWithUnderscoreClick(Sender: TObject);
begin
  {$IFDEF EXPERIMENTAL}
  FProject.PrefixSymbolsWithUnderscore := CheckBoxPrefixSymbolsWithUnderscore.Checked;
  {$ENDIF}
end;

function TFormMain.CheckSave: Boolean;
begin
  if (not FProject.Modified) then
    Exit(True);

  case MessageDlg('Project has been modified.' + sLineBreak + 'Do you want to save the changes?',
    TMsgDlgType.mtConfirmation, mbYesNoCancel, 0)
  of
    mrYes:
      Result := Save;

    mrNo:
      Result := True;
  else
    Result := False;
  end;
end;

procedure TFormMain.ComboBoxCallConvChange(Sender: TObject);
begin
  FProject.CallConv := TCallConv(ComboBoxCallConv.ItemIndex);
end;

procedure TFormMain.ComboBoxConvertCharChange(Sender: TObject);
begin
  FProject.CharConvert := TCharConvert(ComboBoxConvertChar.ItemIndex);
end;

procedure TFormMain.ComboBoxConvertUnsignedCharChange(Sender: TObject);
begin
  FProject.UnsignedCharConvert := TUnsignedCharConvert(ComboBoxConvertUnsignedChar.ItemIndex);
end;

procedure TFormMain.ComboBoxConvertCommentsChange(Sender: TObject);
begin
  FProject.CommentConvert := TCommentConvert(ComboBoxConvertComments.ItemIndex);
end;

procedure TFormMain.ComboBoxEnumHandlingChange(Sender: TObject);
begin
  FProject.EnumHandling := TEnumHandling(ComboBoxEnumHandling.ItemIndex);
end;

procedure TFormMain.ComboBoxReservedWordHandlingChange(Sender: TObject);
begin
  FProject.ReservedWordHandling := TReservedWordHandling(ComboBoxReservedWordHandling.ItemIndex);
end;

procedure TFormMain.ComboBoxUnconvertibleHandlingChange(Sender: TObject);
begin
  FProject.UnconvertibleHandling := TUnconvertibleHandling(ComboBoxUnconvertibleHandling.ItemIndex);
end;

procedure TFormMain.ConfigError(const AMessage: String;
  const AControlToFocus: TWinControl);
var
  C: TWinControl;
begin
  C := AControlToFocus;
  while (C <> nil) do
  begin
    if (C is TCard) then
    begin
      CardPanel.ActiveCard := TCard(C);
      ButtonGroupCategories.ItemIndex := TCard(C).CardIndex;
      FocusControl(AControlToFocus);
      Break;
    end;
    C := C.Parent;
  end;

  ShowMessage(AMessage);
end;

constructor TFormMain.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  {$IFDEF EXPERIMENTAL}
  CheckBoxPrefixSymbolsWithUnderscore.Visible := True;
  {$ENDIF}
  FProject := TProject.Create;
  CardPanel.ActiveCardIndex := 0;

  FPlatformEnabled[TPlatformType.Win32] := CheckBoxWin32;
  FPlatformEnabled[TPlatformType.Win64] := CheckBoxWin64;
  FPlatformEnabled[TPlatformType.MacARM] := CheckBoxMacARM;
  FPlatformEnabled[TPlatformType.MacIntel] := CheckBoxMacIntel;
  FPlatformEnabled[TPlatformType.Linux64] := CheckBoxLinux64;
  FPlatformEnabled[TPlatformType.iOS] := CheckBoxIOS;
  FPlatformEnabled[TPlatformType.Android32] := CheckBoxAndroid32;
  FPlatformEnabled[TPlatformType.Android64] := CheckBoxAndroid64;

  FPlatformLibraryName[TPlatformType.Win32] := EditLibWin32;
  FPlatformLibraryName[TPlatformType.Win64] := EditLibWin64;
  FPlatformLibraryName[TPlatformType.MacARM] := EditLibMacARM;
  FPlatformLibraryName[TPlatformType.MacIntel] := EditLibMacIntel;
  FPlatformLibraryName[TPlatformType.Linux64] := EditLibLinux64;
  FPlatformLibraryName[TPlatformType.iOS] := EditLibIOS;
  FPlatformLibraryName[TPlatformType.Android32] := EditLibAndroid32;
  FPlatformLibraryName[TPlatformType.Android64] := EditLibAndroid64;

  FPlatformPrefix[TPlatformType.Win32] := EditPrefixWin32;
  FPlatformPrefix[TPlatformType.Win64] := EditPrefixWin64;
  FPlatformPrefix[TPlatformType.MacARM] := EditPrefixMacARM;
  FPlatformPrefix[TPlatformType.MacIntel] := EditPrefixMacIntel;
  FPlatformPrefix[TPlatformType.Linux64] := EditPrefixLinux64;
  FPlatformPrefix[TPlatformType.iOS] := EditPrefixIOS;
  FPlatformPrefix[TPlatformType.Android32] := EditPrefixAndroid32;
  FPlatformPrefix[TPlatformType.Android64] := EditPrefixAndroid64;

  if (ParamCount > 0) then
    Load(ParamStr(1));
  MemoCustomTypesMap.Hint := 'Input format: CTypeName=DelphiTypeName.'#13#10'Use CTRL + ENTER to insert new line.';
  MemoCustomTypesMap.OnChange := MemoCustomTypesMapChange;
end;

destructor TFormMain.Destroy;
begin
  FProject.Free;
  inherited;
end;

procedure TFormMain.EditHeaderFileDirectoryChange(Sender: TObject);
begin
  FProject.HeaderFileDirectory := EditHeaderFileDirectory.Text;
end;

procedure TFormMain.EditIgnoredHeadersChange(Sender: TObject);
begin
  FProject.IgnoredFiles := EditIgnoredHeaders.Text;
end;

procedure TFormMain.EditLibConstantChange(Sender: TObject);
begin
  FProject.LibraryConstant := EditLibConstant.Text;
end;

procedure TFormMain.EditLibraryNameChange(Sender: TObject);
var
  Edit: TEdit;
  PT: TPlatformType;
begin
  Edit := Sender as TEdit;
  PT := TPlatformType(Edit.Tag);
  FProject.Platforms[PT].LibraryName := Edit.Text;
end;

procedure TFormMain.EditPasFileChange(Sender: TObject);
begin
  FProject.TargetPasFile := EditPasFile.Text;
end;

procedure TFormMain.EditPrefixChange(Sender: TObject);
var
  Edit: TEdit;
  PT: TPlatformType;
begin
  Edit := Sender as TEdit;
  PT := TPlatformType(Edit.Tag);
  FProject.Platforms[PT].Prefix := Edit.Text;
end;

procedure TFormMain.EditUseUnitsChange(Sender: TObject);
begin
  FProject.UseUnits := EditUseUnits.Text;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (not CheckSave) then
    CanClose := False;
end;

procedure TFormMain.HandleTranslatorMessage(const AMessage: String);
begin
  MemoMessages.Lines.Add(AMessage);
end;

procedure TFormMain.ListBoxCmdLineArgsClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TFormMain.Load(const AFilename: String);
begin
  if (not TFile.Exists(AFilename)) then
  begin
    ShowMessage('Cannot load ' + AFilename + '.' + sLineBreak + 'File does not exist.');
    Exit;
  end;

  CheckSave;
  FProject.Load(AFilename);
  SetControls;
end;

procedure TFormMain.MemoCustomTypesMapChange(Sender: TObject);
begin
  FProject.CustomCTypesMap := MemoCustomTypesMap.Lines.CommaText.Trim;
end;

procedure TFormMain.MemoIgnoreExit(Sender: TObject);
begin
  FProject.SymbolsToIgnore := MemoIgnore.Lines;
end;

procedure TFormMain.NewProject(const AProjectName: String);
begin
  FProject.New(AProjectName);
  SaveDialogProject.FileName := FProject.ProjectFilename;
  SetControls;
end;

function TFormMain.Save: Boolean;
begin
  if (FProject.ProjectFilename = '') then
    Exit(SaveAs);
  FProject.Script := ScriptMemo.Lines.Text;
  FProject.Save(FProject.ProjectFilename);
  Result := True;
end;

function TFormMain.SaveAs: Boolean;
begin
  Result := SaveDialogProject.Execute;
  if (Result) then
  begin
    FProject.Script := ScriptMemo.Lines.Text;
    FProject.Save(SaveDialogProject.FileName);
    UpdateCaption;
  end;
end;

procedure TFormMain.SetControls;
begin
  EditHeaderFileDirectory.Text := FProject.HeaderFileDirectory;
  CheckBoxIncludeSubdiretories.Checked := FProject.IncludeSubdirectories;
  EditIgnoredHeaders.Text := FProject.IgnoredFiles;
  EditPasFile.Text := FProject.TargetPasFile;
  EditUseUnits.Text := FProject.UseUnits;

  CheckBoxIgnoreParseErrors.Checked := FProject.IgnoreParseErrors;
  ListBoxCmdLineArgs.Items.DelimitedText := FProject.DelimitedCmdLineArgs;

  ComboBoxCallConv.ItemIndex := Ord(FProject.CallConv);
  ComboBoxConvertChar.ItemIndex := Ord(FProject.CharConvert);
  ComboBoxConvertUnsignedChar.ItemIndex := Ord(FProject.UnsignedCharConvert);
  ComboBoxConvertComments.ItemIndex := Ord(FProject.CommentConvert);
  ComboBoxReservedWordHandling.ItemIndex := Ord(FProject.ReservedWordHandling);
  CheckBoxDirectivesAsReservedWords.Checked := FProject.TreatDirectivesAsReservedWords;
  {$IFDEF EXPERIMENTAL}
  CheckBoxPrefixSymbolsWithUnderscore.Checked := FProject.PrefixSymbolsWithUnderscore;
  {$ENDIF}
  CheckBoxDelayedLoading.Checked := FProject.DelayedLoading;
  ComboBoxEnumHandling.ItemIndex := Ord(FProject.EnumHandling);
  ComboBoxUnconvertibleHandling.ItemIndex := Ord(FProject.UnconvertibleHandling);

  MemoIgnore.Lines := FProject.SymbolsToIgnore;
  ScriptMemo.Lines.Text := FProject.Script;  
  MemoCustomTypesMap.Lines.Commatext := FProject.CustomCTypesMap;

  EditLibConstant.Text := FProject.LibraryConstant;
  
  SetPlatformControls;

  UpdateCaption;
  UpdateControls;
  UpdatePlatformControls;

  CardPanel.ActiveCard := CardProject;
  ButtonGroupCategories.ItemIndex := 0;
end;

procedure TFormMain.SetPlatformControls;
var
  PT: TPlatformType;
  P: TPlatform;
begin
  for PT := Low(TPlatformType) to High(TPlatformType) do
  begin
    P := FProject.Platforms[PT];
    FPlatformEnabled[PT].Checked := P.Enabled;
    FPlatformLibraryName[PT].Text := P.LibraryName;
    FPlatformPrefix[PT].Text := P.Prefix;
  end;
end;

procedure TFormMain.UpdateCaption;
var
  Filename: String;
begin
  Filename := ExtractFileName(FProject.ProjectFilename);
  if (Filename = '') then
    Caption := 'Chet - C header translator'
  else
    Caption := ExtractFileName(FProject.ProjectFilename) + ' - Chet';
end;

procedure TFormMain.UpdateControls;
begin
  ActionDeleteCmdLineArg.Enabled := (ListBoxCmdLineArgs.ItemIndex >= 0);
end;

procedure TFormMain.UpdatePlatformControls;
var
  P: TPlatformType;
begin
  for P := Low(TPlatformType) to High(TPlatformType) do
    UpdatePlatformControls(P);
end;

procedure TFormMain.UpdatePlatformControls(const APlatform: TPlatformType);
var
  B: Boolean;
begin
  B := FPlatformEnabled[APlatform].Checked;
  FPlatformLibraryName[APlatform].Enabled := B;
  FPlatformPrefix[APlatform].Enabled := B;
end;

end.
