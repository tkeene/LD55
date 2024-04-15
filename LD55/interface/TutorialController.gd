extends Node2D

signal tutorial_end_signal

func run_tutorial(tutorial_name: String):
	var tutorial = find_child(tutorial_name)
	if tutorial != null:
		show()
		TutorialFlags.tutorial_currently_active = true
		tutorial.enable()

func tutorial_ended():
	hide()
	TutorialFlags.tutorial_currently_active = false
	tutorial_end_signal.emit()
