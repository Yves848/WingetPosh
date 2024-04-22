$include = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) 

. "$include\visuals.ps1"

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

  [Int16]$bufferWidth = $Host.UI.RawUI.BufferSize.Width
  [Int16]$lineWidth
  wingetItems([Object[]]$list) {
    $this.list = $list
    $this.items = @()
    $this.ParseList()
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
    $line = $line.PadRight($this.lineWidth, " ")
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
              $insertat += ($nbchars - 1)
            }
            else {
              $insertat = $_.Index             
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
      $fields.add($this.columns[$Idx].Value, $_.Trim())
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

function ParseOutput {
  param (
    [Object[]]$list
  )  
  $list
}

function Invoke-Winget {
  param(
    [switch]$visual,
    $_args
  )
  $list = InvokeWinget -command $_args

  [wingetItems]$items = [wingetItems]::new($list)
  return $items.items.data
}

Invoke-Winget -visual $args

