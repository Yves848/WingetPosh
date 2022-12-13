class Frame {
  [hashtable]$el

  Frame (
    [Bool]$Double = $false
  ) {
    $this.Build($Double)
  }

  Frame() {    
    $this.Build($False)
  }

  [void] Build(
    [Bool]$Double
  ) {
    if ($Double) {
      $this.el = @{"UL" = "╔"; "UR" = "╗"; "TOP" = "═"; "LEFT" = "║"; "RIGHT" = "║"; "BL" = "╚"; "BR" = "╝"; "BOTTOM" = "═" }
    }
    else {
      $this.el = @{"UL" = "┌"; "UR" = "┐"; "TOP" = "─"; "LEFT" = "│"; "RIGHT" = "│"; "BL" = "└"; "BR" = "┘"; "BOTTOM" = "─" }
    }
  }
}

class Window {  
  [int]$X
  [int]$Y
  [int]$W
  [int]$H
  [Frame]$Frame
  hidden [int]$_X
  hidden [int]$_Y
  hidden [int]$_W
  hidden [int]$_H

  Window (
    [int]$X,
    [int]$Y,
    [int]$W,
    [int]$H
  ) {
    $this.X = $X
    $this.Y = $Y
    $this.W = $W
    $this.H = $H
    $this.Frame = [Frame]::new()
    $this.buildInterns()
  }

  hidden [void] buildInterns() {  
    $this._X = $this.X + 1
    $this._Y = $this.Y + 1
    $this._W = $this.W - 2
    $this._H = $this.H - 2

  }

  hidden [void] goto(
    [int]$X,
    [int]$Y
  ) {
    [system.console]::SetCursorPosition($x, $y)
  }

  hidden [void] write(
      [String]$String
  )
  {
    [system.console]::Write($string)
  }

  [void] draw() {
    $this.goto($this.X,$this.Y)
    $this.write($this.topFrame())
    $i =0
    $this.InnerLines() | ForEach-Object { $this.goto($this.X,($this._Y+$i)); $this.write($_); $i++ }
    $this.goto($this.x,($this._H + $this.Y))
    $this.write($this.bottomframe())
  }

  hidden [string] topFrame() {
    return ("{0}{1}{2}" -f $this.Frame.el["UL"], "".PadLeft($this._w, $this.Frame.el["TOP"]), $this.Frame.el["UR"])
  }
  
  hidden [string] BottomFrame() {
    return ("{0}{1}{2}" -f $this.Frame.el["BL"], "".PadLeft($this._w, $this.Frame.el["BOTTOM"]), $this.Frame.el["BR"])
  }

  hidden [string[]] InnerLines() {
    return 1..$this._H | ForEach-Object { ("{0}{1}{2}" -f $this.Frame.el["LEFT"], "".PadLeft($this._W, " "), $this.Frame.el["RIGHT"]) }
  }

}

$win = [Window]::new(10, 10, 40, 20)
$win.draw()