class_name SceneController

extends Node2D

var actors : Array[Actor]
var enabled = false

func _ready():
	SceneChanger.ease_in(set_active)
	for actor in get_tree().get_nodes_in_group("Actor"):
		actors.append(actor)

func _physics_process(delta):
	if enabled:
		for actor in actors:
			actor.update(delta)

func set_active(state : bool = true):
	enabled = state
