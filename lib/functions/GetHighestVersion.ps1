function Get-HighestVersion {
    param (
        [string[]]$Versions
    )

    $maxVersion = $null

    foreach ($version in $Versions) {
        $versionComponents = $version.Split('.') | ForEach-Object { [int]$_ }
        
        if ($null -eq $maxVersion -or ($versionComponents -join '') -gt ($maxVersion -join '')) {
            $maxVersion = $versionComponents
        }
    }

    return $maxVersion -join '.'
}