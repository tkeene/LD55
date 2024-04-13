extends CharacterBody2D

const GROUND_MAX_SPEED : float = 4000.0
const GROUND_ACCELERATION : float = 500.0
const GRAVITY : float = 200.0
const DEFAULT_JUMP_COOLDOWN : float = 0.25
const JUMP_VELOCITY : float = 120.0
const GHOST_JUMP_DURATION = 0.30
const DECELERATION : float = 0.1

var remaining_jump_cooldown_seconds = 0.0
var remaining_floor_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _process(delta):
	# TODO Animation
	pass

func _physics_process(delta):
	if delta > 0.0:
		remaining_jump_cooldown_seconds -= delta
		if is_on_floor():
			remaining_floor_time = GHOST_JUMP_DURATION
		else:
			remaining_floor_time -= delta
		# Input
		var horizontal_input : float = 0.0
		var jump_pressed : bool = false
		if Input.is_action_pressed("Left"):
			horizontal_input -= 1.0
		if Input.is_action_pressed("Right"):
			horizontal_input += 1.0
		if (Input.is_action_just_pressed("Action") and remaining_jump_cooldown_seconds <= 0.0
			and remaining_floor_time >= 0.0):
			jump_pressed = true
		# Platforming Physics
		var current_velocity : Vector2 = velocity
		current_velocity.x = horizontal_input * GROUND_MAX_SPEED * delta
		if jump_pressed:
			current_velocity.y -= JUMP_VELOCITY
			remaining_jump_cooldown_seconds = DEFAULT_JUMP_COOLDOWN
		else:
			current_velocity.y += GRAVITY * delta
		velocity = current_velocity
		
		move_and_slide()