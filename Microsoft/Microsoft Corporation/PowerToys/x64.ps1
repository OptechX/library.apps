<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Microsoft Coporation"
$new_app.Name = "PowerToys"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://github.com/microsoft/PowerToys"
$new_app.Copyright = "Copyright (c) $((Get-Date).ToString('yyyy')) Microsoft Corporation. All rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft%20Corporation/PowerToys/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://aka.ms/powertoys-docs"
$new_app.License = "https://github.com/microsoft/PowerToys/blob/master/LICENSE"
$new_app.Tags = @("powertoys","powertoy","windows","win10","microsoft")
$new_app.Summary = "PowerToys is a set of utilities for power users to tune and streamline their Windows experience for greater productivity."
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
    $version_url = 'https://github.com/microsoft/PowerToys/releases/latest'
    $new_app.Version = (Split-Path -Path ([System.Net.WebRequest]::CreateDefault($version_url)).GetResponse().ResponseUri.OriginalString -Leaf | 
        Select-String -Pattern '\d{1,3}([\.\d{1,3}]+)' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value).TrimEnd('.')
    $new_app.Filename = "PowerToysSetup-$($new_app.Version)-x64.exe"
    $new_app.AbsoluteUri = "https://github.com/microsoft/PowerToys/releases/download/v$($new_app.Version)/$($new_app.Filename)"
    $new_app.Executable = 'exe'
    $new_app.InstallArgs = '/quiet /norestart'
    $new_app.DependsOn = @("netfoundation::netruntime","microsoft::vcredist140")
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
