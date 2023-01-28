<# Manifest Version Info #>
$ManifestVersion='6.6-m365-app'
$LastUpdate='2023-01-28'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Microsoft 365 Values #>
$m365_app = "Visio"
$m365_app_lower = $m365_app.ToLower()
$m365_channel = "Current"
$m365_project_base = "https://raw.githubusercontent.com/OptechX/library.apps/main/Microsoft-365"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = "Microsoft"
$new_app.Publisher = "Microsoft 365"
$new_app.Name = $m365_app
$new_app.Lcid = @("MUI")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://www.microsoft.com/microsoft-365/${m365_app_lower}"
$new_app.Copyright = "Copyright (c) 1992-$((Get-Date).ToString('yyyy')) Microsoft. All rights reserved."
$new_app.Icon = "${m365_project_base}/img/${m365_app_lower}.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://support.microsoft.com/en-au/microsoft-365"
$new_app.License = "https://download.microsoft.com/download/3/D/4/3D42BDC2-6725-4B29-B75A-A5B04179958B/Licensing_guide_Microsoft_365_Enterprise.pdf"
$new_app.Tags = @("vlsc","microsoft-365","365","o365","office-365","office","microsoft","word","excel","visio","publisher","teams","powerpoint","outlook","proplus","enterprise","business","yammer","onedrive","onenote","publisher","access")
$new_app.Summary = "Work visually from anywhere, at any time."
$new_app.RebootRequired = $false


<# Get app data #>
$json_uri = "${m365_project_base}/config/config.json"
$version_url = Invoke-WebRequest -Uri $json_uri -UseBasicParsing | 
    ConvertFrom-Json | 
    Select-Object -ExpandProperty $m365_channel | 
    Select-Object -ExpandProperty VersionUri
$version_info = Invoke-WebRequest -UseBasicParsing -Uri $version_url | 
    Select-Object -ExpandProperty Content | 
    Select-String -Pattern 'Version\s\d{1,}\s\(.*\)' | 
    Select-Object -ExpandProperty Matches -First 1 | 
    Select-Object -ExpandProperty Value
$new_app.Version = $version_info.Replace('Version ','').Replace(' (','.').Replace('Build ','').Replace(')','')
$new_app.Filename = "${m365_app_lower}.ps1"
$new_app.AbsoluteUri = "${m365_project_base}/app/m365-app-${m365_app_lower}.ps1"
$new_app.Executable = 'script'


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app