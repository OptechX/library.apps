<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"

<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Apple Inc."
$new_app.Name = "iTunes"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.apple.com/itunes/"
$new_app.Copyright = "Apple Inc. All rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Apple%20Inc./iTunes/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://support.apple.com/itunes"
$new_app.License = "http://www.apple.com/legal/terms/site.html"
$new_app.Tags = @("apple","itunes","ipod","ipad","iphone")
$new_app.Summary = "iTunes is a free app that lets you organize and enjoy the music, movies, and TV shows."
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
    $version_url = 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-packages/master/automatic/itunes/info'
    $download_url = 'https://www.apple.com/itunes/download/win64'
    $new_app.Version = Invoke-WebRequest -Uri $version_url  | 
        Select-Object -ExpandProperty Content | 
        Select-String -Pattern '(?<=\|).*$' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $download_page = ([System.Net.WebRequest]::CreateDefault($download_url)).GetResponse()
    $new_app.Filename = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf
    $new_app.AbsoluteUri = $download_page.ResponseUri.OriginalString
    $new_app.Executable = 'iTunes'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app