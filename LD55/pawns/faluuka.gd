extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	# Do gravity, ignore it if we are paused, though.
	if not is_on_floor() and !get_tree().paused:
		velocity = Vector2.DOWN * 400
		
	move_and_slide()
