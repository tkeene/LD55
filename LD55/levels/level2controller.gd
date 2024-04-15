extends Node2D

var tutorial_controller

func _ready():
	tutorial_controller = get_node("TutorialController")

func _on_timer_timeout():
	if !TutorialFlags.level_2_tutorial_seen:
		get_tree().paused = true
		TutorialFlags.level_2_tutorial_seen = true
		tutorial_controller.run_tutorial("Level2IntroState")

func _on_tutorial_controller_tutorial_end_signal():
	get_tree().paused = false

func _on_level_root_scroll_acquired():
	TutorialFlags.scrolls_obtained_in_level_2 += 1
	if TutorialFlags.scrolls_obtained_in_level_2 == 1 and !TutorialFlags.level_2_trapped_seen:
		get_tree().paused = true
		TutorialFlags.level_2_trapped_seen = true
		tutorial_controller.run_tutorial("Level2TrappedState")
	elif TutorialFlags.scrolls_obtained_in_level_2 == 2 and !TutorialFlags.level_2_faluuka_seen:
		get_tree().paused = true
		TutorialFlags.level_2_faluuka_seen = true
		tutorial_controller.run_tutorial("PickupFaluukaScroll")
