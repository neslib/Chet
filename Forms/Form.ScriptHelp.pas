{==============================================================================

Copyright © 2022 tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com
============================================================================= }

unit Form.ScriptHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormScriptHelp = class(TForm)
    RichEdit: TRichEdit;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormScriptHelp: TFormScriptHelp;

implementation

uses
  //Richedit,
  System.IOUtils;

{$R *.dfm}

procedure TFormScriptHelp.FormCreate(Sender: TObject);
const
  cFilename = 'ScriptHelp.rtf';
  cResname = 'CNET_SCRIPT_HELP_FILE';
var
  LFilename: string;
begin
  //
//  SendMessage(RichEdit.Handle,EM_SETTYPOGRAPHYOPTIONS,$0001 or $0002,$0001 or $0002);
  LFilename := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), cFilename);
  if not FileExists(LFilename) then
  begin
    if LongBool(FindResource(HInstance,cResname,RT_RCDATA)) then
    with TResourceStream.Create(HInstance,cResname,RT_RCDATA) do
    try
      SaveToFile(LFilename);
    finally
      Free;
    end;
  end;

  RichEdit.Font.Color := clWhite;
  RichEdit.Clear;
  if FileExists(LFilename) then
    RichEdit.Lines.LoadFromFile(LFilename);
end;

end.
