extends Node2D

var initPosition
@export var root_node : Node2D
@export var target := "mouse" 
@export var tool_type := "gold sword"

var damage = {
	"gold sword":1
}

func _ready() -> void:
	initPosition = position.x

func _process(_delta: float) -> void:
	var pointTowards = get_global_mouse_position() if target == "mouse" else get_tree().get_nodes_in_group(target)[0].get_child(0).global_position
	var direction = (pointTowards-global_position).normalized()
	rotation = direction.angle()
	
	
func get_damage():
	return damage[tool_type]
