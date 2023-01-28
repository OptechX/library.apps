<# Manifest Version Info #>
$ManifestVersion='6.6-m365-app'
$LastUpdate='2023-01-28'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Microsoft 365 Values #>
$m365_version = "Business"
$m365_channel = "Current"
$m365_build = "Standard"
$m365_project_base = "https://raw.githubusercontent.com/OptechX/library.apps/main/Microsoft-365"


<# License Lookup #>
$license_url = "https://www.microsoft.com/en-us/licensing/product-licensing/microsoft-365-enterprise"
$license_data = Invoke-WebRequest -Uri $license_url -UseBasicParsing -DisableKeepAlive
$license_pdf = $license_data.Links | 
    Where-Object {$_.outerHTML -match 'https.*Licensing_guide_Microsoft_365_Enterprise.pdf'} | 
    Select-Object -First 1 | 
    Select-Object -ExpandProperty href


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = "Microsoft"
$new_app.Publisher = "Microsoft 365"
$new_app.Name = "Single Apps for Business (Standard)"
$new_app.Lcid = @("MUI")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://microsoft365.com/"
$new_app.Copyright = "Copyright (c) $((Get-Date).ToString('yyyy')) Microsoft. All rights reserved."
$new_app.Icon = "$($m365_project_base)/img/microsoft365.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://support.microsoft.com/en-au/microsoft-365"
$new_app.License = $license_pdf
$new_app.Tags = @("vlsc","microsoft-365","365","o365","office-365","office","microsoft","word","excel","visio","publisher","teams","powerpoint","outlook","proplus","enterprise","business","yammer","onedrive","onenote","publisher","access")
$new_app.Summary = "Microsoft 365 is a product family of productivity software, collaboration and cloud-based services owned by Microsoft. Standard applications. Current update channel."
$new_app.RebootRequired = $false


<# Get icon.png if not already obtained #>
# icon files are hard coded in this version


<# Get app data #>
$json_uri = "$($m365_project_base)/config/config.json"
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
$new_app.Filename = "install-m365-single-apps-$($m365_version.ToLower())-$($m365_channel.ToLower())-$($m365_build.ToLower()).ps1"
$new_app.AbsoluteUri = "$($m365_project_base)/app/Microsoft%20365%20for%20$($m365_version)/Sub-Selections/Single%20Apps/$($new_app.Filename)"
$new_app.Executable = 'script'


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
Invoke-DoNotEditBelowThisLine -InputPayload $new_app
