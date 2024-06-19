https://godotshaders.com/shader/diamond-based-screen-transition/

# Prefix

## TODO:
* [ ] Change `Area2D` collision mask on `Door` so that it only collides with `Player`
* [ ] Add scene change behaviour
  * Each `Door` has an id that corrosponds with its exit on its destination level _(Door with id 3 in Level_1 leads to door with id 3 in Level_2)_
  * [ ] Add scene change transition
* [ ]  Add a jump effect
* [ ]  Add a grapple effect
* [ ]  Add player sound effects
* [ ]  Change up the world to something more like Fez
* [ ]  Add slow camera tracking
* [ ]  Add impactful camera zoom transitions
* [ ]  Add an NPC
* [ ]  Make the NPC move around slowly occasionally
* [ ]  Create a dialog system (oh boy, here we go...)
* [ ]  Make the NPC talk-to-able while they're idle
  * Add a little speech bubble pop-up overhead when they can be talked to
  * If the NPC has any unspoken dialog, make the icon yellow, else gray
* [ ] Add a sound effect for the dialog while each character is being added to the dialog box
* [ ] Have the NPC give the player an item that enhances their ability to navigate the game world
  * The player should be limited to the number of items they can carry, this means at any one-point in time they won't be able to explore the whole world - they'll need to carefully decide which NPCs to exchange items with.
  * Once the player loses an item they can no longer get it back.

## Items
### Claw
Allows the character to grapple
### Grappling Gun
Pulls the character toward where they're aiming
### Map Piece
Two map pieces allow the player to attempt getting an extra life (think Dizzy)
### Fire Staff
Sends out some fire projectile or beam that vaporizes what the character is aiming at, can light dark scenery
### Lightning Staff
Sends out a stream of lightning that vaporizes what the character is aiming at, can toggle electrical machinary
### Nature Staff
Turns seeds into trees which can be climbed, and trees into seeds
### Magic Boots
Allows the character to double jump
### Magic Glasses
Reveals hidden doors and traps

* Make the game arcade-ish
* have enemeys burst through the background, like giant worms
* have enemies like the flytrap in HoD
* add underwater & underwater breathing
* start the player off with magic
* the player loses their spells after a short way in
* they get their spells back half way in
