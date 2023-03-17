extends Entity

@export var tilemap : TileMap
@export var animPlayer : AnimationPlayer

var info
var health

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
	var atlas = str(DATA["resource"]["atlasCoords"]).replace("(", "").replace(")", "").split(",")
	tilemap.set_cell(0, Vector2.ZERO, DATA["resource"]["sourceImg"], Vector2i(int(atlas[0]), int(atlas[1])))
	add_to_group("resource:"+str(DATA["resource"]["id"]))

	info = Terrain_lookup.enviroment[DATA["resource"]["type"]]
	health = info["health"]
	
	super._ready()
	
func apply_damage(damage):
	animPlayer.stop()
	animPlayer.play("shake")
	health -= damage
	if health <= 0:
		ITEM_GLOBALS.create_entity(Vector2(position.x+8, position.y+16), info["item_type"])
		queue_free()

