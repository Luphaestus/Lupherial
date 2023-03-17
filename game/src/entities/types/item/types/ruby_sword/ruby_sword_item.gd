extends Entity

var info = {
 "item_type": "Ruby Sword",
	"is_tool": "ruby_sword"
}

func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
