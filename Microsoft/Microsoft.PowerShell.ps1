# Microsoft.PowerShell
$pRoot = "./winget-pkgs/manifests/m/Microsoft.PowerShell"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
