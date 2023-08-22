# Microsoft.PowerBI
$pRoot = "./winget-pkgs/manifests/m/Microsoft.PowerBI"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
