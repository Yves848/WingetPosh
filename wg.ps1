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

class listSearchItem {
    [installSoftware]$Package
    [bool]$Selected
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
}

$Single = [Frame]::new()
$Single.UL = "┌"
$Single.UR = "┐"
$Single.TOP = "─"
$Single.LEFT = "│"
$Single.RIGHT = "│"
$Single.BL = "└"
$Single.BR = "┘"
$Single.BOTTOM = "─"

$Double = [Frame]::new()
$Double.UL = "╔"
$Double.UR = "╗"
$Double.TOP = "═"
$Double.LEFT = "║"
$Double.RIGHT = "║"
$Double.BL = "╚"
$Double.BR = "╝"
$Double.BOTTOM = "═"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 

function Wait-KeyPress {
    param
    (
        [string]
        $Message = 'Press Arrow-Down to continue',

        [ConsoleKey]
        $Key = [ConsoleKey]::DownArrow
    )
    
    # emit your custom message
    # Write-Host -Object $Message -ForegroundColor Yellow -BackgroundColor Black
    
    # use a blocking call because we *want* to wait

    $keyInfo = [Console]::ReadKey($false)
    
    $keyInfo
}


function wgUpgradable {
    $command = "winget upgrade"
    $upgradeResult = Invoke-Expression $command | Out-String
    $lines = $upgradeResult.Split([Environment]::NewLine)
    # $lines
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
            $software = [upgradeSoftware]::new()
            $software.Name = $name;
            $software.Id = $id;
            $software.Version = $version
            $software.AvailableVersion = $available;
            $upgradeList += $software
        }
    }

    $upgradeList
}

function wgList {
    param(
        [parameter (
            Mandatory,
            HelpMessage = "Package (or part) name to search"
        )]
        [string]$search
    )

    $command = "winget search --name ${search}"
    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)

    $fl = 0
    while (-not $lines[$fl].StartsWith("Nom")) {
        $fl++
    }

    $idStart = $lines[$fl].IndexOf("ID")
    $versionStart = $lines[$fl].IndexOf("Version")
    $sourceStart = $lines[$fl].IndexOf("Source")

    $SearchList = @()
    For ($i = $fl + 1; $i -le $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
            $name = $line.Substring(0, $idStart).TrimEnd()
            $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
            $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
            $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
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

function setPosition {
    param (
        [int]$X,
        [int]$Y
    )
    $cursorPos = $host.UI.RawUI.CursorPosition
    $cursorPos.Y = $Y
    $cursorPos.X = $X
    $host.UI.RawUI.CursorPosition = $cursorPos
}

function drawFrame {
    param (
        [parameter(
            Mandatory,
            HelpMessage = 'Left Position (X)'
        )]
        [int]$X,
        [parameter(
            Mandatory,
            HelpMessage = 'Top Position (Y)'
        )]
        [int]$Y,
        [parameter(
            Mandatory,
            HelpMessage = 'Window Width (W)'
        )]
        [int]$W,
        [parameter(
            Mandatory,
            HelpMessage = 'Window Height (H)'
        )]
        [int]$H,
        [parameter(
            HelpMessage = "Single or double line frame"
        )]
        [switch]$DoubleLine,
        [parameter(
            HelpMessage = "Clear the frame content"
        )]
        [switch]$Clear,
        [parameter(
            Mandatory,
            HelpMessage = 'Frame Color'
        )]
        [System.ConsoleColor]$COLOR
    )
    setPosition $X $Y
    $Frame = $Single
    if ($DoubleLine.IsPresent) {
        $Frame = $Double
    }

    $bloc1 = "".PadLeft($W - 2, $Frame.TOP)
    $blank = "".PadLeft($W - 2, " ") 
    Write-Host $Frame.UL -NoNewline -ForegroundColor $COLOR
    Write-Host $bloc1 -ForegroundColor $COLOR -NoNewline
    Write-Host $Frame.UR -ForegroundColor $COLOR

    for ($i = 1; $i -lt $H; $i++) {
        $Y2 = $Y + $i
        $X2 = $X + $W - 1
        setPosition $X $Y2
        Write-Host $Frame.LEFT -ForegroundColor $COLOR
        if ($Clear.IsPresent) {
            $X3 = $X + 1
            setPosition $X3 $Y2
            Write-Host $blank 
        }
        setPosition $X2 $Y2
        Write-Host $Frame.RIGHT -ForegroundColor $COLOR
    }

    $Y2 = $Y + $H
    setPosition $X $Y2
    $bloc1 = "".PadLeft($W - 2, $Frame.BOTTOM)
    Write-Host $Frame.BL -NoNewline -ForegroundColor $COLOR
    Write-Host $bloc1 -ForegroundColor $COLOR -NoNewline
    Write-Host $Frame.BR -ForegroundColor $COLOR
}

function testFrame {
    Clear-Host
    $maxHeight = $Host.UI.RawUI.WindowSize.Height - 2
    $maxWidth = $Host.UI.RawUI.WindowSize.Width
    drawFrame 0 0 $maxWidth $maxHeight DarkGreen
    drawFrame 10 10 40 10 Blue
    drawFrame 35 15 50 25 Red -DoubleLine -Clear
    setPosition 0 0
    Wait-KeyPress "" Enter
    Clear-Host
}

function displayStatus {
    param(
        # Parameter help description
        [Parameter(
            Mandatory
        )]
        [String]
        $Status
    )
    setPosition -X 0 -Y 0
    $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, " ")
    Write-Host $bloc -BackgroundColor Cyan -NoNewline
    setPosition -X 2 -Y 0
    Write-Host $Status -ForegroundColor White -BackgroundColor Cyan -NoNewline
}

function ClearStatus {
    setPosition -X 0 -Y 0
    $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, " ")
    Write-Host $bloc -BackgroundColor black -NoNewline
}

function testMenu {
    function drawItems {
        $currentLine = 0
        do {
            
            $back = [System.ConsoleColor]::Black 
            $front = [System.ConsoleColor]::White
            if ($currentLine -eq $line) {
                $back = [System.ConsoleColor]::Yellow
                $front = [System.ConsoleColor]::Blue
            }
            $Y = 4 + $currentLine
            setPosition -X 4 -Y $Y
            $bloc = "".PadLeft(67, " ")
            Write-Host $bloc -BackgroundColor $back -ForegroundColor $front
            
            setPosition -X 4 -Y $Y
            if ($menuItems[$currentLine + $startLine].Selected) {
                Write-Host '✔️' -BackgroundColor $back -ForegroundColor $front
            }
            else {
                Write-Host ' ' -BackgroundColor $back -ForegroundColor $front
            }
            setPosition -X 6 -Y $Y
            Write-Host $menuItems[$currentLine + $startLine].Package.Name -BackgroundColor $back -ForegroundColor $front
            $currentLine += 1
        } while ($currentLine -lt 19)
    }

    $line = 0
    $startLine = 0
    Clear-Host
    displayStatus -Status 'Getting packages List'
    $list = wgList -search "test"
    ClearStatus
    $menuItems = @()
    foreach ($item in $list) {
        $menuitem = [listSearchItem]::new()
        $menuitem.Package = $item
        $menuitem.Selected = $false
        $menuItems += $menuitem
    }
    drawFrame -X 3 -Y 3 -W 70 -H 20 -COLOR Blue

    do {
        drawItems
        $key = Wait-KeyPress
        switch ($key.key) {
            DownArrow { 
                 
                if ($line -eq 18) {
                    $startLine += 1  
                }
                else {
                    $line += 1
                }
            }
            UpArrow { 
                $line -= 1 
                if ($line -lt 0) {
                    if ($startLine -gt 0) {
                        $startLine -= 1
                    }
                    $line = 0
                }
            }
            SpaceBar {
                if ($menuItems[$line + $startLine].Selected -eq $false) {
                    $menuItems[$line + $startLine].Selected = $true
                }
                else {
                    $menuItems[$line + $startLine].Selected = $false
                }
                
            }
            Default {}
        }
    } until (
        $key.key -eq [ConsoleKey]::Escape
    )
}

function getUIInfos {
    Write-Host "Width: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Width
    Write-Host "Height: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Height 
    Write-Host "☑️✔️"
}

