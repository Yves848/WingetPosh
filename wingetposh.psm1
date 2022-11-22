class upgradeSoftware {
  [string]$Name
  [string]$Id
  [string]$Version
  [string]$AvailableVersion
  [string]$Source
}

class installSoftware {
  [string]$Name
  [string]$id
  [string]$Version
  [string]$Source
}

class column {
  [string]$Name
  [Int16]$Position
  [Int16]$Len
}

function getColumnsHeaders {
  param(
    [parameter (
      Mandatory
    )]
    [string]$columsLine   
  )

  $tempCols = $columsLine.Split(" ")
  $cols = @()
  $result = @()
  foreach ($column in $tempCols) {
    if ($column.Trim() -ne "") {
      $cols += $column
    }
  }
  
  $i = 0
  while ($i -lt $Cols.Length) {
    $pos = $columsLine.IndexOf($Cols[$i])
    if ($i -eq $Cols.Length) {
      #Last Column
      $len = $columsLine.Length - $pos
    }
    else {
      #Not Last Column
      $pos2 = $columsLine.IndexOf($Cols[$i + 1])
      $len = $pos2 - $pos
    }
    $acolumn = [column]::new()
    $acolumn.Name = $Cols[$i]
    $acolumn.Position = $pos
    $acolumn.Len = $len
    $result += $acolumn
    $i++
  }
  $result
}

function _wgList {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $command = "winget list"
  
  $SearchResult = Invoke-Expression $command | Out-String
  $lines = $SearchResult.Split([Environment]::NewLine)

  $fl = 0
  while (-not $lines[$fl].StartsWith("----")) {
    $fl++
  }

  $columns =  getColumnsHeaders -columsLine $lines[$fl-1]
  
  $idStart = $Columns[1].Position
  $versionStart = $Columns[2].Position
  #$availableStart = $lines[$fl].IndexOf("Disponible")
  $sourceStart = $columns[3].Position

  $InstalledList = @()
  For ($i = $fl + 1; $i -le $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
      $name = $line.Substring(0, $idStart).TrimEnd()
      $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
      $version = $line.Substring($versionStart, $SourceStart - $versionStart).TrimEnd()
      #$available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
      $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
      if ($source -ne "") {
        $software = [installSoftware]::new()
        $software.Name = $name;
        $software.Id = $id;
        $software.Version = $version
        $software.Source = $source
        $InstalledList += $software
      }
    }
  }
  $installedList
}

# function check_ocgv {
#   if(-not (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable)){
#     Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force
#     }
# }

function _wgSearch {
  param(
    [parameter (
      Mandatory,
      HelpMessage = "Package (or part) name to search"
    )]
    [string]$search,
    # Store Filter
    [Parameter(
      HelpMessage = "store to filter on"
    )]
    [string]
    $Store    
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 

  $command = "winget search --name ${search}"

  if ($Store -ne "") {
    $command = $command + " --source " + $Store
  }

  $SearchResult = Invoke-Expression $command | Out-String
  $lines = $SearchResult.Split([Environment]::NewLine)

  $fl = 0
  while (-not $lines[$fl].StartsWith("----")) {
    $fl++
  }

  $columns =  getColumnsHeaders -columsLine $lines[$fl-1]

  $idStart = $columns[1].Position
  $versionStart = $columns[2].Position
  if ($store -eq "") {
    $sourceStart = $columns[3].Position
  }
  $SearchList = @()
  For ($i = $fl + 1; $i -le $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
      $name = $line.Substring(0, $idStart).TrimEnd()
      $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
          
      if ($Store -eq "") {
        $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
        $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
      }
      else {
        $version = $line.Substring($versionStart, $line.Length - $versionStart).TrimEnd()
        $source = $store
      }
      $software = [installSoftware]::new()
      $software.Name = $name;
      $software.Id = $id;
      $software.Version = $version
      $software.Source = $source;
      $SearchList += $software
    }
  }
  $SearchList
}

function wgUpgradable {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $command = "winget upgrade --include-unknown"
  
  $SearchResult = Invoke-Expression $command | Out-String
  $lines = $SearchResult.Split([Environment]::NewLine)

  $fl = 0
  while (-not $lines[$fl].StartsWith("----")) {
    $fl++
  }

  $columns =  getColumnsHeaders -columsLine $lines[$fl-1]
  
  $idStart = $Columns[1].Position
  $versionStart = $Columns[2].Position
  $availableStart = $columns[3].Position
  $sourceStart = $columns[4].Position

  $upgradeList = @()
  For ($i = $fl + 1; $i -le $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
      $name = $line.Substring(0, $idStart).TrimEnd()
      $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
      $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
      $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
      $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
      $software = [upgradeSoftware]::new()
      $software.Name = $name;
      $software.Id = $id;
      $software.Version = $version
      $software.AvailableVersion = $available
      $software.Source = $source
      $upgradeList += $software
    }
  }
  $upgradeList
}

<#
.SYNOPSIS
  Displays a list of installed packages
.DESCRIPTION
  Show-WGList displays a grid view of all the packages installed on the system.  
  Each line is selectable.  Accepting the selection with Enter returns an array of objects.
  Pressing Escape quits the grid with no furher action.  
.EXAMPLE
  Show-WGList | Select-Object -Property Id | Uninstall-WGPackage
  In this example, the selected package in the grid will be uninstalled from the computer.
#>
function Show-WGList {
  param(
    [switch]$Single
  )
  # check_ocgv
  if ($single)
  {
    $list = _wgList | Out-ConsoleGridView -Title 'Installed Packages' -OutputMode Single
  }
  else {
    $list = _wgList | Out-ConsoleGridView -Title 'Installed Packages'  
  }
  return $list
  
}

function Show-WGUpdatables {
  # Parameter help description
  param(
  [Switch]
  $Multiple
  )
  # check_ocgv
  if (-not $Multiple) {
  $list = wgUpgradable | Out-ConsoleGridView -Title 'Upgradable Packages' -OutputMode Single
  }
  else {
    $list = wgUpgradable | Out-ConsoleGridView -Title 'Upgradable Packages'
  }
  # Write-Host $list
  return $list
}

function Search-WGPackage {
  param(
    [parameter (
      Mandatory,
      HelpMessage = "Package (or part) name to search"
    )]
    [string]$search,
    # Store Filter
    [Parameter(
      HelpMessage = "store to filter on"
    )]
    [string]
    $Store    
  )
  # check_ocgv
  _wgSearch $search $Store | Out-ConsoleGridView -Title "Search Package" -OutputMode Single
}

function Install-WGPackage {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [upgradeSoftware[]] $inObj
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $id = $inObj.id
  $command = "winget install '$id'"
  Invoke-Expression $command
}

function Uninstall-WGPackage {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    $inObj,
    [Parameter()]
    [Switch]$Interactive
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 

  if ($PSBoundParameters.ContainsKey('inObj')) {
    if ($PSBoundParameters.ContainsKey('Interactive')) {
      Write-Error "-Interactive switch cannot be used with pipeline variable"
      return
    }
  }

  if ($Interactive) {
    $pkg = Show-WGList -Single | Select-Object -Property id,Name
    if (-not $pkg) {
      return
    }
    $ids = $pkg
  }
  else {
    $ids = $inObj
  }


  $ids | ForEach-Object {
    $id = $_.id;
    $name = $_.name
    if (-not [string]::IsNullOrEmpty($id)) {
      Write-Host "Uninstlling : " -NoNewline
      Write-Host "$name ($id)" -ForegroundColor DarkCyan
      $command = "winget uninstall '$id' -Force"
      # Write-Host $command
      # Invoke-Expression $command
    }
    else {
      Write-Warning "Cannot uninstall unknown package"
    }
  }



  # $id = $inObj.id
  # $command = "winget uninstall '$id'"
  # Invoke-Expression $command
}

function Update-WGPackage {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [upgradeSoftware] $inObj,
    [Parameter()]
    [Switch]$Interactive,
    [Switch]$Force
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  if ($PSBoundParameters.ContainsKey('inObj')) {
    if ($PSBoundParameters.ContainsKey('Interactive')) {
      Write-Error "-Interactive switch cannot be used with pipeline variable"
      return
    }
  }
 
  if ($Interactive) {
    $pkg = Show-WGUpdatables -Multiple | Select-Object -Property id,Name
    if (-not $pkg) {
      return
    }
    $ids = $pkg
  }
  else {
    $ids = $inObj
  }

  # Write-Host $ids
  $forceinstall = ""
  if ($Force) {
    $forceinstall = "--accept-package-agreements"  
  }
  
  $ids | ForEach-Object {
    $id = $_.id;
    $name = $_.name
    if (-not [string]::IsNullOrEmpty($id)) {
      Write-Host "Updating : " -NoNewline
      Write-Host "$name ($id)" -ForegroundColor DarkCyan
      $command = "winget upgrade '$id' $forceinstall"
      # Write-Host $command
      Invoke-Expression $command
    }
    else {
      Write-Warning "Cannot update unknown package"
    }
  }
  
}


#Export-ModuleMember Get-WGList, Get-WGSearch, Get-WGUpgrade, Set-WGInstall, Set-WGRemove
_wgList