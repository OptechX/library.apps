# Microsoft.MSIXCore
$pRoot = "./winget-pkgs/manifests/m/Microsoft.MSIXCore"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
