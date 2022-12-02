[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$pskey = Get-Content .\apikey.txt
Publish-Module -Name 'wingetposh' -NuGetApiKey $pskey -Verbose -RequiredVersion '0.5.2' 