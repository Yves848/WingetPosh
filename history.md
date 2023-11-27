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

### 0.6.2 :
        - Fix flickering
        - rename Update-WGPackages to Update-WGPackage for uniformity
        - in Install-WGPackage, F3 allows to run a new search
        - Version of the module shown in the window frame
        
### 0.6.3 : 
        - remove the module version of the window frame

### 0.6.4 :
        - Add '+' and '-' keys for selections in the grid
        - Version of the module shown in the window frame (back)
        - add "?" to display help

### 0.6.5 :
        - refine windows drawing
        - add a "package" parameter to Install-WGPackage

### 0.6.6 :
        - Correctiong bugs in install, uninstall and update functions
        - Fixing the order of the install-WGPackage parameters

### 0.7.0 :
        - Changing search mode.  Now the search is on everything, not only the name
        - Improving winget result parsing
        - Every function now returns a hastable.  Faster, lighter
        - Adding a "Out-Object" function to convert hashtable results in PsCustomObject arrays (if needed)
        - Adding a "Search-WGPackage" to search without the graphical interface
  
### 0.7.2 : 
        - Minor bug fixes
        
### 0.7.3 :
        - fixing visual function (using hastables)

### 0.7.4 :
        - fixing bug with visual functions returning multiple objects

### 0.7.5 :
        - Fixing the update-wgpackage when multiple packages selected

### 0.7.9 :
        - Start Using runspaces to multitask the module.
          First usage is for animating the waitings.
          Last version before heavy code restucture / rewrite
        - Small visual improvements

### 0.8.0 (beta):
        - Rewrite of the parsing module.
        - Now, parsing successfuly multibytes characters (eg : kanji)
        - Using more animations for the long running tasks (runspaces)
        - More parameters to the functions and more error tracking.
        - Using localized resources from winget repository
        - Many bug fixes.
        - No more fixes to the 0.7.9 => Merging 0.8.0 to master
### 0.8.1 :
        - Using function from PSReadLine for the texts inputs (Allows 'Esc' to cancel editing)
        - Small visual changes to the interactive parts
        - in grids, **F2** cycles instantly through the sources availables
        - '?' displays a small help message on the screen
        - Introdution of an config file and a "localization" file. (~/.config/.wingetposh)

### 0.9.1 :
        - Fixing bug when downloading localized resources on non English Windows.

### 0.9.7 :
        - Removing licence acceptance at installation
        - Only download ressource once for a version.
        - Add function **Get-WGPVersions" to display Winget and/or WGP versions.
        - Updating Readme and screenshots.
### 1.0.0 :
        - Changed the download resources method.  Now based on the "master" branch of Winget
        - Uninstall-WGPackage is deprecated => Show-WGList
        - Update-WGPackage is deprecated => Show-WGList
        - Install-WGPackage accept multiple keywords to perform multiple installations at once
        - Scoop Integration
        - Build-WGInstallFile is added to generate a config file (json) to replicate install on other machines
        - Readme updated
        - Use of multiple runspaces (display and invokes)
        - Bug fixes
### 1.0.1 :
        - fixing a bug on Windows 10 when installing the module.  Now, it correctly download the resources.