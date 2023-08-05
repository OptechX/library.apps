function New-WingetPkgJson {
    param (
        [PSCustomObject]$YamlObj,
        [string]$Category,
        [string]$IconLink,
        [string]$Arch,
        [string]$OutDir
    )

    begin {
        class applicationPackage {
            [System.Int16]$id = 0
            [System.String]$uid = [string]::Empty
            [System.DateTime]$lastUpdate
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
            [AllowNull()][System.String]$bannerIcon
        }
    }

    process {
        # create new package
        $new_pkg = [applicationPackage]::new()
        $new_pkg.uid = $YamlObj.PackageIdentifier
        $new_pkg.lastUpdate = Get-Date
        $new_pkg.applicationCategory = $Category.ToUpper()
        $new_pkg.publisher = $YamlObj.Publisher
        $new_pkg.name = $YamlObj.PackageName
        $new_pkg.version = $YamlObj.PackageVersion
        $new_pkg.copyright = if ($YamlObj.Copyright) { $YamlObj.Copyright } else { "Copyright $([char]169) $($YamlObj.Publisher) $((Get-Date).ToString("yyyy"))" }
        $new_pkg.licenseAcceptRequired = $false
        $new_pkg.lcid = if ($YamlObj.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
        $new_pkg.cpuArch = @("$($Arch)")
        $new_pkg.homepage = if ($YamlObj.PackageUrl) { $YamlObj.PackageUrl } elseif ($YamlObj.PublisherUrl) { $YamlObj.PublisherUrl } elseif ($YamlObj.ReleaseNotesUrl) { $YamlObj.ReleaseNotesUrl } else { "TBA" }
        $new_pkg.icon = $IconLink
        $new_pkg.docs = if ($YamlObj.PackageUrl) { $YamlObj.PackageUrl } elseif ($YamlObj.PublisherUrl) { $YamlObj.PublisherUrl } elseif ($YamlObj.ReleaseNotesUrl) { $YamlObj.ReleaseNotesUrl } else { "TBA" }
        $new_pkg.tags =  if ($YamlObj.Tags) { $YamlObj.Tags } else { @("") }
        $new_pkg.summary = if ($YamlObj.Description) { $YamlObj.Description } else { $YamlObj.ShortDescription }

        if ($YamlObj.LicenseUrl)
        {
            $new_pkg.license = $YamlObj.LicenseUrl
        }
        else
        {
            switch ($YamlObj.License)
            {
                "MIT" { $new_pkg.license = "https://opensource.org/license/mit/" }
                "Microsoft Software License" { $new_pkg.license = "https://www.microsoft.com/en-us/servicesagreement/" }
                "GPLv2" { $new_pkg.license = "https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1" }
                Default { $new_pkg.license = "TBA" }
            }
        }

        $new_pkg | ConvertTo-Json | Out-File -FilePath "${OutDir}/$($YamlObj.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
    }
}
