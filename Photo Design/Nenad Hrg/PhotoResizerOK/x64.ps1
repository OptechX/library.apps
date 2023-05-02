<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(' ','_')
$new_app.Publisher = "Nenad Hrg"
$new_app.Name = "PhotoResizerOK"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.softwareok.com/?seite=Freeware/PhotoResizerOK"
$new_app.Copyright = "Copyright (c) 2008-$((Get-Date).ToString('yyyy')) by Nenad Hrg softwareok.de"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Nenad%20Hrg/PhotoResizerOK/icon.png"
$new_app.LicenseAccept = $true
$new_app.Docs = "http://www.softwareok.com/?seite=faq-PhotoResizerOK&amp;faq=0"
$new_app.License = "https://www.softwareok.com/?seite=Freeware/PhotoResizerOK/Eula"
$new_app.Tags = @("photoresizerok","photo","resize","jpg","png","bmp","raw","exif","watermark","freeware","embedded")
$new_app.Summary = "Quickly reduce your photo file sizes"
$new_app.RebootRequired = $false
$new_app.Filename = 'PhotoResizerOK_x64.zip'
$new_app.AbsoluteUri = 'https://www.softwareok.com/?Download=PhotoResizerOK&goto=../Download/PhotoResizerOK_x64.zip'
$new_app.Executable = 'zip'


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
    $version_url = 'https://www.softwareok.com/?seite=Freeware/PhotoResizerOK/History'
    $info_page = Invoke-WebRequest -Uri $version_url -UseBasicParsing -DisableKeepAlive
    $new_app.Version = $info_page.Content | Select-String -Pattern 'New in version.\d{1,9}\.\d{1,3}' | Select-Object -ExpandProperty Matches -First 1 | Select-String -Pattern '\d{1,3}\.\d{1,3}' | Select-Object -ExpandProperty Matches -First 1 | Select-Object -ExpandProperty Value
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app