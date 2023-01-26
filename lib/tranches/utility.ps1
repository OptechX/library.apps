# load classes
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPayload.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPackage.ps1)

# load functions
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGithubReleaseDownload.ps1)

# set category Utility
$Env:applicationCategory = "Utility"
$ps1_files = Get-ChildItem -Path $Env:applicationCategory -Recurse -Filter "*.ps1"
Write-Output "Matched $($ps1_files.Length) manifests"
foreach ($ps1_file in $ps1_files)
{
    Write-Output "Starting $($ps1_file.FullName)"
    . $ps1_file.FullName
}
