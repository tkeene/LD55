extends Node2D

var tutorial_controller

func _ready():
	tutorial_controller = get_node("TutorialController")

func _on_timer_timeout():
	if !TutorialFlags.level_3_tutorial_seen:
		get_tree().paused = true
		TutorialFlags.level_3_tutorial_seen = true
		tutorial_controller.run_tutorial("Level3IntroState")

func _on_tutorial_controller_tutorial_end_signal():
	get_tree().paused = false

func _on_level_root_scroll_acquired():
	if !TutorialFlags.level_3_second_bluuk_seen:
		get_tree().paused = true
		TutorialFlags.level_3_second_bluuk_seen = true
		tutorial_controller.run_tutorial("PickupSecondBluuk")
