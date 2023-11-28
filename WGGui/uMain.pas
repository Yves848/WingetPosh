unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.ExtCtrls, Vcl.Menus, SynEdit, DosCommand, Vcl.StdCtrls, sButton, System.ImageList,
  Vcl.ImgList, acAlphaImageList;

type
  TfMain = class(TForm)
    TrayIcon1: TTrayIcon;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    PopupMenu1: TPopupMenu;
    L1: TMenuItem;
    List1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    DosCommand1: TDosCommand;
    SynEdit1: TSynEdit;
    sButton1: TsButton;
    W1: TMenuItem;
    N3: TMenuItem;
    ImageList1: TImageList;
    procedure N2Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    function DosCommand1CharDecoding(ASender: TObject; ABuf: TStream): string;
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure sButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

function TfMain.DosCommand1CharDecoding(ASender: TObject; ABuf: TStream): string;
var
  pBytes: TBytes;
  iLength: Integer;
begin
  iLength := ABuf.Size;
  if iLength > 0 then
  begin
    SetLength(pBytes, iLength);
    ABuf.Read(pBytes, iLength);
    try
      result := tEncoding.UTF8.GetString(pBytes);
    except
      result := '';
    end;
  end
  else
    result := '';

end;

procedure TfMain.DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  SynEdit1.Lines.Add(aNewLine);
end;

procedure TfMain.L1Click(Sender: TObject);
begin
  Show;
end;

procedure TfMain.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TfMain.sButton1Click(Sender: TObject);
begin
  var s : string := 'powershell -noprofile -command "get-wglist -quiet |out-object | Where-Object {$_.source.trim() -ceq \"winget\" -and $_.available.trim() -ne \"\"} | ConvertTo-Json';
  DosCommand1.CommandLine := s;
  DosCommand1.Execute;
end;

end.
