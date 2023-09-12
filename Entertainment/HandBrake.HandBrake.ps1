# HandBrake/HandBrake
$pRoot = "./winget-pkgs/manifests/h/HandBrake/HandBrake"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
