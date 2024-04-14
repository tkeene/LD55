class_name SummonsList

static func initialize():
	if _all_spells == null:
		_all_spells = [
		 	_placeholder_block,
			_rewind,
			_bluuk,
			_gozzuppa,
			_wakka,
		]

static var _all_spells = null

static var _placeholder_block = {
	"name": "Placeholder Block",
	"description": "This shouldn't be visible in the final build",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/summon_block.tscn"),
	"is_rewind": false,
}
static var _rewind = {
	"name": "Tempus Unwindus",
	"description": "Reset the level",
	"sprite": preload("res://cards/hourglass.png"),
	"is_rewind": true,
}
static var _bluuk = {
	"name": "bluuk",
	"description": "",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/bluuk.tscn"),
	"is_rewind": false,
}
static var _gozzuppa = {
	"name": "gozzuppa",
	"description": "",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/gozzuppa.tscn"),
	"is_rewind": false,
}
static var _wakka = {
	"name": "wakka",
	"description": "",
	"sprite": preload("res://debug_pixel.bmp"),
	"object": preload("res://pawns/wakka.tscn"),
	"is_rewind": false,
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

