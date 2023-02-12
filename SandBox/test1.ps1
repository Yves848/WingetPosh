# Create a synchronized hashtable
$StateData = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())

$Stop = $False
# Add some data to the hashtable (creates new property)
$StateData.HasData = $False

# Set up our runspace
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.Open()
# Passing in the hashtable
$Runspace.SessionStateProxy.SetVariable("StateData",$StateData)

# Capture process data in a runspace
$Sb = {
    while($True) {
        # We pause here for 2 seconds between captures, how do we keep the UI available?
        Start-Sleep -Seconds 2 

        # Get new data
        $StateData.Data = Get-Process | Sort-Object -Property 'CPU' -Descending `
                                      | Select-Object -First 10 `
                                      | Out-String

        # Alert outer process that new data has arrived
        $StateData.HasData = $True
    }
}
$Session = [PowerShell]::Create()
$Session.Runspace = $Runspace
$null = $Session.AddScript($Sb)
$Handle = $Session.BeginInvoke()

$Stop = $False
Clear-Host
while(-not $Stop) {
    [Console]::CursorVisible = $False
    # Reset the cursor to the top left corner
    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    # Draw spaces over the data that is already there (based on the number of 
    # lines displayed * the width of the window)
    $blanks = ' '.PadRight(12 * ($host.UI.RawUI.WindowSize.Width))
    [Console]::Write($blanks)
    # Reset the cursor again
    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    # Finally send the output to the screen
    [Console]::Write($StateData.Data)
    [Console]::CursorVisible = $True
    if ( -not $StateData.Data ) {
        Write-Host "Waiting for data..."
    }
    Write-Host "Press 'q' to quit" -NoNewLine
   
    while(-not $StateData.HasData) {
        if($global:Host.UI.RawUI.KeyAvailable) {
                # THIS BLOCKS!
                $key = $($global:Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")).character
                if ( $key -eq 'q' ) {
                    $Stop = $True
                    # Clean up!
                    $Session.Stop()
                    $Runspace.Dispose()
                }
                break
        }
        Start-Sleep -Milliseconds 10
    }
    # Reset the "HasData" flag so we can wait for more data
    $StateData.HasData = $False
}
