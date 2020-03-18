/*

last edit: 15-03-2020 15:43

  by w.h.
*/

/*
script name:        x
last edit:           by w.h.
short description:
*/

/*
script name:        test007.ahk
last edit:          ${2:"shift-ctrl-d for date" by w.h.
short description:
*/

/*
script name:        test007.ahk
last edit:          15-03-2020 15:57 by w.h.
short description:  das war ein Test4711x2x3x4 für das neue ahk snippet
*/

/*
script name:        test007.ahk
last edit:          15-03-2020 15:59 by w.h.
short description:
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
;Run %ComSpec% /c ""C:Program FilesAutoHotkeyAutoHotkey.exe" "/reload" "/CP65001" "c:UserswoheyDocumentsEigeneBatchScripts	est01.ahk""
; funktioniert...: RunWait %ComSpec% /c ""C:Program FilesAutoHotkeyAutoHotkey.exe" "/restart" "/CP65001" "c:UserswoheyDocumentsEigeneBatchScripts	est01.ahk""
}
Return
;END Autorefresh


;BEGIN OSD
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
;END OSD
