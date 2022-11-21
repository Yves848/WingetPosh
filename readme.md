```
           _                      _                       _
__      __(_) _ __    __ _   ___ | |_  _ __    ___   ___ | |__
\ \ /\ / /| || '_ \  / _` | / _ \| __|| '_ \  / _ \ / __|| '_ \
 \ V  V / | || | | || (_| ||  __/| |_ | |_) || (_) |\__ \| | | |
  \_/\_/  |_||_| |_| \__, | \___| \__|| .__/  \___/ |___/|_| |_|
                     |___/            |_|
```
***

A small set of functions to help using winget.

It's TUI (Terminal User Interface) entirely written in Powershell.
It has one dependenciy : Microsoft.PowerShell.ConsoleGuiTools

For now, it't only tested with Windows Terminal runnning the latest (7.2.6) Powershell Core

The availablle functions are :
- Get-WGList
- Get-WGSearch
- Get-WGUpgrade
- Set-WGInstall
- Set-WGRemove
  
  
### Examples
``` Powershell
Get-WGList
```
Get the following screen with all the installed packages