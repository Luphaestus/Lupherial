extends Entity

var info = {
	"item_type" : "Diamond Sword",
	"is_tool" : "diamond_sword"
}

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
