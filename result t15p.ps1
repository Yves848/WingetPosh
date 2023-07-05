VERBOSE: Suppressed Verbose Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Publish Location:'https://www.powershellgallery.com/api/v2/package/'.
VERBOSE: Module 'wingetposh' was found in 'C:\Users\ygodart\Documents\PowerShell\Modules\wingetposh\0.9.0'.
VERBOSE: Suppressed Verbose Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Using the provider 'PowerShellGet' for searching packages.
VERBOSE: Using the specified source names : 'PSGallery'.
VERBOSE: Getting the provider object for the PackageManagement Provider 'NuGet'.
VERBOSE: The specified Location is 'https://www.powershellgallery.com/api/v2/items/psscript' and PackageManagementProvider is 'NuGet'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/items/psscript/FindPackagesById()?id='wingetposh'' for ''.
VERBOSE: Total package yield:'0' for the specified package 'wingetposh'.
VERBOSE: Suppressed Verbose Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Using the provider 'PowerShellGet' for searching packages.
VERBOSE: Using the specified source names : 'PSGallery'.
VERBOSE: Getting the provider object for the PackageManagement Provider 'NuGet'.
VERBOSE: The specified Location is 'https://www.powershellgallery.com/api/v2' and PackageManagementProvider is 'NuGet'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='wingetposh'' for ''.
VERBOSE: Total package yield:'1' for the specified package 'wingetposh'.
VERBOSE: Performing the operation "Publish-Module" on target "Version '0.9.0' of module 'wingetposh'".
VERBOSE: Calling Publish-PSArtifactUtility
VERBOSE: Calling New-NuspecFile
VERBOSE: Calling New-NugetPackage
VERBOSE: Calling C:\Users\ygodart\AppData\Local\Microsoft\WinGet\Links\nuget.exe pack "C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh\wingetposh.nuspec" -outputdirectory "C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh" -noninteractive
VERBOSE: C:\Users\ygodart\AppData\Local\Microsoft\WinGet\Links\nuget.exe output:
VERBOSE:        Tentative de génération du package à partir de 'wingetposh.nuspec'.
VERBOSE:        AVERTISSEMENT : NU5110: The script file 'wingetLocals.ps1' is outside the 'tools' folder and hence will not be executed during installation of this package. Move it into the 'tools' folder.
VERBOSE:        AVERTISSEMENT : NU5111: The script file 'wingetLocals.ps1' is not recognized by NuGet and hence will not be executed during installation of this package. Rename it to install.ps1, uninstall.ps1 or init.ps1 and place it directly under 'tools'.
VERBOSE:        AVERTISSEMENT : NU5125: The 'licenseUrl' element will be deprecated. Consider using the 'license' element instead.
VERBOSE:        Successfully created package 'C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh\wingetposh.0.9.0-alpha.nupkg'.
VERBOSE:
VERBOSE: finished running C:\Users\ygodart\AppData\Local\Microsoft\WinGet\Links\nuget.exe with exit code 0
VERBOSE: Created Nuget Package C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh\wingetposh.0.9.0-alpha.nupkg
VERBOSE: Successfully created nuget package at C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh\wingetposh.0.9.0-alpha.nupkg
VERBOSE: Calling Publish-NugetPackage -NupkgPath C:\Users\ygodart\AppData\Local\Temp\570170038\wingetposh\wingetposh.0.9.0-alpha.nupkg -Destination https://www.powershellgallery.com/api/v2/package/ -NugetExePath C:\Users\ygodart\AppData\Local\Microsoft\WinGet\Links\nuget.exe -UseDotnetCli:False
VERBOSE: Pushing wingetposh.0.9.0-alpha.nupkg to 'https://www.powershellgallery.com/api/v2/package/'...
  PUT https://www.powershellgallery.com/api/v2/package/
AVERTISSEMENT : <licenseUrl> element will be deprecated, please consider switching to specifying the license in the package. Learn more: https://aka.ms/deprecateLicenseUrl.
  Created https://www.powershellgallery.com/api/v2/package/ 3009ms
Your package was pushed.

VERBOSE: Successfully published module 'wingetposh' to the module publish location 'https://www.powershellgallery.com/api/v2/package/'. Please allow few minutes for 'wingetposh' to show up in the search results.