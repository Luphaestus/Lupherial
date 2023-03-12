extends Node

var terrain := {
	"water": {"terrain_id": 0, "enviroment": ["", 1]},
	"tundra":{"terrain_id": 1, "enviroment": ["", 100, "birch-snow", 10, "birch"  , 1]},
	"ice":   {"terrain_id": 2, "enviroment": ["", 1]},
	"path":  {"terrain_id": -1, "enviroment": ["", 1]},
	"taiga": {"terrain_id": 3, "enviroment": ["", 151, "birch"     , 10, "acacia" , 10, "oak"   , 10, "coal"   , 10]},
	"swamp": {"terrain_id": 4, "enviroment": ["", 100, "brushee"   , 10, "oshtree", 10]},
	"forest":{"terrain_id": 5, "enviroment": ["", 100, "birch"     , 40, "oak"    , 20, "acacia", 20, "blossom", 1]},
	"desert":{"terrain_id": 7, "enviroment": ["", 200, "lacti"     , 10, "macti"  , 10, "tacti" , 10]}
}

var terrain_enviroment = {
	
	"tundra": {
		#tree
		"birch"      : {"source_img": 87, "atlas_coords": Vector2i(1, 1)}, 
		"birch-snow" : {"source_img": 87, "atlas_coords": Vector2i(2, 1)},
		
		#rock
		"large-rock"  : {"source_img": 87, "atlas_coords": Vector2i(2, 3)},
		"small-rock"  : {"source_img": 87, "atlas_coords": Vector2i(4, 3)},
		"medium-rock" : {"source_img": 87, "atlas_coords": Vector2i(4, 4)},
		"mercury"     : {"source_img": 87, "atlas_coords": Vector2i(5, 3)},
		"coal"        : {"source_img": 87, "atlas_coords": Vector2i(5, 4)},
		"gummite"     : {"source_img": 87, "atlas_coords": Vector2i(6, 3)},
		"Sodalite"    : {"source_img": 87, "atlas_coords": Vector2i(6, 4)},
	},
	"taiga": {
		#tree
		"birch"  : {"source_img": 76, "atlas_coords": Vector2i(3, 1)},
		"oak"    : {"source_img": 76, "atlas_coords": Vector2i(1, 1)},
		"acacia" : {"source_img": 76, "atlas_coords": Vector2i(2, 1)}, 
		
		#rock
		"large-rock"  : {"source_img": 76, "atlas_coords": Vector2i(2, 3)},
		"small-rock"  : {"source_img": 76, "atlas_coords": Vector2i(4, 3)},
		"medium-rock" : {"source_img": 76, "atlas_coords": Vector2i(4, 4)},
		"mercury"     : {"source_img": 76, "atlas_coords": Vector2i(5, 3)},
		"coal"        : {"source_img": 76, "atlas_coords": Vector2i(5, 4)},
		"gummite"     : {"source_img": 76, "atlas_coords": Vector2i(6, 3)},
		"Sodalite"    : {"source_img": 76, "atlas_coords": Vector2i(6, 4)},
	},
	"swamp": {
		#tree
		"brushee" : {"source_img": 68, "atlas_coords": Vector2i(1, 1)}, 
		"oshtree" : {"source_img": 68, "atlas_coords": Vector2i(1, 1)}, 
		
		#rock
		"large-rock"  : {"source_img": 68, "atlas_coords": Vector2i(2, 3)},
		"small-rock"  : {"source_img": 68, "atlas_coords": Vector2i(4, 3)},
		"medium-rock" : {"source_img": 68, "atlas_coords": Vector2i(4, 4)},
		"mercury"     : {"source_img": 68, "atlas_coords": Vector2i(5, 3)},
		"coal"        : {"source_img": 68, "atlas_coords": Vector2i(5, 4)},
		"gummite"     : {"source_img": 68, "atlas_coords": Vector2i(6, 3)},
		"Sodalite"    : {"source_img": 68, "atlas_coords": Vector2i(6, 4)},
	},
	"forest": {
		#tree
		"birch"   : {"source_img": 60, "atlas_coords": Vector2i(6, 1)},
		"oak"     : {"source_img": 60, "atlas_coords": Vector2i(1, 1)},
		"acacia"  : {"source_img": 60, "atlas_coords": Vector2i(2, 1)},
		"blossom" : {"source_img": 60, "atlas_coords": Vector2i(3, 1)},
		
		#rock
		"large-rock"  : {"source_img": 60, "atlas_coords": Vector2i(2, 3)},
		"small-rock"  : {"source_img": 60, "atlas_coords": Vector2i(4, 3)},
		"medium-rock" : {"source_img": 60, "atlas_coords": Vector2i(4, 4)},
		"mercury"     : {"source_img": 60, "atlas_coords": Vector2i(5, 3)},
		"coal"        : {"source_img": 60, "atlas_coords": Vector2i(5, 4)},
		"gummite"     : {"source_img": 60, "atlas_coords": Vector2i(6, 3)},
		"Sodalite"    : {"source_img": 60, "atlas_coords": Vector2i(6, 4)},
	},
	"desert": {
		#tree
		"lacti" : {"source_img": 39, "atlas_coords": Vector2i(1, 1)},
		"macti" : {"source_img": 39, "atlas_coords": Vector2i(2, 1)},
		"tacti" : {"source_img": 39, "atlas_coords": Vector2i(3, 1)},
		
		#rock
		"large-rock"  : {"source_img": 39, "atlas_coords": Vector2i(2, 3)},
		"small-rock"  : {"source_img": 39, "atlas_coords": Vector2i(4, 3)},
		"medium-rock" : {"source_img": 39, "atlas_coords": Vector2i(4, 4)},
		"mercury"     : {"source_img": 39, "atlas_coords": Vector2i(5, 3)},
		"coal"        : {"source_img": 39, "atlas_coords": Vector2i(5, 4)},
		"gummite"     : {"source_img": 39, "atlas_coords": Vector2i(6, 3)},
		"Sodalite"    : {"source_img": 39, "atlas_coords": Vector2i(6, 4)}, 
		
		}
}

var enviroment := {
	#trees
	"birch"     : {"health": 4, "item_type": "wood"},
	"birch-snow": {"health": 6, "item_type": "wood"},
	"oak"       : {"health": 3, "item_type": "wood"},
	"acacia"    : {"health": 4, "item_type": "wood"},
	"blossom"   : {"health": 7, "item_type": "wood"},
	"brushee"   : {"health": 3, "item_type": "wood"},
	"oshtree"   : {"health": 4, "item_type": "wood"},
	"lacti"     : {"health": 4, "item_type": "wood"},
	"macti"     : {"health": 3, "item_type": "wood"},
	"tacti"     : {"health": 3, "item_type": "wood"},
	
	"large-rock"  : {"health": 5, "item_type": "coal"},
	"small-rock"  : {"health": 5, "item_type": "coal"},
	"medium-rock" : {"health": 5, "item_type": "coal"},
	"mercury"     : {"health": 5, "item_type": "coal"},
	"coal"        : {"health": 5, "item_type": "coal"},
	"gummite"     : {"health": 5, "item_type": "coal"},
	"Sodalite"    : {"health": 5, "item_type": "coal"},
}

var chart := [
	["tundra", "taiga", "swamp"], 
	["water", "ice", "forest"]
]

func _ready() -> void:
	for type in terrain:
		if len(terrain[type]["enviroment"]) != 0:
			var compiled = []
			for index in range(0, len(terrain[type]["enviroment"]), 2):
				for i in range(terrain[type]["enviroment"][index+1]):
					compiled.append(terrain[type]["enviroment"][index])
			terrain[type]["enviroment"] = compiled
		else:
			terrain[type]["enviroment"] = [""]
