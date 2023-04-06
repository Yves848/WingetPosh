[Flags()] enum Styles {
  Normal = 0
  Underline = 1
  Bold = 2
  Reversed = 3
}

class upgradeSoftware {
  [boolean]$Selected
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
  
class column {
  [string]$Name
  [Int16]$Position
  [Int16]$Len
}
    
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
  [int]$page = 1
  [int]$nbPages = 1
  
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
    [System.Console]::SetCursorPosition($X, $Y)
  }
  
  [void] drawWindow() {
    $esc = $([char]0x1b)

    [System.Console]::CursorVisible = $false
    $this.setPosition($this.X, $this.Y)
    $bloc1 = $this.frameStyle.UL, "".PadLeft($this.W - 2, $this.frameStyle.TOP), $this.frameStyle.UR -join ""
    $blank = "$esc[38;5;15m$($this.frameStyle.LEFT)", "".PadLeft($this.W - 2, " "), "$esc[38;5;15m$($this.frameStyle.RIGHT)" -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    for ($i = 1; $i -lt $this.H; $i++) {
      $Y2 = $this.Y + $i
      $X3 = $this.X 
      $this.setPosition($X3, $Y2)
      Write-Host $blank     
    }
    $Y2 = $this.Y + $this.H
    $this.setPosition( $this.X, $Y2)
    $bloc1 = $this.frameStyle.BL, "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM), $this.frameStyle.BR -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    $this.drawTitle()
    $this.drawFooter()
  }
  
  
  [void] drawVersion() {
    $version = $this.frameStyle.LEFT, [string]$(Get-InstalledModule -Name wingetposh -ErrorAction Ignore).version, $this.frameStyle.RIGHT -join ""
    [System.Console]::setcursorposition($this.W - ($version.Length + 6), $this.Y )
    [console]::write($version)
  }
  
  [void] drawTitle() {
    if ($this.title -ne "") {
      $local:X = $this.x + 2
      $this.setPosition($local:X, $this.Y)
      Write-Host "| " -NoNewline -ForegroundColor $this.frameColor
      $local:X = $local:X + 2
      $this.setPosition($local:X, $this.Y)
      Write-Host $this.title -NoNewline -ForegroundColor $this.titleColor
      $local:X = $local:X + $this.title.Length
      $this.setPosition($local:X, $this.Y)
      Write-Host " |" -NoNewline -ForegroundColor $this.frameColor
    }
  }
  
  [void] drawFooter() {
    $Y2 = $this.Y + $this.H
    $this.setPosition( $this.X, $Y2)
    $bloc1 = $this.frameStyle.BL, "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM), $this.frameStyle.BR -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    if ($this.footer -ne "") {
      $local:x = $this.x + 2
      $local:Y = $this.Y + $this.h
      $this.setPosition($local:X, $local:Y)
      [console]::write($this.footer)
    }
  }
  
  [void] drawPagination() {
    $sPages = ('Page {0}/{1}' -f ($this.page, $this.nbPages))
    [System.Console]::setcursorposition($this.W - ($sPages.Length + 6), $this.Y + $this.H)
    [console]::write($sPages)
  }
  
  [void] clearWindow() {
    $local:blank = "".PadLeft($this.W, " ") 
    for ($i = 1; $i -lt $this.H; $i++) {
      $this.setPosition(($this.X), ($this.Y + $i))
      Write-Host $blank 
    } 
  }
}
  
$columns = [ordered]@{}
  
function getSearchTerms {
  $WinWidth = [System.Console]::WindowWidth
  $X = 0
  $Y = [System.Console]::WindowHeight - 6
  $WinHeigt = 4
  
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = "Search"
  $Win.titleColor = "Green"
  $win.footer = "$(color "[Enter]" "red") : Accept $(color "[Ctrl-C]" "red") : Abort"
  $win.drawWindow();
  $win.setPosition($X + 2, $Y + 2);
  [System.Console]::Write('Package : ')
  [system.console]::CursorVisible = $true
  $pack = [ System.Console]::ReadLine()
  return $pack
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
    if ($i -eq $Cols.Length - 1) {
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

function color {
  param (
    $Text,
    $ForegroundColor = 'default',
    $BackgroundColor = 'default'
  )
  # Terminal Colors
  $Colors = @{
    "default"    = @(40, 50)
    "black"      = @(30, 0)
    "lightgrey"  = @(33, 43)
    "grey"       = @(37, 47)
    "darkgrey"   = @(90, 100)
    "red"        = @(91, 101)
    "darkred"    = @(31, 41)
    "green"      = @(92, 102)
    "darkgreen"  = @(32, 42)
    "yellow"     = @(93, 103)
    "white"      = @(97, 107)
    "brightblue" = @(94, 104)
    "darkblue"   = @(34, 44)
    "indigo"     = @(35, 45)
    "cyan"       = @(96, 106)
    "darkcyan"   = @(36, 46)
  }
  
  if ( $ForegroundColor -notin $Colors.Keys -or $BackgroundColor -notin $Colors.Keys) {
    Write-Error "Invalid color choice!" -ErrorAction Stop
  }
  
  "$([char]27)[$($colors[$ForegroundColor][0])m$([char]27)[$($colors[$BackgroundColor][1])m$($Text)$([char]27)[0m"    
}
  
function Invoke-Winget {
  param (
    [string]$cmd
  )
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $TerminalWidth = $Host.UI.RawUI.BufferSize.Width - 2

  $SearchResult = Invoke-Expression $cmd | Out-String -Width $TerminalWidth
  [string[]]$lines = $SearchResult -Split [Environment]::NewLine
  
  $fl = 0
  while (-not $lines[$fl].StartsWith("----")) {
    $fl++
  }
  
  $cols = getColumnsHeaders -columsLine $lines[$fl - 1]
  $lWidth = $lines[$fl].Length
  
  $PackageList = @()
  $columns.Clear()
  foreach ($col in [column[]]$cols) {
    if ($col.name -ne "source") {
    $colPercent = [Math]::Round(($col.Len / $lWidth * 100) - 0.99, 2)
    $colWidth = [System.Math]::Truncate($TerminalWidth / 100 * $colPercent);
    }
    else {
      $colWidth = $col.len  
    }
    $Columns.Add($col.Name, @($col.Position, $colWidth, $col.len))
  }
  
  For ($i = $fl + 1; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if (-not $line.StartsWith('-')) {
      foreach ($column in $columns) {
        $package = [ordered]@{}
        try {
          foreach ($key in $column.keys) {
            $curcol = $column[$key]
            $field = $line.Substring($curcol[0], $curcol[2])
            $package.Add($key, $field)  
          }
          $PackageList += $package
        }
        catch {
          <#Do this if a terminating exception happens#>
        }
      }
    }
  }
  
  return $PackageList 
}
  
function makeBlanks {
  param(
    $nblines,
    $win
  )
  if ($iscoreclr) {
    $esc = "`e"
  }
  else {
    $esc = $([char]0x1b)
  }
  $blanks = 1..$nblines | ForEach-Object {
    "$esc[38;5;15m$($Single.LEFT)", "".PadLeft($Win.W - 2, " "), "$esc[38;5;15m$($Single.RIGHT)" -join ""
  }
  $blanks | Out-String
}


function makelines {
  param (
    $list,
    $checked,
    $row,
    $selected,
    $W
  ) 
  if ($iscoreclr) {
    $esc = "`e"
  }
  else {
    $esc = $([char]0x1b)
  }
  [string]$line = ""
  foreach ($key in $columns.keys) {
    [string]$col = $list.$key
    $l = $columns[$key][1]
    if ($col.Length -gt $l) {
      $col = $col.Substring(0, $l)
    }
    $line = $line, $col.PadRight($l, " ") -join " "
  }
  if ($row -eq $selected) {
    $line = "$esc[48;5;33m$esc[38;5;15m$($line)"
  }
  if ($row % 2 -eq 0) {
    $line = "$esc[38;5;7m$($line)"
  }
  else {
    $line = "$esc[38;5;8m$($line)"
  }
  if ($checked) {
    $line = "$esc[38;5;46m$('✓')", $line -join ""
  }
  else {
    $line = " ", $line -join ""
  }

  "$esc[38;5;15m$($Single.LEFT)$($line)$esc[0m"
}
  
function displayGrid($title, [scriptblock]$cmd, [ref]$data, $allowSearch = $false) {
  $global:Host.UI.RawUI.FlushInputBuffer()
  $WinWidth = [System.Console]::WindowWidth
  $X = 0
  $Y = 0
  $WinHeigt = [System.Console]::WindowHeight - 1
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = $title
  $Win.titleColor = "Green"
  $win.footer = $Single.LEFT, "$(color "[?]" "red") : Help $(color "[Space]" "red") : Select/Unselect $(color "[Enter]" "red") : Accept $(color "[Esc]" "red") : Quit", $Single.RIGHT -join ""
  $win.drawWindow();
  $win.drawVersion();
  $nbLines = $Win.h - 1
  $blanks = makeBlanks $nblines $win

  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $runspace = [runspacefactory]::CreateRunspace()
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData",$StateData)

  $sb = {
    $x = $statedata.X
    $y = $statedata.Y
    $i = 1
    Write-Host $statedata
    while($true) {
      [System.Console]::setcursorposition($X, $Y)
      $str = '⏳ Getting the data ', ''.PadLeft($i,'.') -join ''
      [System.Console]::write($str)
      $i++
      Start-Sleep -Milliseconds 50
    }
  }
  
  $session = [powershell]::create()
  $statedata.X = ($win.X + 3)
  $statedata.Y = ($win.Y + 1)
  $session.Runspace = $runspace
  $null = $session.AddScript($sb)
  $handle = $session.BeginInvoke()
  $list = Invoke-Command -ScriptBlock $cmd
  $session.Stop()
  $runspace.Dispose()
  $skip = 0
  $nbPages = [math]::Ceiling($list.count / $nbLines)
  $win.nbpages = $nbPages
  $page = 1
  $selected = 0
  [System.Console]::CursorVisible = $false
  $redraw = $true
  while (-not $stop) {
    $win.page = $page
    [System.Console]::setcursorposition($win.X, $win.Y + 1)
    $row = 0
    $partlist = $list | Select-Object -First $nblines -Skip $skip | ForEach-Object {
      $index = (($page - 1) * $nbLines) + $row
      $checked = $list[$index].Selected
      makelines $list[$index] $checked $row $selected $win.W-2
      $row++
    }
    $nbDisplay = $partlist.Length
    $sText = $partlist | Out-String 
    if ($redraw) {
      [System.Console]::setcursorposition($win.X, $win.Y + 1)
      [system.console]::write($blanks)
      $redraw = $false
    }
    [System.Console]::setcursorposition($win.X, $win.Y + 1)
    [system.console]::write($sText.Substring(0, $sText.Length - 2))
    $win.drawPagination()
    while (-not $stop) {
      if ($global:Host.UI.RawUI.KeyAvailable) { 
        [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
        if ($key.Character -eq '?') {
          # Help
          displayHelp $allowSearch
        }
        if ($key.character -eq 'q' -or $key.VirtualKeyCode -eq 27) {
          # Quit
          $stop = $true
        }
        if ($key.VirtualKeyCode -eq 38) {
          # key up
          if ($selected -gt 0) {
            $selected --
          }
        }
        if ($key.VirtualKeyCode -eq 40) {
          # key Down
          if ($selected -lt $nbDisplay - 1) {
            $selected ++
          }
        }
        if ($key.VirtualKeyCode -eq 37) {
          # key Left
          if ($page -gt 1) {
            $skip -= $nbLines
            $page -= 1
            $selected = 0
            $redraw = $true     
          }
        }
        if ($key.VirtualKeyCode -eq 39) {
          # key Right
          if ($page -lt $nbPages) {
            $skip += $nbLines
            $page += 1
            $selected = 0
            $redraw = $true
          }
        }
        if ($key.VirtualKeyCode -eq 32) {
          # key Space
          $index = (($page - 1) * $nbLines) + $selected
          $checked = $list[$index].Selected
          $list[$index].Selected = -not $checked
        }
        if ($key.VirtualKeyCode -eq 13) {
          # key Enter
          Clear-Host
          $data.value = $data.value = $list | Where-Object { $_.Selected }
          $stop = $true
        }
        if ($key.VirtualKeyCode -eq 114) {
          # key F3
          if ($allowSearch) {
            $term = getSearchTerms
            [System.Console]::CursorVisible = $false
            $term = '"', $term, '"' -join ''
            $sb = { Invoke-Winget "winget search --name $term" | Where-Object { $_.source -eq "winget" } }
            $list = Invoke-Command -ScriptBlock $sb
            $skip = 0
            $nbPages = [math]::Ceiling($list.count / $nbLines)
            $win.nbpages = $nbPages
            $page = 1
            $selected = 0
            $redraw = $true
          }
        }
        if ($key.character -eq "+") {
          # key +
          $checked = $true
          $list | ForEach-Object { $_.Selected = $checked }
        }
        if ($key.character -eq "-") {
          # key -
          $checked = $false
          $list | ForEach-Object { $_.Selected = $checked }
        }
        break
      }
      Start-Sleep -Milliseconds 20
    }    
  }
  [System.Console]::CursorVisible = $true
  Clear-Host
}
  
function displayHelp {
  param(
    [boolean]$allowSearch
  )
  $global:Host.UI.RawUI.FlushInputBuffer()
  $WinWidth = [System.Console]::WindowWidth - 4
  $X = 2
  $Y = 10
  $WinHeigt = 6
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = "Help"
  $Win.titleColor = "Blue"
  $win.footer = $Single.LEFT, "$(color "[Esc]" "red") : Close", $Single.RIGHT -join ""
  $win.drawWindow();

  $buffer = "$(color "↑↓" "cyan") : Navigate `t`t`t`t $(color "← →" "cyan") Change page"
  [System.Console]::setcursorposition($win.X + 2, $win.Y + 1)
  [system.console]::write($buffer)
  $buffer = "$(color "Space" "cyan") : Select / Unselect package `t`t $(color "+/-" "cyan") Select All/None "
  [System.Console]::setcursorposition($win.X + 2, $win.Y + 2)
  [system.console]::write($buffer)
  if ($allowSearch) {
    $buffer = "$(color "F3" "cyan") : Enter Package Name"
    [System.Console]::setcursorposition($win.X + 2, $win.Y + 3)
    [system.console]::write($buffer)
  }
  $stop = $false;
  while (-not $stop) {
    if ($global:Host.UI.RawUI.KeyAvailable) { 
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      if ($key.character -eq 'q' -or $key.VirtualKeyCode -eq 27) {
        $stop = $true
      }
    }
  }
}
  
  
function Show-WGList {
  begin {
    $sb = { Invoke-Winget "winget list" | Where-Object { $_.source -eq "winget" } }
    $data = @{}
  }
  process {
    displayGrid -title "Installed Packages" -cmd $sb -data ([ref]$data)
  }
  end {
    return $data
  } 
}
  
function  Update-WGPackage {
  param (
    [switch]$update
  )
  begin {
    $sb = { Invoke-Winget "winget upgrade --include-unknown" | Where-Object { $_.source -eq "winget" } }
    $data = @()
  }
  process {
    displayGrid -title "Upgradable Packages" -cmd $sb -data ([ref]$data)
    if ($update) {
      if ($data.length -gt 0) {
        $data | Out-Object | ForEach-Object {
          $id = $_.Id
          $expression = "winget upgrade --id $($id)"
          Invoke-Expression $expression
        }
      }
    }
  }
  end {
    return $data
  }
}
  
function Install-WGPackage {
  param (
    [switch]$install,
    [string]$package = ""
    
  )
  begin {
    if ($package -eq "") {
      $term = getSearchTerms
    }
    else {
      $term = $package
    }
  }
  process {
    if ($term.Trim() -ne "") {
      $term = '"', $term, '"' -join ''
      $sb = { Invoke-Winget "winget search $term" | Where-Object { $_.source -eq "winget" } }
      $data = @()
      displayGrid -title "Install Package" -cmd $sb -data ([ref]$data) $true
      if ($install) {
        if ($data.length -gt 0) {
          $data | Out-Object | ForEach-Object {
            $id = $_.Id
            $expression = "winget install --id $($id)"
            Invoke-Expression $expression
          }
        }
      }
    }
  }
  end {
    return $data
  }
}
  
function Uninstall-WGPackage {
  begin {
    $sb = { Invoke-Winget "winget list" | Where-Object { $_.source -eq "winget" } }
    $data = @()
  }
  process {
    displayGrid -title "Remove Packages" -cmd $sb -data ([ref]$data)
    if ($data.length -gt 0) {
      $data | Out-Object | ForEach-Object {
        $id = $_.Id
        $expression = "winget uninstall --id $($id)"
        Invoke-Expression $expression
      }
    }
  }
  end {
    return $data
  }
}
  
function Get-WGList {
  Invoke-Winget "winget list" | Where-Object { $_.source -eq "winget" }
}

function Search-WGPackage {
  param(
    [Parameter(Mandatory=$true)]
    [string]$package
  )
  Invoke-Winget "winget search $package" | Where-Object { $_.source -eq "winget" }
}
  
function Get-WGUpdatables {
  Invoke-Winget "winget upgrade --include-unknown" | Where-Object { $_.source -eq "winget" }
}

function Out-Object {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      [hashtable]
      $Data
  )
  begin {
    [PSCustomObject[]]$result = @()
  }
  process {
    foreach($d in $data) {
      $result += [pscustomobject]$d
    }
  }
  end {
    return $result
  }
}
  
function testcolor {
  if ($iscoreclr) {
    $esc = "`e"
  }
  else {
    $esc = $([char]0x1b)
  }
  0..255 | ForEach-Object {
    Write-Host "$esc[4m$esc[38;5;$($_)m'test'$esc[0m"
  } 
}

#Search-WGPackage -search code
#Install-WGPackage -install
#Get-WGList
#Get-WGUpdatables
$list = Show-WGList
#Update-WGPackage -update