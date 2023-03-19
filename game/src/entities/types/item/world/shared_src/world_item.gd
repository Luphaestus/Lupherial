extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().has_method("add_item") and area.get_parent().get_parent().add_item(get_parent()):
		get_tree().get_nodes_in_group("notification")[0].new_notif("picked up: " + get_parent().DATA["constants"]["item"]["item_type"])
		get_parent().queue_free()

func _ready() -> void:
	get_parent().position.x = get_parent().DATA["general_propoties"]["posx"]
	get_parent().position.y = get_parent().DATA["general_propoties"]["posy"]
