# Microsoft.DownloadManager
$pRoot = "./winget-pkgs/manifests/m/Microsoft.DownloadManager"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
