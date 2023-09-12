# AirVPN/Eddie
$pRoot = "./winget-pkgs/manifests/a/AirVPN/Eddie"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
