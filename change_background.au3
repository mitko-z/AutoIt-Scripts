#include <File.au3>
#include <Array.au3>
#include <WinAPIFiles.au3>

Global const $debug = False

Global Const $SPI_SETDESKWALLPAPER = 20
Global Const $SPIF_UPDATEINIFILE = 1
Global Const $WALLPAPER_PATH = "C:\work\docs\backgrounds"

Global $ts = 600000 ; Time to Sleep for 10 minutes
Global $debugImageIndex = 0

Func ChangeWallpaper($ImagePath)
    DllCall("user32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, "int", 0, "str", $ImagePath, "int", BitOR(0x01, $SPIF_UPDATEINIFILE))
EndFunc

Func GetRandomImage()
    Local $ImageFiles = _FileListToArray($WALLPAPER_PATH, "*")
    If @error Then
        Return ""
    EndIf

    Local $imageIndex = 0
	if $debug Then
		$debugImageIndex += 1
		if $debugImageIndex > UBound($ImageFiles) - 1 Then
			$debugImageIndex = 0
		EndIf
		$imageIndex = $debugImageIndex 
	Else
		$imageIndex = Random(1, UBound($ImageFiles) - 1, 1)
	EndIf
    Return $ImageFiles[$imageIndex]
EndFunc

If $debug Then
   $ts = 1000 ; Time to Sleep for 1 second
EndIf

While True
    Local $ImagePath = GetRandomImage()
    If $ImagePath <> "" Then
        $ImagePath = $WALLPAPER_PATH & "\" & $ImagePath
        ChangeWallpaper($ImagePath)
		if $debug Then
			MsgBox(0, "Debug", "Background was set to: " & $ImagePath)
		EndIf
        Sleep($ts)
    EndIf
WEnd