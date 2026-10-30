#include "typepass_encryptpass.au3"
#include <AutoItConstants.au3>

Const $VPN_TITLE = "Cisco Secure Client | EMEA Germany"
Const $stc = 500 ; sleep time in ms between commands
Const $stl = 5000 ; sleep time for loop

Do
   $answer = $IDOK
   If WinExists($VPN_TITLE) Then
	  $answer = MsgBox($MB_OKCANCEL, $programTitle, "Pass will be entered in the dialog for the vpn after 10 sec. Press OK the password to be typed now, Cancel to exit the script!", 10)
	  If $answer = $IDOK Or $answer = $IDTIMEOUT Then
		 WinActivate($VPN_TITLE)
		 $vpnTitlePos = WinGetPos($VPN_TITLE)
		 if @error == 0 Then
			$mouseClickX = $vpnTitlePos[0] + 140
			$mouseClickY = $vpnTitlePos[1] + 117
			MouseClick($MOUSE_CLICK_LEFT, $mouseClickX, $mouseClickY)
			Send($passDecrypted)
			Sleep($stc)
			Send("{enter}")
		 EndIf
	  EndIf
   EndIf
   Sleep($stl) ; sleep for stl ms for not using the processor too much
Until $answer = $IDCANCEL
