extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start_me():
	animation_player.play("write")
	animation_player.queue("loop")
