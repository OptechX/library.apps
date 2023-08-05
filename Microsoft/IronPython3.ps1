# Microsoft/IronPython3
$pRoot = "./winget-pkgs/manifests/m/Microsoft/IronPython/3"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

Invoke-JsonBuilder -VersionMajor $versionMajor
