class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
    [string]$Source
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
    Write-Host -Object $Message -ForegroundColor Yellow -BackgroundColor Black
    
    # use a blocking call because we *want* to wait

    $keyInfo = [Console]::ReadKey($false)
    
    $keyInfo | Select-Object -Property Key
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
            $software = [Software]::new()
            $software.Name = $name;
            $software.Id = $id;
            $software.Version = $version
            $software.AvailableVersion = $available;
            $upgradeList += $software
        }
    }

    $upgradeList
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

function getUIInfos {
    Write-Host "Width: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Width
    Write-Host "Height: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Height 
}
