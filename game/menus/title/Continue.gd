extends Button

var scene = "res://src/entities/chunk.tscn"



func _ready() -> void:
	visible = DirAccess.dir_exists_absolute("res://save/")

func _pressed() -> void:
	ResourceLoader.load_threaded_request(scene)
		
func _process(delta: float) -> void:
	if ResourceLoader.THREAD_LOAD_LOADED == ResourceLoader.load_threaded_get_status(scene):
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
		queue_free()
		

