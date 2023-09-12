# Hashicorp/Terraform
$pRoot = "./winget-pkgs/manifests/h/Hashicorp/Terraform"
$versionMajor = Get-ChildItem -Path $pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor $versionMajor
}
catch {

}
