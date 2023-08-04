<# show list of user agent strings #>
[Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() | 
    Select-Object Name, @{n='UserAgent';e={ [Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name) }}

<# select user agent string and use #>
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
Invoke-WebRequest https://www.google.com -UserAgent $userAgent
