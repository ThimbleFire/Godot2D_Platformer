extends Node2D

@export var filename : String
@onready var player : Player = $"../Player"
@onready var scene_controller : SceneController = $".."

var enabled : bool = true

func _on_area_2d_body_entered(body):
	player.try_interact.connect(_on_interact)

func _on_area_2d_body_exited(body):
	player.try_interact.disconnect(_on_interact)

func _on_interact():
	if enabled:
		enabled = false
		scene_controller.set_active(false)
		SceneChanger.ease_out(_on_ease_out_finished)
	pass
func _on_ease_out_finished():
	get_tree().change_scene_to_file(filename)
	pass
