[CmdletBinding()]
Param(
    [Parameter(Mandatory = $False, Position = 0)]
    [int]$Height = 40,
    [Parameter(Mandatory = $False, Position = 1)]
    [int]$Width = 120
)
$console = $host.ui.rawui
$ConBuffer = $console.BufferSize
$ConSize = $console.WindowSize

$currWidth = $ConSize.Width
$currHeight = $ConSize.Height

# if height is too large, set to max allowed size
if ($Height -gt $host.UI.RawUI.MaxPhysicalWindowSize.Height) {
    $Height = $host.UI.RawUI.MaxPhysicalWindowSize.Height
}

# if width is too large, set to max allowed size
if ($Width -gt $host.UI.RawUI.MaxPhysicalWindowSize.Width) {
    $Width = $host.UI.RawUI.MaxPhysicalWindowSize.Width
}

# If the Buffer is wider than the new console setting, first reduce the width
If ($ConBuffer.Width -gt $Width ) {
    $currWidth = $Width
}
# If the Buffer is higher than the new console setting, first reduce the height
If ($ConBuffer.Height -gt $Height ) {
    $currHeight = $Height
}
# initial resizing if needed
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($currWidth, $currHeight)

# Set the Buffer
$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.size($Width, 2000)

# Now set the WindowSize
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($Width, $Height)

# Display the new sizes (Optional/for debugging)
# "Height: " + $host.ui.rawui.WindowSize.Height
# "Width:  " + $host.ui.rawui.WindowSize.width