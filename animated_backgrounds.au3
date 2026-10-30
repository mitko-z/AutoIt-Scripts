#include <File.au3>
#include <File.au3>
#include <Array.au3>
#include <WinAPIFiles.au3>

Global const $debug = False

Global Const $SPI_SETDESKWALLPAPER = 20
Global Const $SPIF_UPDATEINIFILE = 1

Global $ts = 600000 ; Time to Sleep before changing to other animation; 10 minutes (10 * 60 * 1000 = 600 000)
If $debug Then
   $ts = 1000 ; Time to Sleep for 1 second
EndIf
Global $fps = 300

Global $foldersWithAnimations[7]
$foldersWithAnimations[0] = "C:\work\docs\anim_backgrounds\a383b7b6-a678-40bd-974d-57978ef87ff4_frames"
$foldersWithAnimations[1] = "C:\work\docs\anim_backgrounds\2916627_frames"
$foldersWithAnimations[2] = "C:\work\docs\anim_backgrounds\482026676_1189352012802729_449161235874591702_n_frames"
$foldersWithAnimations[3] = "C:\work\docs\anim_backgrounds\aiur_waterfalls_2_by_highdarktemplar_d5f5yiv - REVERSE - Videobolt.net_frames"
$foldersWithAnimations[4] = "C:\work\docs\anim_backgrounds\Aiurrebuild_LotV_Art2_frames"
$foldersWithAnimations[5] = "C:\work\docs\anim_backgrounds\bryan-goff-f7YQo-eYHdM-unsplash_frames"
$foldersWithAnimations[6] = "C:\work\docs\anim_backgrounds\charles-lee-z-sc2-rebuild-upscaled_frames"

Func ChangeWallpaper($ImagePath)
    DllCall("user32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, "int", 0, "str", $ImagePath, "int", BitOR(0x01, $SPIF_UPDATEINIFILE))
EndFunc

; Function to check if system is running on battery power
Func IsOnBattery()
    Local $tSystemPowerStatus = DllStructCreate("byte ACLineStatus;byte BatteryFlag;byte BatteryLifePercent;byte SystemStatusFlag;dword BatteryLifeTime;dword BatteryFullLifeTime")
    Local $aResult = DllCall("kernel32.dll", "bool", "GetSystemPowerStatus", "struct*", $tSystemPowerStatus)
    
    If @error Or Not $aResult[0] Then
        Return False ; If error, assume on AC power to continue animation
    EndIf
    
    Local $ACLineStatus = DllStructGetData($tSystemPowerStatus, "ACLineStatus")
    ; ACLineStatus: 0 = Offline (on battery), 1 = Online (on AC), 255 = Unknown
    Return ($ACLineStatus = 0)
EndFunc

; function to get the next image in a given folder
Func GetNextImage($currentImage, $folderPath)
    Local $ImageFiles = _FileListToArray($folderPath, "*")
    If @error Then
        Return ""
    EndIf

    For $i = 1 To UBound($ImageFiles) - 1
        If $ImageFiles[$i] = $currentImage Then
            If $i + 1 < UBound($ImageFiles) Then
                Return $ImageFiles[$i + 1]
            Else
                Return $ImageFiles[1] ; Loop back to the first image
            EndIf
        EndIf
    Next

    Return "" ; Current image not found
EndFunc

; function to get the first image in a given folder
Func GetFirstImage($folderPath)
    Local $ImageFiles = _FileListToArray($folderPath, "*")
    If @error Or UBound($ImageFiles) < 2 Then
        Return ""
    EndIf
    Return $ImageFiles[1]
EndFunc

; main function
Func MainFunction()
    $currentFrame = ""
    $currentFolderIndex = Random(0, UBound($foldersWithAnimations) - 1, 1)
    $lastFolderSwitch = TimerInit()

    While True
        ; Skip animation if on battery power
        If IsOnBattery() Then
            Sleep(10000) ; Check again in 10 seconds
            ContinueLoop
        EndIf
        
        ; Check if it's time to switch folder
        If TimerDiff($lastFolderSwitch) >= $ts Then
            ; Pick a random folder index
            ; No declaration needed for $newIndex in global scope
            Do
                $newIndex = Random(0, UBound($foldersWithAnimations) - 1, 1)
            Until $newIndex <> $currentFolderIndex
            $currentFolderIndex = $newIndex
            $lastFolderSwitch = TimerInit()
            ; Start from first frame in new folder
            $currentFrame = ""
        EndIf

        $framesPath = $foldersWithAnimations[$currentFolderIndex]
        If $currentFrame == "" Then
            $currentFrame = GetFirstImage($framesPath)
        Else
            $currentFrame = GetNextImage($currentFrame, $framesPath)
        EndIf
        If $currentFrame <> "" Then
            $ImagePath = $framesPath & "\" & $currentFrame
            ChangeWallpaper($ImagePath)
            Sleep($fps)
        EndIf
    WEnd
EndFunc

MainFunction()