<# Manifest Version Info #>
$ManifestVersion='6.6-dotnet'
$LastUpdate='2023-01-28'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = ".NET Foundation"
$new_app.Name = ".NET 6 SDK"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://dot.net/core"
$new_app.Copyright = "Copyright (c) .NET Foundation and Contributors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/dotnet-6.0/SDK/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://docs.microsoft.com/dotnet"
$new_app.License = "https://raw.githubusercontent.com/dotnet/sdk/main/LICENSE.TXT"
$new_app.Tags = @("microsoft",".net","dotnet","dot-net","runtime","aspnet","asp.net","core","net6","dotnet6","sdk")
$new_app.Summary = ".NET Software Development Kit to build apps."
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
    $version_url = 'https://dotnet.microsoft.com/en-us/download/dotnet/6.0'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = $download_page.Content |
        Select-String -Pattern '<h3.*>SDK\s6\.([\d{1,}\.]+)<\/h3>' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value | 
        Select-String -Pattern '6\.([\d{1,}\.]+)' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.Filename = "dotnet-sdk-$($new_app.Version)-win-x64.exe"
    $rgx = "<a href=`"https:\/\/..`*dotnet-sdk-$($new_app.Version)-win-x64.exe"
    $new_app.AbsoluteUri = Invoke-WebRequest -Uri "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-$($new_app.Version)-windows-x64-installer" | 
        Select-Object -ExpandProperty Links | 
        Where-Object -FilterScript {$_.outerHtml -match $rgx} |
        Select-Object -ExpandProperty outerHtml | 
        Select-String -Pattern "https:\/\/..`*dotnet-sdk-$($new_app.Version)-win-x64.exe" |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $new_app.Executable = 'exe'
    $new_app.InstallArgs = '/passive /norestart'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
