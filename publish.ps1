$content = Import-PowerShellDataFile .\Winget-posh\wingetposh.psd1
if ($content.PrivateData.PSData.Prerelease) {
  $versionP = "$($content.ModuleVersion)","$($content.PrivateData.PSData.Prerelease)" -join "-" 
  $preRelease = $true
}
else {
  $versionP = "$($content.ModuleVersion)"
  $preRelease = $false
}

$version = "$($content.ModuleVersion)"

$folder = "C:\Users\yvesg\Documents\PowerShell\Modules\$(split-path $content.RootModule -LeafBase)",$version -join "\"
$env:NUGET_CLI_LANGUAGE="en_US"

Write-Host "Module folder : $folder"


if ((Test-Path -Path  $folder) -ne $true) {
  mkdir -Path  $folder
}

Copy-Item -Path ".\Winget-posh\*" -Destination "$folder\" -Force -Recurse

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$pskey = Get-Content ~\.config\.private\apikey.txt
Import-Module PowerShellGet
$params = @{
  Name = "wingetposh"
  NuGetApiKey = $pskey
  Verbose = $true
  RequiredVersion = $versionP
  AllowPrerelease = $preRelease
}

Publish-Module @params