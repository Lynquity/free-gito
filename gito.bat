@echo off

if "%1"=="--delete" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\uninstall.ps1"
) else if "%1"=="sync" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\sync.ps1"

) else (
    C:\Windows\System32\ELW\gito\main.exe
)
