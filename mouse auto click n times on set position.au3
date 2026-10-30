$t = 50
$answ = 2
$num = 100

While 1
   MsgBox(0, "MouseClick", "Постави мишката на желаната позиция и натисни <ENTER>")
   $pos = MouseGetPos()
   ; MsgBox(0, "Debug", $pos)
   Sleep($t)
   $num = InputBox("MouseClick", "Въведи броя кликвания", $num)
   For $i = 0 To $num
	  MouseClick("left", $pos[0], $pos[1])
	  Sleep($t)
   Next
   $answ = MsgBox(1, "MouseClick", "Да се продължи ли?")
   If $answ = 2 Then ExitLoop
WEnd
   
