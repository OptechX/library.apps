# Microsoft.DirectX
$pRoot = "./winget-pkgs/manifests/m/Microsoft.DirectX"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
