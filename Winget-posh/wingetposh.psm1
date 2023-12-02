$include = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) 

. "$include\visuals.ps1"

$widths = @(32, 32, 14, 14  , 8)
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

class scoopList {
  [string]$Info
  [string]$Name
  [string]$Version
  [string]$Source
  [datetime]$Updated

}
class scoopSearch {
  [string]$Name
  [string]$Version
  [string]$Source
  [string]$Binaries

}

class scoopBuckets {
  [string]$Name
  [string]$Source
  [string]$Updated
  [int]$Manifests
}

class wingetSource {
  [string]$Name
  [string]$Argument
}
  
class Keys {
  static [string] $enter
  static [string] $space 
  static [string] $escape

  static Keys() {
    [Keys]::enter = [char]::ConvertFromUtf32(0xf0311)
    [Keys]::space = [char]::ConvertFromUtf32(0xf1050)
    [Keys]::escape = [char]::ConvertFromUtf32(0xf12b7)
  }
}
 

$baseFields = @{
  'SearchName'        = 'Name'
  'SearchID'          = 'Id'
  'SearchVersion'     = 'Version'
  'AvailableHeader'   = 'Available'
  'SearchSource'      = 'Source'
  'ShowVersion'       = 'Version'
  'AvailableUpgrades' = 'upgrades available.'
  "SearchMatch"       = "Moniker"
  "SourceListName"    = "Name"
  "SourceListArg"     = "Argument"
}
  
class column {
  [string]$Name
  [Int16]$Position
  [Int16]$Len
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
  $win.footer = "$(color "[Enter]" "red") : Accept $(color "[Esc]" "red") : Abort"
  $win.drawWindow();
  $win.setPosition($X + 2, $Y + 2);
  [System.Console]::Write('Package : ')
  [system.console]::CursorVisible = $true
  try {
    [Microsoft.PowerShell.PSConsoleReadLineOptions]$option = Get-PSReadLineOption
    $save = $option.PredictionSource
    Set-PSReadLineKeyHandler -key Escape -Function CancelLine
    Set-PSReadLineOption -PredictionSource None
    $pack = PSConsoleHostReadLine  
  }
  finally {
    Remove-PSReadLineKeyHandler -Key Escape
    Set-PSReadLineOption -PredictionSource $save
    removeLastPSRealineHistoryItem
    [console]::CursorVisible = $false
  }
  
  return $pack
}

function removeLastPSRealineHistoryItem {
  $psreadline_history = (Get-PSReadLineOption).HistorySavePath
  $h = Get-Content $psreadline_history
  $output = $h[0..($h.count - 2)]
  Clear-History -Newest
}

function getFilterSource {
  $WinWidth = [System.Console]::WindowWidth
  $X = 0
  $Y = [System.Console]::WindowHeight - 6
  $WinHeigt = 4
  
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = "Source Filter"
  $Win.titleColor = "Green"
  $win.footer = "$(color "[Enter]" "red") : Accept $(color "[Esc]" "red") : Abort"
  $win.drawWindow();
  $win.setPosition($X + 2, $Y + 2);
  [System.Console]::Write('Source : ')
  [system.console]::CursorVisible = $true
  try {
    [Microsoft.PowerShell.PSConsoleReadLineOptions]$option = Get-PSReadLineOption
    $save = $option.PredictionSource
    Set-PSReadLineKeyHandler -key Escape -Function CancelLine
    Set-PSReadLineOption -PredictionSource None
    $pack = PSConsoleHostReadLine  
  }
  finally {
    Remove-PSReadLineKeyHandler -Key Escape
    Set-PSReadLineOption -PredictionSource $save
    [console]::CursorVisible = $false
  }
  
  return $pack
}
  

function getColumnsHeaders {
  param(
    [parameter (
      Mandatory
    )]
    [string]$columsLine,
    [int]$width
  )

  $script:fields = Get-Content $env:USERPROFILE\.config\.wingetposh\locals.json | ConvertFrom-Json
  

  $tempCols = ($columsLine | Select-String -Pattern "(?:\S+)" -AllMatches).Matches
  $result = @()
  
  $w = $columsLine.Length
  $i = 0
  while ($i -lt $tempCols.Count) {
    $pos = $tempCols[$i].Index
    if ($i -eq $tempCols.Count - 1) {
      # Last Column
      $len = $width - $pos
    }
    else {
      # Not last Column
      $len = $tempCols[$i + 1].Index - $pos
    }
    $acolumn = [column]::new()
    # get EN Name
    $base = $script:fields.psobject.Properties | Where-Object { $_.Value -eq $tempCols[$i].Value }
    if ($base.count -eq 1) {
      $BaseName = $base.Name
    }
    else {
      $BaseName = ($base | Where-Object { $_.Name.StartsWith("Search") }).Name
    }
    $acolumn.Name = $baseFields[$BaseName]
    $acolumn.Position = $pos
    $acolumn.Len = $len
    $result += $acolumn
    $i++
  }
  $result
}
function getColumnsHeaders0 {
  param(
    [parameter (
      Mandatory
    )]
    [string]$columsLine,
    [int]$width
  )

  $script:fields = Get-Content $env:USERPROFILE\.config\.wingetposh\locals.json | ConvertFrom-Json
  
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
      $len = $width - $pos
    }
    else {
      #Not Last Column
      $pos2 = $columsLine.IndexOf($Cols[$i + 1])
      $len = $pos2 - $pos
    }
    $acolumn = [column]::new()
    # get EN Name
    $base = $script:fields.psobject.Properties | Where-Object { $_.Value -eq $cols[$i] }
    if ($base.count -eq 1) {
      $BaseName = $base.Name
    }
    else {
      $BaseName = ($base | Where-Object { $_.Name.StartsWith("Search") }).Name
    }
    $acolumn.Name = $baseFields[$BaseName]
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
  $stateInstall = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $stateInstall.exp = $exp
  $runspaceInstall = [runspacefactory]::CreateRunspace()
  $runspaceInstall.Open()
  $RunspaceInstall.SessionStateProxy.SetVariable("StateInstall", $StateInstall)
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
      $string = "$($e)[s", "$e[u$frame", " $($statedata.title)" -join ""
      [System.Console]::write($string)
      Start-Sleep -Milliseconds $frameInterval
      $i++
    }
  }

  $sbInstall = {
    $result = Invoke-Expression -Command $stateInstall.exp
  }

  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $runspace
  $handle = $session.BeginInvoke()
  
  $sessionInstall = [powershell]::create()
  $null = $sessionInstall.AddScript($sbInstall)
  $sessionInstall.Runspace = $runspaceInstall
  $handleInstall = $sessionInstall.BeginInvoke()
  while (-not $handleInstall.IsCompleted) {
    
  }
  $sessionInstall.stop()
  $runspaceInstall.Dispose()
  $session.Stop()
  $runspace.Dispose()
  [System.Console]::setcursorposition($statedata.X, $statedata.Y)
  [System.Console]::write("".PadRight($Host.UI.RawUI.BufferSize.Width, " "))
}

function Get-WGSources {
  $cmd = "winget source list"
  $result = Invoke-Expression -Command $cmd
  $data = $false
  $sources = [ordered]@{}
  if (Get-ScoopStatus) {
    $sources.Add("scoop", "")
  }
  $sources.Add("none", "")
  foreach ($line in $result) {
    if ($data) {
      $name, $argument = $line -split "\s+"
      $sources.Add($name, $argument)
    }
    else {
      $data = ($line.Contains('-----')) 
    }
  }
  $sources
}

function Get-ScoopBuckets {
  [scoopBuckets[]]$buckets = Invoke-Scoop "scoop bucket list"
  return $buckets
}

function Get-ScoopStatus {
  Get-WingetposhConfig
  $script:config.IncludeScoop -and (Test-Path -Path "$env:HOMEDRIVE$env:HOMEPATH\Scoop\")
}

function Invoke-Scoop {
  param (
    [string]$cmd
  )
  $stateCmd = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $stateCmd.exp = $cmd
  $stateCmd.SearchResult = ""
  $runspaceCmd = [runspacefactory]::CreateRunspace()
  $runspaceCmd.Open()
  $RunspaceCmd.SessionStateProxy.SetVariable("StateCmd", $StateCmd)

  $sbCmd = {
    $StateCmd.SearchResult = Invoke-Expression $stateCmd.exp
  }

  $sessionCmd = [powershell]::create()
  $null = $sessionCmd.AddScript($sbCmd)
  $sessionCmd.Runspace = $runspaceCmd
  $handleCmd = $sessionCmd.BeginInvoke()
  while (-not $handleCmd.IsCompleted) {
    
  }
  $SearchResult = $StateCmd.SearchResult
  $sessionCmd.stop()
  $runspaceCmd.Dispose() 
  return $SearchResult
}

function Invoke-Winget {
  param (
    [string]$cmd,
    [bool]$quiet

  )
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
  if (-not $quiet) {
    [System.Console]::CursorVisible = $false
  }
  $PackageList = @()
  $stateInstall = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $stateInstall.exp = $cmd
  $stateInstall.SearchResult = ""
  $runspaceInstall = [runspacefactory]::CreateRunspace()
  $runspaceInstall.Open()
  $RunspaceInstall.SessionStateProxy.SetVariable("StateInstall", $StateInstall)

  $sbInstall = {
    $StateInstall.SearchResult = Invoke-Expression $stateInstall.exp | Out-String -Stream
  }

  $sessionInstall = [powershell]::create()
  $null = $sessionInstall.AddScript($sbInstall)
  $sessionInstall.Runspace = $runspaceInstall
  $handleInstall = $sessionInstall.BeginInvoke()
  while (-not $handleInstall.IsCompleted) {
    
  }
  $SearchResult = $StateInstall.SearchResult
  $sessionInstall.stop()
  $runspaceInstall.Dispose() 

  $SearchResult | ForEach-Object -Begin { $i = 0; $data = $false } -Process {
    if ($_.StartsWith('---')) {
      $lWidth = $_.Length
      $cols = getColumnsHeaders -columsLine $SearchResult[$i - 1] -width $lWidth
      $columnWidths = @()
      foreach ($column in [column[]]$cols) {
        $columnWidths += $column.Len
      }

      $totalAvailableSpace = $Host.UI.RawUI.WindowSize.Width - 10  # Subtracting 8 for padding
      $totalColumnWidths = $columnWidths | Measure-Object -Sum | Select-Object -ExpandProperty Sum

      # Calculate adjusted column widths
      $adjustedColumnWidths = @()
      foreach ($width in $columnWidths) {
        $adjustedWidth = [math]::Round(($width / $totalColumnWidths) * $totalAvailableSpace)
        $adjustedColumnWidths += $adjustedWidth
      }

      $columns.Clear()
      $i = 1
      foreach ($col in [column[]]$cols) {
        $colw = [math]::round(($totalAvailableSpace) / 100 * $widths[$i - 1])
        $Columns.Add($col.Name, @($col.Position, $colw, $col.len))
        $i++
      }
      $data = $true
    }
    else {
      if ($data) {
        $s = [string]$_
        $regex = $script:Fields.AvailableUpgrades.Replace("{0}", "")
        if (-not $s.Contains($regex)) {
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
            if ($quiet) {
              $package.Add($col.Name, $field.trim())
            }
            else {
              $package.Add($col.Name, $field)
            }
            
          }
          $PackageList += $package
        }
      }
    }
    $i++
  }
  if (-not $quiet) {
    [System.Console]::CursorVisible = $true
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
    "$esc[38;5;15m$($Single.LEFT)", "".PadRight($Win.W - 2, " "), "$esc[38;5;15m$($Single.RIGHT)" -join ""
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
    if ($charcount -gt ($col.Length - 1)) {
      [char]$char = " "
    }
    else {
      [char]$char = $col[$i]
    }
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


  

function displayGrid {
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    $list,
    [string]$source,
    [string]$title, 
    [ref]$data, 
    $allowSearch = $false,
    $allowModifications = $false,
    $build = $false
  )

  if ($iscoreclr) {
    $esc = "`e"
  }
  else {
    $esc = $([char]0x1b)
  }

  function makelines {
    param (
      $list,
      $checked,
      $Deleted,
      $Updated,
      $row,
      $selected
    ) 
    
    [string]$line = ""
    if ($script:config.UseNerdFont -eq $true) {
      #$check = [char]::ConvertFromUtf32(0xf05d)
      if ($allowModifications -or $build) {
        if ($build) {
          $check = "📝"
        }
        else {
          $check = "📌"
        }
      }
      else {
        $check = "📦"
      }
      $update = "♻️"
      $delete = "🗑️"
    }
    else {
      $check = "✓ "
      $update = "↺ "
      $delete = "Ⅹ "
      #$delete = $check
    }
    
    foreach ($key in $columns.keys) {
      [string]$col = $list.$key
      $line = $line, $col -join " "
    }

    if ($deleted -or $Updated -or $checked) {
      if ($deleted) {
        $line = "$esc[38;5;46m$delete", $line -join ""
      }

      if ($Updated) {
        $line = "$esc[38;5;46m$Update", $line -join ""
      }
      
      if (-not $deleted -and -not $Updated) {
        if ($checked) {
          $line = "$esc[38;5;46m$check", $line -join ""
        }
      }
    }
    else {
      $line = "  ", $line -join ""
    }

    if ($row -eq $selected) {
      $line = "$esc[48;5;33m$esc[38;5;15m$($line)"
    }
    if ($row % 2 -eq 0) {
      $line = "$esc[38;5;252m$($line)"
    }
    else {
      $line = "$esc[38;5;244m$($line)"
    }
    
    "$esc[38;5;15m$($Single.LEFT)$($line)$esc[0m"
  }

  function  drawHeader {
    [System.Console]::setcursorposition($win.X + 1, $win.Y + 1)
    $H = " "
    foreach ($key in $columns.keys) {
      $len = $columns[$key][1]
      [string]$col = $key.PadRight($len, " ")
      $H = $H, $col -join " "
    }
    $header = $H.PadRight($win.w - 2, ' ')
    [System.Console]::write("$esc[4m$esc[38;5;11m$($header)$esc[0m")
  }

  function drawFooter {

    [System.Console]::setcursorposition($win.X + 1, $win.H - 1)
    
    if ($sourceIdx -eq -1) {
      $s = $sources -join ","
    }
    else {
      $s = $sources[$sourceIdx]
    }
    $footerL = " Selected : $nbChecked"
    $footerR = "Source : [ $s ] "
    $fill = $win.w - 2 - $footerL.Length - $footerR.Length
    $f = $footerL, "".PadRight($fill, ' '), $footerR -join ""
    [System.Console]::write("$esc[48;5;19m$esc[38;5;15m$($f)$esc[0m")
  }

  $sources = $(Get-WGSources).keys
  $sourceIdx = $sources.IndexOf("winget");
  $global:Host.UI.RawUI.FlushInputBuffer()
  Get-WingetposhConfig
  $WinWidth = [System.Console]::WindowWidth
  $X = 0
  $Y = 0
  $WinHeigt = [System.Console]::WindowHeight - 1
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
  $win.title = $title
  $Win.titleColor = "Green"
  $win.footer = "$(color "[?]" "red") Help $(color "[F2]" "red") Source $(color "[Space]" "red") Select/Unselect $(color "[Enter]" "red") Accept $(color "[Esc]" "red") Quit"
  $win.drawWindow();
  $win.drawVersion();
  $nbLines = $Win.h - 3
  $blanks = makeBlanks $nblines $win

  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  
  $statedata.X = ($win.X + 3)
  $statedata.Y = ($win.Y + 1)
 
  if ($source) {
    $displayList = $list | Where-Object { $_.source.trim() -eq $source }
    if ($displayList.count -eq 0) {
      $displayList = $list
    }
  }
  else {
    $src = @()
    if ($sources[$sourceIdx].trim() -in ("none", "msstore")) {
      $src += ""
      $src += "msstore"
    }
    else {
      $src += $sources[$sourceIdx]
    }
    $displayList = $list | Where-Object { $src.Contains($_.source.trim()) }
    if ($displayList.count -eq 0) {
      $displayList = $list
    }
  }

  $skip = 0
  $nbPages = [math]::Ceiling($displayList.count / $nbLines)
  $win.nbpages = $nbPages
  $page = 1
  $selected = 0
  $nbChecked = 0
  [System.Console]::CursorVisible = $false
  $redraw = $true
  while (-not $stop) {
    $win.page = $page
    [System.Console]::setcursorposition($win.X, $win.Y + 2)
    $row = 0
    if ($displayList.length -eq 1) {
      $checked = $displayList.Selected
      $Deleted = $displayList.Deleted
      $Updated = $displayList.Updated
      $partdisplayList = makelines $displayList $checked $Deleted $Updated $row $selected
    }
    else {
      $partdisplayList = $displayList | Select-Object -First $nblines -Skip $skip | ForEach-Object {
        $index = (($page - 1) * $nbLines) + $row
        $checked = $displayList[$index].Selected
        $deleted = $displayList[$index].Deleted
        $Updated = $displayList[$index].Updated
        makelines $displayList[$index] $checked $deleted $Updated $row $selected
        $row++
      }
    }
    $nbDisplay = $partdisplayList.Length
    $sText = $partdisplayList | Out-String 
    if ($redraw) {
      [System.Console]::setcursorposition($win.X, $win.Y + 2)
      [system.console]::write($blanks)
      $redraw = $false
    }
    [System.Console]::setcursorposition($win.X, $win.Y + 2)
    [system.console]::write($sText.Substring(0, $sText.Length - 2))
    drawHeader
    drawFooter
    $win.drawPagination()
    while (-not $stop) {
      if ($global:Host.UI.RawUI.KeyAvailable) { 
        [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
        if ($key.Character -eq '?') {
          # Help
          displayHelp $allowSearch
          $redraw = $true
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
          if ($displayList.length -eq 1) {
            $checked = $displayList.Selected
            $displayList.Selected = -not $checked
          }
          else {
            $index = (($page - 1) * $nbLines) + $selected
            $checked = $displayList[$index].Selected
            $displayList[$index].Selected = -not $checked
          }
          if ($checked) { $nbChecked-- } else { $nbChecked++ }
        }

        if ($key.VirtualKeyCode -eq 46) {
          # delete key
          if ($allowModifications -and -not $build) {
            if ($displayList.length -eq 1) {
              $deleted = $displayList.Deleted
              $displayList.deleted = -not $deleted
            }
            else {
              $index = (($page - 1) * $nbLines) + $selected
              $Deleted = $displayList[$index].Deleted
              $displayList[$index].Deleted = -not $Deleted
            }
          }
        }

        if ($key.VirtualKeyCode -eq 85) {
          # "u" key (update)
          if ($allowModifications -and -not $build) {
            if ($displayList.length -eq 1) {
              if ($displayList.Available) {
                $Updated = $displayList.Updated
                $displayList.Updated = -not $deleted
              }
            }
            else {
              $index = (($page - 1) * $nbLines) + $selected
              if ($displayList[$index].Available -and ($displayList[$index].Available.trim() -ne "")) {
                $Updated = $displayList[$index].Updated
                $displayList[$index].Updated = -not $Updated
              }
            }
          }
        }
        if ($key.VirtualKeyCode -eq 85) {
          # "Ctrl-u" key (update)
          if ($allowModifications) {
            if (($key.ControlKeyState -band 8) -ne 0) {
              $displayList | ForEach-Object { 
                $Updated = $_.Updated
                if ($_.Available -and ($_.Available.trim() -ne "")) {
                  $_.Updated = -not $Updated
                }
              }
            }
          }
        }

        if ($key.VirtualKeyCode -eq 13) {
          # key Enter
          Clear-Host
          $data.value = $data.value = $displayList | Where-Object { $_.Selected -or $_.Deleted -or $_.Updated }
          $stop = $true
        }
        if ($key.VirtualKeyCode -eq 114) {
          # key F3
          if ($allowSearch) {
            $term = getSearchTerms
            [System.Console]::CursorVisible = $false
            $term = '"', $term, '"' -join ''
            # Todo : re-run original search
            $sb = { Invoke-Winget "winget search --name $term" | Where-Object { $_.source -eq "winget" } }
            $displayList = Invoke-Command -ScriptBlock $sb
            $skip = 0
            $nbPages = [math]::Ceiling($displayList.count / $nbLines)
            $win.nbpages = $nbPages
            $page = 1
            $selected = 0
            $redraw = $true
          }
        }
        if ($key.VirtualKeyCode -eq 113) {
          # key F2
          $sourceIdx ++
          if ($sourceIdx -gt $sources.count - 1) {
            $displayList = $list
            $sourceIdx = -1
          }
          else {
            $src = @()
            if ($sources[$sourceIdx].trim() -in ("none", "msstore")) {
              $src += ""
              $src += "msstore"
            }
            else {
              $src += $sources[$sourceIdx]
            }
            $displayList = $list | Where-Object { $src.Contains($_.source.trim()) }
            if ($displayList.count -eq 0) {
              $displayList = $list
            }
          }
          $skip = 0
          $nbPages = [math]::Ceiling($displayList.count / $nbLines)
          $win.nbpages = $nbPages
          $page = 1
          $selected = 0
          $redraw = $true
        }
        if ($key.character -eq "+") {
          # key +
          $checked = $true
          $nbChecked = 0
          $displayList | ForEach-Object { $_.Selected = $checked; $nbChecked++ }
        }
        if ($key.character -eq "-") {
          # key -
          $checked = $false
          $displayList | ForEach-Object { $_.Selected = $checked }
          $nbChecked = 0
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
  $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "red");
  $win.title = "Help"
  $Win.titleColor = "Blue"
  $win.footer = "$(color "[Esc]" "red") : Close"
  $win.drawWindow();

  $buffer = "$(color "↑↓" "cyan") : Navigate `t`t`t`t $(color "← →" "cyan") Change page"
  $y = 11
  [System.Console]::setcursorposition($win.X + 2, $Y)
  [system.console]::write($buffer)
  $buffer = "$(color "Space" "cyan") : Select / Unselect package `t`t $(color "+/-" "cyan") Select All/None "
  $Y ++
  [System.Console]::setcursorposition($win.X + 2, $Y)
  [system.console]::write($buffer)
  $Y ++
  $buffer = "$(color "F2" "cyan") Cycle Sources"
  [System.Console]::setcursorposition($win.X + 2, $Y)
  [system.console]::write($buffer)
  if ($allowSearch) {
    $y++
    $buffer = "$(color "F3" "cyan") : Enter Package Name"
    [System.Console]::setcursorposition($win.X + 2, $Y)
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

function GetVersion {
  $version = [string]$(Get-InstalledModule -Name wingetposh -ErrorAction Ignore).version
  if ([bool]$version) {
    return "Debug"
  }
  return $version
}

function openSpinner {
  $SpinnerWidth = 50
  $DotWidth = $SpinnerWidth - 2
  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $statedata.X = [math]::round(($Host.UI.RawUI.BufferSize.Width - $SpinnerWidth) / 2)
  $statedata.Y = [math]::round(($Host.UI.RawUI.BufferSize.Height - 3) / 2)
  $statedata.SpinnerWidth = $SpinnerWidth
  $statedata.DotWidth = $DotWidth
  $stateData.SpinLimit = $SpinnerWidth - 5
  $runspace = [runspacefactory]::CreateRunspace()
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData", $StateData)
  [window]$win = [window]::new($statedata.X, $statedata.Y, $SpinnerWidth, 2, $false, "White")
  $win.titleColor = "Red"
  $win.title = '⏳ Fetching Winget data '
  $win.drawWindow()
  $win.drawTitle()
  $statedata.X ++
  $statedata.Y ++
  $sb = {
    [System.Console]::CursorVisible = $false
    $x = $statedata.X
    $y = $statedata.Y
    
    $i = 1
    $string = "".PadRight($statedata.DotWidth, ".")
    $nav = "oOo"
    while ($true) {
      if ($i -lt $nav.Length) {
        $mobile = $nav.Substring($nav.Length - $i)
        $string = $mobile.PadRight($statedata.DotWidth, '.')
      }
      else {
        if ($i -gt $stateData.SpinLimit) {
          $nb = $statedata.DotWidth - $i
          $mobile = $nav.Substring(1, $nb)
          $string = $mobile.PadLeft($statedata.DotWidth, '.')
        }
        else {
          $left = "".PadLeft($i, '.')
          $right = "".PadRight($stateData.SpinLimit - $i, '.')
          $string = $left, $nav, $right -join ""
        }
      }
      [System.Console]::setcursorposition($X, $Y)
      [System.Console]::write($string)
      $i++
      if ($i -gt $statedata.DotWidth) {
        $i = 1
      }
      Start-Sleep -Milliseconds 100
    }
  }
  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $runspace
  $null = $session.BeginInvoke()
  return $Session, $runspace, $win
}

function closeSpinner {
  param(
    $Session,
    $Runspace
  )
  $null = $session.Stop()
  $null = $runspace.dispose() 
  [System.Console]::CursorVisible = $true
}
  
function Get-WGPackage {
  param(
    [string]$source,
    [switch]$interactive,
    [switch]$uninstall,
    [switch]$update,
    [switch]$apply,
    [switch]$silent,
    [switch]$Build,
    [bool]$quiet
  )
  Get-WingetposhConfig
  if ($source) {
    $sources = Get-WGSources 
    if (-not $sources.Contains($source)) {
      Clear-Host
      Write-Host "⚠️ Source Unknown." -ForegroundColor DarkYellow
      Write-Host "".PadRight($Host.UI.RawUI.BufferSize.Width, "-") -ForegroundColor DarkYellow
      Write-Host "Valid sources are : " -ForegroundColor Blue
      $sources.keys | ForEach-Object {
        Write-Host "  🔹 $($_)"
      }
      Write-Host ""
      Write-Host "🛑 Operation Aborted"
      return $null
    }
  }

  $title = ""
  if ($update) {
    $command = "winget update --include-unknown"
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
    $title = " ⟬ Update ⟭ "
  }
  else {
    if ($uninstall) {
      $title = " ⟬ Uninstall ⟭ " 
    }
  } 
  if (-not $quiet) {
    $Session, $Runspace, $win = openSpinner
  }
  $list = @(Invoke-Winget $command -quiet $quiet)
  # Include scoop search if configured
  if (Get-ScoopStatus) {
    [scoopList[]]$list2 = Invoke-Scoop -cmd "scoop list"
    if ($list2) {
      $list2 | ForEach-Object {
        if ($quiet) {
          $package = [ordered]@{}
          $package.add("Name", $_.Name.trim())
          $package.add("Id", $_.Name.trim())
          $package.add("Version", $_.Version.trim())
          $package.add("Available", $_.Version.trim())
          $package.add("Source", "scoop".trim())
        }
        else {
          $package = [ordered]@{}
          $package.add("Name", $_.Name.PadRight($columns["Name"][1], " "))
          $package.add("Id", $_.Name.PadRight($columns["Id"][1], " "))
          $package.add("Version", $_.Version.PadRight($columns["Version"][1], " "))
          $package.add("Available", $_.Version.PadRight($columns["Version"][1], " "))
          $package.add("Source", "scoop".PadRight($columns["Source"][1], " "))
        }
     
        $list += $package
      }
    }
  }
  if (-not $quiet) {
    closeSpinner -Session $Session -Runspace $Runspace
  }

  if ($source) {
    $list = $list |  Where-Object { $_.source -eq $source }
  }
  
  if ($interactive) {
    $data = @()
    if ($build) {
      $title = " ⟬ Build Install File ⟭ "
    }
    displayGrid -list $list -title "Packages List $($title)" -data ([ref]$data) -allowSearch $false -allowModifications $true -Build $Build
    if ($apply) {
      $title = ""
      if ($data.length -gt 0) {
        $data | Out-Object | ForEach-Object {
          $id = ($_.Id).Trim()
          if ($uninstall) {
            $expression = "winget uninstall "
            if ($silent) {
              $expression = $expression, "--silent --disable-interactivity" -join ""
            }
            $expression = $expression, " --id $($id)" -join ""
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
    }
    else {
      return $data
    }
  }
  else {
    return $list
  }
}

function Search-WGPackage {
  param(
    [string]$package,
    [string]$source,
    [switch]$interactive,
    [switch]$allowSearch,
    [switch]$install,
    [switch]$silent,
    [bool]$quiet
  )
  begin {
    Get-WingetposhConfig
    if ($source) {
      $sources = Get-WGSources 
      if (-not $sources.Contains($source)) {
        Clear-Host
        Write-Host "⚠️ Source Unknown." -ForegroundColor DarkYellow
        Write-Host "".PadRight($Host.UI.RawUI.BufferSize.Width, "-") -ForegroundColor DarkYellow
        Write-Host "Valid sources are : " -ForegroundColor Blue
        $sources.keys | ForEach-Object {
          Write-Host "  🔹 $($_)"
        }
        $terms = ""
        return $null
      }
    }
    $terms = $package
    if ($package.Trim() -eq "") {
      $terms = getSearchTerms
    }
    $terms = $terms.Replace(" ", "")
  }
  process {
    if ($terms -ne "") {
      $list = @()
      if (-not $quiet) {
        $Session, $Runspace, $win = openSpinner
      }
      $terms -split "," | ForEach-Object { 
        $term = $_
        $command = "winget search '$term'"
        $result = @(Invoke-Winget -quiet $quiet $command)
        $result | ForEach-Object { 
          $list += $_
        }
        if (Get-ScoopStatus) {
          $win.title = "⏳ Fetching Scoop $term data "
          $win.drawWindow()
          $win.drawTitle()
          $ScoopCmd = "scoop search $([regex]::escape($term))"
          [scoopSearch[]]$list2 = Invoke-Scoop -cmd $ScoopCmd
          if ($list2) {
            Get-ScoopBuckets | ForEach-Object { $buckets += $_.Name }
            Clear-Host
            $list2 | ForEach-Object {
              if ($buckets.contains($_.Source)) {
                $pkg = [ordered]@{}
                $pkg.add("Name", $_.Name.PadRight($columns["Name"][1], " "))
                $pkg.add("Id", $_.Name.PadRight($columns["Id"][1], " "))
                $version = $_.Version.PadRight($columns["Version"][1], " ")
                $pkg.add("Version", $version.Substring(0, $columns["Version"][1]))
                $pkg.add("Moniker", "".PadRight($columns["Moniker"][1], " "))
              } 
              else {
                $pkg = [ordered]@{}
                $pkg.add("Name", $_.Name.PadRight($columns["Name"][1], " "))
                $pkg.add("Id", "‼️ Missing bucket ‼️".PadRight($columns["Id"][1], " "))
                $version = $_.Source.PadRight($columns["Version"][1], " ")
                $pkg.add("Version", $version.Substring(0, $columns["Version"][1]))
                $pkg.add("Moniker", "".PadRight($columns["Moniker"][1], " "))
              }
          
              $pkg.add("Source", "scoop".PadRight($columns["Source"][1], " "))
              $list += $pkg
            }
          }
        }
      }
      if (-not $quiet) {
       closeSpinner -Session $Session -Runspace $Runspace
      }
      if ($interactive) {
        Get-ScoopBuckets | ForEach-Object { $buckets += $_.Name }
        $data = @()
        displayGrid -list $list -source $source  -title "Package Search ⟬ Install ⟭ " -data ([ref]$data) -allowSearch $allowSearch 
        if ($install) {
          if ($data.length -gt 0) {
            $data | Out-Object | ForEach-Object {
              if ($_.source.trim() -eq "scoop") {
                $expression = "scoop install  "
                $expression = $expression, "  $($_.Name)" -join ""
                [System.Console]::CursorVisible = $false
                Invoke-Expression2 -exp $expression -title "⚡Invoking scoop for $($_.Name)"
                [System.Console]::CursorVisible = $true
              }
              else {
                $expression = "winget install  "
                if ($silent) {
                  $expression = $expression, "--silent --disable-interactivity" -join ""
                }
                $id = ($_.Id).Trim()
                $expression = $expression, " --id $($id)" -join ""
                [System.Console]::CursorVisible = $false
                Invoke-Expression2 -exp $expression -title "⚡ Installation of $($id)"
                [System.Console]::CursorVisible = $true
              }
            }
          }
        }
      }
      else {
        $list
      }
    }
    else {
      Clear-Host
      Write-Host ""
      Write-Host "🛑 Operation Aborted"
    }
  }
}

function Get-WGPVersion {
  param(
    [ValidateSet("Winget", "WGP", "All")]
    [String]$param = "WGP",
    [switch]$display = $false
  )

  if ($param -in ("Winget", "All")) {
    [string]$v = Invoke-Expression "winget -v" | Out-String -NoNewline
    if ($display) {
      Write-Host "Winget version : $v"
    }
    $v
  }

  if ($param -in ("WGP", "All")) {
    [string]$v = $(Get-InstalledModule -Name wingetposh -ErrorAction Ignore).version
    if ($display) {
      Write-Host "Wingetposh version : $v"
    }
    $v
  }

}

function Get-WGList {
  param(
    [string]$source,
    [bool]$quiet
  )
  $params = @{
    source = $source
    quiet  = $quiet
  }
  Get-WGPackage @params
}

function Build-WGInstallFile {
  param(
    [string]$file = "WGConfig.json"
  )

  if (Test-Path -Path $file) {
    Remove-Item -Path $file
  }

  $data = Get-WGPackage -interactive -Build
  $data | Out-Object | ConvertTo-Json | Out-File -FilePath $file -Append
  Write-Host "Config file writen in $file"
}

function Show-WGList {
  param(
    [string]$source
  )
  $data = Get-WGPackage -interactive -source $source
  if (($data | Out-Object | Where-Object { $_.updated -or $_.deleted }).count -gt 0) {
    $data | Out-Object | ForEach-Object {
      if ($_.Deleted -or $_.Updated) {
        $id = ($_.Id).Trim()
        if ($_.Deleted) {
          $expression = "winget uninstall "
          if ($silent) {
            $expression = $expression, "--silent --disable-interactivity" -join ""
          }
          $expression = $expression, " --id $($id)" -join ""
          $title = "🗑️ Uninstall $($id)"
          $action = " is Uninstalled"
        }
        if ($_.Updated) {
          $expression = "winget upgrade --id $($id)"
          $title = "⚡ Upgrade $($id)"
          $action = " is Updated"
        }
        [System.Console]::CursorVisible = $false
        Invoke-Expression2 -exp $expression -title $title
        #Write-Host "Exit code : $($LASTEXITCODE)"
        Write-Host "Name $($_.Name) $action"
        [System.Console]::CursorVisible = $true
      } 
    }
  }
  else {
    $data | Out-Object
  }
}

function Install-WGPackage {
  param(
    [string]$package,
    [string]$source,
    [switch]$silent,
    [switch]$acceptpackageagreements,
    [switch]$acceptsourceagreements
  )
  $params = @{
    interactive = $true
    package     = $package
    source      = $source
    install     = $true
  }
  Get-WingetposhConfig
  if ($silent) {
    $params.add("silent", $true)
  }
  else {
    $params.Add("silent", $script:config.SilentInstall)
  }
  Search-WGPackage @params
}

function Update-WGPackage {
  param(
    [string]$source,
    [switch]$apply,
    [bool]$quiet
  )
  $interactive = -not $quiet
  $params = @{
    Source      = $source
    Interactive = $interactive
    Update      = -not $quiet
    Apply       = $apply
    quiet       = $quiet
  }
  
  Get-WGPackage @params
}

function Uninstall-WGPackage {
  param(
    [string]$source,
    [switch]$apply,
    [switch]$silent
  )
  $params = @{
    Interactive = $true
    Source      = $source
    Uninstall   = $true
    Apply       = $apply
  }
  Get-WingetposhConfig
  if ($silent) {
    $params.add("silent", $true)
  }
  else {
    $params.Add("silent", $script:config.SilentInstall)
  }
  Get-WGPackage @params
}

function Out-JSON {
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
    foreach ($d in $data) {
      $result += [pscustomobject]$d
    }
  }
  end {
    return (@{
      "packages"= $result
    }) | ConvertTo-Json
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
    [PSCustomObject[]]$result = @()
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

function Get-WingetposhConfig {
  param(
    [switch]$display
  )
  $script:config = Get-Content $env:USERPROFILE/.config/.wingetposh/config.json | ConvertFrom-Json
  if ($display) {
    $script:config
  }
}

function Set-WingetposhConfig {
  param(
    [ValidateSet("UseNerdFont", "SilentInstall", "AcceptPackageAgreements", "AcceptSourceAgreements", "Force", "IncludeScoop")]
    [String]$param,
    $value
  )
  Get-WingetposhConfig
  $script:config.$param = $value
  $script:config | ConvertTo-Json | Out-File -FilePath ~/.config/.wingetposh/config.json -Force | Out-Null
}

function Reset-WingetposhConfig {
  '{ "UseNerdFont" : false, "SilentInstall": false, "AcceptPackageAgreements" : true, "AcceptSourceAgreements" : true,"Force": false, "IncludeScoop": false }' | Out-File -FilePath ~/.config/.wingetposh/config.json -Force | Out-Null
}

function Start-Gui {
  $path =  (Get-Module -Name wingetposh).path | Split-Path -Parent
  Invoke-Expression "$path\WGGui.exe"
}