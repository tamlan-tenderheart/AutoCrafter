; Autocrafter v0.9
; An autoclicking crafting script for Dark Age of Camelot
; Written by Tamlan Tenderheart

; Usage:
; Press F1 to enter the Hotstring to use for each crafting attempt, the default 
;     String is "1" meaning that the script will hit the 1 key each time to
;     craft the item as a default. Any ahk-recognized hotstring may be entered here.
;
; To set an auto-sell inventory slot, move the mouse over an inventory slot and 
;     press F2. Once set, the script will attempt to click that inventory slot
;     and attempt to auto-sell the item (using Ctrl-S).
; Note: For auto-sell to function properly, you must have an in-range merchant 
;     selected.
;
; To toggle auto-sell on and off, press F3.
;
; The default number of seconds to wait for a craft attempt is 2 seconds.
; If you require more or less for each craft attempt, press F4 and enter
; an integer number of milliseconds to wait for each craft attempt to elapse.
;
; To start or stop the crafting, press F5

#SingleInstance, force
#MaxThreadsPerHotkey 2

SellX := -1 ; Uninitialized value
SellY := -1 ; Uninitialized Value
HotbarKeys := "1" ; Default value
CraftDelay := 2000 ; Default 2 seconds
ToggleCraft := false
ToggleSell := false

;SetKeyDelay, 20, 20

#IfWinActive ahk_exe game.dll
F1::
    InputBox, HotbarKeys, Craft Hotstring, Enter the Hotstring for each craft attempt, 1
    Return
	
F2::
    MouseGetPos, SellX, SellY
    TrayTip,Autocraft,The click location to auto-sell is [X%SellX% Y%SellY%], SellX, SellY,,1
    ToggleSell := true
    Return

F3::
    ToggleSell := !ToggleSell
    If( ToggleSell )
	    TrayTip,Autocraft,Autosell is enabled - the sell inventory slot is at [X%SellX% Y%SellY%]
    Else
        TrayTip,Autocraft,Autosell is disabled 	
    Return

F4::
    InputBox, CraftDelayInput, Crafting Delay, Enter the time (in milliseconds) between each craft attempt, 2000
    If( CraftDelayInput is integer )
    {
        CraftDelay = %CraftDelayInput%
        TrayTip,Autocraft,The craft delay has been set to %CraftDelay% milliseconds,,1
    }
    Else
    {
        TrayTip,Autocraft,The value entered was not an integer!,,3
    }
    Return
		
F5::	
    ToggleCraft := !ToggleCraft
    while ToggleCraft
    {
        Send, %HotbarKeys%
        Sleep, %CraftDelay% ; default 2 Seconds
        if( ToggleSell )
        {
            MouseClick,,%SellX%,%SellY%
            Send, {Shift down}sss{Shift up}
        }	
    }
    Return
