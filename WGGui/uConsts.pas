unit uConsts;

interface
uses
  System.Classes,
  System.SysUtils;

const
  sList = 'pwsh -noprofile -command "Get-WGList -quiet $true | Where-Object {$_.source -ceq \"winget\"} | Out-JSON';
  //sList = 'pwsh -noprofile -command "Get-WGList -quiet $true | Out-JSON';
  sUpdate = 'pwsh -noprofile -command "Get-WGList -quiet $true | Where-Object {$_.source -ceq \"winget\" -and $_.available -ne \"\" } | Out-JSON';
  sSearchCmd = 'pwsh -noprofile -command "Search-WGPackage -quiet $true -package \"%s\" | Where-Object {$_.source -ceq \"winget\"} | Out-JSON ';

implementation



end.
