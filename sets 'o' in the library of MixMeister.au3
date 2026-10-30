MsgBox(0,"Welcome", "Please point with the mouse to the first song you want to set in the Mixmeister library and press the OK button.")
Do
;	MouseClick("left", 446, 269, 1, 1)
;	Sleep(500)
;	Send("^q")
	Do
;		MouseClick("left", 788, 113, 1, 1)
		Sleep(500)
;		Send("{SPACE}")
;		Sleep(500)
		$answ = MsgBox(518, "...", "Continue?")
		If $answ = 2 Then Exit
	Until $answ = 11
;	MouseClick("left", 788, 113, 1, 1)
;	Send("{DEL}")
;	MouseClick("left", 446, 269, 1, 1)
;	Send("^g")
;	Sleep(500)
;	Send("ov")
;	Sleep(500)
;	Send("{ENTER}")
	Send("^e")
	Sleep(500)
	Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}")
	Send("o")
	Send("{ENTER}")
	Sleep(500)
;	MouseClick("left", 446, 269, 1, 1)
	Send("{DOWN}")

Until 0