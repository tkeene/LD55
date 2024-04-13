extends Node2D

const NORMAL_MUSIC = "res://music/LDJAM55_AthleticTalentWillSaveYourSkin.mp3"
const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const FADE_IN_VOLUME = -100.0
const FADE_IN_SPEED = 1000.0
const MOVE_PLACING_OBJECT_SPEED = 200.0

var music_player = null
var quit_held_time = 0.0

var placeable_objects = [
	preload("res://pawns/summon_block.tscn"),
	preload("res://pawns/summon_block.tscn")
]
var current_placing_object : Node2D = null
var current_spellbook_index = 0

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
	# Object Placement UI
	if Engine.time_scale == 0.0:
		if current_placing_object == null:
			($OverlayUI/SelectedScrollRect as CanvasItem).visible = true
			if placeable_objects.size() > 0:
				if Input.is_action_just_pressed("ui_right"):
					current_spellbook_index += 1
				elif Input.is_action_just_pressed("ui_left"):
					current_spellbook_index -= 1
				if current_spellbook_index < 0:
					current_spellbook_index = placeable_objects.size() - 1
				elif current_spellbook_index >= placeable_objects.size():
					current_spellbook_index = 0
				var selected_object : PackedScene = placeable_objects[current_spellbook_index]
				($OverlayUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]" + selected_object.resource_path
				if Input.is_action_just_pressed("ui_accept"):
					current_placing_object = selected_object.instantiate() as Node2D
					current_placing_object.global_position = Vector2(500, 400)
					add_child(current_placing_object)
			else:
				($OverlayUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]You have no more pages!"
		else:
			($OverlayUI/SelectedScrollRect as CanvasItem).visible = false
			if Input.is_action_pressed("ui_left"):
				current_placing_object.global_position += Vector2.LEFT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_right"):
				current_placing_object.global_position += Vector2.RIGHT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_up"):
				current_placing_object.global_position += Vector2.UP * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_down"):
				current_placing_object.global_position += Vector2.DOWN * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			
			if Input.is_action_just_pressed("ui_accept"):
				current_placing_object = null;
				un_pause_game()
	else:
		($OverlayUI/SelectedScrollRect as CanvasItem).visible = false


func un_pause_game():
	if current_placing_object != null:
		current_placing_object.queue_free()
	current_placing_object = null
	Engine.time_scale = 1.0
	music_player.stream = load(NORMAL_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C (hold 1 second) - Quit\nX - Summon\nZ - Jump"

func pause_game():
	current_placing_object = null
	Engine.time_scale = 0.0
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C (hold 1 second) Quit\nX - Return To Level\n◀/▶ Select/Move\nZ - Place"
