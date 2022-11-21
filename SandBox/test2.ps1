Import-Module Microsoft.PowerShell.ConsoleGuiTools 
$module = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -List).ModuleBase
Add-Type -Path (Join-Path $module Terminal.Gui.dll) 

[Terminal.Gui.Application]::Init()

$Window = [Terminal.Gui.Window]::new()
$Window.Title = "Hello, World"
[Terminal.Gui.Application]::Top.Add($Window)

$Label = [Terminal.Gui.Label]::new()
$Label.Text = "0"
$Label.Height = 1
$Label.Width = 20
$Window.Add($Label)

$Button = [Terminal.Gui.Button]::new()
$Button.X = [Terminal.Gui.Pos]::Right($Label)
$Button.Text = "Start Job"
$Button.add_Clicked({ 
    Start-ThreadJob { 
      $bgLabel = $args[0]
      1..100 | ForEach-Object {
        $Item = $_
        [Terminal.Gui.Application]::MainLoop.Invoke({ $bgLabel.Text = $Item.ToString() }) 
        Start-Sleep -Milliseconds 1000
      }
        
    } -ArgumentList $Label
  })

$Window.Add($Button)

$Button2 = [Terminal.Gui.Button]::new()
$Button2.X = [Terminal.Gui.Pos]::Right($Button)
$Button2.Text = "Do I work?"
$Button2.add_Clicked({ 
    [Terminal.Gui.MessageBox]::Query("Still workin'", "")
  })

$Window.Add($Button2)

