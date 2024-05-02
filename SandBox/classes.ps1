class column {
  [string]$Name
  [int]$Width #Percentage
}

class InstalledPackage {
  [string]$Name
  [string]$Id
  [string[]]$AvailableVersions
  [string]$Source
  [bool]$IsUpdateAvailable
}