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
$new_app.UID = $new_pkg.uid

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
