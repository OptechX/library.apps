
$packs = 'All','Project','Standard','Visio'
$arches = @('32','64')
$channels = 'Current','MonthlyEnterprise','SemiAnnual'
foreach ($channel in $channels)
{
    foreach ($pack in $packs)
    {
        foreach ($arch in $arches)
        {
            $guid = [System.Guid]::NewGuid()

            $data = @"
<Configuration ID="${guid}">
  <Add OfficeClientEdition="${arch}" Channel="${channel}">
    <Product ID="O365BusinessRetail">
      <Language ID="MatchOS" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Excel" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="PowerPoint" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
      <ExcludeApp ID="Word" />
    </Product>
    <Product ID="VisioProRetail">
      <Language ID="MatchOS" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Excel" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="PowerPoint" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
      <ExcludeApp ID="Word" />
    </Product>
    <Product ID="ProjectProRetail">
      <Language ID="MatchOS" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Excel" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="PowerPoint" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
      <ExcludeApp ID="Word" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <AppSettings>
    <User Key="software\microsoft\office\16.0\excel\options" Name="defaultformat" Value="51" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" />
    <User Key="software\microsoft\office\16.0\powerpoint\options" Name="defaultformat" Value="27" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" />
    <User Key="software\microsoft\office\16.0\word\options" Name="defaultformat" Value="" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" />
  </AppSettings>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@

            $data | Out-File -FilePath "${PSScriptRoot}/Microsoft-365/lib/jig/Configuration-Business-x${arch}-${channel}-${pack}.xml"
        }
    }
}








Get-ChildItem -Path $PSScriptRoot/Microsoft-365/lib/jig -Filter *x32*.xml | ForEach-Object {
    $i = $_.FullName
    $j = $_.Name
    
    Rename-Item -Path $i -NewName $j.Replace('x32','x86')
}

$project = (16..29)
$visio = (30..44)
$standard = (16..44)

Get-ChildItem -Path $PSScriptRoot/Microsoft-365/lib/jig -Filter *.xml | ForEach-Object {
  $i = $_.FullName
  $j = $_.Name
  
  if ($i -like "*Visio*")
  {
    Get-Content -Path $i | Select-Object -SkipIndex $visio | Set-Content $i
  }
  if ($i -like "*Project*")
  {
    Get-Content -Path $i | Select-Object -SkipIndex $project | Set-Content $i
  }
  if ($i -like "*Standard*")
  {
    Get-Content -Path $i | Select-Object -SkipIndex $standard | Set-Content $i
  }

}

