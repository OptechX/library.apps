# Microsoft/Edge
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Edge"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
