# Mojang.MinecraftLauncher
$pRoot = "./winget-pkgs/manifests/m/Mojang/MinecraftLauncher"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
