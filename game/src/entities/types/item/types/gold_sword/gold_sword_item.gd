extends Entity

var info = {
	"item_type": "Gold Sword",
	"is_tool": "gold_sword"
}

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
