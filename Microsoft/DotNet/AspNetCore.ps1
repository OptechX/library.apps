# copyright symbol
$copyrightSymbol = [char]169

# DotNet/AspNetCore
$pRoot = "./winget-pkgs/manifests/m/Microsoft/DotNet/AspNetCore"
$versionMajor = Get-ChildItem -Path $pRoot -Directory
foreach ($thisVersion in $versionMajor)
{
    $versionMinor = Get-ChildItem -Path $thisVersion -Directory

    try {
        $sortedVersions = $versionMinor.Name | ForEach-Object { [Version]$_ } | Sort-Object -Descending
        $highestVersion = $sortedVersions[0]
        $currentVersion = [string]$highestVersion

        # locale data
        $yamlPath = Get-ChildItem -Path $thisVersion/$currentVersion -Filter "*locale.en-US.yaml" | Select-Object -ExpandProperty FullName
        $yamlContent = Get-Content -Path $yamlPath -Raw
        $yamlLocale = $yamlContent | ConvertFrom-Yaml

        # installer data
        $yamlPath = Get-ChildItem -Path $thisVersion/$currentVersion -Filter "*.installer.yaml" | Select-Object -ExpandProperty FullName
        $yamlContent = Get-Content -Path $yamlPath -Raw
        $yamlInstaller = $yamlContent | ConvertFrom-Yaml

        # icon url test
        $iconUrl = "https://github.com/OptechX/library.apps.images/raw/main/$($env:applicationCategory)/$($yamlLocale.Publisher)/$($yamlLocale.PackageIdentifier)/icon.svg"
        try {
            $response = Invoke-WebRequest -Uri $iconUrl -Method Head
            if ($response.StatusCode -eq 200)
            {
                $iconUri = $iconUrl
            }
            else
            {
                $iconUri = ""
            }
        } catch {
            $iconUri = ""
        }

        # switch manifest version from locale data
        switch ($yamlLocale.ManifestVersion)
        {
            "1.1.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            "1.2.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            "1.3.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            "1.4.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            "1.5.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            "1.6.0" {
                foreach ($arch in $yamlInstaller.Installers.Architecture)
                {
                    foreach ($arch in $yamlInstaller.Installers.Architecture)
                    {
                        switch ($arch)
                        {
                            "x64" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x64")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            "x86" {
                                $new_pkg = [applicationPackage]::new()
                                $new_pkg.uid = $yamlLocale.PackageIdentifier
                                $new_pkg.lastUpdate = Get-Date
                                $new_pkg.applicationCategory = $env:applicationCategory.ToUpper()
                                $new_pkg.publisher = $yamlLocale.Publisher
                                $new_pkg.name = $yamlLocale.PackageName
                                $new_pkg.version = $yamlLocale.PackageVersion
                                $new_pkg.copyright = if ($yamlLocale.Copyright) { $yamlLocale.Copyright } else { "Copyright ${copyrightSymbol} $($yamlLocale.Publisher) $((Get-Date).ToString("yyyy"))" }
                                $new_pkg.licenseAcceptRequired = $false
                                $new_pkg.lcid = if ($yamlLocale.PackageLocale -eq 'en-US') { @("EN_US") } else { @("MUI") }
                                $new_pkg.cpuArch = @("x86")
                                $new_pkg.homepage = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.icon = $iconUri
                                $new_pkg.docs = if ($yamlLocal.PackageUrl) { $yamlLocale.PackageUrl } elseif ($yamlLocale.PublisherUrl) { $yamlLocale.PublisherUrl } elseif ($yamlLocale.ReleaseNotesUrl) { $yamlLocale.ReleaseNotesUrl } else { "" }
                                $new_pkg.license = if ($yamlLocale.LicenseUrl) { $yamlLocale.LicenseUrl } else { switch ($yamlLocale.License) { "MIT" { "https://opensource.org/license/mit/" } Default { "" } } }
                                $new_pkg.tags =  if ($yamlLocale.Tags) { $yamlLocale.Tags } else { @("") }
                                $new_pkg.summary = $yamlLocale.ShortDescription
                
                                $new_pkg | ConvertTo-Json | Out-File -FilePath "${PSScriptRoot}/$($yamlLocale.PackageIdentifier)_$($new_pkg.CpuArch[0])_ingestScript.json" -Force -Confirm:$false -Encoding utf8
                            }
                            Default {
                                
                            }
                        }
                    }
                }
            }
            Default {
                "Version unknown"
            }
        }
    } catch { }
}




