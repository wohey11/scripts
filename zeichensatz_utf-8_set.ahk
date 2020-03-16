; Heben Sie die Kommentierung der entsprechenden Zeile auf oder lassen Sie sie alle kommentiert,
;   um den Standard des aktuellen Builds wiederherzustellen.  Je nach Bedarf anpassen:
; Zeichensatz := 0     ; Standard-ANSI-Zeichensatz des Systems
Zeichensatz := 65001 ; UTF-8
; Zeichensatz := 1200  ; UTF-16
; Zeichensatz := 1252  ; ANSI-Latin-1; Westeuropäisch (Windows)
if (Zeichensatz != "")
    Zeichensatz := " /CP" . Zeichensatz
Befehl="%A_AhkPath%"%Zeichensatz% "`%1" `%*
Key=AutoHotkeyScript\Shell\Open\Command
if A_IsAdmin    ; Für alle Benutzer setzen.
    RegWrite, REG_SZ, HKCR, %Key%,, %Befehl%
else            ; Nur für den aktuellen Benutzer setzen.
    RegWrite, REG_SZ, HKCU, Software\Classes\%Key%,, %Befehl%
