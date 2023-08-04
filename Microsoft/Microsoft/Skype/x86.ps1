<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Microsoft"
$new_app.Name = "Skype"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "http://www.skype.com"
$new_app.Copyright = "Copyright (c) Microsoft $((Get-Date).ToString('yyyy'))"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Skype/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://www.skype.com/en/about/"
$new_app.License = "https://www.microsoft.com/servicesagreement#14e_Skype"
$new_app.Tags = @("skype","voip")
$new_app.Summary = "Install Skype, add your friends as contacts, then call, video call and instant message with them for free."
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
    $version_url = 'https://go.skype.com/msi-download'
    $download_page = ([System.Net.WebRequest]::CreateDefault($version_url)).GetResponse()

    $new_app.Filename = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf
    $new_app.Version = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf | 
        Select-String -Pattern '\d{1,}.*\d{1,}' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.AbsoluteUri = $download_page.ResponseUri.OriginalString
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
