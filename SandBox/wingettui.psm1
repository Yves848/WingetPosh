$include = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) 

. "$include\visuals.ps1"
. "$include\classes.ps1"
. "$include\tools.ps1"

$script:fields = Get-Content $env:USERPROFILE\.config\.wingetposh\locals.json | ConvertFrom-Json

[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$script:BORDER_FOREGROUND = "#1e2030"
$script:TEXT_FOREGROUND = "#cad3f5"
$env:GUM_CHOOSE_SELECTED_BACKGROUND = "22"
$env:GUM_CHOOSE_SELECTED_FOREGROUND = "#ffffff"

$baseFields = @{
  'SearchName'        = 'Name'
  'SearchID'          = 'Id'
  'SearchVersion'     = 'Version'
  'AvailableHeader'   = 'Available'
  'SearchSource'      = 'Source'
  'ShowVersion'       = 'Version'
  'AvailableUpgrades' = 'upgrades available.'
  "SearchMatch"       = "Moniker"
  "SourceListName"    = "Name"
  "SourceListArg"     = "Argument"
}

$sources = @{
  "winget" = "winget"
  "scoop"  = "scoop"
}

function Get-FieldBAseNAme {
  param(
    [string]$name
  )
  $base = $script:fields.psobject.Properties | Where-Object { $_.Value -eq $name }
  if ($base.count -eq 1) {
    $BaseName = $base.Name
  }
  else {
    $BaseName = ($base | Where-Object { $_.Name.StartsWith("Search") }).Name
  }
  
  return $baseFields[$BaseName]
}

function Get-FieldLength {
  param(
    [string]$buffer
  )
  $i = 0
  $buffer.ToCharArray() | ForEach-Object {
    $l = [Text.Encoding]::UTF8.GetByteCount($_)
    if ($l -ge 2) {
      $l = $l - 1
    }  
    $i += $l 
  }
  return $i
}

enum lineAction {
  None = 0
  Install = 1
  Remove = 2
  Update = 3
}

class wingetItems {
  [System.Text.RegularExpressions.Match[]]$columns
  [item[]]$items
  [Object[]]$list
  [string]$source

  [Int16]$bufferWidth = ($Host.UI.RawUI.BufferSize.Width)
  [Int16]$lineWidth
  wingetItems(
    [Object[]]$list,
    [string]$source = $null
  ) {
    $this.list = $list
    $this.source = $source
    $this.items = @()
    $this.ParseList()
  }

  [void] ParseOutput() {  
    $w = $this.bufferWidth
    $w0 = $this.lineWidth 
    $proportion = [System.Math]::Floor($W / $w0 * 100)
    $tempcols2 = @()
    $this.columns | ForEach-Object {
      $name = Get-FieldBAseNAme -name $_.Value
      [psobject]$obj = New-Object -TypeName psobject -Property @{
        Index = [System.Math]::Floor($_.Index * $proportion / 100)
        Name  = $name
      }
      $tempcols2 += $obj
    }
    $blankline = "".PadRight($w, " ")
    $this.items | ForEach-Object {
      $offset = 0
      $fields = $_.data
      $bl2 = $blankline
      $tempcols2 | ForEach-Object {
        $buffer = ($fields."$($_.Name)").trim()
        $l0 = Get-FieldLength -buffer $buffer # "real" length of the buffer
        $l1 = $buffer.Length # "visual" length of the buffer
        $diff = $l0 - $l1
        $offset += $diff # Offset to adjust the position of the buffer
        if ($_.index -gt 0) {
          $position = ($_.Index - $offset) - 1
        }
        else {
          $position = $_.Index
        }
        if ($buffer -ne "") {
          try {
            if (($position + ($l1 + $diff)) -gt $w) {
              $sub = ($position + $l1 + $diff) - $w
              $buffer = $buffer.Substring(0, $l1 - $sub)
              $l1 = $buffer.Length
            }
            $bl2 = ([string]$bl2).Remove($position, $l1 + $diff).Insert($position, $buffer)  
          }
          catch {
            <#Do this if a terminating exception happens#>
            Write-Host "Buffer: $buffer position:$position l1:$l1 diff:$diff $($bl2.Length)"
          }
          
        }
        if ($_.Index -gt 0) {
          # add separator
          $bl2 = ([string]$bl2).Remove($position - 1, 1).Insert($position - 1, "|")
        }
      }
      Write-Host $bl2  
    }
  }

  [void] ParseList() {
    $partialKey = "---"
    $index = 0
    $data = $false
    $this.list | ForEach-Object {
      if ($_ -match $partialKey) {
        # Found the columns headers
        $index = $this.list.IndexOf($_) - 1
        $this.GetColumnHeaders($this.list[$index])
        $this.lineWidth = ([string]$this.list[$index]).Length
        $data = $true
      }
      else {
        if ($data) {
          # parse the real data
          $this.ParseData($_)  
        }  
      }
    } 
  }

  [void] ParseData(
    $line
  ) {
    $line = $line.PadRight($this.lineWidth, " ").Replace("|", " ").Replace('…', ' ')
    $i = 0
    $pos = 0
    $insertat = 0
    $offset = 0
    $this.columns | ForEach-Object {
      if ($_.Index -gt 0) {
        while ($pos -lt $_.Index) {
          $nbchars = [Text.Encoding]::UTF8.GetByteCount($line[$i])
          $pos = $pos + $nbchars
          if ($nbchars -gt 1) {
            if ($pos -lt $_.Index) {
              $insertat += 2
            }
            else {
              $insertat += $nbchars
            }
          }
          else {
            $insertat++ 
          }
          $i++
        }
        $line = ($line).Insert($insertat + $offset, "|") 
        $offset++
      }
    }
    
    $fields = [ordered]@{}
    $idx = 0
    
    $line.Split("|") | ForEach-Object {
      $base = $script:fields.psobject.Properties | Where-Object { $_.Value -eq $this.columns[$Idx].Value }
      if ($base.count -eq 1) {
        $BaseName = $base.Name
      }
      else {
        $BaseName = ($base | Where-Object { $_.Name.StartsWith("Search") }).Name
      }
      $fields.add($baseFields[$BaseName], $_.Trim())
      $idx++
    }
    
    [item]$item = [item]::new()
    $item.data = New-Object -TypeName PSObject -Property $fields
    $this.items += $item
  }

  GetColumnHeaders(
    [string]$header
  ) {
    $this.columns = ($header | Select-String -Pattern "(?:\S+)" -AllMatches).Matches
  }
}

class displayOptions {
  [System.Boolean]$selected
  [System.Boolean]$checked
  [lineAction]$action
}
class Item {
  [displayOptions]$options
  [PSCustomObject]$data
}

function Get-WGPackage { 
  param(
    [string]$source = $null,
    [switch]$interactive = $false,
    [switch]$update = $false,
    [switch]$uninstall = $false
  )
  $GetParams = @{}
  if ($source) {
    $GetParams.Add("source", $source)
  }
  
  if ($update -and $uninstall) {
    
    return $null
  }

  $Session, $runspace = Open-Spinner -label "Loading Packages List" -type "Dots"
  
  $packages = Get-WinGetPackage | Where-Object { $_.Source -eq $source }

  Close-Spinner -session $Session -runspace $runspace
  if ($interactive) {
    [column[]]$cols = @()
    $cols += [column]::new("Name", "Name", 40)
    $cols += [column]::new("Id", "Id", 40)
    $cols += [column]::new("InstalledVersion", "Version", 20)
    [package[]]$InstalledPackages = @()
    $packages | ForEach-Object {
      $InstalledPackages += [package]::new($_.Name, $_.Id, $_.AvailableVersions[0])
    }
    $choices = makeLines -columns $cols -items $InstalledPackages
    $width = $Host.UI.RawUI.BufferSize.Width - 2
    $height = $Host.UI.RawUI.BufferSize.Height - 7
    $title = makeTitle -title "List of Installed Packages" -width $width
    $header = makeHeader -columns $cols
    gum style --border "rounded" --width $width "$title`n$header" --border-foreground $($Theme["purple"])
    $c = $choices | gum filter  --no-limit  --height $height --indicator "👉 " --placeholder "Search in the list" --prompt.foreground $($Theme["yellow"]) --prompt "🔎 "
    $packages = @()
    if ($c) {
      $c | ForEach-Object {
        $index = ($choices -split '\n').IndexOf($_)
        $packages += $InstalledPackages[$index]
      }
    }
    # Clear-Host
  }
  return $packages
}

function Update-WGPackage { 
  param(
    [string]$source = $null,
    [switch]$interactive = $false
  )
  $GetParams = @{}
  if ($source) {
    $GetParams.Add("source", $source)
  }
  
  $Session, $runspace = Open-Spinner -label "Loading Packages List" -type "Dots"
  
  $packages = Get-WinGetPackage | Where-Object { $_.IsUpdateAvailable }

  Close-Spinner -session $Session -runspace $runspace
  if ($interactive) {
    [column[]]$cols = @()
    $cols += [column]::new("Name", "Name", 35)
    $cols += [column]::new("Id", "Id", 35)
    $cols += [column]::new("InstalledVersion", "Version", 15)
    $cols += [column]::new("Available", "Available", 15)
    [package[]]$InstalledPackages = @()
    $packages | ForEach-Object {
      $InstalledPackages += [package]::new($_.Name, $_.Id, $_.InstalledVersion, $_.AvailableVersions[0])
    }
    $choices = makeLines -columns $cols -items $InstalledPackages
    $height = $Host.UI.RawUI.BufferSize.Height - 6
    $width = $Host.UI.RawUI.BufferSize.Width - 2
    $title = makeTitle -title "Choose a package to update" -width $width
    $header = makeHeader -columns $cols
    gum style --border "rounded" --width $width "$title`n$header" --border-foreground $($Theme["purple"])
    $c = $choices | gum choose  --selected-prefix "✔️" --no-limit --cursor "👉 " --height $height
    $packages = @()
    if ($c) {
      $c | ForEach-Object {
        $index = ($choices -split '\n').IndexOf($_)
        $packages += $InstalledPackages[$index]
      }
    }
    # Clear-Host
  }
  return $packages
}

function Find-WGPackage {
  param(
    [string]$query = $null,
    [string]$source = $null,
    [switch]$interactive = $false
  )
  
  $SearchParams = @{}
  $Y = $host.ui.rawui.CursorPosition.Y 
  $buffer = gum style "Enter search query" --border "rounded" --width ($Host.UI.RawUI.BufferSize.Width - 2)
  $buffer | ForEach-Object {
    [System.Console]::write($_)
  }
  
  if (-not $query) {
    $query = gum input --placeholder "Search for a package" 
    $SearchParams.Add("query", $query)
  }

  if ($source) {
    $SearchParams.Add("source", $source)
  }
  else {
    $source = gum style "every sources" --foreground "#FF0000"
  }
  if ($query) {
    $title = gum style $query --foreground "#00FF00" --bold
    $Session, $runspace = Open-Spinner -label "Searching for $title in $source" -type "Dots"
    $queries = $query.Split(",")
    $packages = @()
    $queries | ForEach-Object {
      $SearchParams["query"] = [string]$_.Trim()
      $packs = Find-WinGetPackage @SearchParams
      $packs | ForEach-Object {
        $packages += $_
      }
    }
    [System.Console]::setcursorposition(0, $Y)
  }
  else {
    [System.Console]::setcursorposition(0, $Y)
    $buffer = gum style "No query specified" --border "rounded" --width ($Host.UI.RawUI.BufferSize.Width - 2) --foreground "#FF0000"
    $buffer | ForEach-Object {
      [System.Console]::write($_)
    }
    return $null
  }
  if ($packages -and $interactive) {
    # Clear-Host
    [column[]]$cols = @()
    $cols += [column]::new("Name", "Name", 40)
    $cols += [column]::new("Id", "Id", 40)
    $cols += [column]::new("InstalledVersion", "Version", 20)
    [package[]]$InstalledPackages = @()
    $packages | ForEach-Object {
      $InstalledPackages += [package]::new($_.Name, $_.Id, $_.Version)
    }
    $choices = makeLines -columns $cols -items $InstalledPackages
    Close-Spinner -session $Session -runspace $runspace
    $width = $Host.UI.RawUI.BufferSize.Width - 2
    $height = $Host.UI.RawUI.BufferSize.Height - 6
    [System.Console]::setcursorposition(0, $Y)
    $title = makeTitle -title "Choose Packages to Install" -width $width
    $header = makeHeader -columns $cols
    gum style --border "rounded" --width $width "$title`n$header" --border-foreground $($Theme["purple"]) 
    # $c = $choices | gum choose  --selected-prefix "✔️" --no-limit --cursor "👉 " --height $height 
    $c = $choices | gum filter  --no-limit  --height $height --indicator "👉 " --placeholder "Search in the list" --prompt.foreground $($Theme["yellow"]) --prompt "🔎 "
    $packages = @()
    if ($c) {
      $c | ForEach-Object {
        $index = ($choices -split '\n').IndexOf($_)
        $packages += $InstalledPackages[$index]
      }
    }
    Clear-Host
  }
  else {
    Close-Spinner -session $Session -runspace $runspace
  }
  return $packages
}

function isGumInstalled {
  $gum = Get-Command -CommandType Application -Name gum -ErrorAction SilentlyContinue
  if ($gum) {
    return $true
  }
  return $false
}

function installGum {
  $command = "winget install --id charmbracelet.gum"
  Invoke-Expression $command | Out-Null
  $env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}