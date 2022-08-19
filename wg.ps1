Add-Type -AssemblyName PresentationFramework


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

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 

function wgGUI {
    $xamlFile = "C:\Users\yvesg\git\WingetPosh\GUI\WingetGUI\MainWindow.xaml"
    $inputXML = Get-Content $xamlFile -Raw
    $inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
    [XML]$XAML = $inputXML

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    try {
        $window = [Windows.Markup.XamlReader]::Load( $reader )
    }
    catch {
        Write-Warning $_.Exception
        throw
    }
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        #"trying item $($_.Name)"
        try {
            Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
        }
        catch {
            throw
        }
    }

    Get-Variable var_*

    $ids = wgUpgradable

    foreach ($id in $ids) {
        $var_listBox.Items.add($id.id) | Out-Null
    }


    
    $Null = $window.ShowDialog()
}

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

function displayFrame {
    $esc = [char]27
    setPosition 0 10
    $bloc1 = "".PadLeft($Host.UI.RawUI.WindowSize.Width - 2, '─')
    Write-Host "┌$bloc1┐"
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
            Mandatory,
            HelpMessage = 'Frame Color'
        )]
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

    $Dialog.Text = "Upgradable Packages List"
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
    Wait-KeyPress "" Enter
}
