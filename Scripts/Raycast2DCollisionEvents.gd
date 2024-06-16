class_name Raycast2DCollisionEvents

extends RayCast2D

signal on_collision_start(direction)
signal on_collision_end(direction)
signal on_collision(direction)

var colliding = false
@export var direction : Player.Direction

func _process(delta) -> void:
	if is_colliding() and !colliding:
		colliding = true
		emit_signal("on_collision_start", direction)
		return
	if !is_colliding() and colliding:
		colliding = false
		emit_signal("on_collision_end", direction)
		return
	if is_colliding():
		emit_signal("on_collision", direction)
		return
