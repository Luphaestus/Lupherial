extends Entity

var info = {
	"item_type": "Silver Sword",
	"is_tool": "silver_sword"
}

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
