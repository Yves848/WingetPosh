unit uDM;

interface

uses
  System.SysUtils, System.Classes;

type
  tCharDecoding = Function(ASender: TObject; ABuf: TStream): String of object;

  TDM = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    function CharDecoding(ASender: TObject; ABuf: TStream): String;
  end;

var
  DM: TDM;

implementation

function TDM.CharDecoding(ASender: TObject; ABuf: TStream): String;
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

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
