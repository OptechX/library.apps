<# Manifest Version Info #>
$ManifestVersion='6.6.1'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Mozilla"
$new_app.Name = "Firefox ESR"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.mozilla.org/en-US/firefox/new/"
$new_app.Copyright = "Copyright (c) 1998-$((Get-Date).ToString('yyyy')) Mozilla Foundation and its contributors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Mozilla/Firefox%20ESR/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://developer.mozilla.org/en-US/Firefox"
$new_app.License = "https://www.mozilla.org/en-US/MPL/2.0/"
$new_app.Tags = @("browser","mozilla","firefox","extended","support","release","esr")
$new_app.Summary = "Extended Support Release of Mozilla Firefox."
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
    $version_url = 'https://www.mozilla.org/en-US/firefox/all/'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url
    $rgx = "download.mozilla.*product=firefox-devedition.*(&amp;|&)os=win64(&amp;|&)lang=en-US"
    $url = $download_page.links | 
        Where-Object -FilterScript { $_.href -match $rgx } | 
        Where-Object -FilterScript { $_.href -NotMatch 'stub|next' } | 
        Select-Object -First 1 -Expand href
    $response = [System.Net.Http.HttpClient]::new().GetAsync($url)
    $new_app.Version = $response.Result.RequestMessage.RequestUri.OriginalString | 
        Select-String -Pattern 'releases\/\d{3}\.([0-9a-zA-Z]+)\/' |  
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-String -Pattern '\d{3}\.([0-9a-zA-Z]+)' | 
        Select-Object -ExpandProperty Matches -First 1 | 
        Select-Object -ExpandProperty Value
    $new_app.Filename = (Split-Path -Path $response.Result.RequestMessage.RequestUri.OriginalString -Leaf).Replace('%20',' ')
    $new_app.AbsoluteUri = $response.Result.RequestMessage.RequestUri.OriginalString
    $new_app.Executable = 'msi'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
if ($new_app.GetType().Name -like "applicationPayload")
{
    $x_app = [applicationPackage]::new()
    $x_app.lastUpdate = ((Get-Date).ToString("yyyyMMdd"))
    $x_app.applicationCategory = $Env:applicationCategory
    $x_app.publisher = $new_app.Publisher
    $x_app.Name = $new_app.Name
    $x_app.version = $new_app.Version
    $x_app.copyright = $new_app.Copyright
    $x_app.licenseAcceptRequired = $new_app.LicenseAccept
    $x_app.lcid = $new_app.Lcid
    $x_app.cpuArch = $new_app.CpuArch
    $x_app.homepage = $new_app.Homepage
    $x_app.icon = $new_app.Icon
    $x_app.docs = $new_app.Docs
    $x_app.license = $new_app.License
    $x_app.tags = $new_app.Tags
    $x_app.summary = $new_app.Summary
    $x_app.enabled = $new_app.Enabled

    $x_app.GetType()

    Invoke-DoNotEditBelowThisLine -InputPayload $x_app
}
if ($new_app.GetType().Name -like "applicationPackage")
{
    Invoke-DoNotEditBelowThisLine -InputPayload $new_app
}