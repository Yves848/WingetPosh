# Create a temporary directory to store the project
$tempDir = [System.IO.Path]::Combine($PSScriptRoot, "TerminalGuiApp")
[System.IO.Directory]::CreateDirectory($tempDir) | Out-Null
Set-Location $tempDir

# Initialize a new .NET console project
dotnet new console -n TerminalGuiApp
Set-Location .\TerminalGuiApp

# Add Terminal.Gui package
dotnet add package Terminal.Gui

# Build the project to get the DLLs
dotnet build
