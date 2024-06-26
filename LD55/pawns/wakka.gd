class_name Wakka
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var left_cliff_detector: RayCast2D = $LeftCliffDetector
@onready var right_cliff_detector: RayCast2D = $RightCliffDetector
@onready var back_detector: Area2D = $BackDetector

# Set to 1 to start moving (and reverse direction if we're at a wall or cliff).
var start_moving: bool = false
var moving: bool = false

const speed := 50.0

var direction := 1

func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	if delta > 0.0 && !get_tree().paused:
		var cliff_detector = left_cliff_detector if direction > 0 else right_cliff_detector
		# Do gravity, ignore it if we are paused, though.
		if not is_on_floor() and !get_tree().paused:
			velocity = Vector2.DOWN * 300

		if start_moving:
			print("time to start moving")
			start_moving = false
			moving = true
			# Check if we need to switch directions.
			if is_on_wall() or (is_on_floor() and !cliff_detector.is_colliding()):
				print("turning around")
				direction *= -1
			velocity.x = (Vector2.LEFT * speed * direction).x
			animation_player.play.call_deferred("walk")
		else:
			# Check if we need to stop.
			if is_on_wall() or (is_on_floor() and !cliff_detector.is_colliding()):
				print("time to stop")
				moving = false
				velocity.x = 0
				animation_player.play.call_deferred("idle")
			elif moving:
				velocity.x = (Vector2.LEFT * speed * direction).x
		move_and_slide()

# Called when something enters the back detector.
func on_back_loaded(body: Node2D):
	if body is Player:
		print("Got landed on")
		start_moving = true
