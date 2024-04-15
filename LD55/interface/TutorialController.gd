extends Node2D

func run_tutorial(tutorial_name: String):
	var tutorial = find_child(tutorial_name)
	if tutorial != null:
		show()
		tutorial.enable()

func tutorial_ended():
	hide()
