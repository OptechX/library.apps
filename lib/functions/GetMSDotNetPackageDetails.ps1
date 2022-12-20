function Get-MSDotNetPackageDetails()
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
            )]
        [string]$VersionUrl,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
            )]
        [regex]$HtmlPattern,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2
            )]
        [regex]$VersionPattern,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 3
            )]
        [string]$SubsFilename,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 4
            )]
        [string]$AbsoluteUrl
    )

    PROCESS {
        $version_url = $VersionUrl
        $download_page = Invoke-WebRequest -UseBasicParsing -Uri $version_url -DisableKeepAlive

        $app_version = $download_page.Content |
            Select-String -Pattern $HtmlPattern |
            Select-Object -ExpandProperty Matches -First 1 | 
            Select-String -Pattern $VersionPattern |
            Select-Object -ExpandProperty Matches -First 1 |
            Select-Object -ExpandProperty Value
        
        $app_filename = $SubsFilename.Replace('<REPLACE>',$app_version)

        $rgx = "<a href=`"https:\/\/..`*$($app_filename)"
        $rgx2 = "https:\/\/..`*$($app_filename)"

        $absolute_url = $AbsoluteUrl.Replace('<REPLACE>',$app_version)
        
        $resolved_url = Invoke-WebRequest -Uri $absolute_url | 
            Select-Object -ExpandProperty Links | 
            Where-Object -FilterScript {$_.outerHtml -match $rgx} |
            Select-Object -ExpandProperty outerHTML | 
            Select-String -Pattern $rgx2 | 
            Select-Object -ExpandProperty Matches -First 1 |
            Select-Object -ExpandProperty Value

        [System.String[]]$returnData = @($app_version,$app_filename,$resolved_url)
        return $returnData
    }
}

<#
Example
=======

$x = Get-MSDotNetPackageDetails -VersionUrl 'https://dotnet.microsoft.com/en-us/download/dotnet/6.0' `
-HtmlPattern '<button data-toggle="collapse".*<\/button>' `
-VersionPattern '6\.([\d{1,}\.]+)' `
-SubsFilename "aspnetcore-runtime-<REPLACE>-win-x64.exe" `
-AbsoluteUrl "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-<REPLACE>-windows-x64-installer"

#>