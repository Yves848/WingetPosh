# Define a string that contains Kanji characters mixed with normal text
$string = "QQ小程序开发者工具    The"
$string2 = "MusicLake             The"
$string3 = "MusicLâke             The"

$i = 0
$count = 0

while ($count -lt 22) {
  [char]$char = $string[$i]
  $bytes = [text.Encoding]::UTF8.GetByteCount($char)
  if ($bytes -gt 1) {
    $count += ($bytes -1)
  } else {
    $count += $bytes
  }
  $i++
}

"i : $($i) count : $($count)"
$string[$i]