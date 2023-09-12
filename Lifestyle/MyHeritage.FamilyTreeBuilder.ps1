# MyHeritage/FamilyTreeBuilder
$pRoot = "./winget-pkgs/manifests/m/MyHeritage/FamilyTreeBuilder"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
