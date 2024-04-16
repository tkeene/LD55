class_name LevelExit
extends Area2D

@export var next_level_path = "res://levels/level1.tscn"

func _on_body_entered(node: PhysicsBody2D):
	if node is Player:
		LevelRoot.play_goal_sound_next_frame = true
		call_deferred("_start_next_level")

func _start_next_level():
	get_tree().change_scene_to_file(next_level_path)

