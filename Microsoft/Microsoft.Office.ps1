# Microsoft/Office
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Office"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
