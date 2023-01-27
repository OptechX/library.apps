<# Manifest Version Info #>
$ManifestVersion='6.3'
$LastUpdate='2022-12-10'
Write-Output "Manifest Version: ${ManifestVersion}"
Write-Output "Last Updated: ${LastUpdate}"


<# Create static new object #>
$new_app = [applicationPayload]::new()
$new_app.Category = $Env:applicationCategory
$new_app.Publisher = "Adobe"
$new_app.Name = "Acrobat Reader DC"
$new_app.Lcid = @("MUI")
$new_app.CpuArch = @("x86")
$new_app.Homepage = "https://www.adobe.com/products/reader.html"
$new_app.Copyright = "Copyright (c) 1984-2018 Adobe Systems Incorporated and its licensors"
$new_app.Icon = "https://github.com/OptechX/library.apps.images/raw/main/$($Env:applicationCategory)/Adobe/Acrobat%20Reader%20DC/icon.png"
$new_app.LicenseAccept = $true
$new_app.Docs = "https://helpx.adobe.com/reader.html"
$new_app.License = "http://www.adobe.com/products/eulas/pdfs/Reader10_combined-20100625_1419.pdf"
$new_app.Tags = @("adobe","reader","acrobat","dc","pdf")
$new_app.Summary = "View, print, sign, and annotate PDF files"
$new_app.RebootRequired = $false
$new_app.Filename
$new_app.GithubUrl
$new_app.GithubFilename


<# Get icon.png if not already obtained #>
$icon_path = "${PSScriptRoot}/icon.png"
if (-not(Test-Path -Path $icon_path))
{
    Invoke-WebRequest -Uri $new_app.Icon -OutFile $icon_path -UseBasicParsing -Method Get
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
    $version_url = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
    $download_page = Invoke-WebRequest -Uri $version_url -UseBasicParsing -DisableKeepAlive
    $release_text = $download_page.links | Where-Object {$_.outerHTML -match 'DC.*\([0-9.]+\)'} | Select-Object -ExpandProperty outerHTML -First 1
    $release = $release_text -replace '.*\(([0-9.]+)\).*','$1'
    $version = "20$release"
    $release_path = $release.replace('.','')
    $http_base_path = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/${release_path}/AcroRdrDCx64${release_path}_MUI.exe"
    $filename = Split-Path -Path $http_base_path -Leaf
    $new_app.Filename = $filename
    $new_app.Version = $version
    #Invoke-WebRequest -Uri $http_base_path -OutFile $filename -UseBasicParsing
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
    $api_response = Invoke-WebRequest -Uri "${Env:ENGINE_API_URI}/v1/Application/${app_publisher}/${app_name}".Replace(' ','%20') -Method Get -UseBasicParsing -SkipHttpErrorCheck
    switch($api_response.StatusCode)
    {
        # 404 == object not found
        404 {
            $json = $new_pkg | ConvertTo-Json
            try {
                Write-Output "Importing new UID: $($new_pkg.uid)"
                Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch {
                Write-Output "unable to post new data, pre-updates"
                $json
            }
        }
        # 200 == object found
        200 {
            $matched_data = $api_response.Content | ConvertFrom-Json
            Write-Output "Found application: ${app_publisher}/${app_name}"

            # find if existing UID, update variables that match
            if ($matched_data.uid -match $new_app.UID)
            {
                Write-Output "Matched UID: $($new_pkg.uid)"

                <#
                  First, create an application package, and set the minimal options. This will be used as the framework for the PUT which
                  is a framework to work from. Each item can be separated out and updated, or ignored, depending if there is a match. So
                  starting with LCID, if not, add the existing, then CPUARCH second. Push the payload to the ENGINE.API once it's been
                  satisfactorily determined the package is ready.
                #>

                # create a default bundle, excluding the LCID and CPUARCH
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
                $int_pkg.homepage = $new_app.Homepage
                $int_pkg.icon = $new_app.Icon
                $int_pkg.docs = $new_app.Docs
                $int_pkg.license = $new_app.License
                $int_pkg.tags = $new_app.Tags
                $int_pkg.summary = $new_app.Summary

                # determine if LCID requires to be updated
                if ($matched_data.lcid -notcontains $new_pkg.lcid)
                {
                    Write-Output "Updating Lcid for ${uid}"
                    $int_pkg.lcid = @($matched_data.lcid) + @($new_pkg.lcid)
                }
                else
                {
                    $int_pkg.lcid = @($matched_data.lcid)
                }

                # determine if CPUARCH requires to be updated
                if ($matched_data.cpuArch -notcontains $new_pkg.cpuArch)
                {
                    Write-Output "Updating CpuArch for ${uid}"
                    $int_pkg.cpuArch = @($matched_data.cpuArch) + @($new_pkg.cpuArch)
                }

                # convert package to JSON object
                $json = $int_pkg | ConvertTo-Json
                

                # update API endpoint with new data
                try {
                    Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/$($int_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                } catch {
                    Write-Output "match in matched_data error 2"
                }
            }

            # not found existing UID, create new payload and update
            else {
                Write-Output "Not found UID: ${uid}"
                Write-Output "Creating new application..."

                try {
                    Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                } catch {
                    Write-Output "fanatical error C"
                }
            }
        }

        # default == something else
        Default {
            $resp_code = $api_response.StatusCode
            Write-Output "Some weird error happened: ${resp_code}"
            Write-Output "for ~> ${app_publisher}/${app_name}"
        }
    }
}
catch {
    Write-Output "Something else is wrong, log a ticket"
}
