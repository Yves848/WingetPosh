[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Publish-Module -Name 'wingetposh' -NuGetApiKey $pskey -Verbose -RequiredVersion '0.2.1' 