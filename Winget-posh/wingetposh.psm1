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
  while (-not $lines[$fl].StartsWith("Nom")) {
    $fl++
  }
  
  $idStart = $lines[$fl].IndexOf("ID")
  $versionStart = $lines[$fl].IndexOf("Version")
  $availableStart = $lines[$fl].IndexOf("Disponible")
  $sourceStart = $lines[$fl].IndexOf("Source")

  $InstalledList = @()
  For ($i = $fl + 1; $i -le $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
      $name = $line.Substring(0, $idStart).TrimEnd()
      $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
      $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
      $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
      $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
      if ($source -ne "") {
        $software = [upgradeSoftware]::new()
        $software.Name = $name;
        $software.Id = $id;
        $software.Version = $version
        $software.AvailableVersion = $available
        $software.Source = $source
        $InstalledList += $software
      }
    }
  }
  $installedList
}

function check_ocgv {
  if(-not (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable)){
    Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force
    }
}

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
  while (-not $lines[$fl].StartsWith("Nom")) {
    $fl++
  }
  $idStart = $lines[$fl].IndexOf("ID")
  $versionStart = $lines[$fl].IndexOf("Version")
  if ($store -eq "") {
    $sourceStart = $lines[$fl].IndexOf("Source")
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
  while (-not $lines[$fl].StartsWith("Nom")) {
      $fl++
  }

  $idStart = $lines[$fl].IndexOf("ID")
  $versionStart = $lines[$fl].IndexOf("Version")
  $availableStart = $lines[$fl].IndexOf("Disponible")
  $sourceStart = $lines[$fl].IndexOf("Source")

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

function Get-WGList {
  check_ocgv
  _wgList | Out-ConsoleGridView -Title 'Installed Packages'
}

function Get-WGUpgrade {
  check_ocgv
  wgUpgradable | Out-ConsoleGridView -Title 'Upgradable Packages'
}

function Get-WGSearch {
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
  check_ocgv
  _wgSearch $search $Store | Out-ConsoleGridView -Title "Search Package" -OutputMode Single
}

function Set-WGInstall{
  [CmdletBinding()]
  param (
      [Parameter(ValueFromPipeline)]
      $inObj
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $id = $inObj.id
  $command = "winget install '$id'"
  Invoke-Expression $command
}

function Set-WGRemove{
  [CmdletBinding()]
  param (
      [Parameter(ValueFromPipeline)]
      $inObj
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $id = $inObj.id
  $command = "winget uninstall '$id'"
  Invoke-Expression $command
}

function set-WGUpgrade {
  [CmdletBinding()]
  param (
      [Parameter(ValueFromPipeline)]
      $inObj
  )

  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $id = $inObj.id
  $command = "winget upgrade '$id'"
  Invoke-Expression $command
}


#Export-ModuleMember Get-WGList, Get-WGSearch, Get-WGUpgrade, Set-WGInstall, Set-WGRemove