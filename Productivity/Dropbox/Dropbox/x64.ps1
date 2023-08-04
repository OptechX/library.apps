<# Manifest Version Info #>
$ManifestVersion='6.8-Productivity'
$LastUpdate='2023-08-04'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"

<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Dropbox"
$new_app.Name = "Dropbox"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.dropbox.com/"
$new_app.Copyright = "Copyright (c) $((Get-Date).ToString('yyyy')) Dropbox, Inc."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Dropbox/Dropbox/icon.svg".Replace(" ","%20")
$new_app.LicenseAccept = $true
$new_app.Docs = "https://www.dropbox.com/help"
$new_app.License = "https://www.dropbox.com/terms"
$new_app.Tags = @("dropbox","file","fileshare","share","sharing")
$new_app.Summary = "Dropbox is a free service that lets you bring all your photos, docs, and videos anywhere."
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
    $json_uri = 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-packages/master/automatic/dropbox/dropbox.json'
    $json_corrected = [System.Text.Encoding]::UTF8.GetString(
        [System.Text.Encoding]::GetEncoding(28591).GetBytes(
            (Invoke-WebRequest -Uri $json_uri -Method Get).Content))
    $new_app.Version = ($json_corrected -replace '[^a-zA-Z0-9\.:,{}"]' | ConvertFrom-Json).stable
    $download_uri = "https://www.dropbox.com/download?build=$(($json_corrected -replace '[^a-zA-Z0-9\.:,{}"]' | ConvertFrom-Json).stable)&plat=win&type=full&arch=x64"
    $new_app.Filename = (Split-Path -Path ([System.Net.WebRequest]::CreateDefault($download_uri)).GetResponse().ResponseUri.OriginalString -Leaf).Replace('%20',' ')
    $new_app.AbsoluteUri = ([System.Net.WebRequest]::CreateDefault($download_uri)).GetResponse().ResponseUri.OriginalString
    $new_app.Executable = 'nullsoft'
}

<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
$new_pkg = [applicationPackage]::new()
$new_pkg.uid = "$($new_app.Publisher -replace "[^a-zA-Z0-9]")::$($new_app.Name -replace "[^a-zA-Z0-9]")"
$new_pkg.lastUpdate = Get-Date
$new_pkg.applicationCategory = $new_app.Category
$new_pkg.publisher = $new_app.Publisher
$new_pkg.name = $new_app.Name
$new_pkg.version = $new_app.Version
$new_pkg.copyright = $new_app.Copyright
$new_pkg.licenseAcceptRequired = $new_app.LicenseAccept
$new_pkg.lcid = $new_app.Lcid
$new_pkg.cpuArch = $new_app.CpuArch
$new_pkg.homepage = $new_app.Homepage
$new_pkg.icon = $new_app.Icon
$new_pkg.docs = $new_app.Docs
$new_pkg.license = $new_app.License
$new_pkg.tags = $new_app.Tags
$new_pkg.summary = $new_app.Summary

$new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($new_app.CpuArch[0]).json" -Force -Confirm:$false -Encoding utf8
