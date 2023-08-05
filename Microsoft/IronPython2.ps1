# Microsoft/IronPython2
$pRoot = "./winget-pkgs/manifests/m/Microsoft/IronPython/2"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

Invoke-JsonBuilder -VersionMajor $versionMajor
