#include <MsgBoxConstants.au3>
#include <Sound.au3>

; Constants
$hours_to_count = 9

$time_to_wait_ms = 1000 * 60 * 60 * $hours_to_count - 1000 * 60 * 2

$answer = $IDOK;
Do
   $answer = MsgBox($MB_OKCANCEL, "Hours Timer", "Press OK to start counting 9 hours, Cancel to exit!")

   If $answer = $IDOK Then
	  Sleep($time_to_wait_ms)

	  Local $aSound = _SoundOpen(@WindowsDir & "\media\tada.wav")
	  If @error = 2 Then
		 MsgBox($MB_SYSTEMMODAL, "Error", "The file does not exist")
		 Exit
	  ElseIf @extended <> 0 Then
	   Local $iExtended = @extended ; Assign because @extended will be set after DllStructCreate().
	   Local $tText = DllStructCreate("char[128]")
	   DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "struct*", $tText, "int", 128)
	   MsgBox($MB_SYSTEMMODAL, "Error", "The open failed." & @CRLF & "Error Number: " & $iExtended & @CRLF & "Error Description: " & DllStructGetData($tText, 1) & @CRLF & "Please Note: The sound may still play correctly.")
	  EndIf
	  _SoundPlay($aSound, 1)
	  _SoundClose($aSound)

	  MsgBox(0, "Hours Timer", "Time is over!")
   EndIf

Until $answer = $IDCANCEL
