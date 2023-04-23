$init = @{}
(
  ('UseNerdFont', $false),
  ('SilentInstall', $false),
  ('AcceptPackageAgreements', $true),
  ('AcceptSourceAgreements', $true),
  ('Force', $false)
) | ForEach-Object { $init[$_[0]] = $_[1] }

$config =  @{}
if (Test-Path -Path ~/.config/.wingetposh/config.json) {
  (Get-Content $env:USERPROFILE/.config/.wingetposh/config.json | ConvertFrom-Json).psobject.Properties | ForEach-Object {
    $config[$_.Name] = $_.Value
  }
}
" "
$init.GetEnumerator() | ForEach-Object {
  if (-not $config.ContainsKey($_.key)) {
      $config.Add($_.key,$_.Value)
  }
}

$config | ConvertTo-Json | Out-File -FilePath ~/.config/.wingetposh/config.json -Force | Out-Null