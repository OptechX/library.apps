# MusicBee/MusicBee
$pRoot = "./winget-pkgs/manifests/m/MusicBee/MusicBee"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
