extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	if delta > 0.0 && !get_tree().paused:
		# Do gravity, ignore it if we are paused, though.
		if not is_on_floor():
			velocity = Vector2.DOWN * 400
			
		move_and_slide()
	else:
		velocity = Vector2.ZERO
