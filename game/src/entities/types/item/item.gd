extends Entity
var item

@export var sprite : Sprite2D 

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
	super._ready()
	item = ITEM_GLOBALS.items[DATA["item"]["item_type"]]
	sprite.frame_coords = item["icon_coords"]
	


func _on_area_2d_area_entered(_area: Area2D) -> void:
	get_tree().get_nodes_in_group("notification")[0].new_notif("picked up: " + DATA["item"]["item_type"])
	queue_free()


