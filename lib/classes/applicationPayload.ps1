<#
  Version: 2.1
  Last Update: 2022-12-10
#>

class applicationPayload {
    [System.Int16]$Id = 0
    [System.Guid]$UUID = [System.Guid]::NewGuid()
    [System.String]$UID = [string]::Empty
    [System.String]$Category = [string]::Empty
    [System.String]$Publisher = [string]::Empty
    [System.String]$Name = [string]::Empty
    [System.String]$Version = [string]::Empty
    [System.String[]]$Lcid = @()
    [System.String[]]$CpuArch = @()
    [System.String]$Homepage = [string]::Empty
    [System.String]$Copyright = [string]::Empty
    [System.String]$Icon = [string]::Empty
    [System.String]$License = [string]::Empty
    [System.Boolean]$LicenseAccept = $false
    [System.String]$Docs = [string]::Empty
    [System.String[]]$Tags = @()
    [System.String]$Summary = [string]::Empty
    [System.Boolean]$RebootRequired = $false
    [System.String]$Filename = [string]::Empty
    [System.String]$AbsoluteUri = [string]::Empty
    [System.String]$Executable = [string]::Empty
    [System.String]$InstallCmd = [string]::Empty
    [System.String]$InstallArgs = [string]::Empty
    [System.String]$DisplayName = [string]::Empty
    [System.String]$DisplayPublisher = [string]::Empty
    [System.String]$DisplayVersion = [string]::Empty
    [System.String]$Detection = [string]::Empty
    [System.String]$DetectValue = [string]::Empty
    [System.String]$DetectScript = [string]::Empty
    [System.String]$UninstallProcess = [string]::Empty
    [System.String]$UninstallCmd = [string]::Empty
    [System.String]$UninstallArgs = [string]::Empty
    [System.String]$UninstallScript = [string]::Empty
    [System.String]$TransferMethod = [string]::Empty
    [System.String]$Locale = [string]::Empty
    [System.String]$UriPath = [string]::Empty
    [System.Boolean]$Enabled = $true
    [System.String[]]$DependsOn = @()
    [System.String]$GithubUrl = [string]::Emtpy
    [System.String]$GithubFilename = [string]::Empty
}
