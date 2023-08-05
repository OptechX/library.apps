# Microsoft/IronPython3
$pRoot = "./winget-pkgs/manifests/m/Microsoft/IronPython/3"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
