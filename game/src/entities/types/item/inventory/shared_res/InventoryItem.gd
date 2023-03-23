extends MarginContainer

class_name InventoryItem

var world_entity_path : String
var stack_size : int
var geometry

var globalPosition = Vector2(-1, -1)

@export var texture_ : TextureRect
var real_scale = 0
func init(new_size):
	real_scale =  Vector2(new_size)/texture_.texture.get_size()
	real_scale *= Vector2(len(geometry[0]), len(geometry))
	texture_.scale = real_scale


	
func get_item_size():
	return texture_.size 

var first = true
func _process(_delta: float) -> void:
	if texture_.scale != real_scale:
		first = false
		texture_.scale = real_scale
		
var rotate = 0
