<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "PowerShell"
$new_app.Name = "OpenSSH"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://github.com/PowerShell/Win32-OpenSSH/wiki"
$new_app.Copyright = "Copyright (c) 1995-$((Get-Date).ToString('yyyy')) various contributors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/PowerShell/Win32-OpenSSH/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://github.com/PowerShell/Win32-OpenSSH/wiki"
$new_app.License = "https://raw.githubusercontent.com/PowerShell/openssh-portable/latestw_all/LICENCE"
$new_app.Tags = @("powershell","ssh","ssh-agent","openssh")
$new_app.Summary = "OpenSSH is a complete implementation of the SSH protocol (version 2) for secure remote login, command execution and file transfer."
$new_app.RebootRequired = $false


<# Get icon.png if not already obtained #>
$icon_path_svg = "${PSScriptRoot}/icon.svg"
$icon_path_png = "${PSScriptRoot}/icon.png"
$icon_path_jpg = "${PSScriptRoot}/icon.jpg"
$icon_path_jpeg = "${PSScriptRoot}/icon.jpeg"
if (-not(
    (Test-Path -Path $icon_path_svg) -or `
    (Test-Path -Path $icon_path_png) -or `
    (Test-Path -Path $icon_path_jpg) -or `
    (Test-Path -Path $icon_path_jpeg)
))
{
    $icon_path = Split-Path -Path $new_app.Icon -Leaf
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
}
else
{

}


<# Get app data #>
if ($new_app.GithubUrl -ne [string]::Empty)
{
    $app_data = Get-GitHubReleaseDownload -GithubUrl $new_app.GithubUrl -FileName $new_app.GithubFilename
    $new_app.Version = $app_data[0]
    $new_app.Filename = $app_data[1]
}
else
{
    $version_url = 'https://github.com/PowerShell/Win32-OpenSSH/releases/latest'
    $version_data = ([System.Net.WebRequest]::CreateDefault($version_url)).GetResponse()
    $new_app.Version = Split-Path -Path $version_data.ResponseUri.OriginalString -Leaf | 
        Select-String -Pattern '\d{1,}.*' | 
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $repo_name = "PowerShell/Win32-OpenSSH"
    $asset_pattern = "OpenSSH*Win64-*.msi"
    $releases_uri = "https://api.github.com/repos/${repo_name}/releases/latest"
    $asset = (Invoke-WebRequest $releases_uri | ConvertFrom-Json).assets | Where-Object name -like $asset_pattern
    $download_uri = $asset.browser_download_url
    $new_app.Filename = Split-Path -Path $download_uri -Leaf
    $new_app.AbsoluteUri = $download_uri
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
