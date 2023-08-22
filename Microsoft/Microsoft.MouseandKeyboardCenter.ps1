# Microsoft/MouseandKeyboardCenter
$pRoot = "./winget-pkgs/manifests/m/Microsoft/MouseandKeyboardCenter"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
