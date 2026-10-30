$answ = 2
While 1
	Sleep(5000)
	$pos = MouseGetPos()
	$answ = InputBox("Mouse X, Y Coordinates", "Mouse x, y coordinates:", $pos[0] & ", " & $pos[1])
	If $answ = "" Then ExitLoop
WEnd