# Mega/MEGASync
$pRoot = "./winget-pkgs/manifests/m/Mega/MEGASync"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
