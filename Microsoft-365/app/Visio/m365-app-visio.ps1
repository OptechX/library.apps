if ($IsWindows)
{
    <# variables #>
    $app = "Visio"


    <# set OS arch #>
    if ([System.Environment]::Is64BitOperatingSystem)
    {
        $cpu_arch = "x64"
    }
    else
    {
        $cpu_arch = "x86"
    }


    Write-Output "This file does nothing. It's a placeholder only."
    Write-Output "Used for ${app} on WinOS ${cpu_arch}"
}
