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
https://youtu.be/nWH5SarJ6wI


A small set of functions to help using winget.

It's TUI (Terminal User Interface) entirely written in Powershell.

No more dependencies.  Works with Powershell 5.1

The availablle functions are :
- Function        Get-WGList                                         0.6.1      wingetposh
- Function        Install-WGPackage                                  0.6.1      wingetposh
- Function        Invoke-Winget                                      0.6.1      wingetposh
- Function        Show-WGList                                        0.6.1      wingetposh
- Function        Uninstall-WGPackage                                0.6.1      wingetposh
- Function        Update-WGPackages                                  0.6.1      wingetposh
  
  
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

### 0.5.4 : 
- Addind a license file.

### 0.5.5 : 
- Adding license acceptance when installing module

### 0.5.6 : 
        - Adding headless functions : Get-WGList and Get-WGUpdatables

### 0.6.0 :
        - Removing "Microsoft.PowerShell.ConsoleGuiTools" dependance to add Powershell 5.1 compatibility
        - Rewriting the TUI in full powershell (some flickering still to fix)
        - Adding "Invoke-Winget" funtion to add generic call to Winget

### 0.6.1 : 
        - Fix -Install switch of Install-WGPAckage
        - Rename Show-WGUpdatables to Update-WGPackages
        - Add a switch -Update to Update-WGPackages

### Remark : 
To install in powershell 5.1, you need to install the latest "PowershellGet"
``` Powershell
Install-Module PowerShellGet -AllowClobber -Force
```
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

## Search and install a package

The -Install parameter will launch the installation of the selected package(s).

``` Powershell
  Install-WGPackage -Install
```

![image8](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img8.png)
![image8-1](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img8-1.png)



***

## Select and update an installed package
 
```Powershell
  Update-WGPackages -update
```
![image9](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img9.png)

***

## Select and uninstall an installed package
 
``` Powershell
  Uninstall-WGPackage
```
![image10](https://raw.githubusercontent.com/Yves848/WingetPosh/master/images/img10.png)

## Generic function to convert winget results to PSCustomObject

``` Powershell
  $list = Invoke-Winget "winget list"
```