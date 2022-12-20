<# Manifest Version Info #>
$ManifestVersion='6.5'
$LastUpdate='2022-12-11'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $env:applicationCategory
$new_app.Publisher = "Opera Norway"
$new_app.Name = "Opera"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://www.opera.com/browsers/opera"
$new_app.Copyright = "(c) 1995-$((Get-Date).ToString('yyyy')) Opera Norway. All rights reserved."
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($env:applicationCategory)/Opera%20Norway/Opera/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://help.opera.com/en/latest/"
$new_app.License = "http://www.opera.com/eula/computers"
$new_app.Tags = @("browser","opera","internet")
$new_app.Summary = "The Opera web browser makes the Web fast and fun, giving you a better web browser experience on any computer."
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
    $version_url = 'https://get.geo.opera.com/pub/opera/desktop/'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive
    $download_page = $download_page.Links | Where-Object -FilterScript {$_.href -match '^[\d]+[\d\.]+\/$'} | Sort-Object href -Descending | ForEach-Object {
        [string]$version = $_.href -replace '/',''
        $url = "https://get.geo.opera.com/pub/opera/desktop/$version/win/"
        try
        {
            $result = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
            return $result
        }
        catch { }
    } | Select-Object -First 1
    $filename = $download_page.Links | Where-Object -FilterScript {$_.href -match '^.*_Setup.exe$'} | Select-Object -First 1 -ExpandProperty href
    $new_app.Version = $version
    $new_app.Filename = $filename
    $new_app.AbsoluteUri = "${url}${filename}"
    $new_app.Executable = 'exe'
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
    $matched_data = Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application/${app_publisher}/${app_name}" -Method Get -UseBasicParsing -Headers @{accept="text/plain"} -ErrorAction Stop
    switch($matched_data.Length)
    {
        0 {
            $json = $new_pkg | ConvertTo-Json
            try {
                Write-Output "Importing UID: $($new_pkg.uid)"
                Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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
                        Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application/$($int_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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
                        Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application/$($int_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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
                    Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application/${temp_id}" -Method Put -UseBasicParsing -Body $new_match -ContentType "application/json" -ErrorAction Stop
                } catch {
                    Write-Output "match in matched_data error"
                }
            }
            $json = $new_pkg | ConvertTo-Json
            try {
                Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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
                Invoke-RestMethod -Uri "${env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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