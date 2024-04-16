extends Node2D


const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const VOLUME = -20.0

var thanks_for_playing : AudioStreamPlayer = null
var music_player : AudioStreamPlayer = null

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	thanks_for_playing = AudioStreamPlayer.new()
	add_child(thanks_for_playing)
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = VOLUME
	music_player.play()

func _on_timer_timeout():
	$TheEndText.start_me()

func _on_timer_2_timeout():
	thanks_for_playing.stream = load("res://audio/sfx_thanks.wav")
	thanks_for_playing.play()
