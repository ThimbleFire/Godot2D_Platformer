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
var windowed_res_ref = Vector2i(1920,1080)

func _ready():
	get_tree().paused = true
	animation_player.play("menu_foreground_blur")
	var label : Label = settings_container.get_child(0)
	match GameConfiguration.get_value("WindowMode"):
		Window.MODE_EXCLUSIVE_FULLSCREEN:
			enable_label(label, "SCREEN MODE: FULLSCREEN") 
			disable_label(settings.get_child(1), "RESOLUTION: " + GameConfiguration.current_resolution_str)
		Window.MODE_WINDOWED:
			enable_label(label, "SCREEN MODE: WINDOWED") 
			enable_label(settings.get_child(1), "RESOLUTION: " + GameConfiguration.current_resolution_str)
	
func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused == true and !animation_player.is_playing():
			if main.visible == true:
				close()
			elif settings.visible == true:
				close_settings()
				
	match active_page:
		0:
			handle_main()
		1:
			handle_settings()

func handle_main():
	var child = main_container.get_child(0)
	if Input.is_action_just_pressed("Down"):
		if menu_index < main.get_child_count() - 1:
			child.reparent(main)
			main.move_child(child, menu_index)
			menu_index += 1
			var child2 = main.get_child(menu_index + 1)
			child2.reparent(main_container)
			
	if Input.is_action_just_pressed("Up"):
		if menu_index > 0:
			child.reparent(main)
			main.move_child(child, main_container.get_index() + 1)
			menu_index -= 1
			var child2 = main.get_child(menu_index)
			child2.reparent(main_container)
			
	if Input.is_action_just_pressed("Interact"):
		match menu_index:
			0: close_main()
			1: 
				active_page = Page.SETTINGS
				main.visible = false
				settings.visible = true
			2: quit()

func close_main():
	animation_player.play_backwards("menu_foreground_blur")
	await animation_player.animation_finished
	get_tree().paused = false
	self.queue_free()

func handle_settings():
	var child = settings_container.get_child(0)
	if Input.is_action_just_pressed("Down"):
		if settings_index < settings.get_child_count() - 1:
			child.reparent(settings)
			settings.move_child(child, settings_index)
			settings_index += 1
			var child2 = settings.get_child(settings_index + 1)
			child2.reparent(settings_container)
			
	if Input.is_action_just_pressed("Up"):
		if settings_index > 0:
			child.reparent(settings)
			settings.move_child(child, settings_container.get_index() + 1)
			settings_index -= 1
			var child2 = settings.get_child(settings_index)
			child2.reparent(settings_container)
			
	if Input.is_action_just_pressed("Interact"):
		match settings_index:
			2: reset_configuration()
			3: close_settings()
		
	if Input.is_action_just_pressed("right"):
		match settings_index:
			0: _on_fullscreen_increase(child)
			1: _on_resolution_increase(child)
		
	if Input.is_action_just_pressed("left"):
		match settings_index:
			0: _on_fullscreen_decrease(child)
			1: _on_resolution_decrease(child)

func close_settings():
	GameConfiguration.gcsave()
	active_page = Page.MAIN
	main.visible = true
	settings.visible = false

func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
func _on_resolution_increase(child : Label):
	var enabled : bool = settings_container.get_child(0).get_meta("Enabled")
	if enabled:
		GameConfiguration.increase_resolution()
		child.text = "RESOLUTION: " + GameConfiguration.current_resolution_str
		GameConfiguration.set_value("Resolution", get_window().size)

func _on_resolution_decrease(child : Label):
	var enabled : bool = settings_container.get_child(0).get_meta("Enabled")
	if enabled:
		await get_tree().create_timer(0.05).timeout
		GameConfiguration.decrease_resolution()
		child.text = "RESOLUTION: " + GameConfiguration.current_resolution_str
		GameConfiguration.set_value("Resolution", get_window().size)
		GameConfiguration.set_value("Borderless", get_window().borderless)

func _on_fullscreen_increase(child : Label):
	match get_window().mode:
		Window.MODE_WINDOWED:
			windowed_res_ref = get_window().size
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			child.text = "SCREEN MODE: FULLSCREEN"
			get_window().borderless = true
			disable_label(settings.get_child(1), "RESOLUTION: 1920 x 1080")
			await get_tree().create_timer(0.05).timeout
			GameConfiguration.set_value("Resolution", get_window().size)
			GameConfiguration.set_value("Borderless", get_window().borderless)
			GameConfiguration.set_value("WindowMode", get_window().mode)

func _on_fullscreen_decrease(child : Label):
	match get_window().mode:
		Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
			child.text = "SCREEN MODE: WINDOWED"
			enable_label(settings.get_child(1))
			get_window().borderless = true
			await get_tree().create_timer(0.05).timeout
			get_window().borderless = false
			await get_tree().create_timer(0.05).timeout
			get_window().size = windowed_res_ref
			enable_label(settings.get_child(1), "RESOLUTION: " + GameConfiguration.current_resolution_str)
			GameConfiguration.set_value("Resolution", get_window().size)
			GameConfiguration.set_value("Borderless", get_window().borderless)
			GameConfiguration.set_value("WindowMode", get_window().mode)
	
func disable_label(label : Label, state : String = ""):
	label.set("theme_override_colors/font_color", Color(0.33, 0.33, 0.33, 1.0))
	label.set_meta("Enabled", false)
	if state != "":
		label.text = state
	pass

func enable_label(label : Label, state : String = ""):
	label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	label.set_meta("Enabled", true)
	if state != "":
		label.text = state
	pass

func reset_configuration():
	get_window().borderless = false
	get_window().mode = Window.MODE_WINDOWED
	enable_label(settings.get_child(0), "SCREEN MODE: WINDOWED")
	get_window().size = Vector2i(1280, 720)
	enable_label(settings.get_child(1), "RESOLUTION: " + GameConfiguration.current_resolution_str)
	GameConfiguration.set_value("Resolution", get_window().size)
	GameConfiguration.set_value("Borderless", get_window().borderless)
	GameConfiguration.set_value("WindowMode", get_window().mode)
