class column {
  [string]$FieldName
  [string]$Label
  [int]$Width #Percentage

  column(
    [string]$FieldName,
    [string]$Label,
    [int]$Width
  ) {
    $this.FieldName = $FieldName
    $this.Label = $Label
    $this.Width = $Width
  }
}

class package {
  [string]$Name
  [string]$Id
  [string[]]$AvailableVersions
  [string]$Source
  [bool]$IsUpdateAvailable
  [string]$InstalledVersion
  [string]$Available

  package(
    [string]$Name,
    [string]$Id,
    [string[]]$AvailableVersions,
    [string]$Source,
    [bool]$IsUpdateAvailable,
    [string]$InstalledVersion
  ) {
    $this.Name = $Name
    $this.Id = $Id
    $this.AvailableVersions = $AvailableVersions
    $this.Source = $Source
    $this.IsUpdateAvailable = $IsUpdateAvailable
    $this.InstalledVersion = $InstalledVersion
  }

  package(
    [string]$Name,
    [string]$Id,
    [string]$InstalledVersion
  ) {
    $this.Name = $Name
    $this.Id = $Id
    $this.InstalledVersion = $InstalledVersion
  }
  
  package(
    [string]$Name,
    [string]$Id,
    [string]$InstalledVersion,
    [string]$Available
  ) {
    $this.Name = $Name
    $this.Id = $Id
    $this.InstalledVersion = $InstalledVersion
    $this.Available = $Available
  }
}
