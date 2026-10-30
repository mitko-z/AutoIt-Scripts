#include "typepass_encryptpass.au3"

Do
   $answer = MsgBox(1, $programTitle, "Press OK to put the password in to the clipboard, Cancel to exit the script")
   ;Send($passDecrypted)
   ClipPut($passDecrypted)
Until $answer = 2
