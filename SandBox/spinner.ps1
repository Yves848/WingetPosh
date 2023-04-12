function Write-TerminalProgress {
    [console]::CursorVisible = $false
    $path = "progress.json"
    $spinner = '{"aesthetic": {
		"interval": 80,
		"frames": [
			"▰▱▱▱▱▱▱",
			"▰▰▱▱▱▱▱",
			"▰▰▰▱▱▱▱",
			"▰▰▰▰▱▱▱",
			"▰▰▰▰▰▱▱",
			"▰▰▰▰▰▰▱",
			"▰▰▰▰▰▰▰",
			"▰▱▱▱▱▱▱"
		]
	}}'
    $spinners = $spinner | ConvertFrom-Json 
    $frameCount = $spinners.aesthetic.frames.count
    $frameLength = $spinners.aesthetic.frames[0].Length
    $frameInterval = $spinners.aesthetic.interval
    $e = "$([char]27)"
    1..30 | foreach -Begin { Write-Host "$($e)[s" -NoNewline } -Process { 
        $frame = $spinners.aesthetic.frames[$_ % $frameCount]
        Write-Host "$e[u$frame" -NoNewline
        Start-Sleep -Milliseconds $frameInterval
    }
    Write-Host "$e[u$($e)[$($frameLength)PDone." -NoNewline
    [console]::CursorVisible = $true
}

Write-TerminalProgress -IconSet aesthetic