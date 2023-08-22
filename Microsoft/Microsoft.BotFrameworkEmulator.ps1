# Microsoft/BotFrameworkEmulator
$pRoot = "./winget-pkgs/manifests/m/Microsoft/BotFrameworkEmulator"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
