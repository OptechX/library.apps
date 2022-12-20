<# variables #>
$app = "Business Project Current"
$m365_project_base = "https://raw.githubusercontent.com/OptechX/library.apps/main/Microsoft-365"
$json_uri = "${m365_project_base}/config/config.json"
$o365_config_xml = "C:\tmp\office365\Configuration.xml"


<# set OS arch #>
if ([System.Environment]::Is64BitOperatingSystem)
{
    $cpu_arch = "x64"
}
else
{
    $cpu_arch = "x86"
}


<# check if Configuration.xml file exist, else download #>
if (-not(Test-Path -Path $o365_config_xml))
{
    $xml_config = Invoke-WebRequest -Uri $json_uri -UseBasicParsing -DisableKeepAlive | 
        ConvertFrom-Json | 
        Select-Object -ExpandProperty $app.Split(' ')[2] | 
        Select-Object -ExpandProperty "XmlConfig" | 
        Select-Object -ExpandProperty $app.Split(' ')[0] | 
        Select-Object -ExpandProperty $cpu_arch | 
        Select-Object -ExpandProperty $app.Split(' ')[1]
    New-Item -Path C:\tmp -ItemType Directory -Name "office365" -Force -Confirm:$false
    Invoke-WebRequest -Uri $xml_config -UseBasicParsing -DisableKeepAlive -OutFile $o365_config_xml
}


<# Remove the app to ignore from Configuration.xml file #>
[System.String[]]$apps_to_remain = 'Access','Exce','OneNote','Outlook','PowerPoint','Publisher','Word'
foreach ($app in $apps_to_remain)
{
    $regex = "^.`*${app}.`*`$"
    (Get-Content -Path $o365_config_xml | Select-String -Pattern $regex -NotMatch) | Set-Content -Path $o365_config_xml
}
