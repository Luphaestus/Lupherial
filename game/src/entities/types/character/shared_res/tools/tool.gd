extends Node2D

var initPosition
@export var root_node : Node2D
@export var sprite : Sprite2D
@export var target := "mouse" 

var tool_type := "gold sword"



var tool := {
	"bronze sword": {"imgCoords": Vector2i(0, 0), "damage":1},
	
	"silver sword":{"imgCoords": Vector2i(0, 1), "damage":1},
	
	"gold sword": {"imgCoords": Vector2i(0, 2), "damage":1},
	
	"diamond sword": {"imgCoords": Vector2i(0, 3), "damage":1},
	
	"ruby sword": {"imgCoords": Vector2i(0, 4), "damage":1},
}

func changeTool(newTool):
	tool_type = newTool
	sprite.frame_coords = tool[tool_type]["imgCoords"]

	

func _ready() -> void:

	initPosition = position.x

func _process(_delta: float) -> void:
	var pointTowards = get_global_mouse_position() if target == "mouse" else get_tree().get_nodes_in_group(target)[0].get_child(0).global_position
	var direction = (pointTowards-global_position).normalized()
	rotation = direction.angle()
	
	
func get_damage():
	return tool[tool_type]["damage"]
