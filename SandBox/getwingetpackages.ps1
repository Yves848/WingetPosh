$packages = Get-WingetPackage -Source winget
# $packages
# Remove-Item -Path .\test.csv -ErrorAction SilentlyContinue -Force
# New-Item -Path .\test.csv -ItemType File -Force | Out-Null
$csv = "Name,Id,Version,Available,Source"
$widths = @(35,35,10,5,15)
$w = $Host.UI.RawUI.BufferSize.Width
$widths_relatives = @()
$widths | ForEach-Object {
  $widths_relatives += [Math]::Floor(($_ / 100) * $w)
}
$updates = @(" ✔️ "," ♻️ ")
# "Name,Id,Version,Available,Source" | Add-Content -Path .\test.csv
$packages | Where-Object { $_.Source -like "winget" } | ForEach-Object {
  if ($_.IsUpdateAvailable) {
    $IsUpdateAvailable = $updates[0]
  }
  else {
    $IsUpdateAvailable = $updates[1]
  }
  $line = "$($_.Name.PadRight($widths_relatives[0]," "))$($_.Id.PadRight($widths_relatives[1]," "))$($_.InstalledVersion.PadRight($widths_relatives[2]," "))$($IsUpdateAvailable.PadRight($widths_relatives[3]," "))$($_.Source.PadRight($widths_relatives[4]," "))"
  # Add-Content .\test.csv -Value $line
  $csv += "`n$line"
}
$csv