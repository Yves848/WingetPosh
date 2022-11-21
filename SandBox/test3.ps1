Import-Module Microsoft.PowerShell.ConsoleGuiTools 
$module = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -List).ModuleBase
Add-Type -Path (Join-Path $module Terminal.Gui.dll)

[Terminal.Gui.Application]::Init()

$Window = [Terminal.Gui.Window]::new()
$Window.Title = "Hello, World"
[Terminal.Gui.Application]::Top.Add($Window)

$Button = [Terminal.Gui.Button]::new()
$Button.Text = "Button" 
$Window.Add($Button)

$Label = [Terminal.Gui.Label]::new()
$Label.Width = 10
$Label.Height = 1
$Label.x = 10
$Window.Add($Label)

$Label = [Terminal.Gui.Label]::new()
$Label.Width = 10
$Label.Height = 1
$Window.Add($Label)

$Window.add_KeyPress({ 
    param($arg) $sKey = $arg.KeyEvent.Key.ToString()

    $Label.Text = $sKey
    if ($sKey -eq 'q') {
      [Terminal.Gui.Application]::RequestStop()
    }
    
  })

[Terminal.Gui.Application]::Run()
[Terminal.Gui.Application]::Shutdown()
