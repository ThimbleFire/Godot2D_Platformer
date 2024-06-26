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
var resolution_index = 5
var windowed_res_ref = Vector2i(1920,1080)

func _ready():
	get_tree().paused = true
	animation_player.play("menu_foreground_blur")
	#resolution_index = Camera.zoom.x - 1.0
	resolution_index = GConfig.RESOLUTIONS.find(GameConfiguration.get_value("Resolution"))
	var label : Label = settings_container.get_child(0)
	match GameConfiguration.get_value("WindowMode"):
		Window.MODE_EXCLUSIVE_FULLSCREEN:
			enable_label(label, "SCREEN MODE: FULLSCREEN") 
			disable_label(settings.get_child(1), "RESOLUTION: " + GConfig.RESOLUTIONS_STR[resolution_index])
		Window.MODE_WINDOWED:
			enable_label(label, "SCREEN MODE: WINDOWED") 
			enable_label(settings.get_child(1), "RESOLUTION: " + GConfig.RESOLUTIONS_STR[resolution_index])
	
func _process(delta):
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
			3: close_settings()
		
	if Input.is_action_just_pressed("right"):
		match settings_index:
			0: _on_fullscreen_increase()
			1: _on_resolution_increase()
		
	if Input.is_action_just_pressed("left"):
		match settings_index:
			0: _on_fullscreen_decrease()
			1: _on_resolution_decrease()

func close():
	animation_player.play_backwards("menu_foreground_blur")
	await animation_player.animation_finished
	get_tree().paused = false
	self.queue_free()
func close_settings():
	GameConfiguration.gcsave()
	active_page = 0
	main.visible = true
	settings.visible = false

func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
func _on_resolution_increase():
	var enabled : bool = settings_container.get_child(0).get_meta("Enabled")
	if enabled:
		if resolution_index < 5:
			resolution_index += 1
			var label : Label = settings_container.get_child(0)
			label.text = "RESOLUTION: " + GConfig.RESOLUTIONS_STR[resolution_index]
			get_window().size = Vector2i(GConfig.WINDOW_WIDTH_SIZE_1 * (resolution_index+1), GConfig.WINDOW_HEIGHT_SIZE_1 * (resolution_index+1))
			GameConfiguration.set_value("Resolution", get_window().size)
func _on_resolution_decrease():
	var enabled : bool = settings_container.get_child(0).get_meta("Enabled")
	if enabled:
		if resolution_index > 0:
			resolution_index -= 1
			var label : Label = settings_container.get_child(0)
			label.text = "RESOLUTION: " + GConfig.RESOLUTIONS_STR[resolution_index]
			await get_tree().create_timer(0.05).timeout
			get_window().borderless = false
			await get_tree().create_timer(0.05).timeout
			get_window().size = Vector2i(GConfig.WINDOW_WIDTH_SIZE_1 * (resolution_index+1), GConfig.WINDOW_HEIGHT_SIZE_1 * (resolution_index+1))
			GameConfiguration.set_value("Resolution", get_window().size)
			GameConfiguration.set_value("Borderless", get_window().borderless)

func _on_fullscreen_increase():
	var label : Label = settings_container.get_child(0)
	match get_window().mode:
		Window.MODE_WINDOWED:
			windowed_res_ref = get_window().size
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			label.text = "SCREEN MODE: FULLSCREEN"
			get_window().borderless = true
			disable_label(settings.get_child(1), "RESOLUTION: 1920 x 1080")
			await get_tree().create_timer(0.05).timeout
			GameConfiguration.set_value("Resolution", get_window().size)
			GameConfiguration.set_value("Borderless", get_window().borderless)
			GameConfiguration.set_value("WindowMode", get_window().mode)
			resolution_index = 5
func _on_fullscreen_decrease():
	var label : Label = settings_container.get_child(0)
	match get_window().mode:
		Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
			resolution_index = GConfig.RESOLUTIONS.find(windowed_res_ref)
			label.text = "SCREEN MODE: WINDOWED"
			enable_label(settings.get_child(1))
			get_window().borderless = true
			await get_tree().create_timer(0.05).timeout
			get_window().borderless = false
			await get_tree().create_timer(0.05).timeout
			get_window().size = windowed_res_ref
			enable_label(settings.get_child(1), "RESOLUTION: " + GConfig.RESOLUTIONS_STR[resolution_index])
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
