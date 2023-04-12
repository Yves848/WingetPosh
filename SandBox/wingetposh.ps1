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

function Invoke-Expression2 {
  param(
    [string]$exp,
    [string]$title
  )
  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $statedata.X = 0
  $statedata.Y = $Host.UI.RawUI.CursorPosition.Y
  $statedata.title = $title
  $runspace = [runspacefactory]::CreateRunspace()
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData", $StateData)
  $sb = {
    $x = $statedata.X
    $y = $statedata.Y
    $spinner = '{"aesthetic": {
      "interval": 80,
      "frames": [
        "▰▱▱▱▱▱▱",
        "▰▰▱▱▱▱▱",
        "▰▰▰▱▱▱▱",
        "▰▰▰▰▱▱▱",
        "▰▰▰▰▰▱▱",
        "▰▰▰▰▰▰▱",
        "▰▰▰▰▰▰▰",
        "▰▱▱▱▱▱▱"
      ]
    }}'
    $spinners = $spinner | ConvertFrom-Json 
    $frameCount = $spinners.aesthetic.frames.count
    $frameInterval = $spinners.aesthetic.interval

    $i = 1
    $string = "".PadRight(30, ".")
    $nav = "oOo"
    while ($true) {
      $e = "$([char]27)"
      [System.Console]::setcursorposition($X, $Y)
      $frame = $spinners.aesthetic.frames[$i % $frameCount]
      $string = "$($e)[s","$e[u$frame"," $($statedata.title)" -join ""
      [System.Console]::write($string)
      Start-Sleep -Milliseconds $frameInterval
      $i++
    }
  }
  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $runspace
  $handle = $session.BeginInvoke()
  $result = Invoke-Expression -Command $exp

  $session.Stop()
  $runspace.Dispose()
  [System.Console]::setcursorposition($statedata.X, $statedata.Y)
  [System.Console]::write("".PadRight($Host.UI.RawUI.BufferSize.Width, " "))
}

function Invoke-Winget {
  param (
    [string]$cmd
  )
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  $TerminalWidth = $Host.UI.RawUI.BufferSize.Width - 2
  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $statedata.X = 1
  $statedata.Y = $Host.UI.RawUI.CursorPosition.Y
  $runspace = [runspacefactory]::CreateRunspace()
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData", $StateData)
  
  
  $sb = {
    $x = $statedata.X
    $y = $statedata.Y
    $i = 1
    #Write-Host $statedata
    $string = "".PadRight(30, ".")
    $nav = "oOo"
    while ($true) {
      if ($i -lt $nav.Length) {
        $mobile = $nav.Substring($nav.Length - $i)
        $string = $mobile.PadRight(30, '.')
      }
      else {
        if ($i -gt 27) {
          $nb = 30 - $i
          $mobile = $nav.Substring(1, $nb)
          $string = $mobile.PadLeft(30, '.')
        }
        else {
          $left = "".PadLeft($i, '.')
          $right = "".PadRight(27 - $i, '.')
          $string = $left, $nav, $right -join ""
        }
      }
      [System.Console]::setcursorposition($X, $Y)
      $str = '⏳ Getting the data ', $string -join ""
      [System.Console]::write($str)
      $i++
      if ($i -gt 30) {
        $i = 1
      }
      Start-Sleep -Milliseconds 100
    }
  
  }
  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $runspace
  $handle = $session.BeginInvoke()
  
  $PackageList = @()
  $SearchResult = Invoke-Expression $cmd | Out-String -Width $TerminalWidth -Stream 

  $SearchResult | ForEach-Object -Begin { $i = 0; $data = $false } -Process {
    if ($_.StartsWith('---')) {
      $lWidth = $_.Length
      $cols = getColumnsHeaders -columsLine $SearchResult[$i - 1]
      $columns.Clear()
      $i = 1
      foreach ($col in [column[]]$cols) {
        if ($i -lt $cols.length) {
          $colPercent = [Math]::Round(($col.Len / $lWidth * 100) - 0.99, 2)
          $colWidth = [System.Math]::Truncate($TerminalWidth / 100 * $colPercent);
        }
        else {
          $colWidth = $col.len  
        }
        $i++
        $Columns.Add($col.Name, @($col.Position, $colWidth, $col.len))
      }
      $data = $true
    }
    else {
      if ($data) {
        $s = [string]$_
        $package = [ordered]@{}
        $i2 = 0
        foreach ($col in $cols) {
          [System.Text.StringBuilder]$sb = New-Object System.Text.StringBuilder $col.Len
          $charcount = 0
          while ($charcount -lt $col.Len) {
            [char]$char = $s[$i2]
            if (-not ([bool]$char)) {
              $char = " "
            }
            [void]$sb.Append($char)
            $nbBytes = [Text.Encoding]::UTF8.GetByteCount($char)
            if ($nbBytes -gt 1) {
              $charcount += ($nbBytes - 1)
            }
            else {
              $charcount += $nbBytes
            }
            $i2++
          }
          $field = $sb.ToString()
          if ($field.Contains("…")) {
            $i2++
          }
          $field = adjustCol -len $columns.$($col.Name)[1] -col $field
          
          $sb = $null
          $package.Add($col.Name, $field)
        }
        $PackageList += $package
      }
    }
    $i++
  }
  $session.Stop()
  $runspace.Dispose()
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

function adjustCol {
  param(
    [int]$len,
    [string]$col
  )
  
  $charcount = 0
  $i = 0
  $field = ""
  while ($charcount -lt $len) {
    [char]$char = $col[$i]
    $field = $field + $char
    $nbBytes = [Text.Encoding]::UTF8.GetByteCount($char)
    if ($nbBytes -gt 1) {
      $charcount += ($nbBytes - 1)
    }
    else {
      $charcount += $nbBytes
    }
    $i++
  }
  
  if ($field.Contains("…")) {
    $field = $field, " " -join ""
  }
  
  return $field
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
    $line = $line, $col -join " "
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
  

function displayGrid {
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    $list,
    [string]$title, 
    [ref]$data, 
    $allowSearch = $false
  )
   
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
  
  $statedata.X = ($win.X + 3)
  $statedata.Y = ($win.Y + 1)
 
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
  
   
function Get-WGPackage {
  param(
    [string]$source,
    [switch]$interactive,
    [switch]$uninstall,
    [switch]$update,
    [switch]$apply
  )
  $title = ""
  if ($update) {
    $command = "winget update"
  }
  else {
    $command = "winget list"
  }
  
  if ($apply) {
    if (-not $interactive) {
      Write-Warning "🚫 -apply can only be used with -interactive"
      return $null
    }
    if ((-not $update) -and (-not $uninstall)) {
      Write-Warning "🚫 -apply can only be used with -update or -uninstall"
      return $null
    }
  }

  if ($update -or $uninstall) {
    if (-not $interactive) {
      Write-Warning "🚫 -update and -uninstall can only be used with -interactive"
      return $null
    }
  }

  if ($update) {
    $title = "⫷ Update ⫸"
  }
  else {
    if ($uninstall) {
      $title = "⫷ Uninstall ⫸"
    }
  }

  $list = Invoke-Winget $command

  if ($source) {
    $list = $list |  Where-Object { $_.source -eq $source }
  }
  
  if ($interactive) {
    $data = @()
    displayGrid -list $list -title "Packages List $($title)" -data ([ref]$data) -allowSearch $false
    if ($apply) {
      $title = ""
      if ($data.length -gt 0) {
        $data | Out-Object | ForEach-Object {
          $id = ($_.Id).Trim()
          if ($uninstall) {
            $expression = "winget uninstall --id $($id)"
            $title = "🗑️ Uninstall $($id)"
          }
          else {
            $expression = "winget upgrade --id $($id)"
            $title = "⚡ Upgrade $($id)"
          }
          [System.Console]::CursorVisible = $false
          Invoke-Expression2 -exp $expression -title $title
          #Write-Host "Exit code : $($LASTEXITCODE)"
          Write-Host "Name $($_.Name)"
          [System.Console]::CursorVisible = $true
        }
      }
      # display summary.

    } else {
      $data
    }
  }
  else {
    $list
  }
}

function Search-WGPackage {
  param(
    [string]$package,
    [string]$source,
    [switch]$interactive,
    [switch]$allowSearch,
    [ValidateScript({ $interactive })]
    [switch]$install
  )
  begin {
    $terms = $package
    if ($package.Trim() -eq "") {
      $terms = getSearchTerms
    }
  }
  process {
    if ($terms -ne "") {
      $command = "winget search '$terms'"
      $list = Invoke-Winget $command
      if ($source) {
        $list = $list |  Where-Object { $_.source -eq $source }
      }
      if ($interactive) {
        $data = @()
        displayGrid -list $list -title "Package Search" -data ([ref]$data) -allowSearch $allowSearch
        if ($install) {
          if ($data.length -gt 0) {
            $data | Out-Object | ForEach-Object {
              $id = ($_.Id).Trim()
              $expression = "winget install --id $($id)"
              [System.Console]::CursorVisible = $false
              Invoke-Expression2 -exp $expression -title "⚡ Installation of $($id)"
              #Write-Host "Exit code : $($LASTEXITCODE)"
              [System.Console]::CursorVisible = $true
            }
          }
        }
        $data
      }
      else {
        $list
      }
    }
    else {
      "Aborted"
    }
  }
}

function Out-Object {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]
    $Data
  )
  begin {
    [pscustomobject[]]$result = @()
  }
  process {
    foreach ($d in $data) {
      $result += [pscustomobject]$d
    }
  }
  end {
    return $result
  }
}


#Search-WGPackage -search code
#Install-WGPackage -install
Get-WGPackage -interactive | Out-Object
#Get-WGUpdatables
#$list = Show-WGList
#Update-WGPackage -update
#Search-WGPackage -package 'notepad' -interactive -install -source winget