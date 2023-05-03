function getWingetLocals {
  $language = (Get-UICulture).Name
  $version = Invoke-Expression "winget --version" | Out-String -NoNewline
  $languageData = $(
    $hash = @{}

    $(try {
        # We have to trim the leading BOM for .NET's XML parser to correctly read Microsoft's own files - go figure
          ([xml](((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-cli/release-$version/Localization/Resources/$language/winget.resw" -ErrorAction Stop ).Content -replace "\uFEFF", ""))).root.data
      }
      catch {
        # Fall back to English if a locale file doesn't exist
        (
              ('SearchName', 'Name'),
              ('SearchID', 'Id'),
              ('SearchVersion', 'Version'),
              ('AvailableHeader', 'Available'),
              ('SearchSource', 'Source'),
              ('ShowVersion', 'Version'),
              ('GetManifestResultVersionNotFound', 'No version found matching:'),
              ('InstallerFailedWithCode', 'Installer failed with exit code:'),
              ('UninstallFailedWithCode', 'Uninstall failed with exit code:'),
              ('AvailableUpgrades', 'upgrades available.')
        ) | ForEach-Object { [pscustomobject]@{name = $_[0]; value = $_[1] } }
      }) | ForEach-Object {
      # Convert the array into a hashtable
      $hash[$_.name] = $_.value
    }
    $hash
  )
  return $languageData
}

if (-not (test-path -Path ~/.config/.wingetposh)) {
  new-item -Path ~/.config/.wingetposh -ItemType Directory | Out-Null
  Remove-Item -Path ~/.config/.wingetposh/locals.json -ErrorAction Ignore | Out-Null
  new-item -Path ~/.config/.wingetposh/locals.json | Out-Null
}

getWingetLocals | ConvertTo-Json |Out-File -FilePath ~/.config/.wingetposh/locals.json -Force | Out-Null

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