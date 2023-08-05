# Microsoft/Edge
$pRoot = "./winget-pkgs/manifests/m/Microsoft/Edge"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

Invoke-JsonBuilder -VersionMajor $versionMajor
