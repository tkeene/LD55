extends Area2D

@onready var animation_player = $AnimationPlayer
# TODO: add a reference to what spell this page should add to the spellbook

func _ready():
	animation_player.play("idle")

func _process(delta):
	pass

func _on_body_entered(body):
	print("You touched the butt. I mean the page.")
	queue_free()
