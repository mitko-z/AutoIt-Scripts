MsgBox(0,"Welcome", "Please point with the mouse to the first song you want to set in the Mixmeister library and press the OK button.")
Do
	MouseClick("left", 446, 269, 1, 1)
	Sleep(500)
	Send("^q")
	
	Do
		MouseClick("left", 788, 113)
		Sleep(1000)
		MouseClick("left", 46,717)
		Sleep(500)
		$answ1 = MsgBox(4, "Question:", "Is the song with correct BPM? If not - press NO to correct it")
		if($answ1 = 7) Then
			$answ4 = InputBox("Enter BPM", "Enter the correct BPM:", "78")
			MouseClick("left", 788, 113, 1, 1)
			Send("^e")
			Sleep(500)
			Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}"& $answ4 & "{ENTER}")
		EndIf
		$answ2 = MsgBox(4, "Question:", "Is the song with the correct BEGINNING? If not - press NO to correct it")
		if($answ2 = 7) Then 
			MouseClick("left", 788, 113, 1, 1)
			MouseClick("left", 198,705, 1, 1)
			MouseClick("left", 163,718, 1, 1)
		EndIf
		$answ3 = MsgBox(518, "...", "Is the song mixable and applicable for loop cathegory? If not - press Cancel. If you want to hear the song again, press Try Again.")
		If $answ3 = 2 Then Exit
	Until $answ3 = 11
	MouseClick("left", 788, 113, 1, 1)
	If($answ2 = 7) Then Send("^w{TAB}{TAB}{ENTER}{ENTER}{TAB}{TAB}{ENTER}")
	Send("{DEL}")
	MouseClick("left", 446, 269, 1, 1)
	Send("^g")
	Sleep(500)
	Send("lo")
	Sleep(500)
	Send("{ENTER}")
	Send("^e")
	Sleep(500)
	Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}")
	Send("mixable")
	Send("{ENTER}")
	Sleep(500)
	MouseClick("left", 446, 269, 1, 1)
	Send("{DOWN}")
Until 0