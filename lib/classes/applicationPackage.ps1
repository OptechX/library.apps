<#
  Version: 2.0
  Last Update: 2022-12-10
#>

class applicationPackage {
    [System.Int16]$id = 0
    [System.Guid]$uuid = [System.Guid]::NewGuid()
    [System.String]$uid = [string]::Empty
    [System.String]$lastUpdate = [string]::Emtpy
    [System.String]$applicationCategory = [string]::Empty
    [System.String]$publisher = [string]::Empty
    [System.String]$name = [string]::Empty
    [System.String]$version = [string]::Empty
    [System.String]$copyright = [string]::Empty
    [System.Boolean]$licenseAcceptRequired = $false
    [System.String[]]$lcid = @()
    [System.String[]]$cpuArch = @()
    [System.String]$homepage = [string]::Empty
    [System.String]$icon = [string]::Empty
    [System.String]$docs = [string]::Empty
    [System.String]$license = [string]::Empty
    [System.String[]]$tags = @()
    [System.String]$summary = [string]::Empty
    [System.Boolean]$enabled = $true
}
