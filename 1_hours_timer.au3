#include <MsgBoxConstants.au3>
#include <Sound.au3>

; Constants
Const $hours_to_count = 1
Const $time_to_wait_ms = 1000 * 60 * 60 * $hours_to_count
Const $time_wait_not_pressed_OK = 1000 * 60 * 5 ; minutes
Const $time_dialog_timeout = 60 ; seconds
Const $script_title = "Hours Timer"

$answer = $IDOK;
Do
   $answer = MsgBox($MB_OKCANCEL, $script_title, "Press OK to start counting" & $hours_to_count & " hour(s), Cancel to exit!")

   If $answer = $IDOK Then
	  Sleep($time_to_wait_ms)

	  Local $aSound = _SoundOpen(@WindowsDir & "\media\tada.wav")
	  If @error = 2 Then
		 MsgBox($MB_SYSTEMMODAL, $script_title, "The file does not exist")
		 Exit
	  ElseIf @extended <> 0 Then
	   Local $iExtended = @extended ; Assign because @extended will be set after DllStructCreate().
	   Local $tText = DllStructCreate("char[128]")
	   DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "struct*", $tText, "int", 128)
	   MsgBox($MB_SYSTEMMODAL, $script_title, "The open failed." & @CRLF & "Error Number: " & $iExtended & @CRLF & "Error Description: " & DllStructGetData($tText, 1) & @CRLF & "Please Note: The sound may still play correctly.")
	  EndIf
	  _SoundPlay($aSound, 1)
	  _SoundClose($aSound)

	  $answerTimePassedDlg = $IDTIMEOUT
	  Do
		 $answerTimePassedDlg = MsgBox($MB_TOPMOST, $script_title, "                                     " & $hours_to_count & " hour(s) time counting is over!                                ", $time_dialog_timeout)
		 If $answerTimePassedDlg = $IDTIMEOUT Then
			Sleep($time_wait_not_pressed_OK)
		 EndIf
	  Until Not ($answerTimePassedDlg = $IDTIMEOUT)
   EndIf

Until $answer = $IDCANCEL
