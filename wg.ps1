# Invoke-WingetList -Query "git" | Select-Object { $_.NamePrefix }

# https://github.com/PhonicUK/CLRCLI/blob/master/CLRCLI/ConsoleHelper.cs

class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
}

Import-Module ~/CLRCLI.dll

function wgList {
    $upgradeResult = winget list "" | Out-String
    $lines = $upgradeResult.Split([Environment]::NewLine)
    $fl = 0
    while (-not $lines[$fl].StartsWith("Name")) {
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



