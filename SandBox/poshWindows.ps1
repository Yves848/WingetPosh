class Frame {
  [hashtable]$el

  Frame (
    [Bool]$Double = $false
  ) 
  {
    $this.Build($Double)
  }

  Frame() 
  {    
    $this.Build($False)
  }

  [void] Build(
    [Bool]$Double
  ){
    if ($Double) {
      $this.el = @{"UL"="╔";"UR"="╗";"TOP"="═";"LEFT"="║";"RIGHT"="║";"BL"="╚";"BR"="╝";"BOTTOM"="═"}
    } else {
      $this.el = @{"UL"="┌";"UR"="┐";"TOP"="─";"LEFT"="│";"RIGHT"="│";"BL"="└";"BR"="┘";"BOTTOM"="─"}
    }
  }
}

class Window {
  


}

$Frame = [Frame]::new()

$line = ("{0}{1}{2}" -f $Frame.el["UL"], "".PadLeft(40,$Frame.el["TOP"]),$Frame.el["UR"])
$line
$line = ("{0}{1}{2}" -f $Frame.el["LEFT"], "".PadLeft(40," "),$Frame.el["RIGHT"])
1..10 | ForEach-Object {$line}
$line = ("{0}{1}{2}" -f $Frame.el["BL"], "".PadLeft(40,$Frame.el["BOTTOM"]),$Frame.el["BR"])
$line
