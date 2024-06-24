extends Node

var canvas_object = preload("res://Assets/ScreenController.tscn")

var callback_ref

func ease_in(event):
	callback_ref = event
	var screen_controller = canvas_object.instantiate()
	add_child(screen_controller)
	var canvas : ScreenTransition = $"CanvasLayer/ColorRect"
	canvas.ease_in(_on_eased_in)
	
func ease_out(event):
	callback_ref = event
	var screen_controller = canvas_object.instantiate()
	add_child(screen_controller)
	var canvas : ScreenTransition = $"CanvasLayer/ColorRect"
	canvas.ease_out(_on_eased_out)
	
func _on_eased_in():
	#$"CanvasLayer".queue_free()
	print("on successful ease in")
	callback_ref.call()
	pass
func _on_eased_out():
	#$"CanvasLayer".queue_free()
	print("on successful ease out")
	callback_ref.call()
	pass
