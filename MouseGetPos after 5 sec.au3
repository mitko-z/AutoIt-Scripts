$answ = 2
While 1
	Sleep(5000)
	$pos = MouseGetPos()
	$answ = MsgBox(1, "Mouse x,y:", $pos[0] & "," & $pos[1] & ". Continue?")
	If $answ = 2 Then ExitLoop
WEnd