extends Node2D

func _ready():
	# Start with the Level 1 icon selected.
	# TODO: Is there a way to start with an invisible item focused, then never
	# let the user return to that invisible item?
	get_node(^"CanvasLayer/LevelSelect/Level1").grab_focus()

func go_to_level(level: String):
	LevelRoot.last_level_loaded = "res://levels/" + level + ".tscn"
	get_tree().change_scene_to_file(LevelRoot.last_level_loaded)
