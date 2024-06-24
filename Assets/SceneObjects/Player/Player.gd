class_name Player

extends Actor

signal try_interact

func handle_movement(delta : float, direction : float = 0.0):
	if Input.is_key_pressed(KEY_A): direction = -1.0
	if Input.is_key_pressed(KEY_D): direction = 1.0
	super.handle_movement(delta, direction)

#Node: scene objects must subscribe to `try_interact` in order to be interacted with.
func handle_interact():
	if Input.is_action_just_pressed("Interact"):
		emit_signal("try_interact")

#NOTE: see also `_on_break_floor_contact`
func handle_jump(no_grapple_exception : bool = false):
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_grappling or no_grapple_exception):
		super.handle_jump()
		return true
