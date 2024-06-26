class_name GConfig

extends Node

const WINDOW_WIDTH_SIZE_1 = 320
const WINDOW_HEIGHT_SIZE_1 = 180
const RESOLUTIONS : Array[Vector2i] = [
	Vector2i(320,180), 
	Vector2i(640,360), 
	Vector2i(960,540), 
	Vector2i(1280,720), 
	Vector2i(1600,900), 
	Vector2i(1920,1080)]
const CONFIGURATION_PATH : String = "user://configuration.cfg"

func increase_resolution():
	var i : int = RESOLUTIONS.find(get_window().size)
	if i + 1 < RESOLUTIONS.size - 1:
		get_window().size = RESOLUTIONS(i + 1)

func decrease_resolution():
	var i : int = RESOLUTIONS.find(get_window().size)
	if i > 0:
		get_window().size = RESOLUTIONS(i - 1)

var config : ConfigFile

func _ready():
	config = ConfigFile.new()
	var err = config.load(CONFIGURATION_PATH)
	if err != OK:
		return
	else: gcload()

func get_value(property_name):
	return config.get_value("Settings", property_name)
	
func set_value(property_name, value):
	config.set_value("Settings", property_name, value)

func gcsave():
	config.save(CONFIGURATION_PATH)
	pass

func gcload():
	get_window().borderless = config.get_value("Settings", "Borderless")
	await get_tree().create_timer(0.02).timeout
	get_window().mode = config.get_value("Settings", "WindowMode")
	await get_tree().create_timer(0.02).timeout
	get_window().size = config.get_value("Settings", "Resolution")
	await get_tree().create_timer(0.02).timeout
