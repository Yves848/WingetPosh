```
           _                      _                       _
__      __(_) _ __    __ _   ___ | |_  _ __    ___   ___ | |__
\ \ /\ / /| || '_ \  / _` | / _ \| __|| '_ \  / _ \ / __|| '_ \
 \ V  V / | || | | || (_| ||  __/| |_ | |_) || (_) |\__ \| | | |
  \_/\_/  |_||_| |_| \__, | \___| \__|| .__/  \___/ |___/|_| |_|
                     |___/            |_|
```
***

## Demo
https://youtu.be/A45vW0GuduM


A small set of functions to help using winget.

It's TUI (Terminal User Interface) entirely written in Powershell.
It has one dependenciy : Microsoft.PowerShell.ConsoleGuiTools

For now, it't only tested with Windows Terminal runnning the latest (7.2.6) Powershell Core

The availablle functions are :
- Show-WGList
- Search-WGPackage "name (or part) of the package" [-Interactive] [-Install]
- Show-WGUpdatables
- Update-WGPackage [-Interactive]
- Install-WGPackage
- Uninstall-WGPackage [-Interactive]
  
  
## Installation
``` Powershell
  Install-Module -Name wingetposh -Scope CurrentUser
```

## History
### 0.5.1 : 
- Fixed the show-WGList bug when there is no updatable packages to show.
### 0.5.2 : 
- Removed the "-Interactive" switch to search-WGPackage.       
- Removed the search parameter from search-WGPackage.
- Allowing multiple selection in uninstall-WGPackage.
- Removing crash brug when no package is found in search-WGPackage.
- Removing the "-Interactive" switch to updage-WGPackage.  If no Object is passed through the pipeline, it will automatically display an interactive grid
- Update readme.md

### Examples
``` Powershell
  Show-WGList
```
![image1](https://github.com/Yves848/WingetPosh/blob/master/images/img1.png?raw=true)

This function allows multiselection.
When at least one package is selected, when the function is exitted with "Return", an Object list is returned.

![](https://github.com/Yves848/WingetPosh/blob/master/images/img4.png?raw=true)
When Hit return .....
![](https://github.com/Yves848/WingetPosh/blob/master/images/img5.png?raw=true)

Of course, we can use this object collection to extract some usefull data .....
![](https://github.com/Yves848/WingetPosh/blob/master/images/img6.png?raw=true)


***

``` Powershell
  Search-WGPackage
```
![image8](https://github.com/Yves848/WingetPosh/blob/master/images/img8.png?raw=true)
![image2](https://github.com/Yves848/WingetPosh/blob/master/images/img2.png?raw=true)

``` Powershell
  Show-WGUpdatables
```
![image3](https://github.com/Yves848/WingetPosh/blob/master/images/img3.png?raw=true)

```Powershell
  Update-WGPackage
```
![image9](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img9.png)

***

## Search and install a package

When passing -Interactive (or even no search parameter), the function will prompt for a search term.
The -Install parameter will launch the installation of the selected package.

``` Powershell
  Search-WGPackage -Install
```

![image8](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img8.png)

``` Powershell
  Search-WGPackage | Select-Object -Property Id | Install-WGPackage
```
or
``` Powershell
  $id = Search-WGPackage | Select-Object -Property Id
  winget install $id
```
or
``` Powershell
  $pkg = Search-WGPackage 
  winget install $pkg.id
```

***

## Select and update an installed package
``` Powershell
  Show-WGUpdatables | Select-Object -Property id | Update-WGPackage
```
or
``` Powershell
  $id = Show-WGUpdatables | Select-Object -Property id
  winget update $id
```
or
``` Powershell
  $pkg = Show-WGUpdatables
  winget update $pkg.id
```
or
 
``` Powershell
  Update-WGPackage -Interactive
``` 

***

## Select and uninstall an installed package
``` Powershell
  Show-WGList -Single | Select-Object -Property id | Remove-WGPackage
```

or

``` Powershell
 $id = Show-WGList -Single | Select-Object -Property id
 winget uninstall $id
```

or
``` Powershell
  $pkg = Show-WGList -Single
  winget $pkg.id
```

or 
``` Powershell
  Uninstall-WGPackage -Interactive
```

***
## Update packages interactively
``` Powershell
  update-WGPackage
```
