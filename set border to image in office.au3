$appTitle = "Set Border to Image"
$tw = 250 ; time to wait

While 1
   $answer = MsgBox(1, $appTitle, "Point out the image you want the border to be added to and press ENTER (ESC to exit)")
   If $answer = 2 Then ExitLoop
   $pos = MouseGetPos()
   Sleep($tw)
   MouseClick("right", $pos[0], $pos[1]) ; call right click menu over the image
   Sleep($tw)
   Send("{up}") ; one level up which means the last option in the menu
   Sleep($tw)
   Send("{enter}") ; select the choosen opition from the menu
   Sleep($tw * 4) ; wait 3x more time to give time the dialog to appear
   MouseClick("left", 578, 254) ; click on "Line Color"
   Sleep($tw)
   MouseClick("left", 669, 272) ; click on "Solid line"
   Sleep($tw)
   MouseClick("left", 746, 318) ; click on dropdown menu for "Color"
   Sleep($tw)
   MouseClick("left", 775, 396) ; click on "Light blue"
   Sleep($tw)
   Send("{esc}")
   Sleep($tw)
WEnd