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

function Get-ProportionalLength {
  param(
    [int]$MaxLength
  )
  $w = $Host.UI.RawUI.BufferSize.Width -6
  return [math]::Floor($w / 100 * $MaxLength)
}

function TruncateString {
  param (
    [string]$InputString,
    [int]$MaxLength
  )
  $l = Get-FieldLength -buffer $InputString 
  $w = $Host.UI.RawUI.BufferSize.Width -6
  $Maxp = [math]::Floor($w / 100 * $MaxLength)
  if ($l -le $Maxp) {
    $pos = 0
    $offset = 0
    $TruncatedString = $InputString
    while ($pos -lt $InputString.Length) {
      $c = $InputString[$pos]
      $nbchars = [Text.Encoding]::UTF8.GetByteCount($c)
      if ($nbchars -gt 1) {
        $offset += ($nbchars - 2)
      }
      # $result += $nbchars
      $pos++
    }
    while ($pos -lt $Maxp - $offset) {
      $TruncatedString += " "
      $pos++
    }
    return $TruncatedString
  }

  $TruncatedString = $InputString.Substring(0, $MaxP - 1) + "…"
  return $TruncatedString
}