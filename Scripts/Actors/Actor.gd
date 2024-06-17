class_name Actor

extends CharacterBody2D

enum Direction { NONE, LEFT, RIGHT, DOWN, UP }
enum AnimationState { IDLE, JUMPING, FALLING, FALLING_FAST, MOVING, GRAPPLING, GET_UP }

const speed = 75.0
const acceleration_speed = speed * 6.0
const gravity_normal = 500
const gravity_grappling = 50
const jump_speed = -161.25
const terminal_velocity = 250

@onready var animator = $"AnimatedSprite2D"

var animation = ["idle", "jumping", "falling", "falling_fast", "moving", "grappling", "get_up"]
var animation_state : AnimationState = 0
var is_grappling : bool = false
var last_grapple : Direction = Direction.NONE
var gravity = 500
# We can't have just a single pause function because multiple things can pause character behaviour
var enabled = true
var is_moving:
	get: return not is_zero_approx(velocity.x)
var is_in_air:
	get: return !is_on_floor() and !is_grappling
var is_jumping:
	get: return velocity.y < 0.0
var is_falling:
	get: return velocity.y > 0 and velocity.y < terminal_velocity
var is_falling_terminal:
	get: return velocity.y >= terminal_velocity or animation_state == AnimationState.FALLING_FAST

func update(delta):
	velocity.y = minf(terminal_velocity, velocity.y + gravity * delta)
	if enabled:
		handle_movement(delta)
		handle_jump()
		handle_animations()
		move_and_slide()

func handle_movement(delta : float, direction : float = 0.0):
	velocity.x = move_toward(velocity.x, direction * speed, acceleration_speed * delta)
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0: animator.scale.x = 1.0
		else: 				 animator.scale.x = -1.0
func handle_jump(no_grapple_exception : bool = false):
	StopGrappling()
	velocity.y = jump_speed
	if is_on_floor():
		emit_jump_particle()

func handle_animations():
	if !is_on_floor():
		if !is_grappling:
			if is_jumping:
				animation_state = AnimationState.JUMPING
			elif is_falling_terminal:
				animation_state = AnimationState.FALLING_FAST
			elif is_falling:
				animation_state = AnimationState.FALLING
		else:
			animation_state = AnimationState.GRAPPLING
	elif is_moving:
		animation_state = AnimationState.MOVING
	else: 
		animation_state = AnimationState.IDLE
	animator.play(animation[animation_state])

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

func set_active(state : bool = true):
	enabled = state

func _on_wall_contact(direction : Direction):
	if is_on_floor():
		return
	# perevent grappling the same wall twice
	if direction != last_grapple:
		StartGrappling()
		last_grapple = direction
func _on_break_wall_contact(direction : Direction):
	if is_grappling:
		StopGrappling()
	if is_falling:
		delayed_grapple_jump()
func _on_floor_contact(direction : Direction):
	if is_falling_terminal:
		terminal_floor_bounce()
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
		if handle_jump(true):
			return
		await get_tree().create_timer(0.0).timeout 

func terminal_floor_bounce():
	var terminal_floor_bounce = -50
	var decayrate : float = 1.05
	set_active(false)
	animation_state = AnimationState.GET_UP
	animator.play(animation[animation_state])
	velocity.y = terminal_floor_bounce
	while animator.frame != 6:
		velocity.x /= decayrate
		move_and_slide()
		await get_tree().create_timer(0.0).timeout
	set_active(true)
