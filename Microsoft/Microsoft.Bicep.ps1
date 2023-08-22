# Microsoft/Bicep
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Bicep"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
