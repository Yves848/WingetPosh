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
        #Write-Host $this.frameStyle.UL -NoNewline -ForegroundColor $this.frameColor
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
        #Write-Host $this.frameStyle.UR -ForegroundColor $this.frameColor

        for ($i = 1; $i -lt $this.H; $i++) {
            $Y2 = $this.Y + $i
            #$X2 = $this.X + $this.W - 1
            $this.setPosition($this.X, $Y2)
            #Write-Host $this.frameStyle.LEFT -ForegroundColor $this.frameColor
          
            $X3 = $this.X 
            $this.setPosition($X3, $Y2)
            Write-Host $blank 
          
            #$this.setPosition($X2, $Y2)
            #Write-Host $this.frameStyle.RIGHT -ForegroundColor $this.frameColor
        }

        $Y2 = $this.Y + $this.H
        $this.setPosition( $this.X, $Y2)
        $bloc1 = "".PadLeft($this.W , $this.frameStyle.BOTTOM)
        #Write-Host $this.frameStyle.BL -NoNewline -ForegroundColor $this.frameColor
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
        #Write-Host $this.frameStyle.BR -ForegroundColor $this.frameColor
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
    
    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)
  
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
    $installedList
}

function displayGrid (
    [upgradeSoftware[]]$list,
    [window]$win
) {
    $nbLines = $Win.h - 2
    $blanks = ''.PadLeft(' ', $Host.UI.RawUI.WindowSize.Width * $nbLines)
    [System.Console]::setcursorposition($Win.X, $win.Y + 1)
    [system.console]::write($blanks)
    $output = $list | Select-Object -Property Name, Id, Version, AvailableVersion, Source -First $nbLines | Format-Table -HideTableHeaders |  Out-String
    [System.Console]::setcursorposition($Win.X, $win.Y + 1)
    [system.console]::write($output)
    if ($nbLines -lt $list.Count) {
        [system.console]::setcursorposition($Win.X + 1, $Win.H)
        $pages = [System.Math]::Ceiling($list.count / $nblines)
        [system.console]::Write($pages)
    }
    
}

function Show-WGList {
    $WinWidth = [System.Console]::WindowWidth
    $X = 0
    $Y = 0
    $WinHeigt = [System.Console]::WindowHeight - 2
    $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
    $win.title = "Package List"
    $Win.titleColor = "Green"
    $win.footer = "[Enter] : Accept [Ctrl-C] : Abort"
    $win.drawWindow();

    $stateData = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
    $stop = $false
    $stateData.HasData = $False
    $stateData.Data = "Coucou"

    $runSpace = [runspacefactory]::CreateRunspace()
    $runSpace.Open()
    $runSpace.SessionStateProxy.SetVariable('stateData', $stateData)

    $Sb = {
        while ($true) {
            
            Start-Sleep -Seconds 2
            $list = _wgList | Where-Object { $_.Source -eq "winget" }
            $stateData.Data = $list | Select-Object -Property Name, Id, Version, AvailableVersion, Source -First $nbLines | Format-Table -HideTableHeaders |  Out-String
            $stateData.HasData = $true
        }
    }

    $Session = [powershell]::create()
    $Session.Runspace = $runSpace
    $Session.AddScript($Sb) | Out-Null
    $handle = $Session.BeginInvoke()

    #Clear-Host

    while (-not $stop) {
        [System.Console]::CursorVisible = $false
        [System.Console]::setcursorposition($win.X, $win.Y + 1)
        $nbLines = $Win.h - 2
        $blanks = ' '.PadRight($Host.UI.RawUI.WindowSize.Width * $nbLines)
        [console]::write($blanks)
        [System.Console]::setcursorposition($win.X, $win.Y + 1)
        [console]::write($stateData.data)
        if (-not $stateData.HasData) {
            Write-Host "Getting the list ......."
        }
        while (-not $stateData.HasData) {
            if ($global:Host.UI.RawUI.KeyAvailable) {
                $key = $($global:host.UI.RawUI.ReadKey()).character
                if ($key -eq 'q') {
                    $stop = $true
                    $Session.Stop()
                    $runSpace.Dispose()
                }
                break
            }
            Start-Sleep -Milliseconds 10
        }    
        $stateData.HasData = $false
    }

}
# Create a synchronized hashtable
$StateData = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())

$Stop = $False
# Add some data to the hashtable (creates new property)
$StateData.HasData = $False

# Set up our runspace
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.Open()
# Passing in the hashtable
$Runspace.SessionStateProxy.SetVariable("StateData",$StateData)

# Capture process data in a runspace
$Sb = {
    while($True) {
        # We pause here for 2 seconds between captures, how do we keep the UI available?
        Start-Sleep -Seconds 2 
        $StateData.data = _wgList
        $StateData.HasData = $True
    }
}
$Session = [PowerShell]::Create()
$Session.Runspace = $Runspace
$null = $Session.AddScript($Sb)
$Handle = $Session.BeginInvoke()

$Stop = $False
Clear-Host
while(-not $Stop) {
    [Console]::CursorVisible = $False
    # Reset the cursor to the top left corner
    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    # Draw spaces over the data that is already there (based on the number of 
    # lines displayed * the width of the window)
    $blanks = ' '.PadRight(12 * ($host.UI.RawUI.WindowSize.Width))
    [Console]::Write($blanks)
    # Reset the cursor again
    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    # Finally send the output to the screen
    #[Console]::Write($StateData.Data)
    
    if ( -not $StateData.HasData ) {
        Write-Host "Waiting for data..."
    }
    else {
        $list = $StateData.data | Select-Object -Property Name, Id, Version, AvailableVersion, Source -First 10 | Format-Table -HideTableHeaders |  Out-String
        Write-Host $list
    }
    Write-Host "Press 'q' to quit" -NoNewLine
    [Console]::CursorVisible = $True
    while(-not $StateData.HasData) {
        if($global:Host.UI.RawUI.KeyAvailable) {
                # THIS BLOCKS!
                $key = $($global:Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")).character
                if ( $key -eq 'q' ) {
                    $Stop = $True
                    # Clean up!
                    $Session.Stop()
                    $Runspace.Dispose()
                }
                break
        }
        Start-Sleep -Milliseconds 10
    }
    # Reset the "HasData" flag so we can wait for more data
    #$StateData.HasData = $False
}
