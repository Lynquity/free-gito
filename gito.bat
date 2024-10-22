@echo off

if "%1" == "" (
     PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\error.ps1"
) else (
     PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\gitomodule.ps1" "%1"
)