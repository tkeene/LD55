extends Node2D

const NORMAL_MUSIC = "res://music/LDJAM55_AthleticTalentWillSaveYourSkin.mp3"
const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const FADE_IN_VOLUME = -100.0
const FADE_IN_SPEED = 1000.0

var music_player = null
var quit_held_time = 0.0

#var placeable_objects = new Array()

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	un_pause_game()
	pass # Replace with function body.

func _process(delta):
	var unscaled_delta = 1.0 / 60.0
	music_player.volume_db = move_toward(music_player.volume_db, 0.0, FADE_IN_SPEED * unscaled_delta )
	if Input.is_action_pressed("ui_cancel"):
		quit_held_time += unscaled_delta
		if quit_held_time > 1.0:
			get_tree().change_scene_to_file("res://01_main_menu/01_main.tscn")
	else:
		quit_held_time = 0.0
	if Input.is_action_just_pressed("Toggle"):
		if Engine.time_scale != 0.0:
			pause_game()
		else:
			un_pause_game()

func un_pause_game():
	Engine.time_scale = 1.0
	music_player.stream = load(NORMAL_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C (hold 1 second) Quit\nX - Summon\nZ - Jump"

func pause_game():
	Engine.time_scale = 0.0
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C (hold 1 second) Quit\nX - Return To Level\n◀/▶ Select/Move\nZ - Place"
