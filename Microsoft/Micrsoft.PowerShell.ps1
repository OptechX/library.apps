# Micrsoft.PowerShell
$pRoot = "./winget-pkgs/manifests/m/Micrsoft.PowerShell"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
