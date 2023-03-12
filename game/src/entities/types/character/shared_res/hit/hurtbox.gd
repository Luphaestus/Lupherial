extends Area2D

@export var root_node : Node2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().root_node != root_node:
		root_node.damage(area)
