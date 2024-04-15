extends CharacterBody2D

@onready var left_raycast : RayCast2D = $LeftWallDetector
@onready var right_raycast : RayCast2D = $RightWallDetector
const SPEED = 150.0
const GRAVITY = 100.0
var current_facing = 1.0
var current_walk_timer = 0.0
var time_to_next_walk_switch = 1.0
var is_dying = false

func _physics_process(delta):
	if delta > 0.0 && !get_tree().paused:
		if is_dying:
			# TODO: Dying animation
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
				# TODO: Standing animation
				velocity.x = 0
			elif current_walk_timer < time_to_next_walk_switch:
				# TODO: Walking animation
				velocity.x = SPEED * current_facing
				if current_facing > 0.0 && right_raycast.is_colliding():
					should_reverse = true
				elif current_facing < 0.0 && left_raycast.is_colliding():
					should_reverse = true
				if should_reverse:
					current_facing = -current_facing
					current_walk_timer = -1.0
			else:
				start_cycle = true
			move_and_slide()

			if start_cycle:
				current_walk_timer = randf_range(-1.0, -3.0)
				time_to_next_walk_switch = randf_range(1.0, 3.0)

func _on_body_entered(node: PhysicsBody2D):
	if !is_dying:
		if node is Player:
			var player = node as Player
			if player.velocity.y > 0.1: # If the player is falling downwards
				is_dying = true
				current_walk_timer = 0.5
				player.launch_up()
			else:
				player.kill()
