$timeToWait = 1000 * 60
Do
   Sleep($timeToWait)
   $currMousePos = MouseGetPos()
   MouseMove($currMousePos[0] + 1, $currMousePos[1])
Until False