static var _starter_spells = [
	_placeholder_block,
	_placeholder_block,
	_rewind,
]
static var _all_spells = [
	_placeholder_block,
	_rewind,
	_bluuk,
	_gozzuppa,
	_wakka,
]
static var _placeholder_block = {
	"name": "Placeholder Block",
	"sprite": "res://debug_pixel.bmp",
	"object": "res://pawns/summon_block.tscn",
	"is_rewind": false,
}
static var _rewind = {
	"name": "Tempus Unwindus",
	"sprite": "res://cards/hourglass.png",
	"is_rewind": true,
}
static var _bluuk = {
	"name": "_bluuk",
	"sprite": "res://debug_pixel.bmp",
	"object": "res://pawns/_bluuk.tscn",
	"is_rewind": false,
}
static var _gozzuppa = {
	"name": "_gozzuppa",
	"sprite": "res://debug_pixel.bmp",
	"object": "res://pawns/_gozzuppa.tscn",
	"is_rewind": false,
}
static var _wakka = {
	"name": "_wakka",
	"sprite": "res://debug_pixel.bmp",
	"object": "res://pawns/_wakka.tscn",
	"is_rewind": false,
}

static func get_spell(name):
	var return_value = null
	for dictionary in _all_spells:
		if dictionary.name == name:
			return_value = dictionary
			break
	if return_value == null:
		printerr("summons_list.get_spell() could not find " + name + " in _all_spells")
	return return_value
