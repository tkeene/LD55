extends Node

var restart_timer = 20.0

func _ready():
	get_tree().paused = false

func _process(delta):
	restart_timer -= delta
	if Input.is_action_just_pressed("ui_cancel"):
		restart_timer *= 0.05
	if restart_timer <= 0:
		get_tree().change_scene_to_file("res://01_main_menu/01_main.tscn")
