<#
  Manifest Version: 6.1
  Last Update: 2022-12-10
#>


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Celestia Development Team"
$new_app.Name = "Celestia"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://celestia.space"
$new_app.Copyright = "Copyright (c) 2001-2021, Celestia Development Team"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Celestia%20Development%20Team/Celestia/icon.png" #"https://github.com/OptechX/library.apps.images/raw/main/Microsoft/Edge/icon.png"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://en.wikibooks.org/wiki/Celestia"
$new_app.License = "https://raw.githubusercontent.com/CelestiaProject/Celestia/master/README.md"
$new_app.Tags = @("opengl","space","celestia","planetarium","educational","open","source","open source")
$new_app.Summary = "A real-time space simulation that lets you experience our universe in three dimensions."
$new_app.RebootRequired = $false
$new_app.Filename = ""
$new_app.GithubUrl = "https://github.com/CelestiaProject/Celestia/releases/latest"
$new_app.GithubFilename = "celestia-(VERSION)-win.exe"


<# Get icon.png if not already obtained #>
$icon_path = "${PSScriptRoot}/icon.png"
if (-not(Test-Path -Path $icon_path))
{
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
}
else
{

}


<# Get app data #>
if ($new_app.GithubUrl -ne [string]::Empty -or $null -ne $new_app.GithubUrl)
{
    $app_data = Get-GitHubReleaseDownload -GithubUrl $new_app.GithubUrl -FileName $new_app.GithubFilename
    $new_app.Version = $app_data[0]
    $new_app.Filename = $app_data[1]
}


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
