# AutoCrafter
An autoclicking crafting script for Dark Age of Camelot

## Usage:
**Press F1** to enter the Hotstring to use for each crafting attempt, the default String is "1" meaning that the script will hit the 1 key on each attempt to craft the item. Any ahk-recognized hotstring may be entered here.

**Press F2** while hovering the mouse over an inventory slot to set it as the autosell slot. Once set and if autosell is enabled, the script will click that inventory slot and attempt to autosell the item at that location after each crafting attempt. 
*Note 1: Actually the location of the inventory slot is what is recorded, so if your dialog moves, you will need to reset the sell inventory slot* 
*Note 2: For auto-sell to function properly, you must have an in-range merchant selected*

**Press F3** to toggle auto-sell on and off. Autosell is off by default, but is turned on automatically when you select an inventory, or if you manually toggle it on.

**Press F4** to enter the amount of time to wait between craft attempts. The default crafting wait time is 2000ms, or 2 seconds. Wait times should be entered in milliseconds.

**Press F5** to start or stop the crafting crafting script using the configured values. Does not actually stop an in-progress craft attempt.
