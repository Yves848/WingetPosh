[Flags()] enum Styles {
  Normal = 0
  Underline = 1
  Bold = 2
  Reversed = 3
}

function testcolor {
  if ($iscoreclr) {
    $esc = "`e"
  } else {
    $esc = $([char]0x1b)
  }
  0..255 | ForEach-Object {
    Write-Host "$($_) $esc[4m$esc[38;5;$($_)m'test'$esc[0m"
  } 
}

testcolor