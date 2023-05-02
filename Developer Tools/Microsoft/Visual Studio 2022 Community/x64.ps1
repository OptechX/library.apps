<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory.Replace(' ','_')
$new_app.Publisher = "Microsoft"
$new_app.Name = "Visual Studio 2022 Community"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://learn.microsoft.com/en-us/visualstudio/windows/?view=vs-2022&preserve-view=true"
$new_app.Copyright = "Copyright (c) $((Get-Date).ToString('yyyy')) Microsoft Corporation"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Visual%20Studio%202022%20Community/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://visualstudio.microsoft.com/vs/getting-started/"
$new_app.License = "https://visualstudio.microsoft.com/license-terms/vs2022-ga-community/"
$new_app.Tags = @("vs","vscode","visual-studio","vs_community","community","vs2022","2022","developer","microsoft","visual","studio")
$new_app.Summary = "Use Visual Studio to develop applications, services, and tools in the language of your choice, for your platforms and devices."
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
    $download_page = "https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-history"
    $vs2022_page = Invoke-WebRequest -UseBasicParsing -Uri $download_page -DisableKeepAlive
    $high_version = $vs2022_page.Content | 
        Select-String -Pattern 'Visual Studio 2022 version\s.*Release Notes' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value | 
        Select-String -Pattern '\d{1,}\.([\d{1,}\.]+)' | 
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.Version = $vs2022_page.Content |
        Select-String -Pattern "${high_version}\.\d{1,}" |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.AbsoluteUri = $vs2022_page.Links | 
        Where-Object -FilterScript {$_ -match 'https://aka.ms/vs/.*/release/vs_community.exe'} |
        Select-Object -ExpandProperty href
    $new_app.Filename = Split-Path -Path $new_app.AbsoluteUri -Leaf
    $new_app.Executable = 'exe'
}


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app