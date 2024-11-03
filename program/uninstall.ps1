if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # If not admin, restart PowerShell as admin
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"";
    $newProcess.Verb = "runas"; # Force PowerShell to run as administrator
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null;
    Exit;
}

$path1 = "C:\Windows\System32\ELW\gito"
$path2 = "C:\Windows\System32\gito.bat"

if (Test-Path -Path $path1) 
{
    Remove-Item -Path $path1 -Recurse -Force
    Write-Output "Remove"
}

if (Test-Path -Path $path2)
{
    Remove-Item -Path $path2  -Force
    Write-Output "Remove"
}
