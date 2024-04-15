extends Node2D

var tutorial_controller

func _ready():
	tutorial_controller = get_node("TutorialController")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if !TutorialFlags.level_1_tutorial_seen:
		get_tree().paused = true
		TutorialFlags.level_1_tutorial_seen = true
		tutorial_controller.run_tutorial("LevelIntroState")

func _on_tutorial_controller_tutorial_end_signal():
	get_tree().paused = false

func _on_spawner_player_killed():
	print("You died.  Do I get to lecture you?")
	if !TutorialFlags.bluuk_summoned and !TutorialFlags.died_no_bluuk_seen:
		get_tree().paused = true
		TutorialFlags.died_no_bluuk_seen = true
		$Hint.show()
		tutorial_controller.run_tutorial("DeadNoBluuk")
	elif TutorialFlags.bluuk_summoned and !TutorialFlags.wakka_obtained and !TutorialFlags.died_yes_bluuk_seen:
		get_tree().paused = true
		TutorialFlags.died_yes_bluuk_seen = true
		tutorial_controller.run_tutorial("DeadYesBluuk")
	elif TutorialFlags.wakka_obtained and !TutorialFlags.wakka_summoned and !TutorialFlags.died_no_wakka_seen:
		get_tree().paused = true
		TutorialFlags.died_no_wakka_seen = true
		tutorial_controller.run_tutorial("DeadNoWakka")
	elif TutorialFlags.wakka_summoned and !TutorialFlags.died_yes_wakka_seen:
		get_tree().paused = true
		TutorialFlags.died_yes_wakka_seen = true
		tutorial_controller.run_tutorial("DeadYesWakka")

func _on_level_root_bluuk_placed():
	TutorialFlags.bluuk_summoned = true
	$Hint.hide()

func _on_level_root_scroll_acquired():
	if !TutorialFlags.obtain_wakka_seen:
		get_tree().paused = true
		TutorialFlags.wakka_obtained = true
		TutorialFlags.obtain_wakka_seen = true
		tutorial_controller.run_tutorial("PickupWakkaScroll")

func _on_level_root_wakka_placed():
	TutorialFlags.wakka_summoned = true
