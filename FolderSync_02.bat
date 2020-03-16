CLS
@ECHO OFF
COLOR 1F
REM ****************************************************************************
REM ** SCRIPT      : FolderSync_02
REM ** BESCHREIBUNG: F¸hrt die Synchronisation zweier Verzeichnisse durch (Inkrementell, Master/Slave!)
REM ** AUTOR       : Bjˆrn Bastian (http://aufschnur.de)
REM ** VERSION     : 2016-03-03
REM **
REM ** HINWEISE    : - Benˆtigt ROBOCOPY (ab Windows Vista vorinstalliert)
REM **               - F¸r Umlaute in ECHO: ‰=Ñ ˆ=î ¸=Å ƒ=é ÷=ô ‹=ö
REM ** last edit by wh: 10.03.2020 18:07:15
REM ** Aufruf: foldersync <quelle> <ziel> <ausgew‰hltes Verzeichnis> von TC aus:foldersync %P %T %N
REM ****************************************************************************

CHCP 1252
REM KONFIGURATION ----------------------
REM Quell- und Zielverzeichnis angeben. WICHTIG:
REM Verzeichnisse die Leerzeichen enthalten m¸ssen mit Anf¸hrungszeichen umschlossen werden
REM Kein abschlieﬂender Backslash \, auﬂer wenn komplettes Laufwerk syncronisiert werden soll
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
"die vom Totalcommander ¸bergeben wurden."
"Die momentane Auswahl lautet:"
"Quelle: %quelle%%pfad2%"
"Ziel:   %ziel%"
"Im Quellverzeichnis wird bei allen Dateien das Archivbit gelˆscht."
"Damit wird ein inkrementelles Backup mˆglich."
""
) do echo.%%~l & rem %%~l entfernt die Anf¸hrungszeichen    
pause

REM Testen ob das verzeichnis existiert
if exist "%directorybsl%" echo directory existiert & mkdir %ziel%%pfad2%
if not exist "%directorybsl%" echo ACHTUNG,directory existiert nicht & pause & exit
pause
REM echo Soll das Archivbit im Quellverzeicnis gesetzt werden? (j/n):
set /p input=Soll das Archivbit im Quellverzeicnis gesetzt werden? (j/n):
    if %input%==j (
    echo %time%
    attrib +a %quelle%%pfad2%\*.* /S /D
	echo %time%
	pause
)
REM neue Quelle ist das ausgew‰hlte Verzeichnis im Totalcommander
SET quelle=%quelle%%pfad2%
echo neue Quelle: %quelle%
REM neues Ziel ist zielverzeichnis plus ausgew‰hltes Quellverzeichnis
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
REM /mir	Spiegelt eine Verzeichnisstruktur wider (‰quivalent zu /e und /Purge).
REM /purge	Lˆscht Zieldateien und-Verzeichnisse, die in der Quelle nicht mehr vorhanden sind.
REM /e	Kopiert Unterverzeichnisse. Beachten Sie, dass diese Option leere Verzeichnisse umfasst.
REM /m	Kopiert nur Dateien, f¸r die das Archive -Attribut festgelegt ist, und setzt das Archiv Attribut zur¸ck.
REM /Copy:<copyflags >	Gibt die zu kopierenden Dateieigenschaften an. Im folgenden sind die g¸ltigen Werte f¸r diese Option aufgef¸hrt:
REM D- Daten
REM A -Attribute
REM T -Zeitstempel
REM S NTFS-Zugriffs Steuerungs Liste (ACL)
REM O -Besitzer Informationen
REM U -‹berwachungsinformationen
REM Der Standardwert f¸r copyflags ist DAT (Daten, Attribute und Zeitstempel).
REM /xjd	Schlieﬂt Verkn¸pfungs Punkte f¸r Verzeichnisse aus.
REM /eta	Zeigt die gesch‰tzte Ankunftszeit (ETA) der kopierten Dateien an.

REM ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /m /R:3 /W:20 /LOG+:"%quelle%\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
REM ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /xjd /m /eta /R:3 /W:20 /LOG+:%logfile%
ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /xjd /m /np /tee /R:3 /W:20 /LOG+:%logfile%
IF %ERRORLEVEL% GEQ 8 GOTO ERRCOPY
GOTO END

REM FEHLERBEHANDLUNG
:ERRCOPY
ECHO.
ECHO FEHLER: Mindestens eine Datei konnte nicht kopiert/gelîscht werden!
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