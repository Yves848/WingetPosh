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
        [System.Console]::SetCursorPosition($X,$Y)
    }

    [void] drawWindow() {
        [System.Console]::CursorVisible = $false
        $this.setPosition($this.X,$this.Y)
      

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
            Write-Host "| " -NoNewline -ForegroundColor $this.frameColor
            $local:X = $local:X + 2
            $this.setPosition($local:X,$this.Y)
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
            $this.setPosition($local:X,$local:Y)
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

function getSearchTerms {
    $WinWidth = [System.Console]::WindowWidth
      $X = 0
      $Y = [System.Console]::WindowHeight -6
      $WinHeigt = 4
  
      $win = [window]::new($X, $Y, $WinWidth, $WinHeigt, $false, "White");
    $win.title = "Search"
    $Win.titleColor = "Green"
    $win.footer = "[Enter] : Accept [Ctrl-C] : Abort"
    $win.drawWindow();
    $win.setPosition($X+2, $Y+2);
    [System.Console]::Write('Package :')
    [system.console]::CursorVisible = $true
    $pack = [System.Console]::ReadLine()
    return $pack
  }

  getSearchTerms