# Grammarly/Grammarly
$pRoot = "./winget-pkgs/manifests/g/Grammarly/Grammarly"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
