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
  $controls = @{}
  
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
    $blank = "$esc[38;5;15m$($this.frameStyle.LEFT)", "".PadLeft($this.W - 2, " "), "$esc[38;5;15m$($this.frameStyle.RIGHT)" -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    for ($i = 1; $i -lt $this.H; $i++) {
      $Y2 = $this.Y + $i
      $X3 = $this.X 
      $this.setPosition($X3, $Y2)
      Write-Host $blank     
    }
    $Y2 = $this.Y + $this.H
    $this.setPosition( $this.X, $Y2)
    $bloc1 = $this.frameStyle.BL, "".PadLeft($this.W - 2, $this.frameStyle.BOTTOM), $this.frameStyle.BR -join ""
    Write-Host $bloc1 -ForegroundColor $this.frameColor -NoNewline
    $this.drawTitle()
    $this.drawFooter()
  }
  
  
  [void] drawVersion() {
    $version = $this.frameStyle.LEFTSPLIT, [string]$(Get-InstalledModule -Name wingetposh -ErrorAction Ignore).version, $this.frameStyle.RIGHTSPLIT -join ""
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

  [void] runWindow() {
    $this.drawWindow()
    $local:stop = $false
    $local:control = 0
    $this.controls.GetEnumerator() | ForEach-Object {
      ([InputBox]$_.Value).draw()
    }
    
    while (-not $local:stop) {
      [System.Management.Automation.Host.KeyInfo]$local:result = [System.Management.Automation.Host.KeyInfo]::new(65, "b", [System.Management.Automation.Host.ControlKeyStates]::NumLockOn, $true)
      if ($this.controls.containsKey("control$($local:control)")) {
        #setfocus
        $local:result = ($this.controls["control$($local:control)"]).focus()
      }
      $key = $local:result
      if ($key.VirtualKeyCode -eq 27) {
        $stop = $true
      }  
      if ($key.VirtualKeyCode -eq 9) {
        [InputBox]($this.controls["control$($local:control)"]).draw()
        $key = {}
        $local:control ++
        if ($local:control -gt ($this.controls.count - 1)) {
          $local:control = 0
        }
      }
    }
  }

  [void] addInputBox(
    [string]$name,
    [int]$x,
    [int]$y,
    [int]$width
  ) {
    [InputBox]$ib = [InputBox]::new()
    $ib.parent = $this
    $ib.name = $name
    $ib.id = $this.controls.Count
    $ib.X = $x
    $ib.Y = $y
    $ib.width = $width
    $ib.buffer = ""
    $this.controls.Add("control$($ib.Id)", $ib)
  }
}

class InputBox {
  [window]$parent
  [string]$name
  [int]$Id
  [int]$X
  [int]$Y
  [int]$Width
  [string]$buffer

  [void] draw() {
    $local:X = $this.parent.X + $this.X
    $local:Y = $this.parent.Y + $this.Y
    [console]::setcursorposition($local:X, $local:Y)
    [console]::write($this.buffer)
  }

  [System.Management.Automation.Host.KeyInfo] focus() {
    $local:X = $this.parent.X + $this.X
    $local:Y = $this.parent.Y + $this.Y
    $local:stop = $false
    while (-not $local:stop) {
      [console]::setcursorposition($local:X, $local:Y)
      [console]::write($this.buffer)
      [System.Console]::CursorVisible = $true
      if ($global:Host.UI.RawUI.KeyAvailable) {
        [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      }
      if ($key.VirtualKeyCode -eq 9) {
        $local:stop = $true
      }
      if ($key.VirtualKeyCode -eq 27) {
        $local:stop = $true
      }
      if ($key.Character  -match "[\w+]") {
        $this.buffer = $this.buffer + $key.Character
      }
    }
    [System.Console]::CursorVisible = $false
    return $key
  }
}

function testWindow {
  [window]$win = [window]::new(0, 0, [console]::WindowWidth, [console]::WindowHeight - 1, $false, "white")
  $win.title = "Test Input Box"
  $win.titleColor = "Blue"
  $win.drawTitle()
  $win.addInputBox("searchkey", 1, 1, 30)
  $win.addInputBox("text", 10, 10, 40)
  $win.runWindow()
  Clear-Host
  $win.controls.GetEnumerator() | ForEach-Object {
    "$($([InputBox]$_.Value).Name) | $($([InputBox]$_.Value).buffer)"
  }
}


function Read-HostPlus()   
{
    param 
    ( 
        $CancelString = "x",    
        $MaxLen = 60            
    )     
    $result = ""
    $cursor = New-Object System.Management.Automation.Host.Coordinates
    while ($true)
    {
        While (!$host.UI.RawUI.KeyAvailable ){}
        $key = $host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
        
        switch ($key.virtualkeycode) 
        {
            27 { While (!$host.UI.RawUI.KeyAvailable ){}; return $CancelString }
            13 { While (!$host.UI.RawUI.KeyAvailable ){}; return $result }   
            8  
            {
                if ($result.length -gt 0)
                {
                    $cursor = $host.UI.RawUI.CursorPosition                    
                    $width = $host.UI.RawUI.MaxWindowSize.Width
                    if ( $cursor.x -gt 0) {  $cursor.x--  }
                    else {  $cursor.x = $width -1; $cursor.y--  }
                    $Host.UI.RawUI.CursorPosition = $cursor  ;   write-host " "  ;  $Host.UI.RawUI.CursorPosition = $cursor
                    $result = $result.substring(0,$result.length - 1 )                  
                }
            }            
            Default 
            {
                $key_char = $key.character  
                if(  [byte][char]$key_char -ne 0  -and  [byte][char]$key_char -gt 31 -and ($result + $key_char).Length -le $MaxLen  )
                {                                      
                    $result += $key_char 
                    $cursor.x = $host.UI.RawUI.CursorPosition.X                              
                    Write-Host $key_char -NoNewline
                    if ($cursor.X -eq $host.UI.RawUI.MaxWindowSize.Width-1 ) {write-host " `b" -NoNewline }    
                }
            }
        }        
    }
}

#testWindow
