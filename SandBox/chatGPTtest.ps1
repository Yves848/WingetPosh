# Define the command to execute
$command = "powershell"
#$arguments = "example.com"

# Create a new process start info object
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.FileName = $command
$processStartInfo.Arguments = $arguments
$processStartInfo.RedirectStandardOutput = $true
$processStartInfo.RedirectStandardError = $true
$processStartInfo.RedirectStandardInput = $true
$processStartInfo.UseShellExecute = $false
$processStartInfo.CreateNoWindow = $true
$processStartInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
$processStartInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

# Create a new process object
$process = New-Object System.Diagnostics.Process 
$process.StartInfo = $processStartInfo 

# Register an event handler for the output data received event
Register-ObjectEvent -InputObject $process -EventName "OutputDataReceived" -Action {
    if (-not [string]::IsNullOrEmpty($eventArgs.Data)) {
       #Write-Host "# $($eventArgs.Data)"
    }
}

# Register an event handler for the error data received event
Register-ObjectEvent -InputObject $process -EventName "ErrorDataReceived" -Action {
    if (-not [string]::IsNullOrEmpty($eventArgs.Data)) {
        Write-Error $eventArgs.Data
    }
}

# Start the process
if (-not $process.Start()) {
    throw "Failed to start process"
}

# Begin asynchronous reading of output and error streams
$process.BeginOutputReadLine()
$process.BeginErrorReadLine()

# Send input to the process asynchronously
$inputData = @"
Write-Host "Hello, World!"
winget search code
exit 0`n
"@
$process.StandardInput.WriteAsync($inputData)

# Wait asynchronously for the process to exit
$waitHandle = $process.WaitForExitAsync()

# Do other work asynchronously while waiting for the process to exit
while (-not $waitHandle.IsCompleted) {
    # Do something asynchronously
}

# Close the process
$process.Close()
