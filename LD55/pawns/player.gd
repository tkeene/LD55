class_name Player
extends CharacterBody2D

const GROUND_MAX_SPEED : float = 90.0
const GROUND_ACCELERATION : float = 400.0
const AIR_ACCELERATION : float = 40.0
const GRAVITY : float = 400.0
const DEFAULT_JUMP_COOLDOWN : float = 0.25
const JUMP_VELOCITY : float = 180.0
const GHOST_JUMP_DURATION = 0.1
const DECELERATION : float = 0.1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_timer: Timer = $DeathTimer
@onready var tutorial_timer: Timer = $TutorialDeathTimer

static var last_position = Vector2.ZERO
var is_dead = false
var last_direction = "right"
var jump_pressed_flag = false
var remaining_jump_cooldown_seconds = 0.0
var remaining_floor_time = 0.0
var TIME_BETWEEN_FOOTSTEPS = 0.5
var walk_sound_timer = 0.0
var audio_source : AudioStreamPlayer = null

# Called when the player dies.
signal died
signal killed

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle_right")
	audio_source = AudioStreamPlayer.new()
	add_child(audio_source)

func _process(delta):
	# Do no animation if the player is dead.
	var is_walking = false
	if is_dead:
		pass
	elif jump_pressed_flag:
		animation_player.play("jump_" + last_direction)
		animation_player.queue("airborn_" + last_direction)
		jump_pressed_flag = false
		audio_source.stream = load("res://audio/sfx_jump.wav")
		audio_source.play()
	elif is_on_floor() and velocity.x > 0.1:
		is_walking = true
		animation_player.play("walk_right")
		last_direction = "right"
	elif is_on_floor() and velocity.x < -0.1:
		is_walking = true
		animation_player.play("walk_left")
		last_direction = "left"
	elif is_on_floor():
		animation_player.play("idle_" + last_direction)
	if is_walking:
		if walk_sound_timer <= 0.0:
			walk_sound_timer = TIME_BETWEEN_FOOTSTEPS
			audio_source.stream = load("res://audio/sfx_walk.wav")
			audio_source.play()
		else:
			walk_sound_timer -= delta
	else:
		walk_sound_timer = 0.0

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
		last_position = global_position

# Call this to kill the player.
func kill():
	print("Blort is kill. No.")
	if !is_dead:
		audio_source.stream = load("res://audio/sfx_die.wav")
		audio_source.play()
	is_dead = true
	animation_player.stop()
	death_timer.start()
	tutorial_timer.start()
	animation_player.play("die")
	animation_player.queue("dead")

# This will be called a short bit after the player is killed.
func _finalize_death():
	died.emit()

func _on_tutorial_death_timer_timeout():
	killed.emit()
