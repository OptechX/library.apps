<# Manifest Version Info #>
$ManifestVersion='6.8-Lifestyle'
$LastUpdate='2023-08-04'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"

<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(" ","").ToUpper()
$new_app.Publisher = "Tencent Inc."
$new_app.Name = "WeChat"
$new_app.Lcid = @("EN_US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://www.wechat.com/"
$new_app.Copyright = "Copyright (c) 1998-2021 Tencent Inc. All Rights Reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Tencent%20Inc./WeChat/icon.png".Replace(" ","%20")
$new_app.LicenseAccept = $false
$new_app.Docs = "https://help.wechat.com/oshelpcenter"
$new_app.License = "https://www.wechat.com/en/service_terms.html"
$new_app.Tags = @("wechat","messenger")
$new_app.Summary = "WeChat is more than a messaging and social media app - it is a lifestyle for over one billion users across the world."
$new_app.RebootRequired = $false
$new_app.Filename
$new_app.GithubUrl
$new_app.GithubFilename

<# Get icon.png if not already obtained #>
$icon_path = "${PSScriptRoot}/icon.png"
if (-not(Test-Path -Path $icon_path))
{
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
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
    $nuspec_url = 'https://raw.githubusercontent.com/facorread/wechat-chocolatey/master/wechat.nuspec'
    Invoke-WebRequest -Uri $nuspec_url -OutFile wechat.nuspec -UseBasicParsing
    [xml]$nuspec_xml = Get-Content -Path wechat.nuspec
    $new_app.Version = $nuspec_xml.Package.metadata.version
    $download_url = 'https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe'
    Invoke-WebRequest -Uri $download_url -OutFile (Split-Path -Path $download_url -Leaf) -UseBasicParsing
    $new_app.Filename = (Split-Path -Path $download_url -Leaf)
}

<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
$new_pkg = [applicationPackage]::new()
$new_pkg.uid = "$($new_app.Publisher -replace "[^a-zA-Z0-9]")::$($new_app.Name -replace "[^a-zA-Z0-9]")"
$new_pkg.lastUpdate = Get-Date
$new_pkg.applicationCategory = $new_app.Category
$new_pkg.publisher = $new_app.Publisher
$new_pkg.name = $new_app.Name
$new_pkg.version = $new_app.Version
$new_pkg.copyright = $new_app.Copyright
$new_pkg.licenseAcceptRequired = $new_app.LicenseAccept
$new_pkg.lcid = $new_app.Lcid
$new_pkg.cpuArch = $new_app.CpuArch
$new_pkg.homepage = $new_app.Homepage
$new_pkg.icon = $new_app.Icon
$new_pkg.docs = $new_app.Docs
$new_pkg.license = $new_app.License
$new_pkg.tags = $new_app.Tags
$new_pkg.summary = $new_app.Summary

$new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($new_app.CpuArch[0]).json" -Force -Confirm:$false -Encoding utf8
