CLS
@ECHO OFF
COLOR 1F
REM ****************************************************************************
REM ** SCRIPT      : FolderSync_02
REM ** BESCHREIBUNG: Führt die Synchronisation zweier Verzeichnisse durch (Inkrementell, Master/Slave!)
REM ** AUTOR       : Björn Bastian (http://aufschnur.de)
REM ** VERSION     : 2016-03-03
REM **
REM ** HINWEISE    : - Benötigt ROBOCOPY (ab Windows Vista vorinstalliert)
REM ** last edit by wh: 09.12.2020 10:58:33
REM ** Aufruf: foldersync <quelle> <ziel> <ausgewähltes Verzeichnis> von TC aus:foldersync %P %T %N
REM ****************************************************************************
REM folgende Zeile für Umlaute in ECHO: ä=„ ö=” ü= Ä=Ž Ö=™ Ü=š
CHCP 1252
REM folgende Zeile eingefügt, damit %time% richtig angezeigt wird
SetLocal EnableDelayedExpansion

REM KONFIGURATION ----------------------
REM Quell- und Zielverzeichnis angeben. WICHTIG:
REM Verzeichnisse die Leerzeichen enthalten müssen mit Anführungszeichen umschlossen werden
REM Kein abschließender Backslash \, außer wenn komplettes Laufwerk syncronisiert werden soll
REM SET quelle=c:\Users\wohey\Documents
REM SET ziel=z:\Backups\Laptop\Documents
SET logfile="%userprofile%\AppData\Local\Temp\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET quelle=%1
SET ziel=%2
echo quelle: %quelle%
echo ziel: %ziel%
SET pfad="%~p1"
echo pfad: %pfad%
SET pfad2=%3
echo pfad2: %pfad2%
echo directory:  %quelle%%pfad2%
set directorybsl=%quelle%%pfad2%\
echo directorybsl: %directorybsl%
call c:\Users\wohey\Documents\EigeneBatchScripts\banner foldersync
rem here-document
for %%l in (
"Das Script kopiert (synchronisiert) ein Quellverzeichnis "
"zu einem Zielverzeichnis (mit allen Unterverzeichnissen),"
"die vom Totalcommander übergeben wurden."
"Die momentane Auswahl lautet:"
"Quelle: %quelle%%pfad2%"
"Ziel:   %ziel%"
"Im Quellverzeichnis wird bei allen Dateien das Archivbit gelöscht."
"Damit wird ein inkrementelles Backup möglich."
""
) do echo.%%~l & rem %%~l entfernt die Anführungszeichen
pause

REM Testen ob das verzeichnis existiert
if exist "%directorybsl%" echo directory existiert & mkdir %ziel%%pfad2%
if not exist "%directorybsl%" echo ACHTUNG,directory existiert nicht & pause & exit
pause
REM echo Soll das Archivbit im Quellverzeicnis gesetzt werden? (j/n):
set /p input=Soll das Archivbit im Quellverzeicnis gesetzt werden und damit ein FULL-Backup (KEIN inkrementelles) erzeugt werden? (j/n):
    if %input%==j (
    echo %time%
    attrib +a %quelle%%pfad2%\*.* /S /D
	echo %time%
	pause
)
REM neue Quelle ist das ausgewählte Verzeichnis im Totalcommander
SET quelle=%quelle%%pfad2%
echo neue Quelle: %quelle%
REM neues Ziel ist zielverzeichnis plus ausgewähltes Quellverzeichnis
SET ziel=%ziel%%pfad2%
echo neues Ziel: %ziel%
echo hiernach wird es ernst!
pause
REM exit
echo start: %time% >> %logfile%
REM ------------------------------------
REM CHCP 850
CLS

ECHO.
ECHO ++++++++++++++++++++++
ECHO +++ DATENSICHERUNG +++
ECHO ++++++++++++++++++++++
ECHO.

SET timestamp=%date:~-4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%

ECHO.
ECHO VERZEICHNISSE CHECKEN...
IF NOT EXIST %quelle% GOTO ERRSOURCE
IF NOT EXIST %ziel% GOTO ERRDEST

ECHO.
ECHO SYNCHRONISIERUNG STARTEN...
ECHO.
REM /mir	Spiegelt eine Verzeichnisstruktur wider (äquivalent zu /e und /Purge).
REM /purge	Löscht Zieldateien und-Verzeichnisse, die in der Quelle nicht mehr vorhanden sind.
REM /e	Kopiert Unterverzeichnisse. Beachten Sie, dass diese Option leere Verzeichnisse umfasst.
REM /m	Kopiert nur Dateien, für die das Archive -Attribut festgelegt ist, und setzt das Archiv Attribut zurück.
REM /Copy:<copyflags >	Gibt die zu kopierenden Dateieigenschaften an. Im folgenden sind die gültigen Werte für diese Option aufgeführt:
REM D- Daten
REM A -Attribute
REM T -Zeitstempel
REM S NTFS-Zugriffs Steuerungs Liste (ACL)
REM O -Besitzer Informationen
REM U -Überwachungsinformationen
REM Der Standardwert für copyflags ist DAT (Daten, Attribute und Zeitstempel).
REM /xjd	Schließt Verknüpfungs Punkte für Verzeichnisse aus.
REM /eta	Zeigt die geschätzte Ankunftszeit (ETA) der kopierten Dateien an.

REM ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /m /R:3 /W:20 /LOG+:"%quelle%\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
REM ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /xjd /m /eta /R:3 /W:20 /LOG+:%logfile%
ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /xjd /m /np /tee /R:3 /W:20 /LOG+:%logfile%
IF %ERRORLEVEL% GEQ 8 GOTO ERRCOPY
GOTO END

REM FEHLERBEHANDLUNG
:ERRCOPY
ECHO.
ECHO FEHLER: Mindestens eine Datei konnte nicht kopiert/gel”scht werden!
ECHO %timestamp%  FEHLER: Mindestens eine Datei konnte nicht kopiert/geloescht werden! >> "%logfile%"
GOTO ERREND
:ERRSOURCE
ECHO.
ECHO FEHLER: Quellverzeichnis nicht vorhanden!
ECHO %timestamp%  FEHLER: Quellverzeichnis nicht vorhanden! (%quelle%) >> "%logfile%"
GOTO ERREND
:ERRDEST
ECHO.
ECHO FEHLER: Zielverzeichnis nicht vorhanden!
ECHO %timestamp%  FEHLER: Zielverzeichnis nicht vorhanden! (%ziel%) >> "%logfile%"
GOTO ERREND

REM SHIT HAPPENS
:ERREND
COLOR 4F
ECHO.
ECHO VORGANG MIT FEHLERN ABGESCHLOSSEN
ECHO.
ECHO Dieses Fenster schliesst sich in 10 Sekunden.
ECHO.
ping -n 10 localhost >nul
echo stop: %time% >> %logfile%
xcopy %logfile% %ziel%
EXIT

REM HAPPY END
:END
COLOR 2F
ECHO.
ECHO VORGANG ERFOLGREICH ABGESCHLOSSEN
ECHO.
ECHO Dieses Fenster schliesst sich in 10 Sekunden.
ECHO.
ping -n 10 localhost >nul
echo stop: %time% >> %logfile%
xcopy %logfile% %ziel%
EXIT