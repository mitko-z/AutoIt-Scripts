#include <Crypt.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <AutoItConstants.au3>
#include <Array.au3>

Global $programTitle = "Scripts Setup"
Global $settingsFile = @ScriptDir & "\user_settings.ini"

; Encryption constants and variables
Global $sKey = "password"
Global $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)
Global $passStorageFile = @ScriptDir & "\typepass_data.dat"

; Default coordinates - will be used if custom ones aren't set
Global $defaultCoordinates = [ _
    ["welcomeText", 957, 245], _
    ["dashboard", 74, 262], _
    ["homeOfficeButton", 1630, 204], _
    ["firstStartDateField", 914, 462], _
    ["firstCalendar", 825, 675, 39, 32], _
    ["secondStartDateField", 898, 535], _
    ["secondCalendar", 825, 738, 39, 32], _
	["saveChangesButton", 985, 635] _
]

; Functions to encrypt and decrypt data
Func _Decrypt($sData)
   _Crypt_Startup()
   $binaryResult = _Crypt_DecryptData($sData, $hKey, $CALG_USERKEY)
   _Crypt_Shutdown()
   Local $sDecrypted = BinaryToString($binaryResult)
   Return $sDecrypted
EndFunc

Func _Encrypt($sData)
   _Crypt_Startup()
   $binaryResult = _Crypt_EncryptData($sData, $hKey, $CALG_USERKEY)
   _Crypt_Shutdown()
   Local $sEncrypted = "" & $binaryResult
   Return $sEncrypted
EndFunc

; Function to initialize settings file with default values if it doesn't exist
Func InitializeSettingsFile()
    If Not FileExists($settingsFile) Then
        ; Create settings file with default coordinates
        For $i = 0 To UBound($defaultCoordinates) - 1
            Local $coordName = $defaultCoordinates[$i][0]
            Local $elementsCount = 0
            
            ; Count elements in this row (safely)
            For $j = 0 To 10 ; assuming max 10 elements per row
                If $j >= UBound($defaultCoordinates, 2) Then ExitLoop
                If Not IsArray($defaultCoordinates) Then ExitLoop
                If $j > 0 And $defaultCoordinates[$i][$j] = "" Then ExitLoop
                $elementsCount = $j + 1
            Next
            
            ; Write the values based on how many elements are in the array
            If $elementsCount = 3 Then
                ; Simple X,Y coordinates
                IniWrite($settingsFile, "Coordinates", $coordName & "_X", $defaultCoordinates[$i][1])
                IniWrite($settingsFile, "Coordinates", $coordName & "_Y", $defaultCoordinates[$i][2])
            ElseIf $elementsCount = 5 Then
                ; X,Y,Width,Height coordinates (for calendars)
                IniWrite($settingsFile, "Coordinates", $coordName & "_X", $defaultCoordinates[$i][1])
                IniWrite($settingsFile, "Coordinates", $coordName & "_Y", $defaultCoordinates[$i][2])
                IniWrite($settingsFile, "Coordinates", $coordName & "_Width", $defaultCoordinates[$i][3])
                IniWrite($settingsFile, "Coordinates", $coordName & "_Height", $defaultCoordinates[$i][4])
            EndIf
        Next
        
        IniWrite($settingsFile, "Settings", "SetupComplete", "No")
    EndIf
EndFunc

; Function to get decrypted password
Func GetDecryptedPassword()
    If Not FileExists($passStorageFile) Then
        MsgBox($MB_ICONERROR, $programTitle, "Password file not found. Please run setup first.")
        Return ""
    EndIf
    
    Local $file = FileOpen($passStorageFile, 0)
    If $file = -1 Then
        MsgBox($MB_ICONERROR, $programTitle, "Error opening password file!")
        Return ""
    EndIf
    
    Local $encryptedPass = FileReadLine($file)
    FileClose($file)
    
    Return _Decrypt($encryptedPass)
EndFunc

; Function to get coordinates
Func GetCoordinates($coordName)
    ; Initialize settings file if it doesn't exist
    InitializeSettingsFile()
    
    ; Check if it's a calendar (requires 4 values)
    If StringInStr($coordName, "Calendar") Then
        Local $x = Number(IniRead($settingsFile, "Coordinates", $coordName & "_X", "0"))
        Local $y = Number(IniRead($settingsFile, "Coordinates", $coordName & "_Y", "0"))
        Local $width = Number(IniRead($settingsFile, "Coordinates", $coordName & "_Width", "0"))
        Local $height = Number(IniRead($settingsFile, "Coordinates", $coordName & "_Height", "0"))
        
        Local $aResult[4]
        $aResult[0] = $x
        $aResult[1] = $y
        $aResult[2] = $width
        $aResult[3] = $height
        Return $aResult
    Else
        ; Regular coordinate (2 values)
        Local $x = Number(IniRead($settingsFile, "Coordinates", $coordName & "_X", "0"))
        Local $y = Number(IniRead($settingsFile, "Coordinates", $coordName & "_Y", "0"))
        
        Local $aResult[2]
        $aResult[0] = $x
        $aResult[1] = $y
        Return $aResult
    EndIf
EndFunc

; Function to setup password
Func SetupPassword()
    Local $sPassword = InputBox($programTitle, "Enter your password (will be encrypted and stored):", "", "*")
    If @error Or $sPassword = "" Then
        Return False
    EndIf
    
    $bPassword = _Encrypt($sPassword)
    
    $file = FileOpen($passStorageFile, 2)
    If $file = -1 Then
        MsgBox($MB_ICONERROR, $programTitle, "Error opening password storage file!")
        Return False
    EndIf
    
    FileWriteLine($file, String($bPassword))
    FileClose($file)
    
    MsgBox($MB_ICONINFORMATION, $programTitle, "Password saved successfully!")
    Return True
EndFunc

; Function to setup coordinates
Func SetupCoordinates()
    ; Initialize settings file if it doesn't exist
    InitializeSettingsFile()
    
    MsgBox($MB_ICONINFORMATION, $programTitle, "You'll now set up custom coordinates for mouse clicks." & @CRLF & _
        "For each position, move your mouse to the correct location and press OK.")
    
    ; List of coordinates to capture
    Local $coordList = [["welcomeText", "Welcome text position"], _
                       ["dashboard", "Dashboard button"], _
                       ["homeOfficeButton", "Home Office button"], _
                       ["firstStartDateField", "First start date field"], _
                       ["secondStartDateField", "Second start date field"]]
                       
    ; Capture mouse positions
    For $i = 0 To UBound($coordList) - 1
        Local $coordName = $coordList[$i][0]
        Local $coordDesc = $coordList[$i][1]
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Position your mouse at the " & $coordDesc & " and press OK")
        Sleep(500) ; Give time to move away from the message box
        
        Local $pos = MouseGetPos()
        
        ; Save to INI file
        IniWrite($settingsFile, "Coordinates", $coordName & "_X", $pos[0])
        IniWrite($settingsFile, "Coordinates", $coordName & "_Y", $pos[1])
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Position saved: " & $coordName & " = [" & $pos[0] & ", " & $pos[1] & "]")
    Next
    
    ; For calendar coordinates, we need width and height too
    MsgBox($MB_ICONINFORMATION, $programTitle, "Now you'll set up calendar dimensions." & @CRLF & _
        "For each calendar, you'll need to specify the top-left corner position and the size of each day cell.")
    
    Local $calendarList = [["firstCalendar", "First calendar"], _
                         ["secondCalendar", "Second calendar"]]
                         
    For $i = 0 To UBound($calendarList) - 1
        Local $calName = $calendarList[$i][0]
        Local $calDesc = $calendarList[$i][1]
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Position your mouse at the TOP-LEFT corner of the " & $calDesc & " and press OK")
        Sleep(500)
        
        Local $pos1 = MouseGetPos()
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Now position your mouse at the TOP-LEFT corner of the NEXT DAY (to the right) and press OK")
        Sleep(500)
        
        Local $pos2 = MouseGetPos()
        Local $cellWidth = $pos2[0] - $pos1[0]
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Now position your mouse at the TOP-LEFT corner of the DAY BELOW and press OK")
        Sleep(500)
        
        Local $pos3 = MouseGetPos()
        Local $cellHeight = $pos3[1] - $pos1[1]
        
        ; Save to INI file
        IniWrite($settingsFile, "Coordinates", $calName & "_X", $pos1[0])
        IniWrite($settingsFile, "Coordinates", $calName & "_Y", $pos1[1])
        IniWrite($settingsFile, "Coordinates", $calName & "_Width", $cellWidth)
        IniWrite($settingsFile, "Coordinates", $calName & "_Height", $cellHeight)
        
        MsgBox($MB_ICONINFORMATION, $programTitle, "Calendar dimensions saved: " & $calName & " = [" & _
            $pos1[0] & ", " & $pos1[1] & ", " & $cellWidth & ", " & $cellHeight & "]")
    Next
    
    IniWrite($settingsFile, "Settings", "SetupComplete", "Yes")
    
    MsgBox($MB_ICONINFORMATION, $programTitle, "All coordinates saved successfully!")
    Return True
EndFunc

; Function to run setup wizard
Func RunSetup()
    ; Ask about password setup
    Local $passwordChoice = MsgBox($MB_YESNO + $MB_ICONQUESTION, $programTitle, "Would you like to set up your password?")
    If $passwordChoice = $IDYES Then
        SetupPassword()
    EndIf
    
    ; Ask about coordinates setup
    Local $coordsChoice = MsgBox($MB_YESNO + $MB_ICONQUESTION, $programTitle, "Would you like to set up screen coordinates for the Home Office automation?")
    If $coordsChoice = $IDYES Then
        SetupCoordinates()
    EndIf
    
    ; Show completion message if something was set up
    If $passwordChoice = $IDYES Or $coordsChoice = $IDYES Then
        MsgBox($MB_ICONINFORMATION, $programTitle, "Setup completed successfully!")
    Else
        MsgBox($MB_ICONINFORMATION, $programTitle, "Setup cancelled. No changes were made.")
    EndIf
EndFunc

; Export variables to be used in other scripts
Global $passDecrypted = GetDecryptedPassword()