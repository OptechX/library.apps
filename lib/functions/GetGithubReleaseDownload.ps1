function Get-GithubReleaseDownload {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
            )]
        [string]$GithubUrl,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
            )]
        [string]$FileName
    )

    PROCESS {
        $url = $GithubUrl
        $request = [System.Net.WebRequest]::Create($url)
        $response = $request.GetResponse()
        $realTagUrl = $response.ResponseUri.OriginalString
        $version = $realTagUrl.split('/')[-1].Trim('v')

        # replace the word "(VERSION)" in the filename with the version from GitHub
        $newFileName = $FileName.Replace("(VERSION)",$version)
        $realDownloadUrl = $realTagUrl.Replace('tag', 'download') + '/' + $newFileName

        [string[]]$returnData = @($version,$realDownloadUrl)
        return $returnData
    }
}