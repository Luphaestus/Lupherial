extends Button

func _ready() -> void:
	visible = DirAccess.dir_exists_absolute("res://save/")

func _pressed() -> void:
	get_tree().change_scene_to_file("res://src/entities/chunk.tscn")
