#include <Crypt.au3>

$programTitle = "TypePass Setup"
$filename = "typepass_data.dat"

$sKey = "password"
Global $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)

Func _Decrypt($sData)
   $binaryResult = _Crypt_DecryptData($sData, $hKey, $CALG_USERKEY)
   Local $sDecrypted = BinaryToString($binaryResult)
   Return $sDecrypted
EndFunc

Func _Encrypt($sData)
   $binaryResult = _Crypt_EncryptData($sData, $hKey, $CALG_USERKEY)
   Local $sEncrypted = "" & $binaryResult
   Return $sEncrypted
EndFunc

$sPassword = InputBox($programTitle, "This script will encrypt your password and will store it in a file. Type your password here:", "", "*")
If not $sPassword = "" Then
   _Crypt_Startup()
   $bPassword = _Encrypt($sPassword)
   _Crypt_Shutdown()

   $file = FileOpen($filename, 2)
   FileWriteLine($file, string($bPassword))
   FileClose($file)
Else
   MsgBox(0, $programTitle, "Incorect password. Run this script again if you need this password encryption!")
EndIf
_Crypt_DestroyKey($hKey)