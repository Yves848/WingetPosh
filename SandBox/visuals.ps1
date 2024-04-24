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

function Open-Spinner{
  param(
    [string]$label = "Loading"
  )
  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $runspace = [runspacefactory]::CreateRunspace()
  $statedata.X = $host.ui.rawui.CursorPosition.X # setting the cursor position (X)
  $statedata.Y = $host.ui.rawui.CursorPosition.Y # setting the cursor position (Y)
  $statedata.label = $label # setting the label
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData", $StateData)
  $sb = {

    [system.Console]::CursorVisible = $false
    $X = $StateData.X
    $Y = $StateData.Y
    #$Spinner = @("◜", "◠", "◝", "◞", "◡", "◟")
    #$Spinner = @("◾", "◾", "◼️", "◼️", "⬛", "⬛", "◼️", "◼️")
    #$Spinner = @("≻    ", " ≻   ", "  ≻  ", "   ≻ ", "    ≻","    ≺", "   ≺ ", "  ≺  ", " ≺   ", "≺    ")
    #$Spinner = @("......","o.....","Oo....","oOo...",".oOo..","..oOo.","...oOo","....oO",".....o","....oO","...oOo","..oOo.",".oOo..","oOo...","Oo....","o.....","......")
    #$Spinner = @("▰▱▱▱▱▱▱","▰▰▱▱▱▱▱","▰▰▰▱▱▱▱","▰▰▰▰▱▱▱","▰▰▰▰▰▱▱","▰▰▰▰▰▰▱","▰▰▰▰▰▰▰","▰▱▱▱▱▱▱")
    #$Spinner = @("⣾⣿", "⣽⣿", "⣻⣿", "⢿⣿", "⡿⣿", "⣟⣿", "⣯⣿", "⣷⣿","⣿⣾", "⣿⣽", "⣿⣻", "⣿⢿", "⣿⡿", "⣿⣟", "⣿⣯", "⣿⣷")
    $Spinner = @("⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷","⣿")
    $i = 0
    $offset = ($spinner | Measure-Object -Property Length -Maximum).Maximum
    while ($true) {
      [System.Console]::setcursorposition($X, $Y)
      $text = "$([char]27)[35m$([char]27)[50m$($Spinner[$i])$([char]27)[0m"      
      #[system.console]::write($Spinner[$i])
      [system.console]::write($text)
      [System.Console]::setcursorposition(($X + $offset) +1, $Y)
      [system.console]::write($statedata.label)
      $i = ($i + 1) % $Spinner.Length
      Start-Sleep -Milliseconds 50
    }
  }
  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $runspace
  $null = $session.BeginInvoke()
  return $Session, $runspace
}

function Close-Spinner {
  param(
    $Session,
    $Runspace
  )
  $null = $session.Stop()
  $null = $runspace.dispose() 
  [System.Console]::setcursorposition(0,$host.ui.rawui.CursorPosition.Y) # setting the cursor position (X)
  [system.console]::write(" ".PadLeft(($host.ui.rawui.BufferSize.Width), " "))
  [System.Console]::setcursorposition(0,$host.ui.rawui.CursorPosition.Y)
  [System.Console]::CursorVisible = $true
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
      #$this.UL = "┌"
      $this.UL = [char]::ConvertFromUtf32(0x256d)
      #$this.UR = "┐"
      $this.UR = [char]::ConvertFromUtf32(0x256e)
      $this.TOP = "─"
      $this.LEFT = "│"
      $this.RIGHT = "│"
      $this.BL = [char]::ConvertFromUtf32(0x2570)
      #$this.BL = "└"
      $this.BR = [char]::ConvertFromUtf32(0x256f)
      #$this.BR = "┘"
      $this.BOTTOM = "─"
      $this.LEFTSPLIT = [char]::ConvertFromUtf32(0x2524)
      $this.RIGHTSPLIT = [char]::ConvertFromUtf32(0x251c)
    }
  }
}

$Single = [Frame]::new($false)
$Double = [Frame]::new($true)




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
    $blank = $this.frameStyle.LEFT, "".PadLeft($this.W - 2, " "), $this.frameStyle.RIGHT -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    for ($i = 1; $i -lt $this.H; $i++) {
      $Y2 = $this.Y + $i
      $X3 = $this.X 
      $this.setPosition($X3, $Y2)
      Write-Host $blank -ForegroundColor $this.frameColor    
    }
    $Y2 = $this.Y + $this.H
    $this.setPosition( $this.X, $Y2)
    $bloc1 = $this.frameStyle.BL, "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM), $this.frameStyle.BR -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    $this.drawTitle()
    $this.drawFooter()
  }
    
  
  [void] drawVersion() {
    $v = Get-WGPVersion -param WGP
    $version = $this.frameStyle.LEFTSPLIT, $v, $this.frameStyle.RIGHTSPLIT -join ""
    $isempty = [string]::IsNullOrEmpty($v)
    if ($isempty -eq $true) {
      $version = $this.frameStyle.LEFTSPLIT, "Debug", $this.frameStyle.RIGHTSPLIT -join ""
    }
    [System.Console]::setcursorposition($this.W - ($version.Length + 6), $this.Y )
    [console]::write($version)
  }
  
  [void] drawTitle() {
    if ($this.title -ne "") {
      $local:X = $this.x + 2
      $this.setPosition($local:X, $this.Y)
      Write-Host ($this.frameStyle.LEFTSPLIT, " " -join "") -NoNewline -ForegroundColor $this.frameColor
      $local:X = $local:X + 2
      $this.setPosition($local:X, $this.Y)
      Write-Host $this.title -NoNewline -ForegroundColor $this.titleColor
      $local:X = $local:X + $this.title.Length
      $this.setPosition($local:X, $this.Y)
      Write-Host (" ", $this.frameStyle.RIGHTSPLIT -join "") -NoNewline -ForegroundColor $this.frameColor
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
      $foot = $this.frameStyle.LEFTSPLIT, " ", $this.footer, " ", $this.frameStyle.RIGHTSPLIT -join ""
      [console]::write($foot)
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