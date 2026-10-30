#include "user_settings.au3"
#include <AutoItConstants.au3>
#include <Process.au3>



; override the program title
global $programTitle = "Add Home Office"

Func _ClickCurrentDayInCalendar($topLeftX, $topLeftY, $squareWidth, $squareHeight)
    ; Get current date information
    Local $currentDay = @MDAY
    Local $firstDayOfMonth = _DateToDayOfWeek(@YEAR, @MON, 1)

    ; Convert from 1-7 (Sunday-Saturday) to 0-6 (Monday-Sunday)
    ; Sunday (1) becomes 6, Monday (2) becomes 0, Tuesday (3) becomes 1, etc.
    $firstDayOfMonth = Mod($firstDayOfMonth + 5, 7)

    ; Calculate position of current day
    Local $position = $currentDay + $firstDayOfMonth - 1

    ; Calculate row (0-based)
    ; Integer division by 7 gives us the row number
    Local $row = Int($position / 7)

    ; Calculate column (0-based)
    ; Modulo 7 gives us the column number (0 = Monday, 6 = Sunday)
    Local $column = Mod($position, 7)

    ; Calculate actual coordinates
    Local $clickX = $topLeftX + ($column * $squareWidth) + ($squareWidth / 2)
    Local $clickY = $topLeftY + ($row * $squareHeight) + ($squareHeight / 2)

    ; Click in the middle of the calculated square
    MouseClick("left", $clickX, $clickY)
EndFunc


; Helper function to get day of week (returns 1-7, where 1 is Sunday)
Func _DateToDayOfWeek($year, $month, $day)
    Local $a = Int((14 - $month) / 12)
    Local $y = $year - $a
    Local $m = $month + (12 * $a) - 2
    Local $d = Mod($day + $y + Int($y / 4) - Int($y / 100) + Int($y / 400) + Int((31 * $m) / 12), 7) + 1
    Return $d
EndFunc

; Function to ensure Chrome is running
Func EnsureChromeIsRunning($chromeTitle)
    ; Check if Chrome is already running
    If Not WinExists($chromeTitle) Then
        ; Chrome not running, so launch it
        Local $chromePath = "C:\Program Files\Google\Chrome\Application\Chrome.exe"
        ; Check if Chrome exists at the default location
        If Not FileExists($chromePath) Then
            ; Try alternate location (x86)
            $chromePath = @ProgramFilesDir & " (x86)\Google\Chrome\Application\chrome.exe"
            If Not FileExists($chromePath) Then
                ; If still not found, ask user
                $chromePath = InputBox($programTitle, "Please enter the full path to chrome.exe:", "", "")
                If @error Or Not FileExists($chromePath) Then
                    MsgBox($MB_ICONERROR, $programTitle, "Could not find Chrome browser.")
                    Return False
                EndIf
            EndIf
        EndIf
        
        ; Run Chrome
        Run($chromePath)
        
        ; Wait for Chrome to start (with timeout)
        Local $timeout = 10 ; seconds
        Local $startTime = TimerInit()
        
        While Not WinExists($chromeTitle) And TimerDiff($startTime) < $timeout * 1000
            Sleep(500)
        WEnd
        
        If Not WinExists($chromeTitle) Then
            MsgBox($MB_ICONERROR, "Error", "Chrome failed to start within the timeout period.")
            Return False
        EndIf
    EndIf
    
    Return True
EndFunc

Func AddHomeOffice()
    ; Initialize settings if not already done
    InitializeSettingsFile()
    Global $gVar
    Local $var
    Dim $i

    Local Const $stc = 500 ; sleep time in ms between commands
    Local Const $stl = 5000 ; sleep time for loop
    Local Const $ChromeTitle = "Chrome"
    Opt( "WinTitleMatchMode", 2)
    Local $addHomeOfficeActionAnswer = MsgBox($MB_YESNO + $MB_TOPMOST, $programTitle, "Add home office for today?")
    if $addHomeOfficeActionAnswer == $IDYES Then
        if Not EnsureChromeIsRunning($ChromeTitle) Then
            MsgBox($MB_ICONERROR, "Error", "Could not ensure Chrome is running. Operation canceled.")
            Return
        EndIf

        WinActivate($ChromeTitle)
        Sleep($stc)
        Send("^t") ; open new tab
        Sleep($stc)
        Send("https://rbhrmsf4.app.bosch.com/")
        Send("{enter}")
        Local $copiedText = ""
        Local $counter = 0
        Local $maxAttempts = 3
        Local $welcomeText = "Welcome" ; this is expected to be copied on the login page
        Local $monText = "Mon" ; this is expected to be copied if already logged in
        $whileCondition = ($copiedText <> $welcomeText And $copiedText <> $monText) And $counter < $maxAttempts
        While $whileCondition
           Sleep($stl) ; give time the page to load
           Local $textToCopyXYCoords = GetCoordinates("welcomeText")
           MouseClick("left", $textToCopyXYCoords[0], $textToCopyXYCoords[1], 2) ; double click to select the text
           Sleep($stc)
           Send("^c") ; copy to clipboard
           $counter += 1
           $copiedText = ClipGet()
           Local $retryAnswer = $IDOK
           If $counter >= $maxAttempts Then
              $retryAnswer = MsgBox($MB_RETRYCANCEL, $programTitle, "Couldn't retrieve the Welcome for " & $maxAttempts & " attempts. Retry to try for next" & $maxAttempts & " attempts or Cancel")
              If $retryAnswer == $IDRETRY Then
                 $counter = 0
               EndIf
            EndIf
            $whileCondition = ($copiedText <> $welcomeText And $copiedText <> $monText) And $counter < $maxAttempts
         WEnd
         If $retryAnswer <> $IDCANCEL Then
            If $copiedText == $welcomeText Then
				; old way of logging in
              ;Send("{tab}")	; go to the user field
              ;Send("kad1sf")
              ;Send("{tab}")
              ;Send($passDecrypted)
              ;Send("{enter}")
              ;Sleep($stl
			  
			  ; new way of logging in - just click on the Sign In button
			  MouseClick("left", 766, 321)
			  Sleep(5000) ; wait some time for the sign in process 
           EndIf
           Local $dashboardXYCoords = GetCoordinates("dashboard")
           MouseClick("left", $dashboardXYCoords[0], $dashboardXYCoords[1]) ; Dashboard
           Sleep($stc)
           Local $homeOfficeButtonXYCoords = GetCoordinates("homeOfficeButton")
           MouseClick("left", $homeOfficeButtonXYCoords[0], $homeOfficeButtonXYCoords[1])
           Sleep($stc)
           Local $firstStartDateFieldXYCoords = GetCoordinates("firstStartDateField")
           MouseClick("left", $firstStartDateFieldXYCoords[0], $firstStartDateFieldXYCoords[1])
           Sleep($stc)
           Local $firstCalendDims = GetCoordinates("firstCalendar")
           _ClickCurrentDayInCalendar($firstCalendDims[0], $firstCalendDims[1], $firstCalendDims[2], $firstCalendDims[3])
           Sleep($stc)
           Local $secondStartDateFieldXYCoords = GetCoordinates("secondStartDateField")
           MouseClick("left", $secondStartDateFieldXYCoords[0], $secondStartDateFieldXYCoords[1])
           Sleep($stc)
           Local $secondCalendDims = GetCoordinates("secondCalendar")
           _ClickCurrentDayInCalendar($secondCalendDims[0], $secondCalendDims[1], $secondCalendDims[2], $secondCalendDims[3])
		   Local $saveChangesButton = GetCoordinates("saveChangesButton")
		   MouseClick("left", $saveChangesButton[0], $saveChangesButton[1])
        EndIf
    EndIf
EndFunc
