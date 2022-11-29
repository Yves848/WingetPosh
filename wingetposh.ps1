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
  [String]$Source
}

class column {
  [string]$Name
  [Int16]$Position
  [Int16]$Len
}

class Frame {
  [char]$UL
  [char]$UR
  [char]$TOP
  [char]$LEFT
  [char]$RIGHT
  [char]$BL
  [char]$BR
  [char]$BOTTOM
  [char]$LEFTSPLIT
  [char]$RIGHTSPLIT

  Frame (
      [bool]$Double
  ) {
      if ($Double) {
          $this.UL = "╔"
          $this.UR = "╗"
          $this.TOP = "═"
          $this.LEFT = "║"
          $this.RIGHT = "║"
          $this.BL = "╚"
          $this.BR = "╝"
          $this.BOTTOM = "═"
          $this.LEFTSPLIT = "⊫"
      }
      else {
          $this.UL = "┌"
          $this.UR = "┐"
          $this.TOP = "─"
          $this.LEFT = "│"
          $this.RIGHT = "│"
          $this.BL = "└"
          $this.BR = "┘"
          $this.BOTTOM = "─"
      }
  }
}

$Single = [Frame]::new($false)
$Double = [Frame]::new($true)

class window {
  [int]$X
  [int]$Y
  [int]$W
  [int]$H
  [Frame]$frameStyle
  [System.ConsoleColor]$frameColor
  [string]$title = ""
  [System.ConsoleColor]$titleColor
  [string]$footer = ""

  window(
      [int]$X,
      [int]$y,
      [int]$w,
      [int]$h,
      [bool]$Double,
      [System.ConsoleColor]$color = "White"
  ) {
      $this.X = $X
      $this.Y = $y
      $this.W = $W
      $this.H = $H
      $this.frameStyle = [Frame]::new($Double)
      $this.frameColor = $color
    
  }

  window(
      [int]$X,
      [int]$y,
      [int]$w,
      [int]$h,
      [bool]$Double,
      [System.ConsoleColor]$color = "White",
      [string]$title = "",
      [System.ConsoleColor]$titlecolor = "Blue"
  ) {
      $this.X = $X
      $this.Y = $y
      $this.W = $W
      $this.H = $H
      $this.frameStyle = [Frame]::new($Double)
      $this.frameColor = $color
      $this.title = $title
      $this.titleColor = $titlecolor
  }

  [void] setPosition(
      [int]$X,
      [int]$Y
  ) {
      [System.Console]::SetCursorPosition($X,$Y)
  }

  [void] drawWindow() {
      [System.Console]::CursorVisible = $false
      $this.setPosition($this.X,$this.Y)
    

      $bloc1 = "".PadLeft($this.W - 2, $this.frameStyle.TOP)
      $blank = "".PadLeft($this.W - 2, " ") 
      Write-Host $this.frameStyle.UL -NoNewline -ForegroundColor $this.frameColor
      Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
      Write-Host $this.frameStyle.UR -ForegroundColor $this.frameColor

      for ($i = 1; $i -lt $this.H; $i++) {
          $Y2 = $this.Y + $i
          $X2 = $this.X + $this.W - 1
          $this.setPosition($this.X, $Y2)
          Write-Host $this.frameStyle.LEFT -ForegroundColor $this.frameColor
        
          $X3 = $this.X + 1
          $this.setPosition($X3, $Y2)
          Write-Host $blank 
        
          $this.setPosition($X2, $Y2)
          Write-Host $this.frameStyle.RIGHT -ForegroundColor $this.frameColor
      }

      $Y2 = $this.Y + $this.H
      $this.setPosition( $this.X, $Y2)
      $bloc1 = "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM)
      Write-Host $this.frameStyle.BL -NoNewline -ForegroundColor $this.frameColor
      Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
      Write-Host $this.frameStyle.BR -ForegroundColor $this.frameColor
      $this.drawTitle()
      $this.drawFooter()
  }

  [void] drawTitle() {
      if ($this.title -ne "") {
          $local:X = $this.x + 2
          $this.setPosition($local:X, $this.Y)
          Write-Host "| " -NoNewline -ForegroundColor $this.frameColor
          $local:X = $local:X + 2
          $this.setPosition($local:X,$this.Y)
          Write-Host $this.title -NoNewline -ForegroundColor $this.titleColor
          $local:X = $local:X + $this.title.Length
          $this.setPosition($local:X, $this.Y)
          Write-Host " |" -NoNewline -ForegroundColor $this.frameColor
      }
  }

  [void] drawFooter() {
      if ($this.footer -ne "") {
        $local:x = ($this.W - ($this.footer.Length + 6))
          $local:Y = $this.Y + $this.h
          $this.setPosition($local:X, $local:Y)
          Write-Host "| " -NoNewline -ForegroundColor $this.frameColor
          $local:X = $local:X + 2
          $this.setPosition($local:X, $local:Y)
          Write-Host $this.footer -NoNewline -ForegroundColor $this.titleColor
          $local:X = $local:X + $this.footer.Length
          $this.setPosition($local:X, $local:Y)
          Write-Host " |" -NoNewline -ForegroundColor $this.frameColor
      }
  }

  [void] clearWindow() {
      $local:blank = "".PadLeft($this.W - 2, " ") 
      for ($i = 1; $i -lt $this.H; $i++) {
          $this.setPosition(($this.X + 1), ($this.Y + $i))
          Write-Host $blank 
      } 
  }
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
 

 
  if ($columns.Length -eq 5) {
    $availableStart =$columns[3].Position
    $sourceStart = $columns[4].Position
  }
  else {
    $sourceStart = $columns[3].Position
  }

  $InstalledList = @()

  if ($Columns.Length -eq 4) {
    For ($i = $fl + 1; $i -le $lines.Length; $i++) {
      $line = $lines[$i]
      if ($line.Length -gt ($sourceStart + 1) -and -not $line.StartsWith('-')) {
        $name = $line.Substring(0, $idStart).TrimEnd()
        $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
        $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
        $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
        if ($source -ne "") {
          $software = [InstallSoftware]::new()
          $software.Name = $name;
          $software.Id = $id;
          $software.Version = $version
          $software.Source = $source
          $InstalledList += $software
        }
      }
    }
  }
  else {
    For ($i = $fl + 1; $i -le $lines.Length; $i++) {
      $line = $lines[$i]
      if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
        $name = $line.Substring(0, $idStart).TrimEnd()
        $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
        $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
        $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
        $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
        if ($source -ne "") {
          $software = [UpgradeSoftware]::new()
          $software.Name = $name;
          $software.Id = $id;
          $software.Version = $version
          $software.AvailableVersion = $available
          $software.Source = "Winget"
          $InstalledList += $software
        }
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

  $command = "winget search --name ${search} --source winget"

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
      $version = $line.Substring($versionStart, $line.Length - $versionStart).TrimEnd()
      $source = "Winget"
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
  while ($fl -lt $lines.Length -and -not $lines[$fl].StartsWith("----")) {
    $fl++
  }

  if ($fl -lt $lines.Length) {

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
      HelpMessage = "Package (or part) name to search"
    )]
    [string]$search,
    # Store Filter
    [Parameter(
      HelpMessage = "store to filter on"
    )]
    [string]
    $Store,
    [Switch]$Interactive,
    [Switch]$Install    
  )
  # check_ocgv
  if ($Interactive -or [string]::IsNullOrEmpty($search))
  {
    [System.Console]::Clear()
    $search = getSearchTerms
    [System.Console]::Clear()
  }

  $packages = _wgSearch $search $Store | Out-ConsoleGridView -Title "Search Package" -OutputMode Single
  if ($Install) {
    $packages | Select-Object -Property id | Install-WGPackage
  } else {
    return $packages
  }
}

function getSearchTerms {
  $WinWidth = [System.Console]::WindowWidth
    $X = 0
    $Y = [System.Console]::WindowHeight -6
    $WinHeigt = 4

    $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = "Search"
  $Win.titleColor = "Green"
  $win.footer = "[Enter] : Accept [Ctrl-C] : Abort"
  $win.drawWindow();
  $win.setPosition($X+2, $Y+2);
  [System.Console]::Write('Package : ')
  [system.console]::CursorVisible = $true
  $pack = [System.Console]::ReadLine()
  return $pack
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
      Write-Host "Uninstalling : " -NoNewline
      Write-Host "$name ($id)" -ForegroundColor DarkCyan
      $command = "winget uninstall '$id' --Force"
      #Write-Host $command
      Invoke-Expression $command
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


#Export-ModuleMember Get-WGList, Get-WGSearch, Get-WGUpgrade, Set-WGInstall, Set-WGRemov_
_wgList