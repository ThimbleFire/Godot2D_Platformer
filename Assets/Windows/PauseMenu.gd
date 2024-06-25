extends Control

enum Page { MAIN, SETTINGS }
var active_page : Page = Page.MAIN

@onready var animation_player : AnimationPlayer = $"AnimationPlayer"
@onready var main : VBoxContainer = $"PanelContainer/Main"
@onready var settings : VBoxContainer = $"PanelContainer/Settings"
@onready var main_container : PanelContainer = $"PanelContainer/Main/Box"
@onready var settings_container : PanelContainer = $"PanelContainer/Settings/Box"

var menu_index = 0
var settings_index = 0

func _ready():
	get_tree().paused = true
	animation_player.play("menu_foreground_blur")
	
func _process(delta):	
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused == true and !animation_player.is_playing():
			if main.visible == true:
				close()
			elif settings.visible == true:
				active_page = 0
				settings.visible = false
				main.visible = true
				
	match active_page:
		0:
			handle_main()
		1:
			handle_settings()

func handle_main():
	if Input.is_action_just_pressed("Down"):
		if menu_index < main.get_child_count() - 1:
			var child = main_container.get_child(0)
			child.reparent(main)
			main.move_child(child, menu_index)
			menu_index += 1
			var child2 = main.get_child(menu_index + 1)
			child2.reparent(main_container)
			
	if Input.is_action_just_pressed("Up"):
		if menu_index > 0:
			var child = main_container.get_child(0)
			child.reparent(main)
			main.move_child(child, main_container.get_index() + 1)
			menu_index -= 1
			var child2 = main.get_child(menu_index)
			child2.reparent(main_container)
			
	if Input.is_action_just_pressed("Interact"):
		match menu_index:
			0: close()
			1: 
				active_page = 1
				main.visible = false
				settings.visible = true
			2: quit()
			
func handle_settings():
	if Input.is_action_just_pressed("Down"):
		if settings_index < settings.get_child_count() - 1:
			var child = settings_container.get_child(0)
			child.reparent(settings)
			settings.move_child(child, settings_index)
			settings_index += 1
			var child2 = settings.get_child(settings_index + 1)
			child2.reparent(settings_container)
			
	if Input.is_action_just_pressed("Up"):
		if settings_index > 0:
			var child = settings_container.get_child(0)
			child.reparent(settings)
			settings.move_child(child, settings_container.get_index() + 1)
			settings_index -= 1
			var child2 = settings.get_child(settings_index)
			child2.reparent(settings_container)
			
	if Input.is_action_just_pressed("Interact"):
		match settings_index:
			3: 
				active_page = 0
				main.visible = true
				settings.visible = false
	pass

func close():
	animation_player.play_backwards("menu_foreground_blur")
	await animation_player.animation_finished
	get_tree().paused = false
	self.queue_free()
	
func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
