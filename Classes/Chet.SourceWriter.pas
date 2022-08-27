unit Chet.SourceWriter;

interface

uses
  System.Classes,
  System.SysUtils;

type
  { Class for writing Pascal source code }
  TSourceWriter = class
  {$REGION 'Internal Declarations'}
  private
    FWriter: TStreamWriter;
    FIndent: String;
    FSection: String;
    FNeedIndent: Boolean;
    FLastLineEmpty: Boolean;
  {$ENDREGION 'Internal Declarations'}
  public
    { Constructor.

      Parameters:
        APasFilename: name of the Pascal file to generate. }
    constructor Create(const APasFilename: String);
    destructor Destroy; override;

    { Starts a section with grouped declarations, such as a 'const', 'type'
      or 'uses' section.

      Parameters:
        ASection: name of the section.

      The section will actually only be started if any text is written before
      EndSection is called. }
    procedure StartSection(const ASection: String);

    { Ends a section started with StartSection. }
    procedure EndSection;

    { Increases indentation level with two spaces. }
    procedure Indent;

    { Decreases indentation level by two spaces. }
    procedure Outdent;

    { Writes a string.

      Parameters:
        AValue: the string to write.
        AArgs: (optional) arguments in case AValue is a format string. }
    procedure Write(const AValue: String); overload;
    procedure Write(const AValue: String; const AArgs: array of const); overload;

    { Writes a single new line. }
    procedure WriteLn; overload;

    { Writes a string followed by a new line.

      Parameters:
        AValue: the string to write.
        AArgs: (optional) arguments in case AValue is a format string. }
    procedure WriteLn(const AValue: String); overload;
    procedure WriteLn(const AValue: String; const AArgs: array of const); overload;

    { Whether the writer is currently at the start of a section. }
    function IsAtSectionStart: Boolean;

    { The current indentation level. }
    property CurrentIndent: String read FIndent;
  end;

implementation

{ TSourceWriter }

constructor TSourceWriter.Create(const APasFilename: String);
begin
  inherited Create;
  FWriter := TStreamWriter.Create(APasFilename);
end;

destructor TSourceWriter.Destroy;
begin
  FWriter.Free;
  inherited;
end;

procedure TSourceWriter.EndSection;
begin
  if (FSection = '') then
  begin
    { We did write the section }
    WriteLn;
    FIndent := '';
    FNeedIndent := False;
  end;
  FSection := '';
end;

procedure TSourceWriter.Indent;
begin
  FIndent := FIndent + '  ';
end;

function TSourceWriter.IsAtSectionStart: Boolean;
begin
  Result := (FSection <> '');
end;

procedure TSourceWriter.Outdent;
begin
  if (FIndent <> '') then
    FIndent := FIndent.Substring(2);
end;

procedure TSourceWriter.StartSection(const ASection: String);
begin
  FSection := ASection;
end;

procedure TSourceWriter.WriteLn;
begin
  if (not FLastLineEmpty) then
    FWriter.WriteLine;

  FLastLineEmpty := True;
end;

procedure TSourceWriter.Write(const AValue: String;
  const AArgs: array of const);
begin
  Write(Format(AValue, AArgs));
end;

procedure TSourceWriter.Write(const AValue: String);
begin
  if (FSection <> '') then
  begin
    FWriter.WriteLine(FSection);
    FSection := '';
    FIndent := '  ';
    FNeedIndent := True;
  end;

  if (FNeedIndent) and (FIndent <> '') then
  begin
    FWriter.Write(FIndent);
    FNeedIndent := False;
  end;

  FWriter.Write(AValue);
  FLastLineEmpty := False;
end;

procedure TSourceWriter.WriteLn(const AValue: String;
  const AArgs: array of const);
begin
  Write(Format(AValue, AArgs));
  Write(sLineBreak);
  FNeedIndent := True;
end;

procedure TSourceWriter.WriteLn(const AValue: String);
begin
  Write(AValue);
  Write(sLineBreak);
  FNeedIndent := True;
end;

end.
