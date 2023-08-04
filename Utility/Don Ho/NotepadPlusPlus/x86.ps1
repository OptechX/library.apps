<# Manifest Version Info #>
$ManifestVersion='6.8-Utility'
$LastUpdate='2023-08-04'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"

<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper().Replace(' ','').ToUpper()
$new_app.Publisher = "Don Ho"
$new_app.Name = "Notepad++"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://notepad-plus-plus.org/"
$new_app.Copyright = "Copyright (C) 2021 Don Ho"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Don%20Ho/Notepad%2B%2B/icon.png".Replace(" ","%20")
$new_app.LicenseAccept = $false
$new_app.Docs = "https://notepad-plus-plus.org/online-help/"
$new_app.License = "https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/LICENSE"
$new_app.Tags = @("notepad","notepadplusplus","notepad-plus-plus","plus","notepad-plus","notepad++","development","text","editor")
$new_app.Summary = "Notepad++ is a free (as in `"free speech`" and also as in `"free beer`") source code editor and Notepad replacement that supports several languages"
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
    $version_url = 'https://notepad-plus-plus.org/downloads/'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = ($download_page.Links | 
        Select-String -Pattern 'downloads\/v.*\d{1,}' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-String -Pattern 'v.*\d{1,}\/' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value).Replace('v','').Replace('/','')
    $new_app.AbsoluteUri = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$($new_app.Version)/npp.$($new_app.Version).Installer.x64.exe"
    $new_app.Filename = Split-Path -Path $new_app.AbsoluteUri -Leaf
    $new_app.Executable = 'exe'
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