#include "typepass_encryptpass.au3"

Do
   $answer = MsgBox(1, $programTitle, "1. Go to the field with password;" & @CR & "2. Switch to this current dialog with Alt + Tab (mouse click wont work, sorry) and" & @CR & "3. Press OK the password to be typed, Cancel to exit the script")
   Send($passDecrypted)
Until $answer = 2
