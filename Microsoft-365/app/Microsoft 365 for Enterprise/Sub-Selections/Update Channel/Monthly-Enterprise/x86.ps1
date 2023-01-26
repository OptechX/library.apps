<# Manifest Version Info #>
$ManifestVersion='6.5.1-m365v2'
$LastUpdate='2022-12-20'
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
$new_app.Name = "Business Monthly Enterprise Channel"
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
$new_app.Filename = "install-m365-apps-$($m365_version.ToLower())-$($m365_channel.ToLower())-$($m365_build.ToLower()).ps1"
$new_app.AbsoluteUri = "$($m365_project_base)/app/Microsoft%20365%20for%20$($m365_version)/$($new_app.Filename)"
$new_app.Executable = 'script'


<# ============== DO NOT EDIT BELOW THIS LINE ============== #>
$new_pkg = [applicationPackage]::new()
$new_pkg.uid = "$($new_app.Publisher.ToLower() -replace "[^a-zA-Z0-9]")::$($new_app.Name.ToLower() -replace "[^a-zA-Z0-9]")::$($new_app.Version.ToLower() -replace "[^a-zA-Z0-9\.\-]")"
$new_pkg.lastUpdate = $((Get-Date).ToString("yyyyMMdd"))
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

$app_publisher = $new_app.Publisher
$app_name = $new_app.Name
$new_app.UID = "$($new_app.Publisher.ToLower())::$($new_app.Name.ToLower())::$($new_app.Version.ToLower())"

try {
    $matched_data = Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/${app_publisher}/${app_name}" -Method Get -UseBasicParsing -Headers @{accept="text/plain"} -ErrorAction Stop
    switch($matched_data.Length)
    {
        0 {
            $json = $new_pkg | ConvertTo-Json
            try {
                Write-Output "Importing UID: $($new_pkg.uid)"
                Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch {
                Write-Output "unable to post new data, pre-updates"
            }
        }
        1 {
            if ($matched_data.uid -eq $new_app.UID)
            {
                Write-Output "Matched UID: $($new_pkg.uid)"
                if ($matched_data.lcid -notcontains $new_pkg.lcid)
                {
                    Write-Output "Lcid to be updated"
                    $int_pkg = [applicationPackage]::new()
                    $int_pkg.id = $matched_data.id
                    $int_pkg.uid = $matched_data.uid
                    $int_pkg.lastUpdate = $((Get-Date).ToString("yyyyMMdd"))
                    $int_pkg.applicationCategory = $new_app.Category
                    $int_pkg.publisher = $new_app.Publisher
                    $int_pkg.name = $new_app.Name
                    $int_pkg.version = $new_app.Version
                    $int_pkg.copyright = $new_app.Copyright
                    $int_pkg.licenseAcceptRequired = $new_app.LicenseAccept
                    $int_pkg.lcid = @($matched_data.lcid,$new_pkg.lcid)
                    $int_pkg.cpuArch = $new_app.CpuArch
                    $int_pkg.homepage = $new_app.Homepage
                    $int_pkg.icon = $new_app.Icon
                    $int_pkg.docs = $new_app.Docs
                    $int_pkg.license = $new_app.License
                    $int_pkg.tags = $new_app.Tags
                    $int_pkg.summary = $new_app.Summary
                    $json = $int_pkg | ConvertTo-Json
                    try {
                        Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/$($int_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                    } catch {
                        Write-Output "match in matched_data error"
                    }
                }
                if ($matched_data.cpuArch -notcontains $new_pkg.cpuArch)
                {
                    Write-Output "CpuArch to be updated"
                    $int_pkg = [applicationPackage]::new()
                    $int_pkg.id = $matched_data.id
                    $int_pkg.uid = $matched_data.uid
                    $int_pkg.lastUpdate = $((Get-Date).ToString("yyyyMMdd"))
                    $int_pkg.applicationCategory = $new_app.Category
                    $int_pkg.publisher = $new_app.Publisher
                    $int_pkg.name = $new_app.Name
                    $int_pkg.version = $new_app.Version
                    $int_pkg.copyright = $new_app.Copyright
                    $int_pkg.licenseAcceptRequired = $new_app.LicenseAccept
                    $int_pkg.lcid = $new_app.Lcid
                    $int_pkg.cpuArch = @($matched_data.cpuArch,$new_pkg.cpuArch)
                    $int_pkg.homepage = $new_app.Homepage
                    $int_pkg.icon = $new_app.Icon
                    $int_pkg.docs = $new_app.Docs
                    $int_pkg.license = $new_app.License
                    $int_pkg.tags = $new_app.Tags
                    $int_pkg.summary = $new_app.Summary
                    $json = $int_pkg | ConvertTo-Json
                    try {
                        Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/$($int_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                    } catch {
                        Write-Output "match in matched_data error"
                    }
                }
            }
        }
        Default {
            foreach ($match in $matched_data)
            {
                $match.enabled = $false
                $new_match = $match | ConvertTo-Json
                $temp_id = $match.id
                try {
                    Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/${temp_id}" -Method Put -UseBasicParsing -Body $new_match -ContentType "application/json" -ErrorAction Stop
                } catch {
                    Write-Output "match in matched_data error"
                }
            }
            $json = $new_pkg | ConvertTo-Json
            try {
                Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch {
                Write-Output "unable to post new data following updates"
            }
        }
    }
}
catch {
    switch (($_ | ConvertFrom-Json).Status)
    {
        "404" {
            $json = $new_pkg | ConvertTo-Json
            try {
                Write-Output "Importing UID: $($new_pkg.uid)"
                Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch {
                Write-Output "Unable to post new data, pre-updates"
            }
        }
        Default {
            Write-Output "Something else is wrong, log a ticket"
        }
    }
}
