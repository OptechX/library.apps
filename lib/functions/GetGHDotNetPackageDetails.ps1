function Get-GHDotNetPackageDetails()
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
        [regex]$VersionPattern,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2
            )]
        [string]$SubsFilename,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 3
            )]
        [string]$AbsoluteUrl
    )

    PROCESS {
        $version_url = $VersionUrl
        $app_version = (Split-Path -Path ([System.Net.WebRequest]::CreateDefault($version_url)).GetResponse().ResponseUri.OriginalString -Leaf | 
            Select-String -Pattern $VersionPattern |
            Select-Object -ExpandProperty Matches -First 1 | 
            Select-Object -ExpandProperty Value).TrimEnd('.')
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

$x = Get-GHDotNetPackageDetails -VersionUrl 'https://github.com/dotnet/runtime/releases/latest' `
-VersionPattern '7\.([\d{1,}\.]+)' `
-SubsFilename "windowsdesktop-runtime-<REPLACE>-win-x64.exe" `
-AbsoluteUrl "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-<REPLACE>-windows-x64-installer"

#>
