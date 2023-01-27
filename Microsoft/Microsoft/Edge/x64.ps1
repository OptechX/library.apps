<# Manifest Version Info #>
$ManifestVersion='6.6'
$LastUpdate='2023-01-27'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft"
$new_app.Name = "Edge"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.microsoft.com/en-us/edge"
$new_app.Copyright = "(c) 2022 Microsoft Corporation. All rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Edge/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://docs.microsoft.com/en-us/microsoft-edge/"
$new_app.License = "https://www.microsoft.com/en-us/servicesagreement/"
$new_app.Tags = @("microsoft","edge","browser","stable","chromium","open","source","open source")
$new_app.Summary = "Microsoft Edge browser, based on the Chromium open source browser"
$new_app.RebootRequired = $false
$new_app.Filename = "MicrosoftEdgeEnterpriseX64.msi"


<# Get icon.png if not already obtained #>
$icon_path = "${PSScriptRoot}/icon.png"
if (-not(Test-Path -Path $icon_path))
{
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
}


<# Get app data #>
$msedge_api_uri = "https://edgeupdates.microsoft.com/api/products"
$msedge_build_stream = "Stable"
$msedge_api_dl_data = (Invoke-WebRequest -Uri $msedge_api_uri -Method Get -UseBasicParsing).Content
$json = $msedge_api_dl_data | ConvertFrom-Json
$releases = $json | Where-Object -Property Product -eq $msedge_build_stream | Select-Object Releases
$new_app.AbsoluteUri = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x64'}).Artifacts.Location
$new_app.Version = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x64'}).ProductVersion.Trim()
$download_hash = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x64'}).Artifacts.Hash


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app