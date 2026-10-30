#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

; Create GUI
GUICreate("Useless Box", 300, 200)
$checkbox = GUICtrlCreateCheckbox("Switch (do NOT turn it on!)", 80, 80, 240, 25)
GUISetState(@SW_SHOW)

; Main loop
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $checkbox
            If BitAND(GUICtrlRead($checkbox), $GUI_CHECKED) Then
                ; User turned it ON
                MsgBox($MB_OK, "Oh-oh!", "Oh, no! You've just turned on this switch! (·•᷄_•᷅ )")
				Sleep(800) ; small delay before the “hand” acts

				; Get GUI control position (relative to window)
				Local $pos = ControlGetPos("Useless Box", "", $checkbox)
				If IsArray($pos) Then
					; Convert to screen coordinates
					Local $guiPos = WinGetPos("Useless Box")
					Local $x = $guiPos[0] + $pos[0] + 8 ; 8px border
					Local $y = $guiPos[1] + $pos[1] + ($pos[3] / 2) + 30 ; 30px title bar
					; “Hand” moves and clicks back
					MouseClick("left", $x, $y)
                EndIf
            EndIf
    EndSwitch
WEnd
