# Hashicorp/Vagrant
$pRoot = "./winget-pkgs/manifests/h/Hashicorp/Vagrant"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
