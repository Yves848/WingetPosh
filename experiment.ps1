if(-not (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable)){
  Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force
  }
  else {
    Write-Host "Already installed"
  }
