# Microsoft/Git
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Git"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

# build version major
$versionList = New-Object System.Collections.Generic.List[Version]
foreach ($iVersion in $versionMajor)
{
    try {
        $i = [Version]$iVersion.Name
        $versionList.Add($i)
    }
    catch {

    }
}
if ($versionList.Count -ge 1)
{
    $sortedVersions = $versionList | Sort-Object -Descending
    $highestVersion = $sortedVersions[0]
    $currentVersion = [string]$highestVersion
    
    # locale data
    $yamlPath = Get-ChildItem -Path $pRoot/$currentVersion -Filter "*locale.en-US.yaml" | Select-Object -ExpandProperty FullName
    $yamlContent = Get-Content -Path $yamlPath -Raw
    $yamlLocale = $yamlContent | ConvertFrom-Yaml
    
    # installer data
    $yamlPath = Get-ChildItem -Path $pRoot/$currentVersion -Filter "*.installer.yaml" | Select-Object -ExpandProperty FullName
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
    } 
    catch {
        $iconUri = ""
    }
    
    # build the json output
    if ($yamlInstaller.Installers)
    {
        foreach ($arch in $yamlInstaller.Installers.Architecture)
        {
            if ($arch -eq "x86" -or $arch -eq "x64")
            {
                $arch
                New-WingetPkgJson -YamlObj $yamlLocale -Category $env:applicationCategory -IconLink $iconUri -Arch $arch -OutDir $PSScriptRoot
            }
        }
    }    
}

# build version minor
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
        } 
        catch {
            $iconUri = ""
        }

        # build the json output
        if ($yamlInstaller.Installers)
        {
            foreach ($arch in $yamlInstaller.Installers.Architecture)
            {
                if ($arch -eq "x86" -or $arch -eq "x64")
                {
                    New-WingetPkgJson -YamlObj $yamlLocale -Category $env:applicationCategory -IconLink $iconUri -Arch $arch -OutDir $PSScriptRoot
                }
            }
        }
    }
    catch {

    }
}


