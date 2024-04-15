class_name LevelRoot

extends Node2D

const NORMAL_MUSIC = "res://music/LDJAM55_AthleticTalentWillSaveYourSkin.mp3"
const PAUSED_MUSIC = "res://music/LDJam55_ContemplatingPainfulLacerations.mp3"
const FADE_IN_VOLUME = -100.0
const FADE_IN_SPEED = 1000.0
const MOVE_PLACING_OBJECT_SPEED = 200.0
const NUMBER_OF_CARDS_TO_SHOW = 15
const CARDS_IN_HAND_MAX_ANGLE_RADIANS = PI / 6.0

static var instance = null
static var last_level_loaded
var music_player = null
var quit_held_time = 0.0

static var unlocked_summons = []
var current_inventory = []
var cards_for_summons : Array[TextureRect] = []
var current_placing_object : Node2D = null
var current_spellbook_index : int = 0

signal respawn_requested

func _ready():
	instance = self
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	current_inventory.append(SummonsList.get_spell("Bluuk"))
	current_inventory.append(SummonsList.get_spell("Tempus Unwindus"))
	for summon in unlocked_summons:
		current_inventory.push_front(summon)
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
	visible = true

func _process(delta):
	var unscaled_delta = 1.0 / 60.0
	music_player.volume_db = move_toward(music_player.volume_db, 0.0, FADE_IN_SPEED * unscaled_delta )
	if Engine.time_scale != 0.0:
		($OverlayUI/PlacementUI as CanvasItem).visible = false
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
			if current_inventory.size() > 0:
				if Input.is_action_just_pressed("ui_right"):
					current_spellbook_index += 1
				elif Input.is_action_just_pressed("ui_left"):
					current_spellbook_index -= 1
				if current_spellbook_index < 0:
					current_spellbook_index = current_inventory.size() - 1
				elif current_spellbook_index >= current_inventory.size():
					current_spellbook_index = 0
				var selected_summon_data = current_inventory[current_spellbook_index]
				($OverlayUI/PlacementUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]" + selected_summon_data["name"]
				($OverlayUI/PlacementUI/SelectedScrollRect/SelectedScrollDescriptionLabel as RichTextLabel).text = "[color=black]" + selected_summon_data["description"]
				($OverlayUI/PlacementUI/SelectedScrollRect/Sprite as TextureRect).texture = selected_summon_data["sprite"]
				var middle_of_hand = NUMBER_OF_CARDS_TO_SHOW / 2
				for card_index in range(cards_for_summons.size()):
					var card_spellbook_index = card_index - middle_of_hand + current_spellbook_index
					if (card_spellbook_index < 0 || card_spellbook_index >= current_inventory.size()):
						cards_for_summons[card_index].visible = false
					else:
						cards_for_summons[card_index].visible = true
						cards_for_summons[card_index].get_node("RichTextLabel").text = "[color=black]" + current_inventory[card_spellbook_index]["name"]
				if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
					if selected_summon_data["is_rewind"]:
						reset_level()
					else:
						current_placing_object = selected_summon_data["object"].instantiate() as Node2D
						current_placing_object.global_position = Player.last_position + Vector2.UP * 50.0
						add_child(current_placing_object)
			else:
				($OverlayUI/PlacementUI/SelectedScrollRect/SelectedScrollLabel as RichTextLabel).text = "[color=black]You have no more pages!"
				if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
					un_pause_game()
		else:
			($OverlayUI/PlacementUI as CanvasItem).visible = false
			var placing_position = current_placing_object.global_position
			if Input.is_action_pressed("ui_left"):
				placing_position += Vector2.LEFT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_right"):
				placing_position += Vector2.RIGHT * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_up"):
				placing_position += Vector2.UP * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			if Input.is_action_pressed("ui_down"):
				placing_position += Vector2.DOWN * MOVE_PLACING_OBJECT_SPEED * unscaled_delta
			current_placing_object.global_position = placing_position
			if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
				current_inventory.remove_at(current_spellbook_index)
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
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C (hold 1 second) - Quit\nX - Summon\nZ - Jump"

func pause_game():
	current_placing_object = null
	Engine.time_scale = 0.0
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play()
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]C - Return\nX/Z - Place\n◀/▶ Select/Move"
	

static func unlock_summon(name):
	instance._unlock_summon(name)

func _unlock_summon(name):
	var summon = SummonsList.get_spell(name)
	if summon != null:
		unlocked_summons.append(summon)
		current_inventory.push_front(summon)

static func has_summon(name):
	var has_it = false
	for summon in unlocked_summons:
		if (summon.name == name):
			has_it = true
			break
	return has_it

static func reset_level():
	instance.get_tree().change_scene_to_file(LevelRoot.last_level_loaded)
