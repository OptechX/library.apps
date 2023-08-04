<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Igor Pavlov"
$new_app.Name = "7-Zip"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "http://www.7-zip.org/"
$new_app.Copyright = "7-Zip Copyright (C) 1999-$((Get-Date).ToString('yyyy')) Igor Pavlov."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Igor%20Pavlov/7-Zip/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "http://www.7-zip.org/faq.html"
$new_app.License = "http://www.7-zip.org/license.txt"
$new_app.Tags = @("7zip","7-zip","zip","archive","archiver","winrar","rar","7z","7za","pzip")
$new_app.Summary = "7-Zip is a file archiver with a high compression ratio"
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
    $version_url = 'http://www.7-zip.org/download.html'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = $download_page.Content | 
        Select-String -Pattern 'Download 7-Zip.\d{1,2}\.\d{1,2}' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-String -Pattern '\d{1,2}\.\d{1,2}' | 
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $download_page.Links | Select-Object href | Where-Object -FilterScript {$_ -match "$($new_app.Version.Replace('.',''))-x64.msi"}
    $new_app.Filename = Split-Path -Path ($download_page.Links | 
        Select-Object href | 
        Where-Object -FilterScript {$_ -match "$($new_app.Version.Replace('.',''))-x64.msi"}).href -Leaf
    $new_app.AbsoluteUri = "https://7-zip.org/$(($download_page.Links | 
        Select-Object href | 
        Where-Object -FilterScript {$_ -match "$($new_app.Version.Replace('.',''))-x64.msi"}).href)"
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
