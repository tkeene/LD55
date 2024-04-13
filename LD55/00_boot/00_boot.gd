extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Action"):
		get_tree().change_scene_to_file("res://01_main_menu/01_main.tscn")
		pass
	if Input.is_action_just_pressed("Toggle"):
		pass
	if Input.is_action_just_pressed("Menu"):
		pass
	if Input.is_action_just_pressed("Left"):
		pass
	if Input.is_action_just_pressed("Right"):
		pass
	if Input.is_action_just_pressed("Up"):
		pass
	if Input.is_action_just_pressed("Down"):
		pass
