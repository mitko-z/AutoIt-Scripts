MsgBox(0, "", "Go to XNView and click OK to start")
$ts = 1000
for $i = 0 To 252 Step 1
   MouseClick("left", 100, 82)
   Sleep($ts)
   Send("{enter}")
   Sleep($ts)
   Send("{pgdn}")
Next