# Microsoft/Git
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Git"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}