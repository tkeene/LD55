extends Area2D
class_name Page

@onready var animation_player = $AnimationPlayer

@export var summon_name = "[NAME]"

func _ready():
	if LevelRoot.has_summon(summon_name):
		queue_free()
	else:
		animation_player.play("idle")

func _process(delta):
	pass

func _on_body_entered(body):
	if body is Player:
		print("You touched the butt. I mean the page.")
		LevelRoot.unlock_summon(summon_name)
		queue_free()
