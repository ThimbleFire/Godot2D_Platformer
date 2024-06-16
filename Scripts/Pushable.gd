extends CharacterBody2D

@onready var player_character : Player = $"../Player"

func _on_player_collision(direction):
	velocity.x = move_toward(velocity.x, (1.0 if direction == 1 else -1.0) * 75.0, 450 * get_process_delta_time())
	
func _physics_process(delta):
	velocity_decay()
	move_and_slide()
	
func velocity_decay():
	var decayrate : float = 1.05
	velocity /= decayrate
	pass

