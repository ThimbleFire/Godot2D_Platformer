class_name Player

extends CharacterBody2D

enum Direction { NONE, LEFT, RIGHT, DOWN, UP }

const speed = 75.0
const acceleration_speed = speed * 6.0
const gravity_normal = 500
const gravity_grappling = 50

@export var jump_speed = -181.25
@export var terminal_velocity = 225

@onready var animator = $"AnimatedSprite2D"
@onready var label = $"Label"
@onready var raycast_left : Raycast2DCollisionEvents = $"RayCast2D_Left"
@onready var raycast_right : Raycast2DCollisionEvents = $"RayCast2D_Right"

# Get the gravity from the project settings so you can sync with rigid body nodes.
@export var gravity = 500
var is_grappling : bool = false
var last_grapple : Direction = Direction.NONE
var is_paused = false

var is_against_left_wall:
	get: return raycast_left.is_colliding()

var is_against_right_wall:
	get: return raycast_right.is_colliding()

func _physics_process(delta):
	if is_paused:
		return
	
	# jump
	if Input.is_action_just_pressed("jump"):
		try_jump()
	elif Input.is_action_just_pressed("jump") and velocity.y < 0.0:
		velocity.y *= 0.6
		
	# gravity
	velocity.y = minf(terminal_velocity, velocity.y + gravity * delta)
		
	movement(delta)
	handle_animations()
	move_and_slide()

func try_jump() -> void:
	if is_on_floor():
		label.text = ""
	elif is_on_wall() and is_grappling:
		StopGrappling()
		velocity.x *= 2.5
	else:
		return
	velocity.y = jump_speed

func handle_animations():
	# play animations
	if !is_on_floor() and !is_on_wall():
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
	elif is_on_wall():
		if is_grappling:
			animator.play("grappling")
	pass

func movement(delta : float):
	var direction : float = 0.0
	if Input.is_key_pressed(KEY_A): direction = -1.0
	if Input.is_key_pressed(KEY_D): direction = 1.0
	
	velocity.x = move_toward(velocity.x, direction * speed, acceleration_speed * delta)
		
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			animator.scale.x = 1.0
		else:
			animator.scale.x = -1.0

func StartGrappling():
	is_grappling = true
	# set velocity.y to 0.0 to stop any jump momentum
	velocity.y = 0.0
	SpawnGrapplingParticles()
	gravity = gravity_grappling
	print("Start Grappling")
func StopGrappling():
	is_grappling = false
	gravity = gravity_normal
	print("Stop Grappling")

func SpawnGrapplingParticles():
	while is_grappling:
		print("Spawn grappling particles!")
		await get_tree().create_timer(1.0).timeout

func pause():
	is_paused = true
func unpause():
	is_paused = false

func _on_wall_contact(direction : Direction):
	if is_on_floor():
		return
		
	StartGrappling()
	last_grapple = direction
		
func _on_break_wall_contact(direction : Direction):
	StopGrappling()
	
func _on_floor_contact(direction : Direction):
	if is_grappling:
		StopGrappling()
	last_grapple = Direction.NONE
	
func _on_break_floor_contact(direction : Direction):
	pass

func _on_ceiling_contact(direction : Direction):
	pass
	
func _on_break_ceiling_contact(direction : Direction):
	pass

