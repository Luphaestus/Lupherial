extends Entity

@export var tilemap : TileMap
@export var animPlayer : AnimationPlayer

var info
var health
@export var itemEntityPath : String

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
		if itemEntityPath:
			var itemJson = get_tree().get_nodes_in_group("engine")[0].ReadEntityJsonFile(itemEntityPath) 
			itemJson["general_propoties"]["posx"] = position.x+8
			itemJson["general_propoties"]["posy"] = position.y+16
			itemJson["item"]["item_type"] = info["item_type"]
			var itemObject : Object = load(itemJson["constants"]["general_propoties"]["scriptLocation"]).instantiate()
			itemObject.DATA = itemJson
			get_parent().call_deferred("add_child", itemObject)
		queue_free()

