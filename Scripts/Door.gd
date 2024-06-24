extends Node2D

@export var filename : String
@onready var player : Player = $"../Player"
@onready var screen_transition : ScreenTransition = $"../CanvasLayer/ColorRect"

func _on_area_2d_body_entered(body):
	player.try_interact.connect(_on_interact)

func _on_area_2d_body_exited(body):
	player.try_interact.disconnect(_on_interact)

func _on_interact():
	screen_transition.ease_out(_on_ease_out_finished)

func _on_ease_out_finished():
	get_tree().change_scene_to_file(filename)
	pass
