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
      return $InputString.PadRight($MaxLength, " ")
  }

  $TruncatedString = $InputString.Substring(0, $MaxLength - 2) + "…"
  return $TruncatedString
}