@echo off
rem Backup des kompletten Verzeichnisses

echo "******************* Backup des Laufwerks g: nach v: **************************"

"c:\Windows\system32\robocopy.exe" "g:" "v:" /Copyall /E /B /R:3 /W:10 /XD "System Volume Information" /XD "$recycle.bin" /LOG+:"c:\Logfiles\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"