# load classes
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPayload.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath classes/applicationPackage.ps1)

# load functions
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetHighestVersion.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/NewWingetPkgJson.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/InvokeJsonBuilder.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGithubReleaseDownload.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGithubVersionFromTags.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/do-not-edit-below-this-line.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetRedirectedUrl.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetMSDotNetPackageDetails.ps1)
. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath functions/GetGHDotNetPackageDetails.ps1)

# set category Microsoft
$Env:applicationCategory = "Microsoft"

# clone winget directory
git clone https://github.com/microsoft/winget-pkgs.git
try {
    Remove-Item -Path ./winget-pkgs/.git -Recurse -Force -ErrorAction SilentlyContinue
}
catch {
    
}

# install PowerShell-Yaml module
Install-Module -Name PowerShell-Yaml -Force

# process ps1 files
$ps1_files = Get-ChildItem -Path $Env:applicationCategory -Recurse -Filter "*.ps1"
Write-Output "Matched $($ps1_files.Length) manifests"
foreach ($ps1_file in $ps1_files)
{
    Write-Output "Starting $($ps1_file.FullName)"
    . $ps1_file.FullName
}

# execute update
Get-ChildItem -Path ./lib/functions -Recurse -Filter "*.json" | Where-Object { $_.Name -match 'x86_ingestScript.json|x64_ingestScript.json' } | ForEach-Object { Move-Item -Path $_.FullName -Destination $Env:applicationCategory/ -Force -Confirm:$false }
$json_files = Get-ChildItem -Path $Env:applicationCategory -Recurse -Filter "*.json" | Where-Object { $_.Name -match 'x86_ingestScript.json|x64_ingestScript.json' }
foreach ($json_file in $json_files)
{
    Write-Output "Starting $($json_file.FullName)"
    #& ./bin/oxlaut --json "${json_file}"
}
