@echo off

if "%1"=="--delete" (
	powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\ELW\gito\uninstall.ps1"
)
python C:\Windows\System32\program\main.py

