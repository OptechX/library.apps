<# Manifest Version Info #>
$ManifestVersion='6.6-dotnet'
$LastUpdate='2023-01-28'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = ".NET Foundation"
$new_app.Name = ".NET Runtime"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://dot.net/core"
$new_app.Copyright = "Copyright (c) .NET Foundation and Contributors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/dotnet/Desktop%20Runtime/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://docs.microsoft.com/dotnet"
$new_app.License = "https://github.com/dotnet/core/blob/main/LICENSE.TXT"
$new_app.Tags = @("microsoft",".net","dotnet","dot-net","runtime","aspnet","asp.net","core")
$new_app.Summary = "This package is required to run Windows Desktop applications with the .NET Runtime."
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
    $version_url = 'https://github.com/dotnet/runtime/releases/latest'
    $x = Get-GHDotNetPackageDetails -VersionUrl $version_url `
        -VersionPattern '7\.([\d{1,}\.]+)' `
        -SubsFilename "windowsdesktop-runtime-<REPLACE>-win-x64.exe" `
        -AbsoluteUrl "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-<REPLACE>-windows-x64-installer"
    $new_app.Version = $x[0]
    $new_app.Filename = $x[1]
    $new_app.AbsoluteUri = $x[2]
    $new_app.Executable = 'exe'
    $new_app.InstallArgs = '/passive /norestart'
    $new_app.DisplayName = "Microsoft Windows Desktop Runtime - $($new_app.Version) (x64)"
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app