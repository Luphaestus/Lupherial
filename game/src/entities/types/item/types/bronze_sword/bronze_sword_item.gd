extends Entity

var info = {
	"item_type": "Bronze Sword",
	"is_tool": "bronze_sword"
}

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
