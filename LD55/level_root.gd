extends Node2D

const NORMAL_MUSIC = "res://music/LDJAM55_AthleticTalentWillSaveYourSkin.mp3"
const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const FADE_IN_VOLUME = -100.0
const FADE_IN_SPEED = 1000.0

var music_player = null

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = load(NORMAL_MUSIC)
	music_player.play()
	pass # Replace with function body.

func _process(delta):
	var unscaled_delta = 1.0 / 60.0
	music_player.volume_db = move_toward(music_player.volume_db, 0.0, FADE_IN_SPEED * unscaled_delta )
	if Input.is_action_just_pressed("Toggle"):
		if Engine.time_scale != 0.0:
			Engine.time_scale = 0.0
			music_player.stream = load(PAUSED_MUSIC)
			music_player.volume_db = FADE_IN_VOLUME
			music_player.play()
			pass
		else:
			Engine.time_scale = 1.0
			music_player.stream = load(NORMAL_MUSIC)
			music_player.volume_db = FADE_IN_VOLUME
			music_player.play()
			pass
