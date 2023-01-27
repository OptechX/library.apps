<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft"
$new_app.Name = "SqlCMD Utility"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16"
$new_app.Copyright = "Copyright (c) 2016-$((Get-Date).ToString('yyyy')) Microsoft."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/SqlCmd%20Utility/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16"
$new_app.License = "https://learn.microsoft.com/en-us/sql/opbuildpdf/34e89e264abfe116ed984318f4f944e6/toc.pdf?branch=live&view=sql-server-ver16"
$new_app.Tags = @("sql","sql-server","sqlcmd","cmd","ssms")
$new_app.Summary = "The sqlcmd utility lets you enter Transact-SQL statements, system procedures, and script files"
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
    $version_url = 'https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = $download_page.Content | 
        Select-String -Pattern 'Release number:.*\d' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value |
        Select-String -Pattern '\d{1,}.*\d{1,}' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value

    $download_link = $download_page.Content | 
        Select-String -Pattern '<a href=.*Download Microsoft Command Line Utilities.*for SQL Server \(x86\).*<\/a>' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value | 
        Select-String -Pattern 'https:\/\/go.microsoft.com\/fwlink\/\?linkid=\d{1,}' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $download_info = ([System.Net.WebRequest]::CreateDefault($download_link)).GetResponse().ResponseUri.OriginalString
    $new_app.Filename = Split-Path -Path $download_info -Leaf
    $new_app.AbsoluteUri = $download_info
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app