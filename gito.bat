@echo off

if %1 == "--uninstall" (
    powershell -ExecutionPolicy Bypass -File "C:/Windows/System32/ELW/gito/program/uninstall.ps1"
)

python C:/Windows/System32/ELW/gito/program/main.py

