$include = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) 

. "$include\visuals.ps1"

$script:fields = Get-Content $env:USERPROFILE\.config\.wingetposh\locals.json | ConvertFrom-Json

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

  [Int16]$bufferWidth = ($Host.UI.RawUI.BufferSize.Width)
  [Int16]$lineWidth
  wingetItems([Object[]]$list) {
    $this.list = $list
    $this.items = @()
    $this.ParseList()
  }

  [void] ParseOutput() {  
    $w = $this.bufferWidth
    $w0 = $this.lineWidth
    $proportion = [System.Math]::round($W / $w0 * 100)
    $tempcols2 = @()
    $this.columns | ForEach-Object {
      $name = Get-FieldBAseNAme -name $_.Value
      [psobject]$obj = New-Object -TypeName psobject -Property @{
        Index = [System.Math]::Floor($_.Index * $proportion / 100)
        Name  = $name
      }
      $tempcols2 += $obj
    }
    $block = ""
    $blankline = "".PadRight($w, " ")
    $this.items | ForEach-Object {
      $offset = 0
      $fields = $_.data
      $bl2 = $blankline
      $tempcols2 | ForEach-Object {
        $buffer = ($fields."$($_.Name)").trim()
        $l0 = Get-FieldLength -buffer $buffer # "real" length of the buffer
        $l2 = Get-FieldLength -buffer $bl2 # "real" length of the line
        $l1 = $buffer.Length # "visual" length of the buffer
        $diff = $l0 - $l1
        $offset +=$diff # Offset to adjust the position of the buffer
        # if (($_.Index + $l1) -le $w) {
        #   $l = $l1
        # }
        # else {
        #   $l = $l2 - $_.Index
        # }
        if ($_.index -gt 0) {
          $position = ($_.Index - $offset) - 2
        }
        else {
          $position = $_.Index
        }
        #Write-Host "Position: $position, l: $l, Buffer: $buffer l0: $l0, l1: $l1, l2: $l2 Index: $($_.Index), Offset: $offset w: $w0, w2: $w, proportion: $proportion"
        if ($buffer -ne "") {
          $bl2 = ([string]$bl2).Remove($position, $l1 + $diff).Insert($position, $buffer)
        }
        if ($_.Index -gt 0) {
          # add separator
          $bl2 = ([string]$bl2).Remove($position - 1, 1).Insert($position - 1, "|")
        }
      }
      Write-Host $bl2  
      #$block = $block + $bl2
    }
    #Write-Host $block
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

function InvokeWinget {
  param(
    [string]$command
  )
  #[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8

  $stateInstall = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $stateInstall.exp = "winget $command"
  $stateInstall.SearchResult = ""
  $runspaceInstall = [runspacefactory]::CreateRunspace()
  $runspaceInstall.Open()
  $RunspaceInstall.SessionStateProxy.SetVariable("StateInstall", $StateInstall)

  $sbInstall = {
    [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $StateInstall.SearchResult = Invoke-Expression $stateInstall.exp | Out-String -Stream 
  }

  $sessionInstall = [powershell]::create()
  $null = $sessionInstall.AddScript($sbInstall)
  $sessionInstall.Runspace = $runspaceInstall
  $handleInstall = $sessionInstall.BeginInvoke()
  while (-not $handleInstall.IsCompleted) {
    
  }
  $SearchResults = $StateInstall.SearchResult
  $sessionInstall.stop()
  $runspaceInstall.Dispose() 

  return $SearchResults
}



function Invoke-Winget {
  param(
    [switch]$visual,
    $_args
  )
  $params = $_args -join " "
  $params = $params -replace "\*", "' '"
  $list = InvokeWinget -command $params

  [wingetItems]$items = [wingetItems]::new($list)
  $items.ParseOutput()
  return $items.items.data
}

$l = Invoke-Winget -visual $args


