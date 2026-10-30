#include <MsgBoxConstants.au3>
#include <Sound.au3>
#include <Date.au3>

; Constants
const $ts = 500		; time to sleep, in ms
const $hours_to_count = 9
const $time_to_wait_ms = 1000 * 60 * 60 * $hours_to_count - 1000 * 60 * 2
const $file_name = "9_hours_timer.dat"
const $NOT_INTERRUPTION = 0
const $IS_INTERRUPTION = 1
const $OPEN_FILE = 100
const $READ_FROM_FILE = 101

; function(s)
Func checkUnableToOperateFile($operation, $file_param)
   Switch $operation
	  Case $OPEN_FILE
		 If $file_param = -1 Then
			MsgBox(0, "Hours Timer", "Error: Unable to open file " & $file_name)
			Exit
		 EndIf
	  Case $READ_FROM_FILE
		 If @error = -1 Then
			MsgBox(0, "Hours Timer", "Error: Unable to read from file " & $file_name)
			Exit
		 EndIf
	  Case Else
		 MsgBox(0, "Hours Timer", "Wrong checkUnableToOperateFile() function call!")
		 Exit
   EndSwitch
EndFunc




; main code logic
$answer = $IDOK;
Do															; until cancel has not been pressed
   $file = FileOpen($file_name, 0)
   checkUnableToOperateFile($OPEN_FILE, $file)
   $is_interrupted 	= FileReadLine($file)
   If $is_interrupted = $IS_INTERRUPTION Then
	  $hour_to_reach = FileReadLine($file)
	  checkUnableToOperateFile($READ_FROM_FILE, $file)
	  $minutes_to_reach = FileReadLine($file)
	  checkUnableToOperateFile($READ_FROM_FILE, $file)
	  $message_to_show = "Timer interrupted. Press OK to continue counting till " & ($hour_to_reach + 3) & ":" & $minutes_to_reach & ". Cancel to exit!"
   Else
	  $message_to_show = "Press OK to start counting 9 hours, Cancel to exit!"
   EndIf
   $answer = MsgBox($MB_OKCANCEL, "Hours Timer", $message_to_show)

   If $answer = $IDOK Then
	  If $is_interrupted = $IS_INTERRUPTION Then		 	; script was interrupted => set hours, minutes from file
		 ; MsgBox(0, "DEBUG", "interrupted")
		 $file = FileOpen($file_name, 0)
		 checkUnableToOperateFile($OPEN_FILE, $file)
		 $is_interrupted 	= FileReadLine($file)
		 checkUnableToOperateFile($READ_FROM_FILE, $file)
		 ; MsgBox(0, "DEBUG", "is inter = " & $is_interrupted)
		 $hour_to_reach 	= FileReadLine($file)
		 checkUnableToOperateFile($READ_FROM_FILE, $file)
		 ; MsgBox(0, "DEBUG", "curr hour" & "hour = " & $hour_to_reach)
		 $minutes_to_reach 	= FileReadLine($file)
		 checkUnableToOperateFile($READ_FROM_FILE, $file)
		 ; MsgBox(0, "DEBUG", "min = " & $minutes_to_reach)
		 FileClose($file)
	  Else													; new fresh start => calculate how long to count
		 ; MsgBox(0, "DEBUG", "NOT interrupted")
		 $time = _Date_Time_GetSystemTime()
		 $time_array = _Date_Time_SystemTimeToArray($time)
		 If $time_array[4] < 2 Then
			$hour_to_reach		= $time_array[3] - 1 + $hours_to_count
			$minutes_to_reach	= 60 - 2 + $time_array[4]
		 Else
			$hour_to_reach		= $time_array[3] + $hours_to_count
			$minutes_to_reach	= $time_array[4] - 2
		 EndIf
		 ; MsgBox(0, "DEBUG", "curr time " & $time_array[3] & ":" & $time_array[4] & ", time to reach " & $hour_to_reach & ":" & $minutes_to_reach)
		 $file = FileOpen($file_name, 2)					; write to file when to stop in case of stopping the script
		 checkUnableToOperateFile($OPEN_FILE, $file)
		 FileWriteLine($file, $IS_INTERRUPTION)				; set flag to interruption
		 FileWriteLine($file, $hour_to_reach)
		 FileWriteLine($file, $minutes_to_reach)
		 FileClose($file)
	  EndIf

	  $time_reached = False
	  Do													; wait until the time set
		 Sleep($ts)											; sleep for a while to prevent cpu overheating
		 $time = _Date_Time_GetSystemTime()
		 $time_array = _Date_Time_SystemTimeToArray($time)
		 $current_hour = $time_array[3]
		 $current_minutes = $time_array[4]
		 If $current_hour >= $hour_to_reach Then
			If $minutes_to_reach = 0 Then
			   $time_reached = True
			ElseIf $current_minutes >= $minutes_to_reach Then
			   $time_reached = True
			EndIf
		 EndIf

		 ; show a tool tip message
		 If $time_reached = True Then
			$str_for_tooltip = $hours_to_count & " hours passed!"
		 Else
			$hours_left = Int(($hour_to_reach + ($minutes_to_reach / 60)) - ($current_hour + ($current_minutes / 60)))
			$mins_left = Round((Round((($hour_to_reach + ($minutes_to_reach / 60)) - ($current_hour + ($current_minutes / 60))), 2) - $hours_left) * 60, 0)
			If $mins_left < 10 Then
			   $leading_zero = "0"
			Else
			   $leading_zero = ""
			EndIf

			$str_for_tooltip = "End " & ($hour_to_reach + 3) & ":" & $minutes_to_reach & " (" & $hours_left & "hrs & " & $leading_zero & $mins_left  & "mins remain)"
		 EndIf
		 ToolTip($str_for_tooltip, 1920 - (StringLen($str_for_tooltip) * 7), 1140)

	  Until $time_reached = True

	  ;Sleep($time_to_wait_ms)		; obsolette

	  ; play a celebration sound
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
	  $file = FileOpen($file_name, 2)
	  checkUnableToOperateFile($OPEN_FILE, $file)
	  FileWriteLine($file, $NOT_INTERRUPTION)
   EndIf

Until $answer = $IDCANCEL
