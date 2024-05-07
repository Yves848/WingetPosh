function LoadModule ($m) {
  if (Get-Module | Where-Object { $_.Name -eq $m }) {
    Write-Host "Module $m is already imported."
  }       
  else {  
    if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $m }) {
      Import-Module $m -Verbose
    }     
    else {
      if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
        Install-Module -Name $m -Force -Verbose -Scope CurrentUser
        Import-Module $m -Verbose
      }   
      else {
        Write-Host "Module $m not imported, not available and not in an online gallery, exiting."
        EXIT 1                                     
      }                                            
    }                                              
  }                                                
}                                                  
                                                   
LoadModule "Microsoft.PowerShell.ConsoleGuiTools"  
$module = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -List).ModuleBase
Add-Type -Path (Join-Path $module Terminal.Gui.dll)
                                                   
[Terminal.Gui.Application]::Init()                 
                                                   
$Window = [Terminal.Gui.Window]::new()             
$Window.Title = "Hello, World"                     
[Terminal.Gui.Application]::Top.Add($Window)       
                                                   
$Button = [Terminal.Gui.Button]::new()             
$Button.Text = "Button"                            
$Button.X = 5                                      
$Button.Y = 5                      
$Button.add_Clicked({ [Terminal.Gui.MessageBox]::Query("Clicked!", "") })
$Window.Add($Button)               
                                   
$listview = [Terminal.Gui.ListView]::new()
# $ListView.SetSource(@("Item1", "Item2", "Item3"))
$ListView.SetSource(@({            
      BackgroundColor = "Black"     
      ForegroundColor = "White"              
    }, {                                    
      BackgroundColor = "Black"              
      ForegroundColor = "White"              
    }, {                                    
      BackgroundColor = "Black"              
      ForegroundColor = "White"              
    }))
$ListView.Width = [Terminal.Gui.Dim]::Fill() 
$ListView.Height = [Terminal.Gui.Dim]::Fill()

$Window.Add($ListView)                       
                                             
$Label = [Terminal.Gui.Label]::new()         
$Label.Width = 10                            
$Label.Height = 1                            
$Label.y = 10                                
$Label.x = 10                                
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