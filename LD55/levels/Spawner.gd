extends Sprite2D

const spawn_height = 30

@onready var timer = $Timer
@onready var player: Node2D = preload("res://pawns/player.tscn").instantiate()

func _ready():
	# Set up the player
	player.set_script(preload("res://pawns/player.gd"))
	player.z_index = 1
	player.visible = true
	get_parent().add_child.call_deferred(player)

	place_player_at_spawn()

func _process(delta):
	# If we're processing, fade out of existence 
	if timer.time_left < 1:
		modulate.a = timer.time_left
	else:
		modulate.a = 1

func finish():
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false

# Place the player at the spawn location and run the spawn animation.
func place_player_at_spawn():
	# Place the player
	player.position = position + Vector2.UP * spawn_height
	player.velocity = Vector2.ZERO
	print("Spawning player at " + str(player.position.x) + " x " + str(player.position.y))

	# Run the spawn animation:
	timer.start()
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
