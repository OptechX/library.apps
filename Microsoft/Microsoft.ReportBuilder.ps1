# Microsoft.ReportBuilder
$pRoot = "./winget-pkgs/manifests/m/Microsoft.ReportBuilder"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
