extends Node

var enabled = true

func _on_area_2d_body_entered(body):
	if !enabled:
		return
		
	print("player in door")

func set_active(state : bool = true):
	enabled = state
