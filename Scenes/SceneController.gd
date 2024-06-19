class_name SceneController

extends Node2D

@export var actors : Array[Actor] = []
var enabled = true

func _ready():
	get_viewport().size = Vector2i(512, 512)

func _physics_process(delta):
	if enabled:
		for actor in actors:
			actor.update(delta)

func set_active(state : bool = true):
	enabled = state