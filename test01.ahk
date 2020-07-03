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

Run, %A_WorkingDir%/Hotkey Help.ahk

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
::zB::zum Beispiel ; <-- TAB is TriggerKey
::bsp::Beispiel ; <-- TAB is TriggerKey
::mfg::Mit freundlichen Grüßen `nWolfgang Heyden ; <-- TAB is TriggerKey
>+>^r:: ; <-- Script Reload mit richtiger CodePage rechts_Shift-rechts_Ctrl-r
{
  OSD("Script reloaded RCtrl-Rshift-r")
  sleep 3000
;  Reload  ; Assign Alt-Shift as a hotkey to restart the script.
  Run, %A_AhkPath% /restart /CP65001 %A_ScriptFullPath% ; Nachbildung von reload wegen Codepage
}

RAlt & c:: ; <-- Insert Copyright Sign
{
OSD("© einfügen")
Send ©
}
Return

;!^+d::
::date:: ; <-- Datum und Uhrzeit werden eingefügt
{
OSD("Datum und Uhrzeit einfügen")
FormatTime,Datum,,dd.MM.yy - HH:mm:ss
Send, %Datum% Uhr
}
Return

RShift & F11:: ; <-- CTRL drücken
{
  OSD("Ctrl-Down")
  SendInput,{Ctrl down}
}
Return

RShift & F12:: ; <-- CTRL loslassen
{
  OSD("Ctrl-Up")
  SendInput,{Ctrl up}
}
Return

::snip:: ; <-- (Thunderbird) : snip snap
{
  send, ==========snip=========={Enter}{Enter}==========snap=========={Home}{Up}
}
Return

::onlinehelp:: ; <-- Deutsche Online Hilfe <-- TAB is TriggerKey
RAlt & h:: ; <-- Deutsche Online Hilfe
RCtrl & h:: ; <-- Deutsche Online Hilfe
{
  OSD("Online Hilfe")
  run https://ahkde.github.io/docs/AutoHotkey.htm
}
Return

#IfWinActive ahk_class MozillaWindowClass
RShift & 1:: ; <-- (Thunderbird) : Hot Mail Subject "von Wolfgang"
{
  OSD("AUFMERKSAME MAIL")
  send 🔴🔴🔴ᴠᴏɴ Wᴏʟꜰɢᴀɴɢ❎❎❎
}
Return

::gw::Gruß Wolfgang ; (Thunderbird) : <-- TAB is TriggerKey
#IfWinActive

#IfWinActive Google Notizen - Google Chrome
::sss::(siehe Screenshot) ; (Chrome - Google Notizen) : <-- TAB is TriggerKey
#IfWinActive

RShift & 2:: ; <-- 3 Little Flowers
{
  OSD("Flowers")
  send 🌺🌻🌼
}
Return

RShift & 3:: ; <-- Eyes
{
  OSD("eyes")
  send 👀
}
Return

RShift & 5:: ; <-- 5 Stars
{
  OSD("Stars")
  send ⭐⭐⭐⭐⭐
}
Return

RShift & 4:: ; <-- Baum Haus Baum aus Consrade
{
  OSD("Baum-Haus-Baum aus Consrade")
  send 🌲🏡🌳ᴀᴜs Cᴏɴsʀᴀᴅᴇ
}
Return

RShift & 6:: ; <-- Baum Computer Baum
{
  OSD("Baum-Computer-Baum")
  send 🌲💻🌳
}
Return

RShift & 7:: ; <-- Ausrufezeichen Uhr Ausrufezeichen
{
  OSD("Ausrufezeichen Uhr Ausrufezeichen")
  send ❗⏰❗
}
Return



>+>^t:: ; <-- TOOGLE Windows Always On Top rechts_Shift-rechts_Ctrl-t
{
  OSD("TOOGLE Windows Always On Top")
  Winset, Alwaysontop, TOGGLE, A
}
return

;Beispiel mit ternary Operator
F7::Run,% (WinExist("ahk_exe Notepad.exe") ? "" : "Notepad.exe") ; <-- Test ternary Operator
