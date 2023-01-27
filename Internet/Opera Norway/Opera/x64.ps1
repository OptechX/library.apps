<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Opera Norway"
$new_app.Name = "Opera"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.opera.com/browsers/opera"
$new_app.Copyright = "(c) 1995-$((Get-Date).ToString('yyyy')) Opera Norway. All rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Opera%20Norway/Opera/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://help.opera.com/en/latest/"
$new_app.License = "http://www.opera.com/eula/computers"
$new_app.Tags = @("browser","opera","internet")
$new_app.Summary = "The Opera web browser makes the Web fast and fun, giving you a better web browser experience on any computer."
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
    $version_url = 'https://get.geo.opera.com/pub/opera/desktop/'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $download_page = $download_page.Links | Where-Object -FilterScript {$_.href -match '^[\d]+[\d\.]+\/$'} | Sort-Object href -Descending | ForEach-Object {
        [string]$version = $_.href -replace '/',''
        $url = "https://get.geo.opera.com/pub/opera/desktop/$version/win/"
        try
        {
            $result = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
            return $result
        }
        catch { }
    } | Select-Object -First 1
    $filename = $download_page.Links | Where-Object -FilterScript {$_.href -match '^.*_Setup_x64.exe$'} | Select-Object -First 1 -ExpandProperty href
    $new_app.Version = $version
    $new_app.Filename = $filename
    $new_app.AbsoluteUri = "${url}${filename}"
    $new_app.Executable = 'exe'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app