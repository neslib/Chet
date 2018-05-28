unit Chet.CommentWriter;

interface

uses
  System.Classes,
  System.SysUtils,
  {$IFDEF DEBUG}
  System.Generics.Collections,
  {$ENDIF}
  Neslib.Clang,
  Neslib.Clang.Api,
  Chet.SourceWriter;

type
  { Abstract base class for writing and converting documentation comments.
    The following derived classes are used:
    * TNullCommentWriter: does not write any comments (strips all comments).
    * TCopyCommentWriter: writes comments without conversion.
    * TXmlDocCommentWriter: converts comments to XmlDoc format.
    * TPasDocCommentWriter: converts comments to PasDoc format. }
  TCommentWriter = class abstract
  {$REGION 'Internal Declarations'}
  protected
    FWriter: TSourceWriter; // Reference
    FLines: TStringList;
  {$ENDREGION 'Internal Declarations'}
  public
    { Constructor.

      Parameters:
        ASourceWriter: the writer to write the comments to. }
    constructor Create(const ASourceWriter: TSourceWriter);
    destructor Destroy; override;

    { Writes a comment for a given cursor.

      Parameters:
        ACursor: the Clang cursor which may contain documentation comments to
          write.. }
    procedure WriteComment(const ACursor: TCursor); virtual; abstract;
  end;

type
  { Writer that does not write (or strips all) comments. }
  TNullCommentWriter = class(TCommentWriter)
  public
    procedure WriteComment(const ACursor: TCursor); override;
  end;

type
  { Writer that writes comments without conversion.
    Comments will remain in their original Doxygen format. }
  TCopyCommentWriter = class(TCommentWriter)
  public
    procedure WriteComment(const ACursor: TCursor); override;
  end;

type
  { Abstract base class for TXmlDocCommentWriter and TPasDocCommentWriter. }
  TParsedCommentWriter = class abstract(TCommentWriter)
  {$REGION 'Internal Declarations'}
  private
    FBuilder: TStringBuilder;
    FPrefix: String;
    FState: (Initial, InSummary, InCommand, FinishedCommand, InRemarks);
    FLastLineEmpty: Boolean;
    FNeedToTrimLeft: Boolean;
    {$IFDEF DEBUG}
    FUnusedCommands: TDictionary<String, Integer>;
    {$ENDIF}
  private
    class function IsBlockComment(const AComment: TComment): Boolean; static;
  protected
    procedure AppendRaw(const AText: String);
    procedure Append(const AText: String); overload;
    procedure Append(const AText: String; const AArgs: array of const); overload;
    procedure AppendLine;
    procedure TrimRight; overload;
    function TrimRight(const AText: String): Boolean; overload;
  protected
    procedure WriteChildren(const AComment: TComment);
    procedure WriteNode(const AComment, APrevSibling: TComment; var AInList: Boolean);
    procedure EndSummaryOrRemarks;
  protected
    function BeginComment: String; virtual; abstract;
    procedure EndComment; virtual; abstract;
    procedure BeginSummary; virtual; abstract;
    procedure EndSummary; virtual; abstract;
    procedure BeginRemarks; virtual; abstract;
    procedure EndRemarks; virtual; abstract;
    procedure BeginParam(const AParamName: String); virtual; abstract;
    procedure EndParam; virtual; abstract;
    procedure BeginReturns; virtual; abstract;
    procedure EndReturns; virtual; abstract;
    procedure BeginList; virtual; abstract;
    procedure EndList; virtual; abstract;
    procedure BeginListItem; virtual; abstract;
    procedure EndListItem; virtual; abstract;
    procedure BeginVerbatim; virtual; abstract;
    procedure EndVerbatim; virtual; abstract;
    procedure InlineCode(const ACode: String); virtual; abstract;
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create(const ASourceWriter: TSourceWriter);
    destructor Destroy; override;
    procedure WriteComment(const ACursor: TCursor); override;
  end;

type
  { Writer that converts comments to XmlDoc format. }
  TXmlDocCommentWriter = class(TParsedCommentWriter)
  {$REGION 'Internal Declarations'}
  protected
    function BeginComment: String; override;
    procedure EndComment; override;
    procedure BeginSummary; override;
    procedure EndSummary; override;
    procedure BeginRemarks; override;
    procedure EndRemarks; override;
    procedure BeginParam(const AParamName: String); override;
    procedure EndParam; override;
    procedure BeginReturns; override;
    procedure EndReturns; override;
    procedure BeginList; override;
    procedure EndList; override;
    procedure BeginListItem; override;
    procedure EndListItem; override;
    procedure BeginVerbatim; override;
    procedure EndVerbatim; override;
    procedure InlineCode(const ACode: String); override;
  {$ENDREGION 'Internal Declarations'}
  end;

type
  { Writer that converts comments to PasDoc format. }
  TPasDocCommentWriter = class(TParsedCommentWriter)
  {$REGION 'Internal Declarations'}
  protected
    function BeginComment: String; override;
    procedure EndComment; override;
    procedure BeginSummary; override;
    procedure EndSummary; override;
    procedure BeginRemarks; override;
    procedure EndRemarks; override;
    procedure BeginParam(const AParamName: String); override;
    procedure EndParam; override;
    procedure BeginReturns; override;
    procedure EndReturns; override;
    procedure BeginList; override;
    procedure EndList; override;
    procedure BeginListItem; override;
    procedure EndListItem; override;
    procedure BeginVerbatim; override;
    procedure EndVerbatim; override;
    procedure InlineCode(const ACode: String); override;
  {$ENDREGION 'Internal Declarations'}
  end;

implementation

{$IFDEF DEBUG}
uses
  Winapi.Windows;
{$ENDIF}

{ TCommentWriter }

constructor TCommentWriter.Create(const ASourceWriter: TSourceWriter);
begin
  Assert(Assigned(ASourceWriter));
  inherited Create;
  FWriter := ASourceWriter;
  FLines := TStringList.Create;
end;

destructor TCommentWriter.Destroy;
begin
  FLines.Free;
  inherited;
end;

{ TNullCommentWriter }

procedure TNullCommentWriter.WriteComment(const ACursor: TCursor);
begin
  { Don't write comment }
end;

{ TCopyCommentWriter }

procedure TCopyCommentWriter.WriteComment(const ACursor: TCursor);
var
  Comment: String;
  Line: String;
  I, J: Integer;
  IsBlockComment: Boolean;
begin
  if (ACursor.IsNull) then
    Exit;

  Comment := ACursor.RawComment;
  if (Comment = '') then
    Exit;

  IsBlockComment := Comment.StartsWith('/*');
  if IsBlockComment then
  begin
    // "*)" in the comment is invalid. Replace it with "* )"
    Comment := Comment.Replace('*)', '* )', [rfReplaceAll]);
    Comment[Low(String)] := '(';
    if (Comment.EndsWith('*/')) then
      Comment[Low(String) + Comment.Length - 1] := ')';
  end;

  // Delete "<" at start of comment
  if (Comment.Chars[3] = '<') then
    Comment := Comment.Remove(3, 1);

  FLines.Text := Comment;
  FWriter.WriteLn(FLines[0]);
  for I := 1 to FLines.Count - 1 do
  begin
    Line := FLines[I].TrimRight;

    { Try to fix indentation. If comment block starts with '/*' and line (after
      trimming) starts with '*', then align the '*' }
    if IsBlockComment then
    begin
      Line := Line.Trim;
      if (Line <> '') and (Line.Chars[0] = '*') then
        Line := ' ' + Line
      else
        Line := FLines[I];
    end;

    if (Line.TrimLeft.StartsWith('/*')) then
    begin
      J := Line.IndexOf('/*');
      Line[Low(String) + J] := '(';
    end;

    if (Line.EndsWith('*/')) then
      Line[Low(String) + Line.Length - 1] := ')';

    FWriter.WriteLn(Line);
  end;
end;

{ TParsedCommentWriter }

procedure TParsedCommentWriter.Append(const AText: String);
var
  S: String;
begin
  if (AText = '') then
    Exit;

  S := AText.Replace('*)', '* )');
  if (FLastLineEmpty) then
    FBuilder.Append(FPrefix).Append(S.TrimLeft)
  else if (FNeedToTrimLeft) then
  begin
    FBuilder.Append(S.TrimLeft);
    FNeedToTrimLeft := False;
  end
  else if (S.Chars[0] = ' ') and (FBuilder.Chars[FBuilder.Length - 1] = ' ') then
    FBuilder.Append(S.Substring(1))
  else
    FBuilder.Append(S);

  FLastLineEmpty := False;
end;

procedure TParsedCommentWriter.Append(const AText: String;
  const AArgs: array of const);
begin
  Append(Format(AText, AArgs));
end;

procedure TParsedCommentWriter.AppendLine;
begin
  if (not FLastLineEmpty) then
    FBuilder.AppendLine;

  FLastLineEmpty := True;
end;

procedure TParsedCommentWriter.AppendRaw(const AText: String);
begin
  FBuilder.Append(AText);
end;

constructor TParsedCommentWriter.Create(const ASourceWriter: TSourceWriter);
begin
  inherited;
  FBuilder := TStringBuilder.Create;
  {$IFDEF DEBUG}
  FUnusedCommands := TDictionary<String, Integer>.Create;
  {$ENDIF}
end;

destructor TParsedCommentWriter.Destroy;
{$IFDEF DEBUG}
var
  Command: String;
{$ENDIF}
begin
  {$IFDEF DEBUG}
  if (FUnusedCommands.Count > 0) then
  begin
    OutputDebugString('Comment commands not converted:');
    for Command in FUnusedCommands.Keys do
      OutputDebugString(PChar(Command));
  end;
  FUnusedCommands.Free;
  {$ENDIF}
  FBuilder.Free;
  inherited;
end;

procedure TParsedCommentWriter.EndSummaryOrRemarks;
begin
  case FState of
    InSummary:
      EndSummary;

    InRemarks:
      EndRemarks;
  end;
end;

class function TParsedCommentWriter.IsBlockComment(
  const AComment: TComment): Boolean;
begin
  Result := (AComment.Handle.ASTNode <> nil) and
    (AComment.Kind in [TCommentKind.Paragraph, TCommentKind.BlockCommand,
    TCommentKind.VerbatimBlockCommand, TCommentKind.VerbatimBlockLine]);
end;

function TParsedCommentWriter.TrimRight(const AText: String): Boolean;
var
  I: Integer;
  S: String;
begin
  I := FBuilder.Length - AText.Length;
  S := FBuilder.ToString(I, AText.Length);
  Result := (S = AText);
  if Result then
    FBuilder.Remove(I, AText.Length);
end;

procedure TParsedCommentWriter.TrimRight;
var
  I: Integer;
  S: String;
begin
  S := FBuilder.ToString;
  I := FBuilder.Length - 1;

  while True do
  begin
    while (I > 0) and (FBuilder.Chars[I] <= ' ') do
      Dec(I);

    if (I > 5) and (FBuilder.Chars[I] = '/')
      and (FBuilder.Chars[I - 1] = '/')
      and (FBuilder.Chars[I - 2] = '/')
    then
      Dec(I, 3)
    else
      Break;
  end;

  Inc(I);

  if (I <> FBuilder.Length) then
    FBuilder.Remove(I, FBuilder.Length - I);

  FLastLineEmpty := False;
end;

procedure TParsedCommentWriter.WriteChildren(const AComment: TComment);
var
  I: Integer;
  InList: Boolean;
  Child, PrevSibling: TComment;
begin
  InList := False;
  TCXComment(PrevSibling).ASTNode := nil;
  for I := 0 to AComment.ChildCount - 1 do
  begin
    Child := AComment.Children[I];
    WriteNode(Child, PrevSibling, InList);
    PrevSibling := Child;
  end;

  if InList then
    EndList;
end;

procedure TParsedCommentWriter.WriteComment(const ACursor: TCursor);
var
  Comment: TComment;
  S: String;
begin
  if (ACursor.IsNull) then
    Exit;

  Comment := ACursor.ParsedComment;
  if (Comment.Kind = TCommentKind.Null) then
    Exit;

  { "Root" comment is always of type FullComment }
  FLastLineEmpty := False;
  FState := Initial;
  FBuilder.Clear;
  FPrefix := FWriter.CurrentIndent + BeginComment;
  WriteChildren(Comment);
  EndSummaryOrRemarks;
  EndComment;

  S := FBuilder.ToString;
  if (S.EndsWith(sLineBreak)) then
    SetLength(S, S.Length - Length(sLineBreak));

  FWriter.WriteLn(S);
end;

procedure TParsedCommentWriter.WriteNode(const AComment, APrevSibling: TComment;
  var AInList: Boolean);

  procedure CloseList;
  begin
    if (AInList) then
    begin
      EndList;
      AInList := False;
    end;
  end;

var
  Kind: TCommentKind;
  S, Args: String;
  I: Integer;
begin
  Kind := AComment.Kind;
  case Kind of
    TCommentKind.InlineCommand:
      begin
        S := AComment.InlineCommandName;
        Args := '';
        for I := 0 to AComment.InlineCommandArgCount - 1 do
        begin
          if (Args = '') then
            Args := AComment.InlineCommandArgs[I]
          else
            Args := Args + ' ' + AComment.InlineCommandArgs[I];
        end;
        if (S = 'c') or (S = 'p') then
          InlineCode(Args)
        else
        begin
          {$IFDEF DEBUG}
          FUnusedCommands.AddOrSetValue(S, 0);
          {$ENDIF}
          Append(Args);
        end;
      end;

    TCommentKind.HtmlStartTag:
      Assert(False);

    TCommentKind.HtmlEndTag:
      Assert(False);

    TCommentKind.Paragraph,
    TCommentKind.VerbatimLine:
      begin
        CloseList;
        if (not AComment.IsWhitespace) then
        begin
          case FState of
            Initial:
              begin
                BeginSummary;
                FNeedToTrimLeft := True;
                FState := InSummary;
              end;

            InSummary, FinishedCommand:
              begin
                EndSummary;
                BeginRemarks;
                FNeedToTrimLeft := True;
                FState := InRemarks;
              end;
          else
            if IsBlockComment(APrevSibling) then
            begin
              Append(' ');
              AppendLine;
            end;
          end;
          if (Kind = TCommentKind.VerbatimLine) then
            Append(AComment.VerbatimLineText)
          else
            WriteChildren(AComment);
          AppendLine;
        end;
      end;

    TCommentKind.BlockCommand:
      begin
        S := AComment.BlockCommandName;
        if (S = 'return') or (S = 'returns') then
        begin
          CloseList;
          EndSummaryOrRemarks;
          FState := InCommand;
          BeginReturns;
          FNeedToTrimLeft := True;
          S := FPrefix;
          FPrefix := FPrefix + '  ';
          WriteChildren(AComment);
          EndReturns;
          FState := FinishedCommand;
          FPrefix := S;
        end
        else if (S = 'li') then
        begin
          if (not AInList) then
          begin
            BeginList;
            AInList := True;
          end;
          BeginListItem;
          WriteChildren(AComment);
          EndListItem;
        end
        else
        begin
          {$IFDEF DEBUG}
          { We handle \brief commands manually }
          if (S <> 'brief') then
            FUnusedCommands.AddOrSetValue(S, 0);
          {$ENDIF}
          CloseList;
          WriteChildren(AComment);
        end;

        AppendLine;
      end;

    TCommentKind.ParamCommand:
      begin
        CloseList;
        EndSummaryOrRemarks;
        FState := InCommand;
        BeginParam(AComment.ParamCommandParamName);
        if (AComment.ParamCommandIsDirectionExplicit) then
        begin
          case AComment.ParamCommandDirection of
            TCommentParamPassDirection.Input: Append('[in] ');
            TCommentParamPassDirection.Ouput: Append('[out] ');
            TCommentParamPassDirection.InOut: Append('[inout] ');
          end;
        end;
        FNeedToTrimLeft := True;
        S := FPrefix;
        FPrefix := FPrefix + '  ';
        WriteChildren(AComment);
        EndParam;
        FState := FinishedCommand;
        FPrefix := S;
        AppendLine;
      end;

    TCommentKind.VerbatimBlockCommand:
      begin
        CloseList;
        BeginVerbatim;
        WriteChildren(AComment);
        EndVerbatim;
      end;

    TCommentKind.VerbatimBlockLine:
      begin
        CloseList;

        { Bug in libclang? Sometimes, VerbatimBlockLineText returns a large
          chunk of invalid text. These can usually be detected because they have
          newline (#10) characters in them, which should not appear in
          individual lines of text. This usually means it is an empty line. }
        S := AComment.VerbatimBlockLineText;
        if (S.IndexOf(#10) >= 0) then
          S := '';

        { Keep whitespace }
        FBuilder.Append(FPrefix).Append(S.Replace('*)', '* )'));
        FLastLineEmpty := False;
        AppendLine;
      end;
  else
    Append(AComment.Text);
    if (AComment.HasTrailingNewline) then
      AppendLine;
  end;
end;

{ TXmlDocCommentWriter }

function TXmlDocCommentWriter.BeginComment: String;
begin
  AppendRaw('/// ');
  Result := '/// ';
end;

procedure TXmlDocCommentWriter.BeginList;
begin
  Append('<list type="bullet">');
  AppendLine;
end;

procedure TXmlDocCommentWriter.BeginListItem;
begin
  Append('<item>');
end;

procedure TXmlDocCommentWriter.BeginParam(const AParamName: String);
begin
  Append('<param name="%s">', [AParamName]);
end;

procedure TXmlDocCommentWriter.BeginRemarks;
begin
  Append('<remarks>');
end;

procedure TXmlDocCommentWriter.BeginReturns;
begin
  Append('<returns>');
end;

procedure TXmlDocCommentWriter.BeginSummary;
begin
  Append('<summary>');
end;

procedure TXmlDocCommentWriter.BeginVerbatim;
begin
  Append('<code>');
  AppendLine;
end;

procedure TXmlDocCommentWriter.EndComment;
begin
  { Nothing }
end;

procedure TXmlDocCommentWriter.EndList;
begin
  Append('</list>');
  AppendLine;
end;

procedure TXmlDocCommentWriter.EndListItem;
begin
  TrimRight;
  AppendRaw('</item>');
end;

procedure TXmlDocCommentWriter.EndParam;
begin
  TrimRight;
  AppendRaw('</param>');
end;

procedure TXmlDocCommentWriter.EndRemarks;
begin
  TrimRight;
  if (not TrimRight('<remarks>')) then
    AppendRaw('</remarks>');
  AppendLine;
end;

procedure TXmlDocCommentWriter.EndReturns;
begin
  TrimRight;
  AppendRaw('</returns>');
end;

procedure TXmlDocCommentWriter.EndSummary;
begin
  TrimRight;
  if (not TrimRight('<summary>')) then
    AppendRaw('</summary>');
  AppendLine;
end;

procedure TXmlDocCommentWriter.EndVerbatim;
begin
  AppendLine;
  Append('</code>');
  AppendLine;
end;

procedure TXmlDocCommentWriter.InlineCode(const ACode: String);
begin
  Append('<c>' + ACode + '</c>');
end;

{ TPasDocCommentWriter }

function TPasDocCommentWriter.BeginComment: String;
begin
  AppendRaw('(* ');
  Result := '   ';
end;

procedure TPasDocCommentWriter.BeginList;
begin
  Append('@unorderedlist(');
  FPrefix := FPrefix + '  ';
  AppendLine;
end;

procedure TPasDocCommentWriter.BeginListItem;
begin
  Append('  @item(');
end;

procedure TPasDocCommentWriter.BeginParam(const AParamName: String);
begin
  Append('@param(');
  Append(AParamName);
  Append(' ');
end;

procedure TPasDocCommentWriter.BeginRemarks;
begin
  { Nothing }
end;

procedure TPasDocCommentWriter.BeginReturns;
begin
  Append('@returns(');
end;

procedure TPasDocCommentWriter.BeginSummary;
begin
  { Nothing }
end;

procedure TPasDocCommentWriter.BeginVerbatim;
begin
  Append('@longCode(#');
  AppendLine;
end;

procedure TPasDocCommentWriter.EndComment;
begin
  TrimRight;
  AppendRaw(' *)');
end;

procedure TPasDocCommentWriter.EndList;
begin
  SetLength(FPrefix, FPrefix.Length - 2);
  TrimRight;
  AppendRaw(')');
  AppendLine;
end;

procedure TPasDocCommentWriter.EndListItem;
begin
  TrimRight;
  AppendRaw(')');
end;

procedure TPasDocCommentWriter.EndParam;
begin
  TrimRight;
  AppendRaw(')');
end;

procedure TPasDocCommentWriter.EndRemarks;
begin
  { Nothing }
end;

procedure TPasDocCommentWriter.EndReturns;
begin
  TrimRight;
  AppendRaw(')');
end;

procedure TPasDocCommentWriter.EndSummary;
begin
  { Nothing }
end;

procedure TPasDocCommentWriter.EndVerbatim;
begin
  AppendLine;
  Append('#)');
  AppendLine;
end;

procedure TPasDocCommentWriter.InlineCode(const ACode: String);
begin
  Append('@code(' + ACode + ')');
end;

end.
