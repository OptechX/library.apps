# Adobe/Acrobat/Reader/32-bit
$pRoot = "./winget-pkgs/manifests/a/Adobe/Acrobat/Reader/32-bit"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
