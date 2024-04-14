extends Node2D

const NORMAL_MUSIC = "res://music/LDJAM55_AthleticTalentWillSaveYourSkin.mp3"
const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const FADE_IN_VOLUME = -100.0
const FADE_IN_SPEED = 1000.0
const MOVE_PLACING_OBJECT_SPEED = 200.0
const NUMBER_OF_CARDS_TO_SHOW = 15
const CARDS_IN_HAND_MAX_ANGLE_RADIANS = PI / 6.0

var music_player = null
var quit_held_time = 0.0

var placeable_objects = [
	preload("res://pawns/summon_block.tscn"),
	preload("res://pawns/summon_block.tscn")
]
var cards_for_summons : Array[TextureRect] = []
var current_placing_object : Node2D = null
var current_spellbook_index : int = 0

signal respawn_requested

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var card_prefab = $OverlayUI/PlacementUI/CardPrefab as TextureRect
	var max_card_offset = Vector2.RIGHT * card_prefab.size.x * 4.0
	for i in range(NUMBER_OF_CARDS_TO_SHOW):
		var spawned_card = card_prefab.duplicate()
		var distance = i as float / NUMBER_OF_CARDS_TO_SHOW
		spawned_card.global_position = lerp(card_prefab.position - max_card_offset,
			card_prefab.position + max_card_offset, distance)
		spawned_card.global_position += abs(distance - 0.5) * Vector2.DOWN * 200.0
		spawned_card.rotation = lerp(-CARDS_IN_HAND_MAX_ANGLE_RADIANS, CARDS_IN_HAND_MAX_ANGLE_RADIANS, distance)
		$OverlayUI/PlacementUI.add_child(spawned_card)
		cards_for_summons.append(spawned_card)
	card_prefab.visible = false
	un_pause_game()
	pass # Replace with function body.

func _process(delta):
	var unscaled_delta = 1.0 / 60.0
	music_player.volume_db = move_toward(music_player.volume_db, 0.0, FADE_IN_SPEED * unscaled_delta )
	if Engine.time_scale != 0.0:
		($OverlayUI/PlacementUI as CanvasItem).visible = false
		if Input.is_action_just_pressed("ui_cancel"):
			respawn_requested.emit()
		if Input.is_action_pressed("ui_cancel"):
			quit_held_time += unscaled_delta
			if quit_held_time > 1.5:
				get_tree().change_scene_to_file("res://01_main_menu/01_main.tscn")
		else:
			quit_held_time = 0.0
		if Input.is_action_just_pressed("Toggle"):
			pause_game()
	else:
		# Object Placement UI
		quit_held_time = 0.0
		if Input.is_action_just_pressed("ui_cancel"):
			un_pause_game()
		elif current_placing_object == null:
			($OverlayUI/PlacementUI as CanvasItem).visible = true
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
				($OverlayUI/PlacementUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]" + selected_object.resource_path
				var middle_of_hand = NUMBER_OF_CARDS_TO_SHOW / 2
				for card_index in range(cards_for_summons.size()):
					var card_spellbook_index = card_index - middle_of_hand + current_spellbook_index
					if (card_spellbook_index < 0 || card_spellbook_index > placeable_objects.size()):
						cards_for_summons[card_index].visible = false
					elif (card_spellbook_index == placeable_objects.size()):
						cards_for_summons[card_index].visible = true
						cards_for_summons[card_index].get_node("RichTextLabel").text = "[color=magenta]RESET TODO"
					else:
						cards_for_summons[card_index].visible = true
						cards_for_summons[card_index].get_node("RichTextLabel").text = "[color=black]" + placeable_objects[card_spellbook_index].resource_path
				if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
					current_placing_object = selected_object.instantiate() as Node2D
					current_placing_object.global_position = Vector2(500, 400)
					add_child(current_placing_object)
			else:
				($OverlayUI/PlacementUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]You have no more pages!"
				if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
					un_pause_game()
		else:
			($OverlayUI/PlacementUI as CanvasItem).visible = false
			if Input.is_action_pressed("ui_left"):
				current_placing_object.global_position += Vector2.LEFT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_right"):
				current_placing_object.global_position += Vector2.RIGHT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_up"):
				current_placing_object.global_position += Vector2.UP * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_down"):
				current_placing_object.global_position += Vector2.DOWN * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
				placeable_objects.remove_at(current_spellbook_index)
				current_placing_object = null;
				un_pause_game()

func un_pause_game():
	if current_placing_object != null:
		current_placing_object.queue_free()
	current_placing_object = null
	Engine.time_scale = 1.0
	music_player.stream = load(NORMAL_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C - Reset\nC (hold 1 second) - Quit\nX - Summon\nZ - Jump"

func pause_game():
	current_placing_object = null
	Engine.time_scale = 0.0
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C - Return\nX/Z - Place\n◀/▶ Select/Move"
