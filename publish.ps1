[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$pskey = Get-Content ~\.config\.private\apikey.txt
Publish-Module -Name 'wingetposh' -NuGetApiKey $pskey -Verbose -RequiredVersion '0.6.6' 