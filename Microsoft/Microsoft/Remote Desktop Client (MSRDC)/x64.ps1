<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft"
$new_app.Name = "Remote Desktop Client (MSRDC)"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/windowsdesktop"
$new_app.Copyright = "Copyright (c) $((Get-Date).ToString('yyyy')) Microsoft Corporation.  All Rights Reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Remote%20Desktop%20Client%20(MSRDC)/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/windowsdesktop#workspaces"
$new_app.License = "https://raw.githubusercontent.com/OptechX/library.apps/$($Env:applicationCategory)/Microsoft/Remote%20Desktop%20Client%20(MSRDC)/license.txt"
$new_app.Tags = @("msrdc","rdc","remote","remote desktop","rdc")
$new_app.Summary = "Use the Microsoft Remote Desktop app to connect to a remote PC or virtual apps and desktops made available by your admin."
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
    $version_url = 'https://learn.microsoft.com/en-us/azure/virtual-desktop/whats-new-client-windows'
    $version_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $new_app.Version = $version_page.Content |
        Select-String -Pattern '<h2 id="updates-for-version-\d{1,}".*\d{1,}.*<\/h2>' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value |
        Select-String -Pattern 'Updates for version \d{1,}\.([\d{1,}\.]+)' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value |
        Select-String -Pattern '\d{1,}\.([\d{1,}\.]+)' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $new_app.Filename = "RemoteDesktop_$($new_app.Version)_x64.msi"
    $download_url = 'https://learn.microsoft.com/en-us/azure/virtual-desktop/users/connect-windows?tabs=subscribe'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $download_url -DisableKeepAlive
    $follow_download_url = $download_page.Content | 
        Select-String -Pattern '<a href=.*Windows\s64-bit.*<\/a>' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value | 
        Select-String -Pattern 'https:\/\/go.microsoft.com\/fwlink\/\?linkid=\d{1,}' |
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $new_app.AbsoluteUri = $follow_download_url
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app