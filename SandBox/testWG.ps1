param (
  [ValidateSet("Show-WGList", "Install-WGPackage", "Search-WGPackage", "Get-ScoopStatus", "Test-Scoop", "Uninstall-WGPackage","Build-WGInstallFile")]$func
)


$include = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) 

. "$include\wingetposh.ps1"

switch ($func) {
  "Get-ScoopStatus" { Get-ScoopStatus }
  "Show-WGList" { Show-WGList }
  "Install-WGPackage" { Install-WGPackage }
  "Search-WGPackage" { Search-WGPackage }
  "Test-Scoop" {
    Get-WingetposhConfig
    $script:config.IncludeScoop 
    Test-Path -Path "$env:HOMEDRIVE$env:HOMEPATH\Scoop\"
  }
  "Uninstall-WGPackage" {
    Uninstall-WGPackage
  }
  "Build-WGInstallFile"
  {
    Build-WGInstallFile
  }
  Default {
    #Search-WGPackage -package git
    #Get-WGPackage
    #Search-WGPackage
    #Install-WGPackage
    #Get-WGPackage -interactive -update
    Get-WGList -quiet
    #Show-WGList
    #Update-WGPackage -quiet
    #Search-WGPackage -source $args -interactive -allowSearch
    #Uninstall-WGPackage -source winget -apply
    #Get-WGSources
    #Set-WingetposhConfig -param UseNerdFont -value $args
    #Install-WGPackage 
    #Get-WGPVersion -param WGP
    #Get-ScoopStatus
    #Get-ScoopBuckets
    #Reset-WingetposhConfig
    #GetVersion
  }
}