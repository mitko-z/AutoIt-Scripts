While 1
    $title = WinGetTitle("[ACTIVE]")
    $pos = MouseGetPos()
    ToolTip($title, $pos[0], $pos[1])
    Sleep(100)
WEnd
