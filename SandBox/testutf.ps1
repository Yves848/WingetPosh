[int32]$i = 0
while($i -lt [int32]::MaxValue) {
  Write-Host "$i : $([char]::ConvertFromUtf32($i))" -NoNewline
  $i++
}

