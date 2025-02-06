@echo off

if "%1"=="--delete" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\uninstall.ps1"
) else if "%1"=="-v" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\version.ps1"
) else if "%1"=="--version" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\version.ps1"
) else if "%1"=="m" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\checkversion.ps1"
    C:\Windows\System32\ELW\gito\more.exe
) else if "%1"=="a" (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\checkversion.ps1"
    C:\Windows\System32\ELW\gito\ai.exe
) else (
    powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\checkversion.ps1"
    C:\Windows\System32\ELW\gito\main.exe
)
