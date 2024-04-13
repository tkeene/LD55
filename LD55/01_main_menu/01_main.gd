extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Left"):
		pass
	if Input.is_action_just_pressed("Right"):
		pass
	if Input.is_action_just_pressed("Action"):
		# TODO
		get_tree().change_scene_to_file("res://levels/11_level.tscn")
		pass
