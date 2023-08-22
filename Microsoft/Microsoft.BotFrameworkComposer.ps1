# Microsoft/BotFrameworkComposer
$pRoot = "./winget-pkgs/manifests/m/Microsoft/BotFrameworkComposer"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
