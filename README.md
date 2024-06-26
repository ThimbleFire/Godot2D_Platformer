# Prefix

## TODO code changes:
* `Prefix/Scripts/SceneController.gd::config_load` Don't load borderless, just set it to true if Resolution is 6
* `Prefix/Scripts/SceneController.gd::config_save` Don't use `Camera.zoom.x` to determine resolution index.
* Modify `Prefix/Assets/Windows/PauseMenu.gd` so its applicable to all menus and not just the pause menu.
* Have `PauseMenu.tscn` instantiate `SettingsMenu.tscn` and delete itself.

## TODO List:
* ❌ Save changes to settings immediately because configuration is loaded every time a scene is loaded and currently we're only saving when exiting the game
* ❌ Scale UI with resolution
* ❌ Add UI sound effects
* ❌ Add player character sound effects
* ❌ Change up the world to something more like Fez
* ❌ Add slow camera tracking
* ❌ Add impactful camera zoom transitions
* ❌ Add an NPC
* ❌ Make the NPC move around slowly occasionally
* ❌ Create a dialog system (oh boy, here we go...)
* ❌ Make the NPC talk-to-able while they're idle
  * Add a little speech bubble pop-up overhead when they can be talked to
  * If the NPC has any unspoken dialog, make the icon yellow, else gray
* ❌ Add a sound effect for the dialog while each character is being added to the dialog box
* ❌ Have the NPC give the player an item that enhances their ability to navigate the game world
  * The player should be limited to the number of items they can carry, this means at any one-point in time they won't be able to explore the whole world - they'll need to carefully decide which NPCs to exchange items with.
  * Once the player loses an item they can no longer get it back.

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
