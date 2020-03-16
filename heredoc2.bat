@echo off
:intc_version:
for %%l in (
    "File         : %_SCRIPT_NAME%"
    "Version      : %_VERSION%"
    "Company      : %_COMPANY%"
    "License      : %_LICENSE%"
    "Description  : %_DESCRIPTION%"
    "mal sehen..."
    "und hier mal äöü"
    "File         : %0"
) do echo.%%~l &rem %%~l entfernt die Anführungszeichen

rem /B  When used in a batch script, this option will exit only the script (or subroutine) but not CMD.EXE
exit /B 0
