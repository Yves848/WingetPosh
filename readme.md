```
 __          ___                  _                   _
 \ \        / (_)                | |                 | |
  \ \  /\  / / _ _ __   __ _  ___| |_ _ __   ___  ___| |__
   \ \/  \/ / | | '_ \ / _` |/ _ \ __| '_ \ / _ \/ __| '_ \
    \  /\  /  | | | | | (_| |  __/ |_| |_) | (_) \__ \ | | |
     \/  \/   |_|_| |_|\__, |\___|\__| .__/ \___/|___/_| |_|
                        __/ |        | |
                       |___/         |_|
                       
                    ___   ___  ______
                   / _ \ / _ \|____  |
                  | | | | (_) |   / /
                  | | | |\__, |  / /
                  | |_| |_ / /_ / /
                  \___/(_)_/(_)_/
```
***
## Demo
https://youtu.be/o7I0A_7Y4kY


A set of functions to help using winget.

Entirely written in __Powershell__, it has 2 types of functions : visuals and non visuals.

No dependencies are used to ensure compatibility with Powershell 5.1

***
## Remaks :
  The goal of this module is not really the same as *Microsoft.WinGet.Client* (still in alpha)

  Basically, it was focused on the "graphical interface" aspect. The "parsing" part was added naturally.
  Unlike the official module, it is 100% written in Powershell in order to be compatible with version 5.1 and requires NO external dependency.

  But, in the end, it offers the same functionalities, new ones will be added to it as time goes on. (Scoop support, .....)
***
The availablle functions are :
- Get-WGPackage [-source] [-interactive] [-uninstall] [-update] [-apply]
- Search-WGPackage [-package "search terms"] [-source "source"] [-interactive] [-install] [-allowsearch]
- Get-WGList [-source "source"]
- Get-WGSources
- Install-WGPackage [-package] [-source] [-silent] [-acceptpackageagreements] [acceptsourceagreements]
- Invoke-Winget 
- Out-Object              
- Show-WGList                 
- Uninstall-WGPackage         
- Update-WGPackage [-Update] 
- Set-WingetposhConfig -param -value
- Get-WingetposhConfig [-display]
- Reset-WingetposhConfig
- Get-WGPVersions [-param]
  
***
## Installation

``` Powershell
  Install-Module -Name wingetposh -Scope CurrentUser
```
# IMPORTANT 
Don't forget to import the module after the installation !
*Ideally, put it in your profile file ($PROFILE)*
When it's imported, the localized resources are downloaded from the winget repository.

### Remark : 
To install in powershell 5.1, you need to install the latest "PowershellGet"
``` Powershell
Install-Module PowerShellGet -AllowClobber -Force
```

Close and re-open the powershell 5.1 terminal to make changes effective.
***

## History
See [History.md](./history.md) for the complete module history.

There is a "?" on the bottom of the window, for interactive commands.
Pressing "?" displays a "help" in the context of the running command.

``` Powershell
   Get-Command -module wingetposh
```
![](./images/001.png)

## Get-WGPackage

```
  Get-WGPackage [-source] [-interactive] [-uninstall] [-update] [-apply]
```
- -source : Specify the source to filter on
- -interactive : Switch that command the display of the GUI
- -uninstall : switch to specify if the selected packages will be uninstalled
- -update : switch to specify if the selected packages will be updated
- -apply : additionnal switch to confirm -uninstall & -update

### Examples

``` powershell
  Get-WGPackage -source winget
```
Get a hashtable with the installed packages, filtered on the source "winget"

``` powershell
  Get-WGPackage -source winget | Out-Object
```
Get an Object (or an array of objects) with the installed packages, filtered on the source "winget"

## Search-Package

```
  Search-WGPackage "package" [-source] [-interactive] [-install] [-allowsearch]
```
- -source : Specify the source to filter on
- -interactive : Switch that command the display of the GUI
- -install : Lauch the installation of the selected packages
- -allowsearch : Allow to search on new keywords by pressing "F3" in the grid.

### Examples

``` powershell
  Search-WGPackage notepad -source winget | Out-Object | Select-Object -Property id
```

![](./images/A_07.png)

``` Powershell
  Show-WGList
```
![image1](./images/002.png)

This function allows multiselection, by pressing "space" on the selected line.
When at least one package is selected, when the function is exitted with "Return", an Object list is returned.

![](./images/003.png)
When Hit return .....
![](./images/004.png)

The result is a hashtable, faster and more memory efficient.

But the result can be converted to object by piping it to Out-Object

``` Powershell
   Show-WGlist | Out-Object
```
![](images/005.png)

And, of course, we can pipe this result to perform additionnal operations .....

``` Powershell
   Show-WGList | Out-Object | Select-Object -Property id
```

![](./images/006.png)

***
## Search Packages
The -Package parameter is not mandatory.
If omitted, wingetposh will display a popup to enter the packages to search.

``` Powershell
  Search-WGPackage
```
![](./images/006-1.png)

***

## Converting results to PSCustomObject arrays

``` Powershell
  Get-WGList | Out-Object
```

***

## Search and install a package

If no **-package** parameter is specified, the function will popup a window to enter the terms to search.

The source can be specified to limit the number of results.  EG : *-source winget*

``` Powershell
  Install-WGPackage
```

![image8](./images/007.png)

![image8-1](./images/006-2.png)

***

## Select and update an installed package
 
 To confirm the update, the *-apply* switch must be provided.  Otherwise, the function will only return a list of the selected packages.
 

```Powershell
  Update-WGPackage -source winget -apply
```
![image9](./images/009.png)

***

## Select and uninstall an installed package
 To confirm the update, the *-apply* switch must be provided.  Otherwise, the function will only return a list of the selected packages.
``` Powershell
  Uninstall-WGPackage -source winget -apply
```
![image10](./images/010.png)

## Generic function to convert winget results to PSCustomObject

``` Powershell
  Invoke-Winget "winget list" | Out-Object | Where-Object {$_.Name -like "*code*"}
```
![image11](./images/011.png)

# Configuration

Starting 0.8.0-beta5 version, a config file is used to store some global parameters.
The file is stored in
``` powershell
$env:USERPROFILE/.config/.wingetposh/config.json
```
![image11](./images/012.png)

## Set an option
  Change the value of an option in the config file

## Example
To allow the use of nerd font special characters in the grid, change the option "UseNerdFont" to true
``` Powershell
  Set-WingetposhConfig -param UseNerdFont -value $true
```

To force silent installation of packages, set "SilentInstall" to true
``` powershell
  Set-WingetposhConfig -param SilentInstall -value $true
```

## Reset the config file
  Reset to default every options in the config file

``` Powershell
  Reset-WingetposhConfig
```

## Display the options of the confid file
  Display the value of the options in the config file

``` Powershell
  Get-WingetposhConfig -display
```
![image13](./images/013.png)

## Get-WGPVersions -param All
  Display Winget and WingetPosh versions
  Available parameters : "All", "Winget", "WGP"
  ``` Powershell
  Get-WGPVersions -param All
```
![image14](./images/014.png)