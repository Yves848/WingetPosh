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
        [System.Console]::CursorVisible = $false
        $this.setPosition($this.X, $this.Y)
      

        $bloc1 = "".PadLeft($this.W , $this.frameStyle.TOP)
        $blank = "".PadLeft($this.W , " ") 
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline

        for ($i = 1; $i -lt $this.H; $i++) {
            $Y2 = $this.Y + $i
            #$X2 = $this.X + $this.W - 1
            $this.setPosition($this.X, $Y2)
          
            $X3 = $this.X 
            $this.setPosition($X3, $Y2)
            Write-Host $blank 
        }

        $Y2 = $this.Y + $this.H
        $this.setPosition( $this.X, $Y2)
        $bloc1 = "".PadLeft($this.W , $this.frameStyle.BOTTOM)
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
        $this.drawTitle()
        $this.drawFooter()
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

    [void] drawPagination() {
        $sPages = ('Page {0}/{1}' -f ($this.page, $this.nbPages))
        [System.Console]::setcursorposition($this.X + 2, $this.Y + $this.H)
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

function getSearchTerms {
    $WinWidth = [System.Console]::WindowWidth
    $X = 0
    $Y = [System.Console]::WindowHeight - 6
    $WinHeigt = 4
  
    $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
    $win.title = "Search"
    $Win.titleColor = "Green"
    $win.footer = "[Enter] : Accept [Ctrl-C] : Abort"
    $win.drawWindow();
    $win.setPosition($X + 2, $Y + 2);
    [System.Console]::Write('Package : ')
    [system.console]::CursorVisible = $true
    $pack = [System.Console]::ReadLine()
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
    
    $SearchResult = Invoke-Expression $command | Out-String -Width $Host.UI.RawUI.WindowSize.Width
    [string[]]$lines = $SearchResult -Split [Environment]::NewLine
  
    $fl = 0
    while (-not $lines[$fl].StartsWith("----")) {
        $fl++
    }
  
    $columns = getColumnsHeaders -columsLine $lines[$fl - 1]
  
    $idStart = $Columns[1].Position
    $versionStart = $Columns[2].Position
   
  
   
    if ($columns.Length -eq 5) {
        $availableStart = $columns[3].Position
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
                $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
                $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
                $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
                if ($source -ne "") {
                    $software = [UpgradeSoftware]::new()
                    $software.Name = $name;
                    $software.Id = $id;
                    $software.Version = $version
                    $software.AvailableVersion = $available
                    $software.Source = $Source
                    $InstalledList += $software
                }
            }
        }
    }
    return $installedList
}

function addCheckbox(
    $text
) {
    "[ ] $($text)"
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

function Show-WGList {
    $WinWidth = [System.Console]::WindowWidth
    $X = 0
    $Y = 0
    $WinHeigt = [System.Console]::WindowHeight - 2
    $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
    $win.title = "Package List"
    $Win.titleColor = "Green"
    $win.footer = "[Enter] : Accept [Esc] : Quit"
    $win.drawWindow();
    $nbLines = $Win.h - 3
    $blanks = ' '.PadRight($Host.UI.RawUI.WindowSize.Width * ($nbLines + 1))
    [System.Console]::setcursorposition($win.X, $win.Y + 1)
    [System.Console]::write('Getting the list.......')
    $list = _wgList
    $skip = 0
    $nbPages = [math]::Ceiling($list.count / $nbLines)
    $win.nbpages = $nbPages
    $page = 1
    $selected = 0
    [System.Console]::CursorVisible = $false
    while (-not $stop) {
        $win.page = $page
        $win.drawPagination()
        [System.Console]::setcursorposition($win.X, $win.Y + 1)
        [console]::write($blanks)
        [System.Console]::setcursorposition($win.X, $win.Y + 1)
        $row = 0
        $partlist = $list | `
            Select-Object -Property Name, Id, Version, AvailableVersion, Source -First $nbLines -Skip $skip `
        | Format-Table -HideTableHeaders  `
        | Out-String -Stream `
        | ForEach-Object {
            if (([string]$_.trim()) -ne "") {
                $line = $(addCheckbox $_)
                if ($row -eq $selected) {
                    $line = $(color $line "black" "white")
                }
                $line
                $row ++
            }
                            
        }
        $sText = $partlist | Out-String
        [System.Console]::setcursorposition($win.X, $win.Y + 1)
        [console]::write($sText)
        while (-not $stop) {
            if ($global:Host.UI.RawUI.KeyAvailable) { 
                [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyUp'))
                #Write-Host $key.VirtualKeyCode
                if ($key.character -eq 'q' -or $key.VirtualKeyCode -eq 27) {
                    $stop = $true
                }
                if ($key.VirtualKeyCode -eq 38) {
                    # key up
                    $selected --

                }
                if ($key.VirtualKeyCode -eq 40) {
                    # key Down
                    $selected ++
                }
                if ($key.VirtualKeyCode -eq 37) {
                    # key Left
                    if ($page -gt 1) {
                        $skip -= $nbLines
                        $page -= 1
                        $selected = 0
                    }

                }
                if ($key.VirtualKeyCode -eq 39) {
                    # key Right
                    if ($page -lt $nbPages) {
                        $skip += $nbLines
                        $page += 1
                        $selected = 0
                    }
                }
                break
            }
            Start-Sleep -Milliseconds 10
        }    
    }
    [System.Console]::CursorVisible = $true

}


Show-WGList # Create a synchronized hashtable
