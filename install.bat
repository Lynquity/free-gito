@echo off
:: Überprüfen, ob die Batch-Datei mit Administratorrechten ausgeführt wird
net session >nul 2>&1
if not %errorlevel%==0 (
    echo Administratorrechte erforderlich. Starte die Batch-Datei mit Administratorrechten neu...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

REM Prüft, ob %1 leer ist
if "%~1"=="" (
    REM Kein Parameter angegeben – fragt den Benutzer ab
    set /p parameter="Bitte Parameter eingeben: "
) else (
    REM Andernfalls wird der übergebene Parameter verwendet
    set parameter=%~1
)
:: Überprüfen, ob die Datei 'gito.bat'
if not exist "%~dp0gito.bat" (
    echo Fehler: Die Datei 'gito.bat' wurde im Verzeichnis '...' nicht gefunden.
    pause
    exit /b
)

:: Überprüfen, ob das Zielverzeichnis 'C:\Windows\System32' existiert
if not exist "C:\Windows\System32" (
    echo Fehler: Zielverzeichnis 'C:\Windows\System32' existiert nicht.
    pause
    exit /b
)

:: Verschiebe die Datei 'gito.bat' in das Verzeichnis 'C:\Windows\System32'
echo Verschiebe 'gito.bat' nach 'C:\Windows\System32'...
move "%~dp0gito.bat" "C:\Windows\System32\"

:: Überprüfen, ob die Datei erfolgreich verschoben wurde
if exist "C:\Windows\System32\gito.bat" (
    echo Die Datei 'gito.bat' wurde erfolgreich nach 'C:\Windows\System32' verschoben!
) else (
    echo Fehler beim Verschieben der Datei 'gito.bat'.
)

:: Ruft die move.bat auf
call "%~dp0move.bat" "%parameter%"
