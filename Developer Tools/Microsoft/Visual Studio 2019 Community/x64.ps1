<# Manifest Version Info #>
$ManifestVersion='6.5.1'
$LastUpdate='2022-12-11'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Microsoft"
$new_app.Name = "Visual Studio 2019 Community"
$new_app.Lcid = @("en-US")
$new_app.CpuArch = @("x64")
$new_app.Homepage = "https://learn.microsoft.com/en-us/visualstudio/releases/2019/release-notes"
$new_app.Copyright = "Copyright (c) 2019-$((Get-Date).ToString('yyyy')) Microsoft Corporation"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Microsoft/Visual%20Studio%202019%20Community/icon.svg"
$new_app.LicenseAccept = $false
$new_app.Docs = "https://visualstudio.microsoft.com/vs/getting-started/"
$new_app.License = "https://visualstudio.microsoft.com/license-terms/vs2022-ga-community/"
$new_app.Tags = @("vs","vscode","visual-studio","vs_community","community","vs2019","2019","developer","microsoft","visual","studio")
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
    $download_page = "https://learn.microsoft.com/en-us/visualstudio/releases/2019/history"
    $vs2019_page = Invoke-WebRequest -UseBasicParsing -Uri $download_page -DisableKeepAlive
    $new_app.Version = $vs2019_page.Content | 
        Select-String -Pattern '16\.\d{1,}\.\d{1,}' |
        Select-Object -ExpandProperty Matches -First 1 |
        Select-Object -ExpandProperty Value
    $new_app.AbsoluteUri = 'https://aka.ms/vs/.*/release/vs_community.exe'
    $new_app.Filename = Split-Path -Path $new_app.AbsoluteUri -Leaf
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
