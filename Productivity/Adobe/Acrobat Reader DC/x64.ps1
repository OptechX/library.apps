<# Manifest Version Info #>
$ManifestVersion='6.8-Productivity'
$LastUpdate='2023-08-04'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"

<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Adobe"
$new_app.Name = "Acrobat Reader DC"
$new_app.Lcid = @("MUI")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://www.adobe.com/products/reader.html"
$new_app.Copyright = "Copyright (c) 1984-2018 Adobe Systems Incorporated and its licensors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Adobe/Acrobat%20Reader%20DC/icon.png".Replace(" ","%20")
$new_app.LicenseAccept = $true
$new_app.Docs = "https://helpx.adobe.com/reader.html"
$new_app.License = "http://www.adobe.com/products/eulas/pdfs/Reader10_combined-20100625_1419.pdf"
$new_app.Tags = @("adobe","reader","acrobat","dc","pdf")
$new_app.Summary = "View, print, sign, and annotate PDF files"
$new_app.RebootRequired = $false
$new_app.Filename
$new_app.GithubUrl
$new_app.GithubFilename

<# Get icon.png if not already obtained #>
$icon_path = "${PSScriptRoot}/icon.png"
if (-not(Test-Path -Path $icon_path))
{
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
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
    $version_url = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
    $download_page = Invoke-WebRequest -Uri $version_url -UseBasicParsing -DisableKeepAlive
    $release_text = $download_page.links | Where-Object {$_.outerHTML -match 'DC.*\([0-9.]+\)'} | Select-Object -ExpandProperty outerHTML -First 1
    $release = $release_text -replace '.*\(([0-9.]+)\).*','$1'
    $version = "20$release"
    $release_path = $release.replace('.','')
    $http_base_path = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/${release_path}/AcroRdrDCx64${release_path}_MUI.exe"
    $filename = Split-Path -Path $http_base_path -Leaf
    $new_app.Filename = $filename
    $new_app.Version = $version
    #Invoke-WebRequest -Uri $http_base_path -OutFile $filename -UseBasicParsing
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
