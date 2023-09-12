# GIGABYTE/AORUS-ENGINE
$pRoot = "./winget-pkgs/manifests/g/GIGABYTE/AORUS-ENGINE"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
