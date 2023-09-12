# Google/Drive
$pRoot = "./winget-pkgs/manifests/g/Google/Drive"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
