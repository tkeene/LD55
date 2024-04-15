class_name SummonsList

static func initialize():
	if _all_spells == null:
		_all_spells = [
		 	_placeholder_block,
			_rewind,
			_bluuk,
			_gozzuppa,
			_wakka,
			_faluuka,
			_byggin,
			_victory1,
			_victory2,
			_victory3,
		]

static var _all_spells = null

static var _placeholder_block = {
	"name": "Placeholder Block",
	"description": "This shouldn't be visible in the final build",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/summon_block.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 99,
}
static var _rewind = {
	"name": "Tempus Unwindus",
	"description": "Rewinds time.\n\nTechnically this hourglass is cursed, but it's been my saving grace at many tedious social events (or if I screw up a recipe in the kitchen).",
	"sprite": preload("res://interface/icon_hourglass.png"),
	"is_rewind": true,
	"victory": 0,
	"hand_order": 10,
}
static var _bluuk = {
	"name": "Bluuk",
	"description": "Lazy, avoids moving at all costs. Luckily, this makes Bluuk a convenient platform.\n\nScared of heights, which is ironic",
	"sprite": preload("res://interface/icon_bluuk.png"),
	"object": preload("res://pawns/bluuk.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 0,
}
static var _gozzuppa = {
	"name": "Gozzuppa",
	"description": "\nGozuppa was my mother's favorite summon. They are useful in the same way a dumbwaiter is (and about as smart).",
	"sprite": preload("res://interface/icon_gozzuppa.png"),
	"object": preload("res://pawns/gozzuppa.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 0,
}
static var _wakka = {
	"name": "Wakka",
	"description": "Susceptible to gravity. This isn't terribly bad, and you can steer them by riding on their backs.\n\n(Reminder: \"Pentagram\" does not mean \"pextragram\")",
	"sprite": preload("res://interface/icon_wakka.png"),
	"object": preload("res://pawns/wakka.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 0,
}
static var _faluuka = {
	"name": "Faluuka",
	"description": "Susceptible to gravity.\n\nDoesn't do much, just sits there, why did I even bother giving a TV legs.",
	"sprite": preload("res://interface/icon_faluuka.png"),
	"object": preload("res://pawns/faluuka.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 0,
}
static var _byggin = {
	"name": "Byggin",
	"description": "???",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/byggin.tscn"),
	"is_rewind": false,
	"victory": 0,
	"hand_order": 0,
}
static var _victory1 = {
	"name": "Summon Tower Door Key",
	"description": "I invented this spell so I'd never lose my keys again.\n\nFinally I can get inside my tower! Blorb really is a hard worker to find this for me. I don't know what I'd do without him.",
	"sprite": preload("res://debug_pixel.bmp"),
	"is_rewind": false,
	"victory": 1,
	"hand_order": 50,
}
static var _victory2 = {
	"name": "Summon Airplane Tickets",
	"description": "This spell conjures vacation tickets anytime I want.\n\nI hope nobody steals this spell. It was expensive!",
	"sprite": preload("res://debug_pixel.bmp"),
	"is_rewind": false,
	"victory": 2,
	"hand_order": 51,
}
static var _victory3 = {
	"name": "Summon Anti Wizard Barrier",
	"description": "Kept locked up for safety.\n\nI would be in real trouble if any of my enemies got their hands on this spell!",
	"sprite": preload("res://debug_pixel.bmp"),
	"is_rewind": false,
	"victory": 3,
	"hand_order": 52,
}
static func get_spell(name):
	initialize()
	var return_value = null
	for dictionary in _all_spells:
		if dictionary["name"] == name:
			return_value = dictionary
			break
	if return_value == null:
		printerr("summons_list.get_spell() could not find " + name + " in _all_spells")
	return return_value

