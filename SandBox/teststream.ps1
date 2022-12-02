[Console]::OutputEncoding = [System.Text.Encoding]::UTF8 
[string[]]$WingetArgs = @("list")
#$WingetArgs += "--source", "winget"

[string[]]       $IndexTitles = @("Name", "Id", "Version", "Available", "Source")

[string[]]$WinGetSourceListRaw = & "WinGet" $WingetArgs | out-string # -stream | foreach-object{$_ -replace ("$([char]915)$([char]199)$([char]170)", "$([char]199)")}

