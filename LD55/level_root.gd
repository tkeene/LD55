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
var music_player : AudioStreamPlayer = null
var normal_music_time = 0.0
var paused_music_time = 0.0
var audio_player : AudioStreamPlayer = null

static var unlocked_summons = []
var current_inventory = []
var cards_for_summons : Array[TextureRect] = []
var current_placing_object : Node2D = null
var current_spellbook_index : int = 0
var special_spellcast_time = 0
static var play_goal_sound_next_frame = false

signal respawn_requested
signal bluuk_placed
signal wakka_placed
signal scroll_acquired
signal final_spell_cast

func _ready():
	instance = self
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	current_inventory.append(SummonsList.get_spell("Bluuk"))
	current_inventory.append(SummonsList.get_spell("Tempus Unwindus"))
	for summon in unlocked_summons:
		current_inventory.push_front(summon)
	current_inventory.sort_custom(func(a, b): return a["hand_order"] < b["hand_order"])
	var card_prefab = $OverlayUI/PlacementUI/CardPrefab as TextureRect
	var max_card_offset = Vector2.RIGHT * card_prefab.size.x * 4.0
	for i in range(NUMBER_OF_CARDS_TO_SHOW):
		var spawned_card = card_prefab.duplicate()
		var distance = i as float / NUMBER_OF_CARDS_TO_SHOW
		spawned_card.global_position = lerp(card_prefab.position - max_card_offset,
			card_prefab.position + max_card_offset, distance)
		spawned_card.global_position += abs(distance - 0.5) * Vector2.DOWN * 200.0
		if i == NUMBER_OF_CARDS_TO_SHOW / 2:
			spawned_card.global_position += Vector2.DOWN * 2000.0
		spawned_card.rotation = lerp(-CARDS_IN_HAND_MAX_ANGLE_RADIANS, CARDS_IN_HAND_MAX_ANGLE_RADIANS, distance)
		$OverlayUI/PlacementUI.add_child(spawned_card)
		cards_for_summons.append(spawned_card)
	card_prefab.visible = false
	un_pause_game()
	visible = true

func _process(delta):
	if play_goal_sound_next_frame:
		var goal_sound_player = AudioStreamPlayer.new()
		add_child(goal_sound_player)
		goal_sound_player.stream = load("res://audio/sfx_goal.wav")
		goal_sound_player.play()
		play_goal_sound_next_frame = false
	music_player.volume_db = move_toward(music_player.volume_db, 0.0, FADE_IN_SPEED * delta )
	if TutorialFlags.tutorial_currently_active:
		$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]X - Next"
		return
	if OS.has_feature("editor") && Input.is_key_pressed(KEY_F4) && Input.is_key_pressed(KEY_A):
		unlock_everything()
	if !get_tree().paused:
		($OverlayUI/PlacementUI as CanvasItem).visible = false
		if Input.is_action_just_pressed("Toggle"):
			pause_game()
	else:
		# Object Placement UI
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
						cards_for_summons[card_index].get_node("TextureRect").texture = current_inventory[card_spellbook_index]["sprite"]
				var is_normal_summon = true
				if Input.is_action_pressed("ui_accept") ||  Input.is_action_pressed("Toggle"):
					if selected_summon_data["is_rewind"]:
						is_normal_summon = false
						special_spellcast_time += delta
						if special_spellcast_time >= 1.0:
							reset_level()
					elif selected_summon_data["victory"] > 0:
						is_normal_summon = false
						special_spellcast_time += delta
						if special_spellcast_time >= 1.0:
							#get_tree().change_scene_to_file("res://endgame_screens/ending_0" + str(selected_summon_data["victory"]) + ".tscn")
							print("Final spell has been cast")
							special_spellcast_time = 0.0
							final_spell_cast.emit()
				else:
					special_spellcast_time = 0.0
				if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
					if is_normal_summon:
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
				placing_position += Vector2.LEFT * MOVE_PLACING_OBJECT_SPEED * delta
			if Input.is_action_pressed("ui_right"):
				placing_position += Vector2.RIGHT * MOVE_PLACING_OBJECT_SPEED * delta
			if Input.is_action_pressed("ui_up"):
				placing_position += Vector2.UP * MOVE_PLACING_OBJECT_SPEED * delta
			if Input.is_action_pressed("ui_down"):
				placing_position += Vector2.DOWN * MOVE_PLACING_OBJECT_SPEED * delta
			current_placing_object.global_position = placing_position
			if Input.is_action_just_pressed("ui_accept") ||  Input.is_action_just_pressed("Toggle"):
				if current_placing_object is Bluuk:
					print("You placed a Bluuk.  Good jorb.")
					bluuk_placed.emit()
				if current_placing_object is Wakka:
					print("You placed a Wakka.  Good jorb.")
					wakka_placed.emit()
				current_inventory.remove_at(current_spellbook_index)
				current_placing_object = null;
				un_pause_game()

func un_pause_game():
	if current_placing_object != null:
		current_placing_object.queue_free()
	current_placing_object = null
	special_spellcast_time = 0.0
	get_tree().paused = false
	paused_music_time = music_player.get_playback_position()
	music_player.stream = load(NORMAL_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play(normal_music_time)
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]Z - Jump\nX - Spellbook"

func pause_game():
	current_placing_object = null
	get_tree().paused = true
	normal_music_time = music_player.get_playback_position()
	music_player.stream = load(PAUSED_MUSIC)
	music_player.volume_db = FADE_IN_VOLUME
	music_player.play(paused_music_time)
	$OverlayUI/ControlsPromptRect/ControlsPromptLabel.text = "[color=black]X/Z - Place\nArrows - Select/Move\nC - Close Spellbook"

static func unlock_everything():
	for spell in SummonsList._all_spells:
		if !has_summon(spell.name):
			unlock_summon(spell.name, false)

static func unlock_summon(name, play_sound):
	instance._unlock_summon(name, play_sound)
	instance.scroll_acquired.emit()

func _unlock_summon(name, play_sound):
	var summon = SummonsList.get_spell(name)
	if play_sound && summon["victory"] > 0:
		unlocked_summons.clear()
		current_inventory.clear()
	if summon != null:
		unlocked_summons.append(summon)
		current_inventory.push_front(summon)
		if play_sound:
			audio_player.stream = load("res://audio/sfx_page_get.wav")
			audio_player.play()

static func has_summon(name):
	var has_it = false
	for summon in unlocked_summons:
		if (summon.name == name):
			has_it = true
			break
	return has_it

static func reset_level():
	instance.get_tree().reload_current_scene()
