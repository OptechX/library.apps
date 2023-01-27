<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Western Digital Corporation"
$new_app.Name = "WD Drive Security"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://support.wdc.com/downloads.aspx?p=172"
$new_app.Copyright = "(c) 2022 Western Digital Corporation or its affiliates. All Rights Reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/Security/Western%20Digital%20Corporation/WD%20Drive%20Security/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://support.wdc.com/knowledgebase/answer.aspx?ID=10408"
$new_app.License = "http://support.wdc.com/download/notes/WD_Security_for_Windows_Release_Notes.html?v=806?v=806"
$new_app.Tags = @("wd-security","western","digital","wd","westerndigital","wdc","admin")
$new_app.Summary = "WD Security for Windows"
$new_app.RebootRequired = $false
$new_app.Filename = "WDSecurity_WIN.zip"


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
$new_app.AbsoluteUri = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x86'}).Artifacts.Location
$new_app.Version = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x86'}).ProductVersion.Trim()
$download_hash = ($releases.Releases | Where-Object {$_.Platform -eq 'Windows'} | Where-Object {$_.Architecture -eq 'x86'}).Artifacts.Hash


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app