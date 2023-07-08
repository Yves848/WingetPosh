VERBOSE: Acquiring providers for assembly: C:\program files\powershell\7\Modules\PackageManagement\coreclr\netstandard2.0\Microsoft.PackageManagement.CoreProviders.dll
VERBOSE: Acquiring providers for assembly: C:\program files\powershell\7\Modules\PackageManagement\coreclr\netstandard2.0\Microsoft.PackageManagement.NuGetProvider.dll
VERBOSE: Acquiring providers for assembly: C:\program files\powershell\7\Modules\PackageManagement\coreclr\netstandard2.0\Microsoft.PackageManagement.ArchiverProviders.dll
VERBOSE: Acquiring providers for assembly: C:\program files\powershell\7\Modules\PackageManagement\coreclr\netstandard2.0\Microsoft.PackageManagement.MetaProvider.PowerShell.dll
VERBOSE: Cannot find provider 'PowerShellGet' under the specified path.
VERBOSE: Importing package provider 'PowerShellGet'.
VERBOSE: Suppressed Verbose Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted = 'False'; IsRegistered = 'True'.
VERBOSE: Publish Location:'https://www.powershellgallery.com/api/v2/package/'.
VERBOSE: Module 'wingetposh' was found in 'C:\Users\yvesg\Documents\PowerShell\Modules\wingetposh\0.9.0'.
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
VERBOSE: Calling C:\Users\yvesg\AppData\Local\Microsoft\WinGet\Packages\Microsoft.NuGet_Microsoft.Winget.Source_8wekyb3d8bbwe\nuget.exe pack "C:\Users\yvesg\AppData\Local\Temp\118890506\wingetposh\wingetposh.nuspec" -outputdirectory "C:\Users\yvesg\AppData\Local\Temp\118890506\wingetposh" -noninteractive
VERBOSE: C:\Users\yvesg\AppData\Local\Microsoft\WinGet\Packages\Microsoft.NuGet_Microsoft.Winget.Source_8wekyb3d8bbwe\nuget.exe output:
VERBOSE:        Tentative de génération du package à partir de 'wingetposh.nuspec'.
VERBOSE:        AVERTISSEMENT : NU5110: The script file 'wingetLocals.ps1' is outside the 'tools' folder and hence will not be executed during installation of this package. Move it into the 'tools' folder.
VERBOSE:        AVERTISSEMENT : NU5111: The script file 'wingetLocals.ps1' is not recognized by NuGet and hence will not be executed during installation of this package. Rename it to install.ps1, uninstall.ps1 or init.ps1 and place it directly under 'tools'.
VERBOSE:        AVERTISSEMENT : NU5125: The 'licenseUrl' element will be deprecated. Consider using the 'license' element instead.
VERBOSE:        Création réussie du package 'C:\Users\yvesg\AppData\Local\Temp\118890506\wingetposh\wingetposh.0.9.0-alpha1.nupkg'.
VERBOSE:
VERBOSE: finished running C:\Users\yvesg\AppData\Local\Microsoft\WinGet\Packages\Microsoft.NuGet_Microsoft.Winget.Source_8wekyb3d8bbwe\nuget.exe with exit code 0
VERBOSE: Created Nuget Package
VERBOSE: Successfully created nuget package at
Write-Error: Failed to publish module 'wingetposh': 'Cannot bind argument to parameter 'NupkgPath' because it is an empty string.'.