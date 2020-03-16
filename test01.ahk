/*
script name:        test01.ahk
last edit:          15-03-2020 19:38 by w.h.
short description:  Testdatei mit Hotkeys und Hotstrings
wie z.B.
zb --> zum Beispiel
bsp --> Beispiel
mfg --> Mit freundlichen Grüßen
Wolfgang Heyden
date --> Datum und Uhrzeit
onlinehelp --> Aufruf der Web-Seite https://ahkde.github.io/docs/AutoHotkey.htm
RCtrl & h --> ebenfalls Aufruf der Hilfe Webseite

Als Auslösetaste ist in allen Fällen die Tab-Taste vorgesehen. Mit
#Hotstring EndChars `t   ; reagiert nur auf [Tab] als End Zeichen
wird das eingestellt!
*/

;Auto-Refresh
SetTimer,UPDATEDSCRIPT,1000
UPDATEDSCRIPT:
FileGetAttrib,attribs,%A_ScriptFullPath%
IfInString,attribs,A
{
FileSetAttrib,-A,%A_ScriptFullPath%
SplashTextOn,,,Script wurde aktualisiert,
Sleep,1500
;Reload
;mit folgendem Befehl wird Reload nachgebildet,
;da Reload keine Parameter übergeben werden können
;aber die richtige Codepage übergeben werden MUSS!!
;wegen der deutschen Sonderzeichen!
Run, %A_AhkPath% /restart /CP65001 %A_ScriptFullPath%
;Run %ComSpec% /c ""C:\Program Files\AutoHotkey\AutoHotkey.exe" "/reload" "/CP65001" "c:\Users\wohey\Documents\EigeneBatchScripts\test01.ahk""
; funktioniert...: RunWait %ComSpec% /c ""C:\Program Files\AutoHotkey\AutoHotkey.exe" "/restart" "/CP65001" "c:\Users\wohey\Documents\EigeneBatchScripts\test01.ahk""
}
Return
;ENDE Autorefresh

;BEGIN Anzeige der Aktionen bei Tastenkombinationen
OSD(text)
{
#Persistent
Progress, hide x1050 Y900 b1 w200 h44 zh0 FM10 cwEEEEEE ct111111,, %text%, AutoHotKeyProgressBar, Verdana BRK
WinSet, TransColor, 000000 120, AutoHotKeyProgressBar
Progress, show
SetTimer, RemoveToolTip, 3000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
Progress, Off
return
}
;END Anzeige der Aktionen bei Tastenkombinationen

;STRG+ALT+SHIFT+WIN+N mit dem Start des Programms Notepad.
;^!+#n::run notepad.exe

/*
# = Windows-Taste
! = [Alt]-Taste
^ = [Strg]-Taste
+ = [Umschalt]-Taste
*/

#Hotstring EndChars `t   ; reagiert nur auf [Tab] als End Zeichen
::zB::zum Beispiel
::bsp::Beispiel
::mfg::Mit freundlichen Grüßen `nWolfgang Heyden
>+>^r:: ;rechts_Shift-rechts_Ctrl-r
{
  OSD("Script reloaded RCtrl-Rshift-r")
  sleep 3000
;  Reload  ; Assign Alt-Shift as a hotkey to restart the script.
  Run, %A_AhkPath% /restart /CP65001 %A_ScriptFullPath% ; Nachbildung von reload wegen Codepage
}
::test::test4711x2x3x4
RAlt & c::
{
OSD("© einfügen")
Send ©
}
Return
::Nest2::
{
  OSD("test4711 einfügen")
  Send test4711abcd
}
return

;!^+d::
::date::
{
OSD("Datum und Uhrzeit einfügen")
FormatTime,Datum,,dd.MM.yy - HH:mm:ss
Send, %Datum% Uhr
}
Return

::onlinehelp::
RAlt & h::
RCtrl & h::
{
  OSD("Online Hilfe")
  run https://ahkde.github.io/docs/AutoHotkey.htm
}
