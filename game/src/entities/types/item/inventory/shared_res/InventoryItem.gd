extends MarginContainer

class_name InventoryItem

var world_entity_path : String
var stack_size : int

@export var texture_ : TextureRect
var real_scale = 0
func init(new_size):
	real_scale =  Vector2(new_size)/texture_.texture.get_size()
	texture_.scale = real_scale
func get_item_size():
	return texture_.size 

var first = true
func _process(_delta: float) -> void:
	if first:
		first = false
		texture_.scale = real_scale
