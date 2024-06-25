extends Node

var canvas_object = preload("res://Assets/Screen Transition/ScreenTransition.tscn")

var callback_ref
var screen_controller

func ease_in(event):
	callback_ref = event
	screen_controller = canvas_object.instantiate()
	add_child(screen_controller)
	var canvas = screen_controller.get_child(0) as ColorRect
	canvas.size = DisplayServer.window_get_size()
	canvas.ease_in(_on_eased_in)

func ease_out(event):
	callback_ref = event
	screen_controller = canvas_object.instantiate()
	add_child(screen_controller)
	var canvas = screen_controller.get_child(0) as ColorRect
	canvas.size = DisplayServer.window_get_size()
	canvas.ease_out(_on_eased_out)

func _on_eased_in():
	screen_controller.queue_free()
	callback_ref.call()

func _on_eased_out():
	screen_controller.queue_free()
	callback_ref.call()

