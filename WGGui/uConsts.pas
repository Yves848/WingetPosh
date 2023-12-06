unit uConsts;

interface
uses
  System.Classes,
  System.SysUtils;

const
  //sList = 'pwsh -noprofile -command "Get-WGList -quiet $true | Where-Object {$_.source -ceq \"winget\"} | Out-JSON';
  sList = 'pwsh -noprofile -command "Get-WGList -quiet $true | Out-JSON';
  sUpdate = 'pwsh -noprofile -command "Get-WGList -quiet $true | Where-Object {$_.source -ceq \"winget\" -and $_.available -ne \"\" } | Out-JSON';
  sSearch = 'pwsh -noprofile -command "Search-WGPackage -quiet $true -package %s | Out-JSON ';

function CharDecoding(ASender: TObject; ABuf: TStream) : String;
implementation

function CharDecoding(ASender: TObject; ABuf: TStream) : String;
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

end.
