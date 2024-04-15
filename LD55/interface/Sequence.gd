extends Node2D

var lines : Array
var currentLine = -1
var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lines = get_children()
	currentLine = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not enabled:
		pass
	elif Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Toggle"):
		if lines[currentLine].ticking:
			lines[currentLine].skip()
		else:
			next_line()

func enable():
	print("tutorial starting")
	print("total lines:")
	print(lines.size())
	show()
	enabled = true
	next_line()

func next_line():
	lines[currentLine].hide()
	currentLine += 1
	if currentLine >= lines.size():
		enabled = false
		var controller = find_parent("TutorialController")
		controller.tutorial_ended()
	else:
		lines[currentLine].start()
