# Mercurial/Mercurial
$pRoot = "./winget-pkgs/manifests/m/Mercurial/Mercurial"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
