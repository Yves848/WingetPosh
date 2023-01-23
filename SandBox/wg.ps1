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

class listUpdateItem {
    [upgradeSoftware]$Package
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

    [void] Write (
        [string]$line
    ){
        [System.Console]::Write($line)
    }

    [void] Write (
        [String]$line,
        [System.ConsoleColor]$fg,
        [System.ConsoleColor]$bg
    ) {
        [System.console]::BackgroundColor = $bg
        [System.console]::ForegroundColor = $fg
        $this.Write($line)
    }
  
    [void] drawWindow() {
        [System.Console]::CursorVisible = $false
        $this.setPosition($this.X, $this.Y)
      
  
        $bloc1 = "".PadLeft($this.W - 2, $this.frameStyle.TOP)
        $blank = "".PadLeft($this.W - 2, " ") 
        Write-Host $this.frameStyle.UL -NoNewline -ForegroundColor $this.frameColor
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
        Write-Host $this.frameStyle.UR -ForegroundColor $this.frameColor
  
        for ($i = 1; $i -lt $this.H; $i++) {
            $Y2 = $this.Y + $i
            $X2 = $this.X + $this.W - 1
            $this.setPosition($this.X, $Y2)
            Write-Host $this.frameStyle.LEFT -ForegroundColor $this.frameColor
          
            $X3 = $this.X + 1
            $this.setPosition($X3, $Y2)
            Write-Host $blank 
          
            $this.setPosition($X2, $Y2)
            Write-Host $this.frameStyle.RIGHT -ForegroundColor $this.frameColor
        }
  
        $Y2 = $this.Y + $this.H
        $this.setPosition( $this.X, $Y2)
        $bloc1 = "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM)
        Write-Host $this.frameStyle.BL -NoNewline -ForegroundColor $this.frameColor
        Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
        Write-Host $this.frameStyle.BR -ForegroundColor $this.frameColor
        $this.drawTitle()
        $this.drawFooter()
    }
  
    [void] drawTitle() {
        if ($this.title -ne "") {
            $local:X = $this.x + 2
            $this.setPosition($local:X, $this.Y)
            $this.write("| ",$this.frameColor,"Black")
            $local:X = $local:X + 2
            $this.setPosition($local:X, $this.Y)
            $this.write($this.title,$this.titleColor,"Black")
            $local:X = $local:X + $this.title.Length
            $this.setPosition($local:X, $this.Y)
            $this.write(" |",$this.frameColor,"Black")
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
        $local:blank = "".PadLeft($this.W - 2, " ") 
        for ($i = 1; $i -lt $this.H; $i++) {
            $this.setPosition(($this.X + 1), ($this.Y + $i))
            Write-Host $blank 
        } 
    }
}

$Global:columns = @()
$Global:source = ""
[System.Collections.ArrayList]$Global:toInstall = @()

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$configPath = Join-Path -Path $scriptPath -ChildPath "params.json"
if (Test-Path -Path $configPath -PathType Leaf) {
    $config = Get-Content -Raw -Path $configPath | ConvertFrom-Json
}
else {
    $sConfig = '{
        "source": "winget",
        "nresult": "10"
    }
    '
    $config = $sConfig | ConvertFrom-Json
    $config | ConvertTo-Json | Out-File $configPath
}

$ColorNormal = @{
    BackgroundColor = "Black"
    ForegroundColor = "White"
}

$ColorInverse = @{
    BackgroundColor = "Yellow"
    ForegroundColor = "Blue"
}

$ColorTitle = @{
    BackgroundColor = "Gray"
    ForegroundColor = "Black"
}

$ColorInput = @{
    BackgroundColor = "Blue"
    ForegroundColor = "Yellow"
}

$ColorColumn = @{
    BackgroundColor = "Black"
    ForegroundColor = "Blue"
}



[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 

function spacer {
    Write-Host " " -NoNewline
    Write-Host $Single.LEFT -NoNewline
    Write-Host " " -NoNewline
}
function Wait-KeyPress {
    param
    (
        [ConsoleKey]
        $Key = [ConsoleKey]::DownArrow
    )
    
    $keyInfo = [Console]::ReadKey($false)
    
    $keyInfo
}

function makeFiller {
    param(
        # Width of the filler
        [Parameter(
            HelpMessage = "Width of the filler (default is screen width)"
        )]
        [Int16]
        $Width,
        # Filler character
        [Parameter(
            HelpMessage = "Character to use to fill"
        )]
        [string]
        $Fill
    )
    if ($width -eq 0) {
        $Width = $Host.UI.RawUI.WindowSize.Width
    }
}

function wgConfig {
    param(
        # List parameters
        [Parameter(AttributeValues)]
        [ParameterType]
        $ParameterName
    )
}

function getColumnsHeaders {
    param(
        [parameter (
            Mandatory,
            HelpMessage = "Package (or part) name to search"
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

function wgUpgradable {

    $command = "winget upgrade --include-unknown"
    
    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)

    $fl = 0
    while (-not $lines[$fl].StartsWith("Nom")) {
        $fl++
    }
    $Global:columns = getColumnsHeaders -columsLine $lines[$fl]

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
            $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
            $software = [upgradeSoftware]::new()
            $software.Name = $name;
            $software.Id = $id;
            $software.Version = $version
            $software.AvailableVersion = $available
            $software.Source = $source
            $upgradeList += $software
        }
    }
    $upgradeList
}

function wgList {

    $command = "winget list"
    
    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)

    $fl = 0
    while (-not $lines[$fl].StartsWith("----")) {
        $fl++
    }
    $Global:columns = getColumnsHeaders -columsLine $lines[$fl - 2]

    $idStart = $lines[$fl].IndexOf("ID")
    $versionStart = $lines[$fl].IndexOf("Version")
    $availableStart = $lines[$fl].IndexOf("Disponible")
    $sourceStart = $lines[$fl].IndexOf("Source")

    $InstalledList = @()
    For ($i = $fl + 1; $i -le $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
            $name = $line.Substring(0, $idStart).TrimEnd()
            $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
            $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
            $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
            $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
            if ($source -ne "") {
                $software = [upgradeSoftware]::new()
                $software.Name = $name;
                $software.Id = $id;
                $software.Version = $version
                $software.AvailableVersion = $available
                $software.Source = $source
                $InstalledList += $software
            }
        }
    }
    $installedList
}

function wgSearch {
    param(
        [parameter (
            Mandatory,
            HelpMessage = "Package (or part) name to search"
        )]
        [string]$search,
        # Store Filter
        [Parameter(
            HelpMessage = "store to filter on"
        )]
        [string]
        $Store    
    )

    $command = "winget search --name ${search}"

    if ($Store -ne "") {
        $command = $command + " --source " + $Store
    }
    else {
        # Write-Host "no filter on store"
    }

    # Write-Host $command
    
    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)

    $fl = 0
    while (-not $lines[$fl].StartsWith("Nom")) {
        $fl++
    }
    $Global:columns = getColumnsHeaders -columsLine $lines[$fl]

    $idStart = $lines[$fl].IndexOf("ID")
    $versionStart = $lines[$fl].IndexOf("Version")
    if ($store -eq "") {
        $sourceStart = $lines[$fl].IndexOf("Source")
    }
    $SearchList = @()
    For ($i = $fl + 1; $i -le $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-')) {
            $name = $line.Substring(0, $idStart).TrimEnd()
            $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
            
            if ($Store -eq "") {
                $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
                $source = $line.Substring($sourceStart, $line.Length - $sourceStart).TrimEnd()
            }
            else {
                $version = $line.Substring($versionStart, $line.Length - $versionStart).TrimEnd()
                $source = $store
            }
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
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $X, $Y
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

function clearFrame {
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
        [System.ConsoleColor]$COLOR = "Black"
    )
    setPosition $X $Y
    
    $blank = "".PadLeft($W, " ") 
    Write-Host $blank -ForegroundColor $COLOR -NoNewline
    
    for ($i = 1; $i -le $H; $i++) {
        $Y2 = $Y + $i
        setPosition $X $Y2
        Write-Host $blank    
    }
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

function showOptions {
    $W = $Host.UI.RawUI.WindowSize.Width
    $H = $Host.UI.RawUI.WindowSize.Height
    $WW = [Math]::Round($W * .9)
    $WH = [Math]::Round($H * .8)
    $X = [Math]::Round(($W - $WW) / 2)
    $Y = [Math]::Round(($H - $WH) / 2)
    $coord = @{
        W = $WW
        h = $WH
        X = $X
        Y = $Y
    }

    function Frame {
        clearFrame @coord
        drawFrame @coord -COLOR Blue -Clear
    }
    
    function drawTitle {
        $X1 = $X + 3 
        setPosition -X $X1 + 3 -Y $Y
        Write-Host "| Selected Packages |" -ForegroundColor Blue -NoNewline
    }

    function drawFooter {
        $bloc = "[↑/↓ ⋮ Select] [Del ⋮ Remove] [Space ⋮ Check/Uncheck]"
        $Y1 = $Y + $WH
        $X1 = ($X + $WW) - $bloc.Length - 2
        setPosition -X $X1 -Y $Y1
        Write-Host $bloc -NoNewline -ForegroundColor Blue
    }

    function drawItems {
        $currentLine = 0
        do {
            if ($currentLine -eq $line) {
                $Colors = $ColorInverse
            }
            else {
                <# Action when all if and elseif conditions are false #>
                $Colors = $ColorNormal
            }
            $XX = $X + 1
            $YY = $Y + 2 + $currentLine
            setPosition -X $XX -Y $YY
            $bloc = "".PadLeft($WW - 2, " ")
            Write-Host $bloc @Colors -NoNewline
            
            setPosition -X $XX -Y $YY
            if ($Global:toInstall[$currentLine + $startLine].Selected) {
                Write-Host '✔️' @Colors -NoNewline 
            }
            else {
                Write-Host ' ' @Colors -NoNewline
            }
            $XX = $X + 2
            setPosition -X $XX -Y $YY
            Write-Host $Global:toInstall[$currentLine + $startLine].Package.Name @Colors -NoNewline
            $col = $columns[0]
            $XX = $XX + $col.Len
            setPosition -X $XX  -Y $YY
            Write-Host $Global:toInstall[$currentLine + $startLine].Package.ID @Colors -NoNewline
            $col = $columns[1]
            $XX = $XX + $col.Len
            setPosition -X $XX  -Y $YY
            Write-Host $Global:toInstall[$currentLine + $startLine].Package.Version @Colors -NoNewline
            
            $currentLine += 1
        } while (($currentLine -lt $WH - 1) -and ($currentLine + $startLine -lt $Global:toInstall.count))
    }

    $line = 0
    $startLine = 0
    $over = 0
    Frame
    drawTitle
    drawFooter
    do {
        drawItems
        $key = Wait-KeyPress
        switch ($key.key) {
            DownArrow {            
                if ($line -eq $H - 2) {
                    if (($line + $startLine) -lt $Global:toInstall.Length - 1) {
                        $startLine += 1  
                    }
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
                if ($Global:toInstall[$line + $startLine].Selected -eq $false) {
                    $Global:toInstall[$line + $startLine].Selected = $true
                }
                else {
                    $Global:toInstall[$line + $startLine].Selected = $false
                    
                } 
            }
            Delete {
                $Global:toInstall.removeAt($line + $startLine)
                Frame
                drawTitle
                drawFooter
                drawItems
            }
            Enter {
                $over = 1
            }
            Escape {
                $over = 2
            }
           
        }
    } until (
        $over -gt 0
    )

    # clearFrame @coord
}

function isItemPresent {
    param (
        [string]
        $aId
    )
    $result = $false
    $local:i = 0
    while ((-not $result) -and ($local:i -lt $Global:toInstall.count)) {
        $result = ($Global:toInstall[$local:i].package.id -eq $aid)
        $local:i ++
    }
    $result
}

function wgSearchList {
    param (
        # Package to search
        [Parameter(
            Mandatory,
            HelpMessage = "Winget get search Helper"
        )]
        [String]
        $Search,
        # Source Filter
        [Parameter(
            HelpMessage = "Optional Source Filter"
        )]
        [String]
        $Store
    )

    function updateItems {
        foreach ($item in $menuItems) {
            $local:id = $item.package.id
            $item.selected = isItemPresent($local:id)            
        }
    }

    function installPackages {
        param(
            # Parameter help description
            [System.Object]
            $list
        )
        # $list | ForEach-Object { wginstall -id $_.id }
        $W = $Host.UI.RawUI.WindowSize.Width
        $H = $Host.UI.RawUI.WindowSize.Height
        $WW = [Math]::Round($W * .9)
        $WH = [Math]::Round($H * .6)
        $X = [Math]::Round(($W - $WW) / 2)
        $Y = [Math]::Round(($H - $WH) / 2)
        $coord = @{
            W = $WW
            h = $WH
            X = $X
            Y = $Y
        }
        Clear-Host
        Write-Host "Selected Packages"
        # $list | ForEach-Object { Write-Host "${_.id} | ${_.Name}" }
        foreach ($item in $Global:toInstall) {
            if ($item.selected) {
                Write-Host @ColorColumn -NoNewline " Name : "
                Write-Host $item.Package.Name -NoNewline
                Write-Host @ColorColumn -NoNewline "`t`t Id : "
                Write-Host $item.package.Id
            }
        }
        
        # drawFrame @coord -COLOR Blue -Clear
        # $XX = $X + 2
        # $YY = $Y + 2
        Write-Host "`n`r to install the selected packages :`r`n"
        Write-Host "`$list | ForEach-Object {wginstall -id $_.id}"
        
    }

    function drawTitle {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, "…")
        setPosition -X 0 -y 0
        Write-Host $bloc -NoNewline
        setPosition -x 2 -y 0
        Write-Host "Select Packqages to Install" -NoNewline
        $right = "[↑/↓ ⋮ Choice] [Space ⋮ Check/Uncheck]"
        $X = $Host.UI.RawUI.WindowSize.Width - $right.Length - 3
        setPosition -X $X -Y 0
        Write-Host $right -NoNewline
    }

    function drawColumnNames {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, " ")
        setPosition -X 0 -Y 1
        Write-Host $bloc @ColorTitle -NoNewline
        foreach ($col in $columns) {
            $X = $col.Position + 1
            setPosition -X $X -Y 1 
            Write-Host $col.name @ColorTitle -NoNewline
        }
    }

    function drawFooter {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, "…")
        $Y = $Host.UI.RawUI.WindowSize.Height - 1
        setPosition -X 0 -y $Y
        Write-Host $bloc -NoNewline
        $right = "[? ⋮ Summary] [/ ⋮ Search] [Enter ⋮ Confirm] [Esc ⋮ Abort]"
        $X = $Host.UI.RawUI.WindowSize.Width - $right.Length - 3
        setPosition -X $X -Y $Y 
        Write-Host $right -NoNewline
    }

    function drawItems {
        $currentLine = 0
        do {
            if ($currentLine -eq $line) {
                $Colors = $ColorInverse
            }
            else {
                <# Action when all if and elseif conditions are false #>
                $Colors = $ColorNormal
            }
            $Y = 2 + $currentLine
            setPosition -X 0 -Y $Y
            # $bloc = "".PadLeft($W, " ")
            # Write-Host $bloc @Colors -NoNewline
            
            setPosition -X 0 -Y $Y
            if ($menuItems[$currentLine + $startLine].Selected) {
                Write-Host '✔️' @Colors -NoNewline 
            }
            else {
                Write-Host '  ' @Colors -NoNewline
            }
            $X = 2
            setPosition -X $X -Y $Y
            $col = $columns[0]
            Write-Host $menuItems[$currentLine + $startLine].Package.Name.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            $col = $columns[1]
            Write-Host $menuItems[$currentLine + $startLine].Package.ID.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            $col = $columns[2]
            Write-Host $menuItems[$currentLine + $startLine].Package.Version.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            Write-Host $menuItems[$currentLine + $startLine].Package.Source @Colors -NoNewline
            $currentLine += 1
        } while (($currentLine -lt $H - 1) -and ($currentLine + $startLine -lt $menuItems.Length))
    }
    $Global:toInstall.Clear()
    $line = 0
    $startLine = 0
    $over = 0
    Clear-Host
    displayStatus -Status 'Getting packages List'
    $list = wgSearch -search $Search -Store $Store
    
    ClearStatus
    $menuItems = @()
    foreach ($item in $list) {
        $menuitem = [listSearchItem]::new()
        $menuitem.Package = $item
        $menuitem.Selected = (isItemPresent -aId $item.id)
        $menuItems += $menuitem
    }
    $result = @()
    $W = $Host.UI.RawUI.WindowSize.Width
    $H = $Host.UI.RawUI.WindowSize.Height - 2
    drawTitle
    drawColumnNames
    drawFooter
    do {
        drawItems
        $key = Wait-KeyPress
        switch ($key.key) {
            DownArrow {            
                if ($line -eq $H - 2) {
                    if (($line + $startLine) -lt $menuItems.Length - 1) {
                        $startLine += 1  
                    }
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
                    $Global:toInstall += @{
                        Selected = $true
                        Package  = $menuItems[$line + $startLine].Package
                    }
                }
                else {
                    $tempID = $menuItems[$line + $startLine].Package.id 
                    $menuItems[$line + $startLine].Selected = $false
                    foreach ($item in $Global:toInstall) {
                        if ($item.Package.Id -eq $tempID) {
                            $Global:toInstall.remove($item)
                            break
                        }
                    }
                } 
            }
            Enter {
                $over = 1
                foreach ($item in $Global:toInstall) {
                    if ($item.Selected) {
                        $result += $item.Package
                    }
                }
                installPackages -list $result
            }
            Escape {
                $over = 2
                foreach ($item in $Global:toInstall) {
                    if ($item.Selected) {
                        $result += $item.Package
                    }
                }
                $result
            }
            OemComma {
                showOptions
                updateItems
                Clear-Host
                drawTitle
                drawColumnNames
                drawFooter
                drawItems
                
            }
            Default {
                if ($key.KeyChar -eq "/") {
                    [console]::beep(2000, 100)
                    $Y = $Host.UI.RawUI.WindowSize.Height - 1
                    setPosition -X 2 -y $Y
                    Write-Host "[Search]:" -NoNewline @ColorInput
                    $Search = Read-Host
                    $line = 0
                    $startLine = 0
                    $over = 0
                    Clear-Host
                    displayStatus -Status 'Getting packages List'
                    $list = wgSearch -search $Search -Store $Store
                    ClearStatus
                    $menuItems = @()
                    foreach ($item in $list) {
                        $menuitem = [listSearchItem]::new()
                        $menuitem.Package = $item
                        $menuitem.Selected = (isItemPresent -aId $item.id)
                        $menuItems += $menuitem
                    }
                    drawTitle
                    drawColumnNames
                    drawFooter
                    drawItems
                }
            }
        }
    } until (
        $over -gt 0
    )
    
    $result
    # Clear-Host
    
}

function wgUpgradeList {

    function upgradePackages {
        param(
            # Parameter help description
            [System.Object]
            $list
        )
        # $list | ForEach-Object { wginstall -id $_.id }
        $W = $Host.UI.RawUI.WindowSize.Width
        $H = $Host.UI.RawUI.WindowSize.Height
        $WW = [Math]::Round($W * .9)
        $WH = [Math]::Round($H * .6)
        $X = [Math]::Round(($W - $WW) / 2)
        $Y = [Math]::Round(($H - $WH) / 2)
        $coord = @{
            W = $WW
            h = $WH
            X = $X
            Y = $Y
        }
        #Clear-Host
        Write-Host "Selected Packages"
        # $list | ForEach-Object { Write-Host "${_.id} | ${_.Name}" }
        foreach ($item in $Global:toInstall) {
            if ($item.selected) {
                Write-Host @ColorColumn -NoNewline " Name : "
                Write-Host $item.Package.Name -NoNewline
                Write-Host @ColorColumn -NoNewline "`t`t Id : "
                Write-Host $item.package.Id
            }
        }
        
        # drawFrame @coord -COLOR Blue -Clear
        # $XX = $X + 2
        # $YY = $Y + 2
        Write-Host "`n`r to install the selected packages :`r`n"
        Write-Host "`$list | ForEach-Object {wgUpgrade -id $_.id}"
        
    }

    function drawTitle {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, "…")
        setPosition -X 0 -y 0
        Write-Host $bloc -NoNewline
        setPosition -x 2 -y 0
        Write-Host "Select Packqages to Upgrade" -NoNewline
        $right = "[↑/↓ ⋮ Choice] [Space ⋮ Check/Uncheck]"
        $X = $Host.UI.RawUI.WindowSize.Width - $right.Length - 3
        setPosition -X $X -Y 0
        Write-Host $right -NoNewline
    }

    function drawColumnNames {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, " ")
        setPosition -X 0 -Y 1
        Write-Host $bloc @ColorTitle -NoNewline
        foreach ($col in $columns) {
            $X = $col.Position + 1
            setPosition -X $X -Y 1 
            Write-Host $col.name @ColorTitle -NoNewline
        }
    }

    function drawFooter {
        $bloc = "".PadLeft($Host.UI.RawUI.WindowSize.Width, "…")
        $Y = $Host.UI.RawUI.WindowSize.Height - 1
        setPosition -X 0 -y $Y
        Write-Host $bloc -NoNewline
        $right = "[? ⋮ Options] [Enter ⋮ Confirm] [Esc ⋮ Abort]"
        $X = $Host.UI.RawUI.WindowSize.Width - $right.Length - 3
        setPosition -X $X -Y $Y 
        Write-Host $right -NoNewline
    }

    function drawItems {
        $currentLine = 0
        do {
            if ($currentLine -eq $line) {
                $Colors = $ColorInverse
            }
            else {
                <# Action when all if and elseif conditions are false #>
                $Colors = $ColorNormal
            }
            $Y = 2 + $currentLine
            setPosition -X 0 -Y $Y
            $bloc = "".PadLeft($W, " ")
            #Write-Host $bloc @Colors -NoNewline
            
            setPosition -X 0 -Y $Y
            if ($menuItems[$currentLine + $startLine].Selected) {
                Write-Host '✔️' @Colors -NoNewline 
            }
            else {
                Write-Host '  ' @Colors -NoNewline
            }

            $X = 2
            setPosition -X $X -Y $Y
            $col = $columns[0]
            Write-Host $menuItems[$currentLine + $startLine].Package.Name.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            $col = $columns[1]
            Write-Host $menuItems[$currentLine + $startLine].Package.ID.PadRight($col.len, " ")  @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            $col = $columns[2]
            Write-Host $menuItems[$currentLine + $startLine].Package.Version.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            $col = $columns[3]
            Write-Host $menuItems[$currentLine + $startLine].Package.AvailableVersion.PadRight($col.len, " ") @Colors -NoNewline
            
            $X = $X + $col.Len
            setPosition -X $X  -Y $Y
            Write-Host $menuItems[$currentLine + $startLine].Package.Source @Colors -NoNewline

            $currentLine += 1
        } while (($currentLine -lt $H - 1) -and ($currentLine + $startLine -lt $menuItems.Length))
    }

    $line = 0
    $startLine = 0
    $over = 0
    Clear-Host
    displayStatus -Status 'Getting packages List'
    $list = wgUpgradable

    $Global:toInstall.Clear()
    ClearStatus
    $menuItems = @()
    foreach ($item in $list) {
        $menuitem = [listUpdateItem]::new()
        $menuitem.Package = $item
        $menuitem.Selected = $false
        $menuItems += $menuitem
    }
    $result = @()
    $W = $Host.UI.RawUI.WindowSize.Width
    $H = $Host.UI.RawUI.WindowSize.Height - 2
    drawTitle
    drawColumnNames
    drawFooter
    do {
        drawItems
        $key = Wait-KeyPress
        switch ($key.key) {
            DownArrow {            
                if ($line -eq $H - 2) {
                    if (($line + $startLine) -lt $menuItems.Length - 1) {
                        $startLine += 1  
                    }
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
                # if ($menuItems[$line + $startLine].Selected -eq $false) {
                #     $menuItems[$line + $startLine].Selected = $true
                # }
                # else {
                #     $menuItems[$line + $startLine].Selected = $false
                # }
                if ($menuItems[$line + $startLine].Selected -eq $false) {
                    $menuItems[$line + $startLine].Selected = $true
                    $Global:toInstall += @{
                        Selected = $true
                        Package  = $menuItems[$line + $startLine].Package
                    }
                }
                else {
                    $tempID = $menuItems[$line + $startLine].Package.id 
                    $menuItems[$line + $startLine].Selected = $false
                    foreach ($item in $Global:toInstall) {
                        if ($item.Package.Id -eq $tempID) {
                            $Global:toInstall.remove($item)
                            break
                        }
                    }
                }  
            }
            Enter {
                $over = 1
                foreach ($item in $Global:toInstall) {
                    if ($item.Selected) {
                        $result += $item.Package
                    }
                }

                upgradePackages -list $result
            }
            Escape {
                $over = 2
            }
            OemComma {
                showOptions
                Clear-Host
                drawTitle
                drawColumnNames
                drawFooter
                drawItems
                
            }
            Default {
                
            }
        }
    } until (
        $over -gt 0
    )
    
    
    
    $result
}

function wgInstall {
    param(
        # Parameter help description
        [Parameter(
            Mandatory
        )]
        [string]
        $ID,
        # Parameter help description
        [switch]
        $silent
    )
    $command = "winget install --id ${ID}"

    if ($silent.IsPresent) {
        $command = $command + " --silent "
    }

    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)
}

function wgUpgrade {
    param(
        # Parameter help description
        [Parameter(
            Mandatory
        )] 
        [string]
        $ID,
        # Parameter help description
        [switch]
        $silent
    )
    $command = "winget upgrade --id ${ID}"

    if ($silent.IsPresent) {
        $command = $command + " --silent "
    }

    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)
}

function wgRemove {
    param(
        # Parameter help description
        [Parameter(
            Mandatory
        )]
        [string]
        $ID
    )
    $command = "winget uninstall --id ${ID}"

    $SearchResult = Invoke-Expression $command | Out-String
    $lines = $SearchResult.Split([Environment]::NewLine)

    $lines
}

function wingetPosh {
    # Clear-Host
    $local:W = [Math]::Round($Host.UI.RawUI.WindowSize.Width * .9)
    $local:H = [Math]::Round($Host.UI.RawUI.WindowSize.Height * .6)
    $local:X = [Math]::Round(($Host.UI.RawUI.WindowSize.Width - $local:W) / 2) 
    $local:Y = [Math]::Round(($Host.UI.RawUI.WindowSize.Height - $local:H) / 2)
    $local:window = [window]::new(
        $local:X,
        $local:Y,
        $local:W,
        $local:H,
        $false,
        "Blue",
        "WinGet POSH",
        "Red"
    ) 
    $local:window.footer = "[↑/↓ ⋮ Select] [Enter ⋮ Select] [Esc ⋮ Quit]"
    [System.Console]::CursorVisible = $false
    function drawLines {
        param(
            [array]$menuItems,
            [int]$X,
            [int]$Y,
            [int]$width,
            [int]$selected
        )
        $local:i = 0
        while ($local:i -lt $menuItems.Length) {
            setPosition -X ($X + 1) -Y ($Y + 2 + ($local:i * 3))
            if ($local:i -eq $selected) {
                $local:color = @{
                    ForeGroundColor = "Blue"
                    backgroundColor = "Yellow"
                }
            }
            else {
                $local:color = @{
                    BackgroundColor = "Black"
                    ForegroundColor = "White"
                }
            }
            $local:item = $menuItems[$local:i].PadLeft($width - 2)
            Write-Host $local:item @local:color -NoNewline
            $local:i++
        }
    }

    $local:menuItems = @(
        "Search for packages",
        "List installed packages",
        "List available updates"
    )
    Clear-Host
    $local:window.drawWindow()
    $local:line = 0
    $local:over = 0
    $local:selected = -1
    drawLines -menuitems $local:menuItems -X $local:X -y $local:Y -width $local:W -selected $local:line

    do { 
        $local:key = Wait-KeyPress
        switch ($local:key.key) {
            DownArrow {            
                if ($local:line -lt $local:menuItems.Length - 1) {
                    
                    $local:Line += 1  
                }
            
                else {
                    $local:line = 0
                }
                
            }
            UpArrow { 
                if ($local:line -ge 1) {
                    
                    $local:Line -= 1  
                }
            
                else {
                    $local:line = $local:menuItems.Length - 1
                }
            }
            SpaceBar {
            }
            Enter {
                $local:over = 1
                $local:selected = $local:line
            }
            Escape {
                $local:over = 2
            }
        } 

        if ($local:over -eq 1) {
            switch ($local:selected) {
                0 {  
                    $local:searchPackage = [window]::new(10, 8, 80, 5, $true, "White", "Search Package", "Blue")
                    $local:searchPackage.drawWindow()
                    setPosition 12 11
                    Write-Host "Package to search : " -NoNewline
                    $local:package = Read-Host
                    $list = wgSearchList -Search $local:Package
                }
                2 {
                    $list = wgUpgradeList
                }
                Default {}
            }
            $local:selected = -1
            $local:over = 0
            Clear-Host
            $local:window.drawWindow()
        }
        
        drawLines -menuitems $local:menuItems -X $local:X -y $local:Y -width $local:W -selected $local:line
    }
    until (
        $local:over -eq 2
    )
    
}

function getUIInfos {
    Write-Host "Width: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Width
    Write-Host "Height: " -ForegroundColor Gray -NoNewline
    Write-Host $Host.UI.RawUI.WindowSize.Height 
    Write-Host "✔️"
}

function testWindow {
    $local:window = [window]::new(
        10,
        2,
        40,
        20,
        $false,
        "Blue",
        "Title",
        "Red"
    ) 
    $local:window.drawWindow()
    [System.Console]::ReadKey()
}

