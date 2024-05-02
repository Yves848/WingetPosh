function Get-FieldLength {
  param(
    [string]$buffer
  )
  $i = 0
  $buffer.ToCharArray() | ForEach-Object {
    $l = [Text.Encoding]::UTF8.GetByteCount($_)
    if ($l -ge 2) {
      $l = $l - 1
    }  
    $i += $l 
  }
  return $i
}

function TruncateString {
  param (
      [string]$InputString,
      [int]$MaxLength
  )
  $l = Get-FieldLength -buffer $InputString 

  if ($l -le $MaxLength) {
      $pos = 0
      $offset = 0
      $TruncatedString = $InputString
      while ($pos -lt $InputString.Length) {
          $c = $InputString[$pos]
          $nbchars = [Text.Encoding]::UTF8.GetByteCount($c)
          if ($nbchars -gt 1) {
              $offset += ($nbchars -2)
          }
          # $result += $nbchars
          $pos++
      }
      while ($pos -lt $MaxLength-$offset) {
          $TruncatedString += " "
          $pos++
      }
      return $TruncatedString
  }

  $TruncatedString = $InputString.Substring(0, $MaxLength - 1) + "…"
  return $TruncatedString
}