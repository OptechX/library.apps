function Invoke-CreatePackage {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string]$Branch
    )
    
    $source_string = @"
# $name
`$pRoot = "./winget-pkgs/manifests/m/$name"
`$versionMajor = Get-ChildItem -Path `$pRoot -Directory

try {
    Invoke-JsonBuilder -VersionMajor `$versionMajor
}
catch {

}
"@
    $source_string | Set-Content -Path "${Branch}/$($name.Replace("/",".")).ps1" -Force -Confirm:$false
}