CLS
@ECHO OFF
COLOR 1F
REM ****************************************************************************
REM ** SCRIPT      : FolderSync
REM ** BESCHREIBUNG: F�hrt die Synchronisation zweier Verzeichnisse durch (Inkrementell, Master/Slave!)
REM ** AUTOR       : Bj�rn Bastian (http://aufschnur.de)
REM ** VERSION     : 2016-03-03
REM **
REM ** HINWEISE    : - Ben�tigt ROBOCOPY (ab Windows Vista vorinstalliert)
REM **               - F�r Umlaute in ECHO: �=� �=� �=� �=� �=� �=�
REM ** last edit by wh: 09.03.2020 17:59:06
REM ****************************************************************************

CHCP 1252
REM KONFIGURATION ----------------------
REM Quell- und Zielverzeichnis angeben. WICHTIG:
REM Verzeichnisse die Leerzeichen enthalten m�ssen mit Anf�hrungszeichen umschlossen werden
REM Kein abschlie�ender Backslash \, au�er wenn komplettes Laufwerk syncronisiert werden soll
SET quelle=c:\Users\wohey\Documents
SET ziel=z:\Backups\Laptop\Documents
SET logfile="%userprofile%\AppData\Local\Temp\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
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
REM /mir	Spiegelt eine Verzeichnisstruktur wider (�quivalent zu /e und /Purge).
REM /purge	L�scht Zieldateien und-Verzeichnisse, die in der Quelle nicht mehr vorhanden sind.
REM /e	Kopiert Unterverzeichnisse. Beachten Sie, dass diese Option leere Verzeichnisse umfasst.
REM /m	Kopiert nur Dateien, f�r die das Archive -Attribut festgelegt ist, und setzt das Archiv Attribut zur�ck.
REM /Copy:<copyflags >	Gibt die zu kopierenden Dateieigenschaften an. Im folgenden sind die g�ltigen Werte f�r diese Option aufgef�hrt:
REM D- Daten
REM A -Attribute
REM T -Zeitstempel
REM S NTFS-Zugriffs Steuerungs Liste (ACL)
REM O -Besitzer Informationen
REM U -�berwachungsinformationen
REM Der Standardwert f�r copyflags ist DAT (Daten, Attribute und Zeitstempel).
REM /xjd	Schlie�t Verkn�pfungs Punkte f�r Verzeichnisse aus.
REM /eta	Zeigt die gesch�tzte Ankunftszeit (ETA) der kopierten Dateien an.

REM ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /m /R:3 /W:20 /LOG+:"%quelle%\log-%date:~0,2%-%date:~3,2%-%date:~6,4%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
ROBOCOPY %quelle% %ziel% /COPY:DAT /MIR /xjd /m /eta /R:3 /W:20 /LOG+:%logfile%
IF %ERRORLEVEL% GEQ 8 GOTO ERRCOPY
GOTO END

REM FEHLERBEHANDLUNG
:ERRCOPY
ECHO.
ECHO FEHLER: Mindestens eine Datei konnte nicht kopiert/gel�scht werden!
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
ECHO Dieses Fenster schliesst sich in 5 Sekunden.
ECHO.
ping -n 5 localhost >nul
xcopy %logfile% %ziel%
EXIT

REM HAPPY END
:END
COLOR 2F
ECHO.
ECHO VORGANG ERFOLGREICH ABGESCHLOSSEN
ECHO.
ECHO Dieses Fenster schliesst sich in 5 Sekunden.
ECHO.
ping -n 5 localhost >nul
xcopy %logfile% %ziel%
EXIT