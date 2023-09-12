# Acronis/CyberProtectHomeOffice
$pRoot = "./winget-pkgs/manifests/a/Acronis/CyberProtectHomeOffice"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
