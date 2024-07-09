add-type -path "Terminal.Gui.dll"

[Terminal.Gui.Application]::Init()

$top = [Terminal.Gui.Application]::Top

$win = New-Object Terminal.Gui.Window("MyApp")
$win.X = [Terminal.Gui.Pos]::At(0)
$win.Y = [Terminal.Gui.Pos]::At(1)
$win.Width = [Terminal.Gui.Dim]::Fill()
$win.Height = [Terminal.Gui.Dim]::Fill() - 1
$top.Add($win)

$label = New-Object Terminal.Gui.Label("Hello, World!")
$label.X = [Terminal.Gui.Pos]::Center()
$label.Y = [Terminal.Gui.Pos]::Center() - 1
$win.Add($label)

$okButton = New-Object Terminal.Gui.Button("Ok")
$okButton.X = [Terminal.Gui.Pos]::Center()
$okButton.Y = [Terminal.Gui.Pos]::Center() + 1
$okButton.add_Clicked({ 
  [Terminal.Gui.Application]::RequestStop() })
$win.Add($okButton)

[Terminal.Gui.Application]::Run()
[Terminal.Gui.Application]::Shutdown()