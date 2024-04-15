extends CharacterBody2D

@onready var left_raycast : RayCast2D = $LeftWallDetector
@onready var right_raycast : RayCast2D = $RightWallDetector
@onready var left_cliff_detector : RayCast2D = $LeftCliffDetector
@onready var right_cliff_detector : RayCast2D = $RightCliffDetector 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const SPEED = 75.0
const GRAVITY = 100.0
var current_facing = 1.0
var current_walk_timer = 0.0
var time_to_next_walk_switch = 1.0
var is_dying = false

func _ready():
	play_anim("idle")

func play_anim(animation: String):
	var direction: String
	if current_facing > 0.0:
		direction = "_right"
	else:
		direction = "_left"
	animation_player.play(animation + direction)

func _physics_process(delta):
	if delta > 0.0 && !get_tree().paused:
		if is_dying:
			play_anim("die")
			current_walk_timer -= delta
			if current_walk_timer < 0.0:
				queue_free()
		else:
			var start_cycle = false
			current_walk_timer += delta
			if !is_on_floor():
				velocity.y += GRAVITY * delta
			var should_reverse = false
			if current_walk_timer < 0.0:
				play_anim("idle")
				velocity.x = 0
			elif current_walk_timer < time_to_next_walk_switch:
				play_anim("walk")
				velocity.x = SPEED * current_facing
				if current_facing > 0.0 && right_raycast.is_colliding():
					should_reverse = true
				elif current_facing < 0.0 && left_raycast.is_colliding():
					should_reverse = true
				elif current_facing > 0.0 and !right_cliff_detector.is_colliding():
					should_reverse = true
				elif current_facing < 0.0 and !left_cliff_detector.is_colliding():
					should_reverse = true
				if should_reverse:
					current_facing = -current_facing
					# current_walk_timer = -1.0
			else:
				start_cycle = true
			move_and_slide()

			if start_cycle:
				current_walk_timer = randf_range(-1.0, -3.0)
				time_to_next_walk_switch = randf_range(0.5, 2.0)

func _on_body_entered(node: PhysicsBody2D):
	if !is_dying:
		if node is Player:
			var player = node as Player
			player.kill()


func _on_bounce_collider_body_entered(node: PhysicsBody2D):
	if !is_dying:
		if node is Player:
			var player = node as Player
			is_dying = true
			current_walk_timer = 0.5
			player.launch_up()
