<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Oracle"
$new_app.Name = "SQL Plus (Basic Package)"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://docs.oracle.com/cd/B19306_01/server.102/b14357/toc.htm"
$new_app.Copyright = "7-Zip Copyright (C) 1999-$((Get-Date).ToString('yyyy')) Igor Pavlov."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Oracle/SQL%20Plus%20%28Basic%20Package%29/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://docs.oracle.com/cd/B19306_01/server.102/b14357/toc.htm"
$new_app.License = "https://www.oracle.com/downloads/licenses/standard-license.html"
$new_app.Tags = @("oracle","sql","sqlplus","plus","db","dbsql","sql-plus")
$new_app.Summary = "SQL*Plus is an interactive and batch query tool that is installed with every Oracle Database Server or Client installation"
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
    $version_url = 'https://www.oracle.com/au/database/technologies/instant-client/winx64-64-downloads.html'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = ($download_page.Content | 
        Select-String -Pattern 'Version \d{1,}.*' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value).Replace('</h4>','').Replace('Version ','')
    ($download_page.Links | Select-Object href | Where-Object -FilterScript {$_ -match "instantclient-basic-windows.x64-$($new_app.Version)dbru.zip"}).href
    $new_app.Filename = Split-Path -Path ($download_page.Links | 
        Select-Object href | 
        Where-Object -FilterScript {$_ -match "instantclient-basic-windows.x64-$($new_app.Version)dbru.zip"}).href -Leaf
    $new_app.AbsoluteUri = "https:" + (($download_page.Links | Select-Object href | Where-Object -FilterScript {$_ -match "instantclient-basic-windows.x64-$($new_app.Version)dbru.zip"}).href).Replace(' ','')
    $new_app.Executable = 'zip'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app