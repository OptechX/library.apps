# Microsoft/AzureDataStudio
$pRoot = "./winget-pkgs/manifests/m/Microsoft/AzureDataStudio"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
