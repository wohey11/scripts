@echo off
title Demo um Variablen von VBScript an CMD zuzuweisen
color 2F
mode 55,9

:: Set variable for InputBox:
set myMessage=Hallo, wie ist dein Name?
set myTitle=Bitte Namen eingeben
call :subInputBox

:: Display variable
if "%flag%"=="false" (
	set myMessage=Es wurde nichts eingegeben, oder die Eingabe abgebrochen.
	set myTitle=Keine Eingabe
	call :subMsgBox
) else (
	set myMessage=Hallo %cmdText%!
	set myTitle=Begrüßung
	call :subMsgBox
)
goto End

:: Start subroutine subInputBox
:subInputBox
set VBS="%Temp%\vbsInputBox.vbs"
set CMD="%Temp%\cmdVar.bat"
 
>> %VBS% echo Option Explicit 
>> %VBS% echo Dim strText  
>> %VBS% echo Dim objShell : Set objShell = CreateObject("Wscript.Shell")  
>> %VBS% echo Dim objFSO   : Set objFSO = CreateObject("Scripting.FileSystemObject") 
>> %VBS% echo Dim objFile  : Set objFile = objFSO.CreateTextFile(%CMD%) 
:: Pass variable from batch to VBScript
>> %VBS% echo strText = InputBox("%myMessage%", "%myTitle%")
>> %VBS% echo if strText = vbNullString then 
:: Create batch file
>> %VBS% echo objFile.WriteLine "@echo off"
>> %VBS% echo objFile.WriteLine "set flag=false" 
>> %VBS% echo else 
>> %VBS% echo objFile.WriteLine "@echo off"
:: Set variable in batch file
>> %VBS% echo objFile.WriteLine "set cmdText=" ^& strText  
>> %VBS% echo end if 
>> %VBS% echo objFile.Close  
 
cscript %VBS% > NUL
call %CMD% > NUL
 
del %CMD%
del %VBS%
 
goto :EOF
:: End subroutine subInputBox

:: Start subroutine subMsgBox
:subMsgBox
>> %Temp%\MsgBox.vbs echo MsgBox "%myMessage%", VbInformation + VbOKOnly, "%myTitle%" 
cscript %Temp%\MsgBox.vbs > NUL
del %Temp%\MsgBox.vbs
goto :EOF
:: End of subroutine subMsgBox

:: End of batch file
:End
