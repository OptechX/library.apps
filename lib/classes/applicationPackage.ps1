<#
  Version: 2.1
  Last Update: 2023-08-03
#>

class applicationPackage {
    [System.Int16]$id = 0
    [System.String]$uid = [string]::Empty
    [System.DateTime]$lastUpdate
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
    [AllowNull()][System.String]$bannerIcon
}
