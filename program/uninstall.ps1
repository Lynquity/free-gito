if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Administratorrechte erforderlich. Starte das Skript mit Administratorrechten neu..."
    Start-Process -FilePath "powershell" -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$gitoFile = "C:\Windows\System32\gito.bat"
if (Test-Path -Path $gitoFile) {
    Write-Output "Lösche 'gito.bat' aus 'C:\Windows\System32'..."
    Remove-Item -Path $gitoFile -Force
    if (-not (Test-Path -Path $gitoFile)) {
        Write-Output "Die Datei 'gito.bat' wurde erfolgreich gelöscht!"
    } else {
        Write-Output "Fehler beim Löschen der Datei 'gito.bat'."
    }
} else {
    Write-Output "Die Datei 'gito.bat' existiert nicht in 'C:\Windows\System32'."
}

$destinationDir = "C:\Windows\System32\ELW\gito"
if (Test-Path -Path $destinationDir) {
    Write-Output "Lösche das Verzeichnis '$destinationDir' und alle darin enthaltenen Dateien..."
    Remove-Item -Path $destinationDir -Recurse -Force
    if (-not (Test-Path -Path $destinationDir)) {
        Write-Output "Das Verzeichnis '$destinationDir' wurde erfolgreich gelöscht!"
    } else {
        Write-Output "Fehler beim Löschen des Verzeichnisses '$destinationDir'."
    }
} else {
    Write-Output "Das Verzeichnis '$destinationDir' existiert nicht."
}


