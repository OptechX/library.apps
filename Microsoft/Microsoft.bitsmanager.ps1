# Microsoft.bitsmanager
$pRoot = "./winget-pkgs/manifests/m/Microsoft.bitsmanager"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
