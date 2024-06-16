extends Camera2D

@onready var player_character = $"../Player"
var lastX = 0
var lastY = 0
@export var pan_speed = 1.0

func _process(delta):
	var currentX = floor(player_character.position.x / 128)
	var currentY = floor(player_character.position.y / 128)
	
	if currentX != lastX or currentY != lastY:
		lastX = currentX
		lastY = currentY
		player_character.pause()
		await pan_to(currentX, currentY)
	pass

func pan_to(x, y):
	var offset : Vector2 = Vector2(64, 64)
	var panning_to = Vector2(x * 128, y * 128) + offset
	
	while panning_to != position:
		position = position.move_toward(panning_to, 1.0 * get_process_delta_time() * pan_speed)
		await get_tree().create_timer(0.0).timeout
		
	player_character.unpause()
	pass
