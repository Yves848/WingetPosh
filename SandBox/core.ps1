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

function InvokeWinget {
  param(
    [string]$command
  )
  [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  
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
    $_args
  )
  $params = $_args -join " "
  $params = $params -replace "\*", "' '"
  $Session, $runspace = Open-Spinner -label "Loading"
  $list = InvokeWinget -command $params

  [wingetItems]$items = [wingetItems]::new($list, $null)
  $result = $items.items.data
  Close-Spinner -session $Session -runspace $runspace
  return $result
}

function Get-WingetList{
  param(
    [string]$source = $null
  )
  Invoke-Winget "list"
}
function Search-WingetList{
  param(
    [string]$source = $null,
    $_args
  )
  Invoke-Winget "search $($_args)"
}

Search-WingetList -source "winget" $args