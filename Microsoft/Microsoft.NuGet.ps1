# Microsoft/NuGet
$pRoot = "./winget-pkgs/manifests/m/Microsoft/NuGet"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
