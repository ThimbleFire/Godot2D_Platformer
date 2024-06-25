class_name SceneController

extends Node2D

var pause_menu = preload("res://Assets/Windows/PauseMenu.tscn")
var menu_instance : Control

var actors : Array[Actor]
var enabled = false

func _ready():
	self.config_load()
	SceneChanger.ease_in(set_active)
	for actor in get_tree().get_nodes_in_group("Actor"):
		actors.append(actor)

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused == false:
			menu_instance = pause_menu.instantiate()
			$CanvasLayer.add_child(menu_instance)
	pass

func _physics_process(delta):
	if enabled:
		for actor in actors:
			actor.update(delta)

func set_active(state : bool = true):
	enabled = state
	
func config_save():
	var config = ConfigFile.new()
	config.set_value("Settings", "Resolution", $"Camera2D".zoom.x)
	if get_window().mode != Window.MODE_MINIMIZED:
		config.set_value("Settings", "WindowMode", get_window().mode)
	config.set_value("Settings", "Borderless", get_window().borderless)
	config.save("user://configuration.cfg")
	pass
	
func config_load():
	var config = ConfigFile.new()
	var err = config.load("user://configuration.cfg")
	if err != OK:
		return
	else:
		var camera_zoom = config.get_value("Settings", "Resolution")
		get_window().mode = config.get_value("Settings", "WindowMode")
		get_window().borderless = config.get_value("Settings", "Borderless")
		get_window().size = Vector2i(GConfig.WINDOW_WIDTH_SIZE_1 * camera_zoom, GConfig.WINDOW_HEIGHT_SIZE_1 * camera_zoom)
		$"Camera2D".zoom = Vector2(camera_zoom, camera_zoom) # lol
	pass

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		config_save()
		get_tree().quit()
