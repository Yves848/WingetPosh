# Invoke-WingetList -Query "git" | Select-Object { $_.NamePrefix }

# https://github.com/PhonicUK/CLRCLI/blob/master/CLRCLI/ConsoleHelper.cs

class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
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

Import-Module ~/CLRCLI.dll

function wgList {
    $upgradeResult = winget list "" | Out-String
    $lines = $upgradeResult.Split([Environment]::NewLine)
    # $lines
    $fl = 0
    while (-not $lines[$fl].StartsWith("Nom")) {
        $fl++
    }
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

function displayFrame {
    $esc = [char]27
    setPosition 0 10
    $bloc1 = "".PadLeft($Host.UI.RawUI.WindowSize.Width - 2, '─')
    Write-Host "┌$bloc1┐"
}

function drawFrame {
    param (
        [int]$X,
        [int]$Y,
        [int]$W,
        [int]$H,
        [System.ConsoleColor]$COLOR
    )
    setPosition $X $Y
    $bloc1 = "".PadLeft($W - 2, $Single.TOP)
    Write-Host $Single.UL -NoNewline -ForegroundColor $COLOR
    Write-Host $bloc1 -ForegroundColor $COLOR -NoNewline
    Write-Host $Single.UR -ForegroundColor $COLOR

    for ($i = 1; $i -lt $H; $i++) {
        $Y2 = $Y + $i
        $X2 = $X + $W - 1
        setPosition $X $Y2
        Write-Host $Single.LEFT -ForegroundColor $COLOR
        setPosition $X2 $Y2
        Write-Host $Single.RIGHT -ForegroundColor $COLOR
    }

    $Y2 = $Y + $H
    setPosition $X $Y2
    $bloc1 = "".PadLeft($W - 2, $Single.BOTTOM)
    Write-Host $Single.BL -NoNewline -ForegroundColor $COLOR
    Write-Host $bloc1 -ForegroundColor $COLOR -NoNewline
    Write-Host $Single.BR -ForegroundColor $COLOR
}

function drawBox {
    $Root = [CLRCLI.Widgets.RootWindow]::new()
    $Dialog = [CLRCLI.Widgets.Dialog]::new($Root)

    $Dialog.Text = "Packages List"
    $Dialog.Width = $Host.UI.RawUI.WindowSize.Width - 8
    $Dialog.Height = $Host.UI.RawUI.WindowSize.Height - 8
    $Dialog.Top = 4
    $Dialog.Left = 4
    $Dialog.Border = [CLRCLI.BorderStyle]::Thick

    $Root.run()

    Clear-Host
}


function testFrame {
    drawFrame 10 10 100 10 Blue
}
