class_name ScreenTransition

extends ColorRect

func ease_out(callback):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.5)
	tween.tween_callback(callback)
	pass

func ease_in(callback):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.5)
	tween.tween_callback(callback)
