function getWingetLocals {
  $culture = ((Get-WinUserLanguageList).LanguageTag -split "-")[0]
  $languages = @('de-DE', 'es-ES', 'fr-FR', 'it-IT', 'ja-JP', 'ko-KR', 'pt-BR', 'ru-RU', 'zh-CN', 'zh-TW')
  $language = $languages | Where-Object {$_.StartsWith($culture)}
  Write-Host "⏳ Downloading resources for $language"
  $hash = @{}

  try {
    # Download resources file from github
    $data = ([xml](((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-cli/master/Localization/Resources/$language/winget.resw" -ErrorAction Stop ).Content -replace "\uFEFF", ""))).root.data
  }
  catch {
    # Fall back on the en-US resources
    $data = ([xml](((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-cli/master/src/AppInstallerCLIPackage/Shared/Strings/en-us/winget.resw" -ErrorAction Stop ).Content -replace "\uFEFF", ""))).root.data
  }
  $data | ForEach-Object {
    $hash[$_.name] = $_.value
  }
  $hash
}

$version = [string]$(Get-InstalledModule -Name wingetposh -ErrorAction Ignore).version
if (-not (Test-Path -Path "~/.config/.wingetposh/params.$version")) { 

  Write-Host "🚧 Parsing resources and writing config files."
  if (-not (Test-Path -Path ~/.config/.wingetposh)) {
    New-Item -Path ~/.config/.wingetposh -ItemType Directory | Out-Null
    Remove-Item -Path ~/.config/.wingetposh/locals.json -ErrorAction Ignore | Out-Null
    New-Item -Path ~/.config/.wingetposh/locals.json | Out-Null
  }

  $l = getWingetLocals
  $l | ConvertTo-Json | Out-File -FilePath ~/.config/.wingetposh/locals.json -Force | Out-Null

  $init = @{}
  (
  ('UseNerdFont', $false),
  ('SilentInstall', $false),
  ('AcceptPackageAgreements', $true),
  ('AcceptSourceAgreements', $true),
  ('Force', $false),
  ('IncludeScoop',$false)
  ) | ForEach-Object { $init[$_[0]] = $_[1] }

  $config = @{}
  if (Test-Path -Path ~/.config/.wingetposh/config.json) {
  (Get-Content $env:USERPROFILE/.config/.wingetposh/config.json | ConvertFrom-Json).psobject.Properties | ForEach-Object {
      $config[$_.Name] = $_.Value
    }
  }
  " "
  $init.GetEnumerator() | ForEach-Object {
    if (-not $config.ContainsKey($_.key)) {
      $config.Add($_.key, $_.Value)
    }
  }


  $config | ConvertTo-Json | Out-File -FilePath ~/.config/.wingetposh/config.json -Force | Out-Null
  "ok" | Out-File -FilePath "~/.config/.wingetposh/params.$version" | Out-Null

  Write-Host "Wingetposh version $version installed successfully 👌"
  Write-Host "".PadRight($Host.UI.RawUI.BufferSize.Width, '—')
  Write-Host "🗒️ Go to http://github.com/yves848/wingetposh for help and infos."
  Write-Host "📨 Please report bugs and requests at wingetposh@gmail.com"
  Invoke-Expression .\WGGui.exe
}