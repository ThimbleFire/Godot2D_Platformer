class_name Player

extends CharacterBody2D

enum Direction { NONE, LEFT, RIGHT, DOWN, UP }

const speed = 75.0
const acceleration_speed = speed * 6.0
const gravity_normal = 500
const gravity_grappling = 50

@onready var animator = $"AnimatedSprite2D"

@export var jump_speed = -181.25
@export var terminal_velocity = 225
@export var gravity = 500

var is_grappling : bool = false
var last_grapple : Direction = Direction.NONE
var is_paused = false

var lastX = 0.0

func _physics_process(delta):
	if is_paused:
		return
	
	handle_jump()
	velocity.y = minf(terminal_velocity, velocity.y + gravity * delta)
	handle_movement(delta)
	handle_animations()
	move_and_slide()

func handle_animations():
	# play animations
	if !is_on_floor() and !is_grappling:
		if velocity.y <= 0.0:
			animator.play("jumping")
		if velocity.y > 0.0:
			animator.play("falling")
		if velocity.y >= terminal_velocity:
			animator.play("falling_fast")
	elif is_on_floor():
		if velocity.x != 0:
			animator.play("moving")
		else:
			animator.play("idle")
	if is_grappling:
		animator.play("grappling")
	pass
func handle_movement(delta : float):
	var direction : float = 0.0
	if Input.is_key_pressed(KEY_A): direction = -1.0
	if Input.is_key_pressed(KEY_D): direction = 1.0
	
	velocity.x = move_toward(velocity.x, direction * speed, acceleration_speed * delta)
		
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			animator.scale.x = 1.0
		else:
			animator.scale.x = -1.0
func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or is_grappling:
			StopGrappling()
			velocity.y = jump_speed
			if is_on_floor():
				emit_jump_particle()

func StartGrappling():
	is_grappling = true
	# set velocity.y to 0.0 to stop any jump momentum
	velocity.y = 0.0
	emit_grappling_particles()
	gravity = gravity_grappling
func StopGrappling():
	is_grappling = false
	gravity = gravity_normal

func emit_grappling_particles():
	while is_grappling:
		await get_tree().create_timer(0.33).timeout
func emit_jump_particle():
	pass
func emit_head_bump_particle():
	pass

func pause():
	is_paused = true
func unpause():
	is_paused = false

func _on_wall_contact(direction : Direction):
	
	if is_on_floor():
		return
	
	# perevent grappling the same wall twice
	if direction != last_grapple:
		StartGrappling()
		last_grapple = direction
func _on_break_wall_contact(direction : Direction):
	StopGrappling()
	if velocity.y > 0:
		delayed_grapple_jump()
func _on_floor_contact(direction : Direction):
	if is_grappling:
		StopGrappling()
	last_grapple = Direction.NONE
func _on_break_floor_contact(direction : Direction):
	pass
func _on_ceiling_contact(direction : Direction):
	emit_head_bump_particle()
	pass
func _on_break_ceiling_contact(direction : Direction):
	pass

func delayed_grapple_jump():
	var timer : float = 0.0
	var duration : float = 0.125
	while timer < duration:
		timer += get_process_delta_time()
		if Input.is_key_pressed(KEY_SPACE):
			velocity.y = jump_speed
			return
		await get_tree().create_timer(0.0).timeout 
