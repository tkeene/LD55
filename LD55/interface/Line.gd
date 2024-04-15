extends Node2D

var speed = 50
var ticking = false

@onready var textLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel.set_visible_ratio(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ticking:
		var tick = textLabel.get_visible_ratio() + (1.0/textLabel.text.length()) * speed * delta
		textLabel.set_visible_ratio(tick)
		if tick > 1:
			ticking = false

func start():
	ticking = true
	show()

func skip():
	ticking = false
	textLabel.set_visible_ratio(1.0)

