/*
script name:        ContextSensiveHelp.ahk
last edit:          15-03-2020 16:01 by w.h.
short description:  Script wurde auf die deutsche Hilfedatei angepasst
*/



/*
ACHTUNG ! ! !
wenn z. B. der Windows-Titel Umlaute enthält muss dafür gesorgt werden,
daß die Codepage mit der das Script vom Editor gespeichert wird,
dieselbe ist, mit der der Scriptinterpreter gestartet wird.
Für den Start durch Doppelclick im Windowsexplorer oder im Totalcommander,
läßt sich das durch Registry-Einträge mit folgendem Script erledigen,
welches natürlich vor dem Start des Scripts mit den Umlauten
abgefahren werden muss:
; Heben Sie die Kommentierung der entsprechenden Zeile auf oder lassen Sie sie alle kommentiert,
;   um den Standard des aktuellen Builds wiederherzustellen.  Je nach Bedarf anpassen:
; Zeichensatz := 0     ; Standard-ANSI-Zeichensatz des Systems
; Zeichensatz := 65001 ; UTF-8
; Zeichensatz := 1200  ; UTF-16
Zeichensatz := 1252  ; ANSI-Latin-1; Westeuropäisch (Windows)
if (Zeichensatz != "")
    Zeichensatz := " /CP" . Zeichensatz
Befehl="%A_AhkPath%"%Zeichensatz% "`%1" `%*
Key=AutoHotkeyScript\Shell\Open\Command
if A_IsAdmin    ; Für alle Benutzer setzen.
    RegWrite, REG_SZ, HKCR, %Key%,, %Befehl%
else            ; Nur für den aktuellen Benutzer setzen.
    RegWrite, REG_SZ, HKCU, Software\Classes\%Key%,, %Befehl%
*/

;Auto-Refresh
SetTimer,UPDATEDSCRIPT,1000
UPDATEDSCRIPT:
FileGetAttrib,attribs,%A_ScriptFullPath%
IfInString,attribs,A
{
FileSetAttrib,-A,%A_ScriptFullPath%
SplashTextOn,,,Script wurde aktualisiert,
Sleep,500
;Reload
;mit folgendem Befehl wird Reload nachgebildet,
;da Reload keine Parameter übergeben werden können
;aber die richtige Codepage übergeben werden MUSS!!
;wegen der deutschen Sonderzeichen!
Run, %A_AhkPath% /restart /CP65001 %A_ScriptFullPath%
}
Return
;ENDE Autorefresh



; Context Sensitive Help in Any Editor -- by Rajat
; http://www.autohotkey.com
; This script makes Ctrl+2 (or another hotkey of your choice) show the help file
; page for the selected AutoHotkey command or keyword. If nothing is selected,
; the command name will be extracted from the beginning of the current line.

; The hotkey below uses the clipboard to provide compatibility with the maximum
; number of editors (since ControlGet doesn't work with most advanced editors).
; It restores the original clipboard contents afterward, but as plain text,
; which seems better than nothing.

$^2::
; The following values are in effect only for the duration of this hotkey thread.
; Therefore, there is no need to change them back to their original values
; because that is done automatically when the thread ends:
SetWinDelay 10
SetKeyDelay 0
AutoTrim, On

if A_OSType = WIN32_WINDOWS  ; Windows 9x
	Sleep, 500  ; Give time for the user to release the key.

C_ClipboardPrev = %clipboard%
clipboard =
; Use the highlighted word if there is one (since sometimes the user might
; intentionally highlight something that isn't a command):
Send, ^c
ClipWait, 0.1
if ErrorLevel <> 0
{
	; Get the entire line because editors treat cursor navigation keys differently:
	Send, {home}+{end}^c
	ClipWait, 0.2
	if ErrorLevel <> 0  ; Rare, so no error is reported.
	{
		clipboard = %C_ClipboardPrev%
		return
	}
}
C_Cmd = %clipboard%  ; This will trim leading and trailing tabs & spaces.
clipboard = %C_ClipboardPrev%  ; Restore the original clipboard for the user.
Loop, parse, C_Cmd, %A_Space%`,  ; The first space or comma is the end of the command.
{
	C_Cmd = %A_LoopField%
	break ; i.e. we only need one interation.
}
;IfWinNotExist, AutoHotkey Help
IfWinNotExist, Hilfe für AutoHotkey
{
	; Determine AutoHotkey's location:
	RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
	if ErrorLevel  ; Not found, so look for it in some other common locations.
	{
		if A_AhkPath
			SplitPath, A_AhkPath,, ahk_dir
		else IfExist ..\..\AutoHotkey.chm
			ahk_dir = ..\..
		else IfExist %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
			ahk_dir = %A_ProgramFiles%\AutoHotkey
		else
		{
			MsgBox Could not find the AutoHotkey folder.
			return
		}
	}
	Run %ahk_dir%\AutoHotkey.chm
;  Sleep, 3000
;	WinWait AutoHotkey Help
;Achtung MsgBox wartet auf eine Eingabe und eignet sich deshalb nur bedingt als Testausgabe
;	MsgBox Waiting for Hilfe für AutoHotkey.
;mit folgendem Parameter funktioniert das, weil die MsgBox nach 5 sec automatisch geschlossen wird
;sodas das Programmm fortgesetzt wird, 4100 bedeutet Vordergrund und Ja/Nein
;MsgBox, 4, , Vierparametermodus: Diese MsgBox wird in 5 Sekunden automatisch geschlossen.  Weiter?, 5
MsgBox, 4100, , Vierparametermodus: Diese MsgBox wird in 5 Sekunden automatisch geschlossen.  Weiter?, 5
	WinWait Hilfe für AutoHotkey
}
; The above has set the "last found" window which we use below:
WinActivate
WinWaitActive
StringReplace, C_Cmd, C_Cmd, #, {#}
Send, !n{home}+{end}%C_Cmd%{enter}
return
