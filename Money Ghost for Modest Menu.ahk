#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Event
SetKeyDelay, 0, 50
; ----------------Message Box---------------------------------------------------------------------------------------------------------------

OnMessage(0x44, "OnMsgBox")
MsgBox 0x80, How to Use Money Ghost, Hotkeys - NumPad * Start/Pause `, NumPad - Close`n`n1) Run this script with administrator privileges.`n 2) Keep GTA 5 in Windowed/Borderless mode.`n 3) Start the "Blow Up II" job`,With matchmaking closed.`n 4) Open Modest Menu .`n 5) Set Tunables Min Mission Payout to $100`,000 `n 6) Set RP Multiplier to 10x.( * optional)`n     (Going above 20x makes RP glitch out after 2.5 hours)`n 7) Keep Modest Menu open with "Kill All Cars" selected.`n`nRun it for 3 hours - earn $28M and up to *1`,400`,000 RP  `nRun it for 24hours - earn $100M and up to *5`,000`,000 RP `n*If Selected`n`nI Take no Responsibility for what you do with this information. Be Safe !`n`nCredits - Kiddion for ModestMenu / Terrobility for Macro
OnMessage(0x44, "")

OnMsgBox() {
    DetectHiddenWindows, On
    Process, Exist
    If (WinExist("ahk_class #32770 ahk_pid " . ErrorLevel)) {
        hIcon := LoadPicture("C:\Users\Administrator\Downloads\nicepng_minions_png_380310_Jqg_icon.ico", "w32 Icon1", _)
        SendMessage 0x172, 1, %hIcon%, Static1 ; STM_SETIMAGE
    }
}
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; 1) Run this script with administrator privileges.
; 2) Keep GTA 5 in Windowed/Borderless mode.
; 3) Start the "Blow Up II" job, ideally with matchmaking closed.
; 4) Ensure the menu is open with "Kill All Cars" selected.
; 5) Also crank up tunables Min Mission Payout to $100,000 and RP Multiplier to 10x.
; -- (Going above 20x makes RP glitch out at 0. I purposely do that to avoid gaining levels.)
; 6) Press Numpad * to start or pause the script!
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance
#Include Create_NicePng_minionspng_380310_png.ahk ; change the name to what you need
SetBatchLines, -1
T := A_TickCount
HBITMAP := Create_NicePng_minionspng_380310_png() ; change the name to what you need
H := Bitmap_GetHeight(HBITMAP)
W := Bitmap_GetWidth(HBITMAP)
; msgbox %W%x%H%
; --------------------GUI--------------------------------------------------------------------------------------------------
Gui, Show, x401 y195 h181 w347, Money Ghost by plumbwicked, - %T% ms

Gui, Add, Button, x250 y25 w75 h30 gTest1 , Start / Pause
Gui, Add, Button, x250 y75 w75 h30 gTest2 , Close 

Gui, Add, Text, x185 y120 w160 h30 ,  Only Works with Modest Menu 
Gui, Add, Button, x250 y140 w75 h30 gTest3, Get Menu
Gui, Add, Text, x0 y0 w%W% h%H% hwndHPic1
Bitmap_SetImage(HPic1, HBITMAP)
T := A_TickCount - T

; ----------------------------------------------------------------------------------------------------------------------
; Returns the width of a bitmap.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_GetWidth(hBitmap) {
   Ptr := A_PtrSize ? "Ptr" : "UInt"
   PtrSize := A_PtrSize ? A_PtrSize : 4
   Size := (4 * 5) + PtrSize + (PtrSize - 4)
   VarSetCapacity(BITMAP, Size, 0)
   DllCall("Gdi32.dll\GetObject", Ptr, hBitmap, "Int", Size, Ptr, &BITMAP, "Int")
   Return NumGet(BITMAP, 4, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------
; Returns the height of a bitmap.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_GetHeight(hBitmap) {
   Ptr := A_PtrSize ? "Ptr" : "UInt"
   PtrSize := A_PtrSize ? A_PtrSize : 4
   Size := (4 * 5) + PtrSize + (PtrSize - 4)
   VarSetCapacity(BITMAP, Size, 0)
   DllCall("Gdi32.dll\GetObject", Ptr, hBitmap, "Int", Size, Ptr, &BITMAP, "Int")
   Return NumGet(BITMAP, 8, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------
; Associates a new bitmap with a static control.
; Parameters:     hCtrl    -  Handle to the GUI control (Pic or Text).
;                 hBitmap  -  Handle to the bitmap to associate with the GUI control.
; Return value:   Handle to the image previously associated with the GUI control, if any; otherwise, NULL.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_SetImage(hCtrl, hBitmap) {
   ; STM_SETIMAGE = 0x172, IMAGE_BITMAP = 0x00, SS_BITMAP = 0x0E
   WinSet, Style, +0x0E, ahk_id %hCtrl%
   SendMessage, 0x172, 0x00, %hBitmap%, , ahk_id %hCtrl%
   Return ErrorLevel
}


; Configurables
TargetCycles := 1000  ; Should run for just under 24h, earning GTA$100M (+ up to 5,000,000 RP) total

; Internals - DO NOT EDIT BELOW THIS LINE!
Paused := 1
ElapsedCycles := -1
ElapsedTime := 0

SetTimer, MissionCycle, 1000

; Numpad multiply (*) toggles whether the cycle should run
NumpadMult::
    Paused := Paused = 1 ? 0 : 1
    ToolTip, % "[TOGGLE] Is paused: " . Paused, 64, 96, 2
    SetTimer, RemoveToolTip2, -3000
return

; Numpad subtract (-) kills the script
NumpadSub::
    Paused := true
    ToolTip, % "[EXITAPP] Elapsed cycles: " . ElapsedCycles . " (" . (ElapsedTime / 1000 / 60 / 60) . " hrs)", 64, 96, 2
    SetTimer, RemoveToolTip2, -5000
    Sleep, 5000
    ExitApp
return

; Mission cycle loop
MissionCycle() {
    ; Assume global
    global

    ; Don't run if paused
    if (Paused = 1) {
        ; ToolTip, % "[DEBUG] Paused returned 1", 64, 64
        return
    }

    ; Delay initial start
    if (ElapsedCycles = -1) {
        ToolTip, % "[DEBUG] Held on delayed initial start", 64, 64
        Sleep, 5000
        ElapsedCycles := 0
        return
    }

    ; Check if hit target cycles
    if (ElapsedCycles = TargetCycles) {
        ToolTip, % "[DEBUG] Paused and reset after hitting " . TargetCycles . " TargetCycles`n`nCompleted cycles: " . ElapsedCycles . " (" . (ElapsedTime / 1000 / 60 / 60) . " hrs)", 64, 64
        Paused := true
        ElapsedCycles := -1
        ElapsedTime := 0
        return
    }

    ; Attempts kill all cars 2 times for a total of 10 seconds
    Loop, 2
    {
        ToolTip, % "[DEBUG] Sending Numpad5 - " . A_Index, 64, 64
        ; Selects the highlighted menu option
        Send, {Numpad5}
        ; Waits 10 seconds for mission selection prompt
        Sleep, 5000
    }

    ; Attempts quick repeat 6 times for a total of 30 seconds
    Loop, 6
    {
        ToolTip, % "[DEBUG] Sending PgUp - " . A_Index, 64, 64
        ; Press the quick repeat hotkey, has no effect if replay is already loading
        Send, {PgUp}
        ; Waits 5 seconds
        Sleep, 5000
    }

    ; Delay for another 20 to 30 seconds
    ; -- If removed, you'll get transaction errors after running for 2.5 hours ($28M earned)
    Random, rand, 22500, 30000
    ToolTip, % "[DEBUG] Sleeping for " . rand . " ms", 64, 64
    Sleep, % rand

    ; Track elapsed stats
    ElapsedCycles += 1
    ElapsedTime += (10000 + 30000 + rand)

    ; Display tooltip
    ToolTip, % "[DEBUG] Elapsed cycles: " . ElapsedCycles . " (" . (ElapsedTime / 1000 / 60 / 60) . " hrs)", 64, 64
    ; SetTimer, RemoveToolTip, -10000
}

RemoveToolTip(Which:=1) {
    ToolTip,,,, % Which
}

RemoveToolTip2() {
    ToolTip,,,, 2
}


; ----------------------------------------------------------------------------------------------------------------------
;------Buttons-------------------------------------------------------------------------------------------------------

Test1:

	SendLevel,1
	Send, {NumpadMult down}
	Send, {NumpadMult up}
	return

Test2:

	SendLevel,1
	Send, {NumpadSub down}
	Send, {NumpadSub up}
	return

Test3:
Run, https://www.unknowncheats.me/forum/grand-theft-auto-v/464657-kiddions-modest-external-menu-thread-2-a.html
Return

Return
GuiClose:
GuiEscape:
ExitApp