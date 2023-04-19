[System.Console]::CursorVisible = $false

$x = 0
$y = $Host.UI.RawUI.CursorPosition.Y
$i = 1
#Write-Host $statedata
$string = "".PadRight(30,".")
$nav = "oOo"
while ($true) {
  if ($i -lt $nav.Length) {
    $mobile = $nav.Substring($nav.Length - $i)
    $string = $mobile.PadRight(30,'.')
  } else {
    if ($i -gt 27) {
      $nb = 30 - $i
      $mobile = $nav.Substring(1, $nb)
      $string = $mobile.PadLeft(30,'.')

    } else {
      $left = "".PadLeft($i,'.')
      $right = "".PadRight(27 - $i, '.')
      $string = $left,$nav,$right -join ""
    }
  }
  [System.Console]::setcursorposition($X, $Y)
  $str = '⏳ Getting the data ', $string -join ""
  [System.Console]::write($str)
  $i++
  if ($i -gt 30) {
    $i = 1
  }
  Start-Sleep -Milliseconds 100
}

[System.Console]::CursorVisible = $true