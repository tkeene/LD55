extends Node2D

var tutorial_controller

func _ready():
	tutorial_controller = get_node("TutorialController")

func _on_timer_timeout():
	if !TutorialFlags.final_level_tutorial_seen:
		get_tree().paused = true
		TutorialFlags.final_level_tutorial_seen = true
		tutorial_controller.run_tutorial("FinalLevelState")

func _on_tutorial_controller_tutorial_end_signal():
	get_tree().paused = false

func _on_level_root_scroll_acquired():
	if !TutorialFlags.obtain_door_key_seen:
		get_tree().paused = true
		TutorialFlags.obtain_door_key_seen = true
		tutorial_controller.run_tutorial("PickupDoorKey")

func _on_level_root_final_spell_cast():
	get_tree().change_scene_to_file("res://levels/end_screen.tscn")
