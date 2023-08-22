# Microsoft/Teams
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Teams"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
