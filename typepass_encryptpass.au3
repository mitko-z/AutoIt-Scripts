#include <Crypt.au3>

$filename = "typepass_data.dat"
$programTitle = "TypePass"

$sKey = "password"
Global $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)

Func _Decrypt($sData)
   $binaryResult = _Crypt_DecryptData($sData, $hKey, $CALG_USERKEY)
   Local $sDecrypted = BinaryToString($binaryResult)
   Return $sDecrypted
EndFunc

$file = FileOpen($filename, 0)
$bPasswordHash = FileReadLine($file)
FileClose($file)
_Crypt_Startup()
$passDecrypted = ''
$passDecrypted = _Decrypt($bPasswordHash)
_Crypt_Shutdown()
