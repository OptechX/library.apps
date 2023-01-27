<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft Corporation"
$new_app.Name = "Microsoft Teams Desktop"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://products.office.com/en-us/microsoft-teams/group-chat-software<"
$new_app.Copyright = "Copyright (c) 2017-$((Get-Date).ToString('yyyy')) Microsoft Corporation"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Office%20365/Microsoft%20Teams%20Desktop/icon.png"
$new_app.LicenseAccept = $true
$new_app.Docs = "https://support.office.com/en-us/teams"
$new_app.License = "https://support.microsoft.com/en-us/office/microsoft-teams-subscription-supplemental-notice-60cc09bf-b02a-4a26-8e4a-ad697194bebf?ui=en-us&amp;rs=en-us&amp;ad=us"
$new_app.Tags = @("microsoft-teams","teams","office","365","o365","slack","chat","video","video-calling")
$new_app.Summary = "Microsoft Teams helps your team work better together."
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
    $download_page = Invoke-WebRequest -Uri "https://teams.microsoft.com/downloads/DesktopUrl?env=production&plat=windows"
    $download_url = $download_page.Content.Trim()
    $new_app.Version = $download_url | 
        Select-String -Pattern '\/([\d{1,}\.]+)' | 
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value | 
        Select-String -Pattern '([\d{1,}\.]+)' | 
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.Filename = Split-Path -Path $download_url -Leaf
    $new_app.AbsoluteUri = $download_url
    $new_app.Executable = 'exe'
    $new_app.DependsOn = @("netfx-4.7.2")
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app