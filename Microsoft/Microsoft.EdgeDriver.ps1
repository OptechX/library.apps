# Microsoft/EdgeDriver
$pRoot = "./winget-pkgs/manifests/m/Microsoft/EdgeDriver"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
