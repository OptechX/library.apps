function Get-GithubVersionFromTags {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
            )]
        [string]$Repo
    )

    PROCESS {
        $response = Invoke-RestMethod -Uri https://api.github.com/repos/$Repo/releases/latest
        $latestTag = $response[0].tag_name
        return $latestTag
    }
}
