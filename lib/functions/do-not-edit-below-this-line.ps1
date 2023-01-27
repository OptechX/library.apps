function Invoke-DoNotEditBelowThisLine {
    [CmdletBinding()]
    param (
        [applicationPayload]$InputPayload
    )
    
    begin {
        class applicationPackage {
            [System.Int16]$id = 0
            [System.Guid]$uuid = [System.Guid]::NewGuid()
            [System.String]$uid = [string]::Empty
            [System.String]$lastUpdate = [string]::Emtpy
            [System.String]$applicationCategory = [string]::Empty
            [System.String]$publisher = [string]::Empty
            [System.String]$name = [string]::Empty
            [System.String]$version = [string]::Empty
            [System.String]$copyright = [string]::Empty
            [System.Boolean]$licenseAcceptRequired = $false
            [System.String[]]$lcid = @()
            [System.String[]]$cpuArch = @()
            [System.String]$homepage = [string]::Empty
            [System.String]$icon = [string]::Empty
            [System.String]$docs = [string]::Empty
            [System.String]$license = [string]::Empty
            [System.String[]]$tags = @()
            [System.String]$summary = [string]::Empty
            [System.Boolean]$enabled = $true
        }

        $Env:ENGINE_API_URI = "https://engine.api.prod.optechx-data.com"
    }
    
    process {
        <# Pre-configure some variables #>
        [System.String]$APP_PUBLISHER = $InputPayload.Publisher
        [System.String]$APP_NAME = $InputPayload.Name
        [System.String]$APP_VERSION = $InputPayload.Version
        [System.String]$APP_UID = "$($APP_PUBLISHER.ToLower() -replace "[^a-zA-Z0-9]")::$($APP_NAME.ToLower() -replace "[^a-zA-Z0-9]")::$($APP_VERSION.ToLower() -replace "[^a-zA-Z0-9\.\-]")"
        [System.String]$API_RESPONSE_URI = "https://engine.api.prod.optechx-data.com/v1/Application/uid/${APP_UID}"
        [System.String]$APP_CATEGORY = $InputPayload.Category.Replace(' ','_')  <# issue https://github.com/repasscloud/optechx.drivers/issues/3 #>
        [System.String]$CPU_ARCH = $InputPayload.CpuArch
        [System.String]$LCID = $InputPayload.Lcid

        <# Create a new applicationPackage #>
        $new_app_package = [applicationPackage]::new()

        <# Dissect components from InputPayload into the minimum framework #>
        $new_app_package.uid = $APP_UID
        $new_app_package.lastUpdate = $((Get-Date).ToString("yyyyMMdd"))
        $new_app_package.applicationCategory = $APP_CATEGORY
        $new_app_package.publisher = $APP_PUBLISHER
        $new_app_package.name = $APP_NAME
        $new_app_package.version = $APP_VERSION
        $new_app_package.copyright = $InputPayload.Copyright
        $new_app_package.licenseAcceptRequired = $InputPayload.LicenseAccept
        $new_app_package.lcid = $InputPayload.Lcid
        $new_app_package.cpuArch = $InputPayload.CpuArch
        $new_app_package.homepage = $InputPayload.Homepage
        $new_app_package.icon = $InputPayload.Icon
        $new_app_package.docs = $InputPayload.Docs
        $new_app_package.license = $InputPayload.License
        $new_app_package.tags = $InputPayload.Tags
        $new_app_package.summary = $InputPayload.Summary

        #region Main Logic
        try {
            $api_response = Invoke-WebRequest -Uri $API_RESPONSE_URI -Method Get -UseBasicParsing -SkipHttpErrorCheck -ErrorAction Stop
            <# if the $api_response is unable to communicate with the API endpoint, this is a main logic error, and will
            break down to to the catch statement and report back to the CI/CD this has occured, else the value will be stored for
            updating teh API endpoint with additional/new data #>

            switch ($api_response.StatusCode)
            {
                # 404 == object not found
                404 {
                    $json = $new_app_package | ConvertTo-Json
                    try {
                        Write-Output "Importing new UID: ${APP_UID}"
                        Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                    }
                    catch {
                        Write-Output "MAIN LOGIC 404 ERROR"
                        Write-Error $_.Exception
                        Write-Output "START DIAGNOSTIC DATA>>>"
                        Write-Output $new_app_package
                        Write-Output "<<<END DIAGNOSTIC DATA"
                    }
                }

                # 200 == object found
                200 {
                    $matched_data = $api_response.Content | ConvertFrom-Json
                    Write-Output "Found application: ${APP_PUBLISHER}/${APP_NAME}"

                    # find if existing UID, update variables that match
                    if ($matched_data.uid -match $APP_UID)
                    {
                        Write-Output "Matched UID: ${APP_UID}"

                        <#
                        First, create an application package, and set the minimal options. This will be used as the framework for the PUT which
                        is a framework to work from. Each item can be separated out and updated, or ignored, depending if there is a match. So
                        starting with LCID, if not, add the existing, then CPUARCH second. Push the payload to the ENGINE.API once it's been
                        satisfactorily determined the package is ready.
                        #>

                        # create a default bundle, excluding the LCID and CPUARCH
                        $interim_pkg = [applicationPackage]::new()
                        $interim_pkg.id = $matched_data.id
                        $interim_pkg.uid = $APP_UID
                        $interim_pkg.lastUpdate = $((Get-Date).ToString("yyyyMMdd"))
                        $interim_pkg.applicationCategory = $APP_CATEGORY
                        $interim_pkg.publisher = $InputPayload.Publisher
                        $interim_pkg.name = $InputPayload.Name
                        $interim_pkg.version = $InputPayload.Version
                        $interim_pkg.copyright = $InputPayload.Copyright
                        $interim_pkg.licenseAcceptRequired = $InputPayload.LicenseAccept
                        $interim_pkg.homepage = $InputPayload.Homepage
                        $interim_pkg.icon = $InputPayload.Icon
                        $interim_pkg.docs = $InputPayload.Docs
                        $interim_pkg.license = $InputPayload.License
                        $interim_pkg.tags = $InputPayload.Tags
                        $interim_pkg.summary = $InputPayload.Summary

                        # determine if LCID requires to be updated
                        if ($matched_data.lcid -notcontains $new_app_package.lcid)
                        {
                            Write-Output "Updating Lcid for ${APP_UID}"
                            [System.String[]]$i_lcid
                            $i_lcid = @($matched_data.lcid,$LCID)
                            $interim_pkg.lcid = $i_lcid
                        }
                        else
                        {
                            $interim_pkg.lcid = @($matched_data.lcid)
                        }

                        # determine if CPUARCH requires to be updated
                        if ($matched_data.cpuArch -notcontains $CPU_ARCH)
                        {
                            Write-Output "Updating CpuArch for ${APP_UID}"
                            [System.String[]]$i_cpuArch
                            $i_cpuArch = @($matched_data.cpuArch,$CPU_ARCH)
                            $interim_pkg.cpuArch = $i_cpuArch
                        }
                        else
                        {
                            $interim_pkg.cpuArch = @($matched_data.cpuArch)
                        }

                        # convert package to JSON object
                        $json = $interim_pkg | ConvertTo-Json
                        
                        # update API endpoint with new data
                        try {
                            Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application/$($interim_pkg.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                        } catch {
                            Write-Output "match in matched_data error 2"
                            "${Env:ENGINE_API_URI}/v1/Application/$($interim_pkg.id)"
                            $json
                        }
                    }

                    # not found existing UID, create new payload and update
                    else {
                        Write-Output "Not found UID: ${APP_UID}"
                        Write-Output "Creating new application..."

                        # convert to json object for the else
                        $json = $new_app_package | ConvertTo-Json

                        try {
                            Write-Output "Importing new UID: ${APP_UID}"
                            Invoke-RestMethod -Uri "${Env:ENGINE_API_URI}/v1/Application" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                        } catch {
                            Write-Output "ERROR: Unable to create new UID"
                            Write-Error $_.Exception
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
            Write-Output "Error in main logic"
            Write-Error $_.Exception
        }
        #endregion Main Logic
    }
    
    end {
        
    }
}
