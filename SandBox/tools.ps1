function TruncateString {
  param (
      [string]$InputString,
      [int]$MaxLength
  )

  if ($InputString.Length -le $MaxLength) {
      return $InputString.PadRight($MaxLength, " ")
  }

  $TruncatedString = $InputString.Substring(0, $MaxLength - 3) + "…"
  return $TruncatedString
}