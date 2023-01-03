{==============================================================================

Copyright © 2022 tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com
============================================================================= }

unit Form.ScriptHelp;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TFormScriptHelp = class(TForm)
    RichEdit: TRichEdit;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TFormScriptHelp.FormCreate(Sender: TObject);
const
  SCRIPT_FILENAME = 'ScriptHelp.rtf';
  SCRIPT_RESNAME = 'CNET_SCRIPT_HELP_FILE';
var
  Filename: String;
  ResStream: TResourceStream;
begin
  Filename := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), SCRIPT_FILENAME);
  if (not FileExists(Filename)) then
  begin
    if LongBool(FindResource(HInstance, SCRIPT_RESNAME, RT_RCDATA)) then
    begin
      ResStream := TResourceStream.Create(HInstance, SCRIPT_RESNAME, RT_RCDATA);
      try
        ResStream.SaveToFile(Filename);
      finally
        ResStream.Free;
      end;
    end;
  end;

  RichEdit.Font.Color := clWhite;
  RichEdit.Clear;
  if FileExists(Filename) then
    RichEdit.Lines.LoadFromFile(Filename);
end;

end.
