# Adobe/Acrobat/Reader/64-bit
$pRoot = "./winget-pkgs/manifests/a/Adobe/Acrobat/Reader/64-bit"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
