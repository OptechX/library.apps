# Microsoft.PowerToys
$pRoot = "./winget-pkgs/manifests/m/Microsoft.PowerToys"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
