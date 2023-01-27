<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft"
$new_app.Name = "OneDrive"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://support.microsoft.com/en-us/onedrive"
$new_app.Copyright = "(c) Microsoft Corporation"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/OneDrive/icon.png"
$new_app.LicenseAccept = $true
$new_app.Docs = "https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Windows"
$new_app.License = "https://www.microsoft.com/en-us/servicesagreement/"
$new_app.Tags = @("onedrive","backup","sync","cloud","drive","store","office365","microsoft","microsoft365","m365","o365")
$new_app.Summary = "OneDrive lets you can sync files between your computer and the cloud, so you can get to your files from anywhere"
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
    $version_url = 'https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Windows'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $version = $download_page.Content | 
        Select-String -Pattern 'Version.\d{2,}\.\d{2,}\.\d{2,}\.\d{2,}' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-String -Pattern '\d{2,}\.\d{2,}\.\d{2,}\.\d{2,}' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $rgx = "<a href.`*${version}<\/a>"
    $download_link = $download_page.Content |
        Select-String -Pattern $rgx |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-String -Pattern 'https:\/\/.*\d{6,}' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.Version = $version
    $new_app.Filename = "OneDriveSetup.exe"
    $new_app.AbsoluteUri = Get-RedirectedUrl -URL $download_link
    $new_app.Executable = 'OneDrive'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app