extends Node2D

var TIME_TO_FINISH_ACTIVATION_ANIMATION = 1.5

var activated_sprite = null
var activated_count = 0
var activation_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	activated_sprite = preload("res://00_boot/key_lit.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		activate_key($Z)
		pass
	if Input.is_action_just_pressed("Toggle"):
		activate_key($X)
		pass
	if Input.is_action_just_pressed("ui_cancel"):
		activate_key($C)
		pass
	if Input.is_action_just_pressed("ui_left"):
		activate_key($Left)
		pass
	if Input.is_action_just_pressed("ui_right"):
		activate_key($Right)
		pass
	if Input.is_action_just_pressed("ui_up"):
		activate_key($Up)
		pass
	if Input.is_action_just_pressed("ui_down"):
		activate_key($Down)
		pass
	
	if activated_count >= 7:
		activation_timer += delta
		if activation_timer > TIME_TO_FINISH_ACTIVATION_ANIMATION:
			LevelRoot.last_level_loaded = "res://levels/level1.tscn"
			get_tree().change_scene_to_file("res://levels/level1.tscn")

func activate_key(key_sprite_renderer : Sprite2D):
	if key_sprite_renderer.texture != activated_sprite:
		key_sprite_renderer.texture = activated_sprite
		var audio_source : AudioStreamPlayer = AudioStreamPlayer.new()
		key_sprite_renderer.add_child(audio_source)
		audio_source.pitch_scale = 4.0 / 3.0 * (activated_count+1)
		audio_source.stream = load("res://audio/sfx_goal.wav")
		audio_source.play()
		activated_count += 1
