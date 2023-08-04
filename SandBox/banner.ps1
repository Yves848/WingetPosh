Clear-Host
$params = @{
  Message = "   Wingetposh   "
  Font = "banner3-D"
}
Write-Figlet @params
Write-Figlet -Message "  0.9.8-alpha  " -Font bigchief  -Background darkred -ColorChars yellow