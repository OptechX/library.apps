# Microsoft.PowerAppsCLI
$pRoot = "./winget-pkgs/manifests/m/Microsoft.PowerAppsCLI"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
