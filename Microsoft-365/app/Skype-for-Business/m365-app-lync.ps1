if ($IsWindows)
{
    <# variables #>
    $app = "Lync"
    $regex = "^.`*${app}.`*`$"
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
        $xml_config = Invoke-WebRequest -Uri Invoke-WebRequest -Uri $json_uri -UseBasicParsing | 
            ConvertFrom-Json | 
            Select-Object -ExpandProperty "Current" | 
            Select-Object -ExpandProperty "XmlConfig" | 
            Select-Object -ExpandProperty "Enterprise" | 
            Select-Object -ExpandProperty $cpu_arch | 
            Select-Object -ExpandProperty "All"
        New-Item -Path C:\tmp -ItemType Directory -Name "office365" -Force -Confirm:$false
        Invoke-WebRequest -Uri $xml_config -UseBasicParsing -DisableKeepAlive -OutFile $o365_config_xml
    }


    <# Remove the app to ignore from Configuration.xml file #>
    if ($IsWindows)
    {
        (Get-Content -Path $o365_config_xml | Select-String -Pattern $regex -NotMatch) | Set-Content -Path $o365_config_xml
    }
}