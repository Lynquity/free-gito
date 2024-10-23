@echo off

if "%1"=="-b" (
echo %1
echo %2
echo %3
echo %4

if not "%5"=="" (
	echo Fehler: Es muss in anführungs und schlusszeichen gesetzt sein
	exit /b 1
)
if "%~2"=="" (
	echo Fehler: Der zweite Parameter muss in Anführungszeichen stehen!
	exit /b 1
)

echo Erster Parameter: %2
echo Zweiter Parameter: %4
) else (
	echo Fehler: keinen Branch angegeben
	exit /b 1
)

