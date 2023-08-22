# Microsoft/OneDrive
$pRoot = "./winget-pkgs/manifests/m/Microsoft/OneDrive"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
