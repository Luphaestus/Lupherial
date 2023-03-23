extends Node2D

class_name Tool

var initPosition
@export var root_node : Node2D
@export var sprite : Sprite2D
@export var target := "mouse" 
@export var sensitivity = 100

var tool_type := "gold_sword"



var tool := {
	"bronze_sword": {"imgCoords": Vector2i(0, 0), "damage":1},
	
	"silver_sword":{"imgCoords": Vector2i(0, 1), "damage":1},
	
	"gold_sword": {"imgCoords": Vector2i(0, 2), "damage":1},
	
	"diamond_sword": {"imgCoords": Vector2i(0, 3), "damage":1},
	
	"ruby_sword": {"imgCoords": Vector2i(0, 4), "damage":1},
}

func changeTool(newTool):
	tool_type = newTool
	sprite.frame_coords = tool[tool_type]["imgCoords"]

	

func _ready() -> void:
	if target == "mouse": Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	initPosition = position.x

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func _process(_delta: float) -> void:
	
	if target == "mouse" and Vector2i(Input.get_last_mouse_velocity()) != Vector2i.ZERO:
		rotation = lerp_angle(rotation, Input.get_last_mouse_velocity().angle(), Input.get_last_mouse_velocity().length()/20000)


	elif target != "mouse":
		var pointTowards = get_tree().get_nodes_in_group(target)[0].get_child(0).global_position
		var direction = (pointTowards-global_position).normalized()
		rotation = direction.angle()
func get_damage():
	return tool[tool_type]["damage"]
