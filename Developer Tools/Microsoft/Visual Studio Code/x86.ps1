<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(' ','_')
$new_app.Publisher = "Microsoft"
$new_app.Name = "Visual Studio Code"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://code.visualstudio.com"
$new_app.Copyright = "Copyright (c) 2015 - $((Get-Date).ToString('yyyy')) Microsoft Corporation"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Visual Studio Code/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://code.visualstudio.com/docs"
$new_app.License = "https://code.visualstudio.com/License"
$new_app.Tags = @("microsoft","visualstudiocode","visual","studio","code","dev","developer","editor","ide","js","java","c","c++","typescript","ts","python","ruby","dotnet","vscode","rust")
$new_app.Summary = "Build and debug modern web and cloud applications in VSCode."
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
    $version_url = 'https://update.code.visualstudio.com/api/update/win32/stable/VERSION'
    $download_json= Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive | ConvertFrom-Json
    $new_app.Version = $download_json.productVersion
    $new_app.Filename = Split-Path -Path $download_json.url -Leaf
    $new_app.AbsoluteUri = $download_json.url
    $new_app.Executable = 'exe'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app