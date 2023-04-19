param(
    [switch]$animate = $false
)
$buffer0 = ""
$MAXCOUNT = 30 
$ui = (get-host).ui
$rui = $ui.rawui
 
function fractal([float] $left, [float] $top, [float] $xside, [float] $yside, [float]$zoom) { 
    [float]$maxx = $rui.MaxWindowSize.Width
    [float]$maxy = $rui.MaxWindowSize.Height
    [float]$xscale = $xside / $maxx 
    [float]$yscale = $yside / $maxy 
    for ([int]$y = 1; $y -le ($maxy - 1); $y++) { 
        for ([int]$x = 1; $x -le ($maxx - 1); $x++) { 
            [float]$cx = $x * $xscale + $left; 
            [float]$cy = $y * $yscale + $top; 
            [float]$zx = 0; 
            [float]$zy = 0; 
            [int]  $count = 0; 
            while (($zx * $zx + $zy * $zy -lt 4) -and ($count -lt $MAXCOUNT)) { 
                [float]$tempx = $zx * $zx - $zy * $zy + $cx; 
                $zy = $zoom * $zx * $zy + $cy; 
                $zx = $tempx; 
                $count = $count + 1; 
            } 
            $t = $count + 65
            $char = [char]$t
            $global:buffer[$y * $maxx + $x] = $char
        } 
    } 
}
 
[float] $left = -1.75 
[float] $top = -0.25 
[float] $xside = 0.25 
[float] $yside = 0.45 
1..($rui.MaxWindowSize.Width * $rui.MaxWindowSize.Height) | ForEach-Object { $buffer0 += "#" }
$global:buffer = $buffer0.ToCharArray()
[float]$loop = 5.0
while ($loop -gt 1.0 ) {
    fractal -left $left -top $top -xside $xside -yside $yside -zoom $loop
    [console]::SetCursorPosition(0,0) ;
    [string]$drawscreen = New-Object system.string($global:buffer, 0, $global:buffer.Length)
    [console]::SetCursorPosition(0, 0)
    Write-Host $drawscreen
    # $left, $top, $xside, $yside) 
    $loop -= 0.05
    if (-not $animate) { $loop = -100.0 }
}