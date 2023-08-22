# Microsoft.LAPS
$pRoot = "./winget-pkgs/manifests/m/Microsoft.LAPS"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
