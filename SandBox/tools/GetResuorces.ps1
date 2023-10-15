$languages = @('de-DE', 'es-ES', 'fr-FR', 'it-IT', 'ja-JP', 'ko-KR', 'pt-BR', 'ru-RU', 'zh-CN', 'zh-TW')

$WGVersion = "release-v1.6"

$url1 = "https://raw.githubusercontent.com/microsoft/winget-cli/release-v1.6/src/AppInstallerCLIPackage/Shared/Strings/en-us/winget.resw"
$url2 = "https://raw.githubusercontent.com/microsoft/winget-cli/{0}/Localization/Resources/{1}/winget.resw"

$resfile = "localization.json"

function Get-ResourceFile {
  param(
    [string]$url,
    [string]$version,
    [string]$lang
  )
  try {
    $localization = $url -f $version, $lang
    #$data = ([xml](((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-cli/release-$version/Localization/Resources/$language/winget.resw" -ErrorAction Stop ).Content -replace "\uFEFF", ""))).root.data
    #Write-Host $localization
    $data = ([xml](((Invoke-WebRequest -Uri $localization -ErrorAction Continue ).Content -replace "\uFEFF", ""))).root.data
      
  }
  catch {
    Write-Host "Error $localization"
  }
  return $data
}

$res = [ordered]@{}
$hash = @{}
Get-ResourceFile -url $url1 -version $WGVersion -lang 'en-US' | ForEach-Object {
  $hash[$_.name] = $_.value
}
$res['en-us'] = $hash
foreach ($lang in $languages) {
 Get-ResourceFile -url $url2 -version $WGVersion -lang $lang
}
Clear-Host
Write-Host $res