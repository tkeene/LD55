class_name Player
extends CharacterBody2D

const GROUND_MAX_SPEED : float = 60.0
const GROUND_ACCELERATION : float = 600.0
const AIR_ACCELERATION : float = 40.0
const GRAVITY : float = 400.0
const DEFAULT_JUMP_COOLDOWN : float = 0.25
const JUMP_VELOCITY : float = 180.0
const GHOST_JUMP_DURATION = 0.1
const DECELERATION : float = 0.1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_timer: Timer = $DeathTimer

var is_dead = false
var last_direction = "right"
var jump_pressed_flag = false
var remaining_jump_cooldown_seconds = 0.0
var remaining_floor_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle_right")

func _process(delta):
	# Do no animation if the player is dead.
	if is_dead:
		pass
	elif jump_pressed_flag:
		animation_player.play("jump_" + last_direction)
		animation_player.queue("airborn_" + last_direction)
		jump_pressed_flag = false
	elif is_on_floor() and velocity.x > 0.1:
		animation_player.play("walk_right")
		last_direction = "right"
	elif is_on_floor() and velocity.x < -0.1:
		animation_player.play("walk_left")
		last_direction = "left"
	elif is_on_floor():
		animation_player.play("idle_" + last_direction)

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
		if not is_dead: # Don't let the player move if dead.
			if Input.is_action_pressed("ui_left"):
				horizontal_input -= 1.0
			if Input.is_action_pressed("ui_right"):
				horizontal_input += 1.0
			if (Input.is_action_just_pressed("ui_accept") and remaining_jump_cooldown_seconds <= 0.0
				and remaining_floor_time >= 0.0):
				jump_pressed = true
				jump_pressed_flag = true
		# Platforming Physics
		var current_velocity : Vector2 = velocity
		var acceleration = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
		current_velocity.x = move_toward(current_velocity.x, horizontal_input * GROUND_MAX_SPEED, delta * acceleration)
		if jump_pressed:
			current_velocity.y -= JUMP_VELOCITY
			remaining_jump_cooldown_seconds = DEFAULT_JUMP_COOLDOWN
			remaining_floor_time = -delta
		else:
			current_velocity.y += GRAVITY * delta
		velocity = current_velocity
		
		move_and_slide()

# Call this to kill the player.
func kill():
	print("Blort is kill. No.")
	is_dead = true
	animation_player.stop()
	death_timer.start()
	animation_player.play("die")
	animation_player.queue("dead")

# This will be called a short bit after the player is killed.
func _finalize_death():
	LevelRoot.reset_level()
