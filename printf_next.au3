#include <MsgBoxConstants.au3>

$title = "printf NEXT"
$N = 0
$N = InputBox($title, "This will paste the text <<printf(""N\n"");>> N is a number and then will increment N for the next time. Enter initial number for N! Cancel to exit!")

If @error = 1 Then
   Exit
EndIf

$answer = $IDOK;
Do
   $textMessage = "Click to the line where this text <<printf(""" & $N & "\n"");>> to be pasted, Cancel to exit!"
   $answer = MsgBox($MB_OKCANCEL, "printf NEXT", $textMessage)

   If $answer = $IDOK Then
	  Send("{enter}")
	  ClipPut("printf(""" & $N & "\n"");")
	  Sleep(200)
	  Send("^v")
	  ;ClipPut($N)
	  ;Send("^v")
	  ;ClipPut("\n"");")
	  ;Send("^v")
	  $N = $N + 1
   EndIf

Until $answer = $IDCANCEL
