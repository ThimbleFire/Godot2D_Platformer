# Prefix

## TODO code changes:
* Modify `Prefix/Assets/Windows/PauseMenu.gd` so its applicable to all menus and not just the pause menu.
* Have `PauseMenu.tscn` instantiate `SettingsMenu.tscn` and delete itself.

## TODO List:
* ❌ Add UI sound effects
* ❌ How about you make the game?

## Complete List:
* ✔ Add scene change behaviour
  * Each `Door` has an id that corrosponds with its exit on its destination level _(Door with id 3 in Level_1 leads to door with id 3 in Level_2)_
  * ✔ Add scene change transition
* ✔  Add a jump effect
* ✔  Add a grapple effect
* ✔  Save and load game configuration on exit & load
* ✔  Add a pause menu
* ✔ Add a settings menu for changing resolution
  * ✔ Get it so the menu changes the resolution
* ✔ Save changes to settings immediately because configuration is loaded every time a scene is loaded and currently we're only saving when exiting the game
* ✔ Scale UI with resolution
