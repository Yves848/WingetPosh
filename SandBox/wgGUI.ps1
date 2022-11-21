Add-Type -AssemblyName PresentationFramework

Import-Module ~/CLRCLI.dll

function wgGUI {
    $xamlFile = "C:\Users\yvesg\git\WingetPosh\GUI\WingetGUI\MainWindow.xaml"
    $inputXML = Get-Content $xamlFile -Raw
    $inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
    [XML]$XAML = $inputXML

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    try {
        $window = [Windows.Markup.XamlReader]::Load( $reader )
    }
    catch {
        Write-Warning $_.Exception
        throw
    }
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        #"trying item $($_.Name)"
        try {
            Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
        }
        catch {
            throw
        }
    }

    Get-Variable var_*

    $ids = wgUpgradable

    foreach ($id in $ids) {
        $var_listBox.Items.add($id.id) | Out-Null
    }


    
    $Null = $window.ShowDialog()
}

function drawBox {
    $Root = [CLRCLI.Widgets.RootWindow]::new()
    $Dialog = [CLRCLI.Widgets.Dialog]::new($Root)

    $Dialog.Text = "Upgradable Packages List"
    $Dialog.Width = $Host.UI.RawUI.WindowSize.Width - 8
    $Dialog.Height = $Host.UI.RawUI.WindowSize.Height - 8
    $Dialog.Top = 4
    $Dialog.Left = 4
    $Dialog.Border = [CLRCLI.BorderStyle]::Thick

    $Root.run()

    Clear-Host
}