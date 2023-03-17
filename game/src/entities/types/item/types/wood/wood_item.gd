extends Entity

var info = {
	"item_type": "wood"
}
func _ready() -> void:
	position.x = DATA["general_propoties"]["posx"]
	position.y = DATA["general_propoties"]["posy"]
