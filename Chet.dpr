program Chet;

{$R *.dres}

uses
  Vcl.Forms,
  Form.Main in 'Forms\Form.Main.pas' {FormMain},
  Vcl.Themes,
  Vcl.Styles,
  Chet.Project in 'Classes\Chet.Project.pas',
  Chet.HeaderTranslator in 'Classes\Chet.HeaderTranslator.pas',
  Chet.SourceWriter in 'Classes\Chet.SourceWriter.pas',
  Chet.CommentWriter in 'Classes\Chet.CommentWriter.pas',
  Chet.Postprocessor in 'Classes\Chet.Postprocessor.pas',
  Form.ScriptHelp in 'Forms\Form.ScriptHelp.pas' {FormScriptHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.Title := 'Chet';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
