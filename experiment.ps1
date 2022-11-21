NugetPackageRoot  = $tempModulePath
$tempModulePath = Microsoft.PowerShell.Management\Join-Path -Path $script:TempPath `
            -ChildPath "$(Microsoft.PowerShell.Utility\Get-Random)\$moduleName"