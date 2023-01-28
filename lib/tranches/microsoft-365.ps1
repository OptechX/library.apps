# load classes
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPayload.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPackage.ps1)

# load functions
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGithubReleaseDownload.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetRedirectedUrl.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetMSDotNetPackageDetails.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGHDotNetPackageDetails.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/do-not-edit-below-this-line.ps1)

# set mapping path
$Env:applicationCategoryMappingPath = "Microsoft-365"

# set category Microsoft
$Env:applicationCategory = "Microsoft"
$ps1_files = Get-ChildItem -Path $Env:applicationCategoryMappingPath\app\Access -Recurse -Filter "*.ps1"
Write-Output "Matched $($ps1_files.Length) manifests"
foreach ($ps1_file in $ps1_files)
{
    Write-Output "Starting $($ps1_file.FullName)"
    try {
        . $ps1_file.FullName
    }
    catch {
        Write-Output "Error: $($_.Exception)"
    }
}
