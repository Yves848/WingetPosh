    $widths = @(32, 32, 14, 14  , 8)
    $widths2 = @(25, 25, 21, 21, 8)

    $tw = $host.UI.RawUI.BufferSize.Width -5
    
    $line = ""
    $widths | ForEach-Object {
      $colw = [math]::round($tw / 100 * $_)
      $line = $line, "".PadRight($colw -1 ,"#")," " -join ""
    }

    $line