extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

const distance_to_travel := 200
const travel_time_secs := 3.0
const idle_time := 3.0

var idling := true
var going_up := true
var time_in_state := 0.0
var target_position_y := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	time_in_state += delta
	# If we're idling, do nothing until we're past the idle timeout.
	# At that point, calculate our next target position and start moving toward it.
	if idling:
		if time_in_state >= idle_time:
			time_in_state -= idle_time
			idling = false
			delta = time_in_state
			if going_up:
				target_position_y = position.y - distance_to_travel
			else:
				target_position_y = position.y + distance_to_travel

	# If we're not idling, move toward our destination.
	# Note that this isn't an else, specifically because if we spent slightly
	# more time in idle than we intended, we want to put that into the motion.
	if not idling:
		var distance_this_frame = delta * (distance_to_travel / travel_time_secs)
		position.y = move_toward(position.y, target_position_y, distance_this_frame)
		if time_in_state >= travel_time_secs:
			time_in_state -= travel_time_secs
			going_up = not going_up
			idling = true
