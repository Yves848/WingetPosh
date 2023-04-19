get-command -module wingetposh
show-wglist
show-wglist | out-object
show-wglist | out-object | Select-Object -Property id
get-wglist
Get-WGList | Out-Object
Get-WGList | Out-Object | Select-Object -Property id
Get-WGList | Out-Object | Where-Object {$_.id -like "Microsoft*"}
Search-WGPackage -package code
Search-WGPackage -package code | Out-Object
Search-WGPackage -package code | Out-Object | Select-Object -Property id
Install-WGPackage
Install-WGPackage -package -source winget
Get-WGSources
Install-WGPackage -package notepad
Uninstall-WGPackage -source winget -apply
Update-WGPackage
Update-WGPackage | Out-Object
Update-WGPackage -source winget -apply
Search-WGPackage -package notepad -interactive -install -source winget
Invoke-Winget "winget list"
Invoke-Winget "winget list" | Out-Object
Invoke-Winget "winget list" | Out-Object | Where-Object {$_.Nom -like "*code*"}
clear


