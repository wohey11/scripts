
; *********************** Header - some configuration  ***********************
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors. (disabled by default)
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
setTitleMatchMode, 2 ; set title match mode to "contains"

; this code was auto generated at:
; https://www.ahkgen.com/?length=2&comment0=&func0=KEY&skey0%5B%5D=CTRL&skey0%5B%5D=SHIFT&skey0%5B%5D=ALT&skeyValue0=f&input0=mist&option0=Send&comment1=&func1=KEY&skey1%5B%5D=CTRL&skey1%5B%5D=SHIFT&skey1%5B%5D=ALT&skeyValue1=c&Window1=wh&Program1=wh.wheyden.de&option1=ActivateOrOpenChrome

; *********************** Configured region - selected functions ************

^+!f::send, mist

^+!c::ActivateOrOpenChrome("wh", "wh.wheyden.de")


; *********************** Provided Functions ********************************
OpenConfig()
{
    Run, "https://www.ahkgen.com/?length=2&comment0=&func0=KEY&skey0`%5B`%5D=CTRL&skey0`%5B`%5D=SHIFT&skey0`%5B`%5D=ALT&skeyValue0=f&input0=mist&option0=Send&comment1=&func1=KEY&skey1`%5B`%5D=CTRL&skey1`%5B`%5D=SHIFT&skey1`%5B`%5D=ALT&skeyValue1=c&Window1=wh&Program1=wh.wheyden.de&option1=ActivateOrOpenChrome"
}

ActivateOrOpen(window, program)
{
	; check if window exists
	if WinExist(window)
	{
		WinActivate  ; Uses the last found window.
	}
	else
	{   ; else start requested program
		 Run cmd /c "start ^"^" ^"%program%^"",, Hide ;use cmd in hidden mode to launch requested program
		 WinWait, %window%,,5		; wait up to 5 seconds for window to exist
		 IfWinNotActive, %window%, , WinActivate, %window%
		 {
			  WinActivate  ; Uses the last found window.
		 }
	}
	return
}

ActivateOrOpenChrome(tab, url)
{
    Transform, url, Deref, "%url%" ;expand variables inside url
    Transform, tab, Deref, "%tab%" ;expand variables inside tab
    chrome := "- Google Chrome"
    found := "false"
    tabSearch := tab
    curWinNum := 0

    SetTitleMatchMode, 2
    if WinExist(Chrome)
	{
		WinGet, numOfChrome, Count, %chrome% ; Get the number of chrome windows
		WinActivateBottom, %chrome% ; Activate the least recent window
		WinWaitActive %chrome% ; Wait until the window is active

		ControlFocus, Chrome_RenderWidgetHostHWND1 ; Set the focus to tab control ???

		; Loop until all windows are tried, or until we find it
		while (curWinNum < numOfChrome and found = "false") {
			WinGetTitle, firstTabTitle, A ; The initial tab title
			title := firstTabTitle
			Loop
			{
				if(InStr(title, tabSearch)>0){
					found := "true"
					break
				}
				Send {Ctrl down}{Tab}{Ctrl up}
				Sleep, 50
				WinGetTitle, title, A  ;get active window title
				if(title = firstTabTitle){
					break
				}
			}
			WinActivateBottom, %chrome%
			curWinNum := curWinNum + 1
		}
	}

    ; If we did not find it, start it
    if(found = "false"){
        Run chrome.exe "%url%"
    }
	return
}

; from https://stackoverflow.com/a/28448693
SendUnicodeChar(charCode)
{
    ; if in unicode mode, use Send, {u+####}, else, use the encode method.
    if A_IsUnicode = 1
    {
        Send, {u+%charCode%}
    }
    else
    {
        VarSetCapacity(ki, 28 * 2, 0)
        EncodeInteger(&ki + 0, 1)
        EncodeInteger(&ki + 6, charCode)
        EncodeInteger(&ki + 8, 4)
        EncodeInteger(&ki +28, 1)
        EncodeInteger(&ki +34, charCode)
        EncodeInteger(&ki +36, 4|2)

        DllCall("SendInput", "UInt", 2, "UInt", &ki, "Int", 28)
    }
}

EncodeInteger(ref, val)
{
	DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
}
