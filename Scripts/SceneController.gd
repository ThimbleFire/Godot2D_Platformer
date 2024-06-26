class_name SceneController

extends Node2D

var pause_menu = preload("res://Assets/Windows/PauseMenu.tscn")
var menu_instance : Control

var actors : Array[Actor]
var enabled = false

var resolution_index = 5

func _ready():
	SceneChanger.ease_in(set_active)
	for actor in get_tree().get_nodes_in_group("Actor"):
		actors.append(actor)

func _process(_delta):
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
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		GameConfiguration.gcsave()
		get_tree().quit()
