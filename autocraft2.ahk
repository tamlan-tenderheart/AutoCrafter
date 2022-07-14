; Autocraft v2
; An autoclicking crafting script for Dark Age of Camelot
; Written by Tamlan Tenderheart
;
; Usage:
; Press F1 to bring up the configuration UI. Here you set all the options for
; further crafting. including the crafting hotstring, the craft timing, 
; and the batch size. You can also configure whether autosell is enabled,
; the autsell hotstring, and the sell batch size.
;
; To set an auto-sell inventory slot, move the mouse over an inventory slot and 
; press F2. Once set, the script will attempt to click that inventory slot
; and attempt to auto-sell the item (using Ctrl-S).
; Note: For auto-sell to function properly, you must have an in-range merchant 
; selected.
;
; To start or stop the crafting, press F5

#NoEnv
#SingleInstance, force
#MaxThreadsPerHotkey 2

SetWorkingDir, %A_ScriptDir%

global nSellX := -1        ; Uninitialized value
global nSellY := -1        ; Uninitialized Value
global szCraftMacro := "1"    ; Default macro is click the 1 key
global nCraftDuration := 2000 ; Craft delay in milliseconds (2s default)
global nCraftLimit := 99999     ;
global nCraftCount := 0 
global nSellBatchSize := 1 ; Salvage or sell each item
global nSellCount := 0     ; Current count
global szSellMacro := "sell 2-5"
global bIsCrafting := false
global bIsCraftLimited := false
global bIsAutoSell := false

SetKeyDelay, 20, 20

; Gui
; Gui, New, +AlwaysOnTop +ToolWindow, Autocraft -- by Tamlan Tenderheart
Gui, New, +ToolWindow , Autocraft -- by Tamlan Tenderheart
Gui, Add, GroupBox, w270 h279 , Crafting Options
Gui, Add, Text, x22 y39 w80 h20 , Craft Macro:
Gui, Add, Edit, x102 y36 w100 h20 vszCraftMacro, %szCraftMacro%
Gui, Add, Text, x22 y69 w80 h20 , Craft Duration:
Gui, Add, Edit, x102 y66 w100 h20 +0x2000
GUi, Add, UpDown, vnCraftDuration Range0-99999 0x80, %nCraftDuration%
Gui, Add, Text, x212 y69 , seconds
Gui, Add, CheckBox, x22 y96 w80 h20 vbIsCraftLimited gClickBatchSize, Stop after:
Gui, Add, Edit, x102 y96 w100 h20 Disabled +0x2000 veditCraftLimit
Gui, Add, UpDown, vnCraftLimit Range0-1000 0x80, %nCraftLimit%
Gui, Add, Text, x212 y99 Disabled vlblAttempts, attempts
Gui, Add, CheckBox, x22 y129 w100 h20 vbIsAutoSell gClickAutoSell, Enable autosell
Gui, Add, Text, x39 y159 w230 vlblAutoSellLocation Disabled, Autosell inventory slot location:
Gui, Add, Text, x39 y189 w60 h20 vlblSellMacro Disabled, Sell macro:
Gui, Add, Edit, x102 y186 w150 h20 Disabled vszSellMacro, %szSellMacro%
Gui, Add, Text, x39 y219 vlblSellAfter Disabled, Sell after:
Gui, Add, Edit, x102 y216 w100 Disabled +0x2000 veditSellLimit
Gui, Add, UpDown, vnSellBatchSize Range0-1000 0x80, %nSellBatchSize%
Gui, Add, Text, x212 y219 vlblTries Disabled, tries
Gui, Add, Button, x100 y249 w100 h30 gOk Default, Ok
Gui ,Show, AutoSize Center

ClickBatchSize()
{
    GuiControlGet, bIsCraftLimited
    GuiControl, Enable%bIsCraftLimited%, editCraftLimit
    GuiControl, Enable%bIsCraftLimited%, lblAttempts
    Return
}

ClickAutoSell() 
{
    GuiControlGet, bIsAutoSell
    GuiControl, Enable%bIsAutoSell%, lblSellMacro
    GuiControl, Enable%bIsAutoSell%, szSellMacro
    GuiControl, Enable%bIsAutoSell%, nSellBatchSize
    GuiControl, Enable%bIsAutoSell%, lblAutoSellLocation
    GuiControl, Enable%bIsAutoSell%, lblSellAfter
    GuiControl, Enable%bIsAutoSell%, editSellLimit
    GuiControl, Enable%bIsAutoSell%, lblTries
    Return
}

HaltCraft()
{
    bIsCrafting := false
    Return
}

Ok()
{
    ; Have to hit Ok to save changes, but then the changes aren't editable
    Gui, Submit, NoHide
    Return
}

DoCraft()
{
    bIsCrafting := true
    nCraftCount := 0
    nSellCount := 0
    
    While( bIsCrafting AND nCraftLimit > nCraftCount++ )
    {
        ControlSend,,%szCraftMacro%,ahk_exe game1127.dll
        Sleep, %nCraftDuration%  ; default 2 Seconds
        If( bIsCrafting AND bIsAutoSell AND Mod(nCraftCount, nSellBatchSize) = 0 )
        {
            ControlSend,,{Blind}/,ahk_exe game1127.dll
            Sleep,50
            ControlSend,,{Blind}{Text}%szSellMacro%`n,ahk_exe game1127.dll
        }
    }
    bIsCrafting := false
    Return	
}

; Bindings 

F1::
    HaltCraft()
    ; Gui, show
    Gui ,Show, AutoSize Center
    Return
	
F2::
    ; No need to pause script while setting inventory slot position
    MouseGetPos, SellX, SellY
    GuiControl,,lblAutoSellLocation,Autosell inventory slot location: (x%SellX% y%SellY%)
    Return
		
F5::
    If( bIsCrafting )
    {
        TrayTip,Autocraft,Crafting is disabled,,1
        HaltCraft()
    }
    Else
    {
        TrayTip,Autocraft,Crafting is enabled,,1
        DoCraft()
    }
    Return
