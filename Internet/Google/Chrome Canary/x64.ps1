<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Google"
$new_app.Name = "Chrome Dev"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.google.com/chrome/canary/"
$new_app.Copyright = "Copyright $((Get-Date).ToString('yyyy')) Google LLC. ALl rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Google/Chrome%20Canary/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://support.google.com/chrome/?hl=en&rd=3#topic=7439538"
$new_app.License = "https://www.google.it/intl/en/chrome/browser/privacy/eula_text.html"
$new_app.Tags = @("google","chrome","internet","browser","canary")
$new_app.Summary = "Get on the bleeding edge of the web. Be warned: Canary can be unstable."
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
    $version_url = 'https://github.com/microsoft/winget-pkgs/tree/master/manifests/g/Google/Chrome/Canary'
    $download_page = Invoke-WebRequest -Uri $version_url -UseBasicParsing -DisableKeepAlive
    $rgx = '^.*\d{1,}\.([\d{1,}]+).*'
    $download_page = $download_page.Links | Where-Object -FilterScript {$_.href -match $rgx} | Sort-Object href -Descending | ForEach-Object {
        [string]$version = $_.href -replace '(^.*\/)',''
        $url = "https://github.com/microsoft/winget-pkgs/raw/master/manifests/g/Google/Chrome/Canary/${version}/Google.Chrome.Canary.installer.yaml"
        try
        {
            $result = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
            return $result
        }
        catch { }
    } | Select-Object -First 1
    $new_app.Version = $version
    $download_url = $download_page.Content | 
        Select-String -Pattern 'https\:\/\/.*x64.*exe' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $new_app.Filename = Split-Path -Path $download_url -Leaf
    $new_app.AbsoluteUri = $download_url
    $new_app.Executable = 'exe'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app