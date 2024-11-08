if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # If not admin, restart PowerShell as admin
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"";
    $newProcess.Verb = "runas"; # Force PowerShell to run as administrator
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null;
    Exit;
}
$reponame = 
$branch = 
$url = 
$file_path =

$config_value = @{
    Version = "0.0.1"
    repo_name = $reponame
    branch = $branch
    clone_url = $url
    file_path = $file_path
}

$json = $config_value | ConvertTo-Json -Depth 3

$json |  Out-File -FilePath "./config.json" -Encoding utf8

Write-Host "config.json wurde erstellt"