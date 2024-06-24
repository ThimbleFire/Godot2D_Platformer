class_name SceneController

extends Node2D

@onready var screen_transition : ScreenTransition = $"CanvasLayer/ColorRect"
@export var actors : Array[Actor] = []
var enabled = false

func _ready():
	get_viewport().size = Vector2i(512, 512)
	screen_transition.ease_in(set_active)

func _physics_process(delta):
	if enabled:
		for actor in actors:
			actor.update(delta)

func set_active(state : bool = true):
	enabled = state
