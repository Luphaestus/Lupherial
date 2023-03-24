extends Button

func DeleteDirectory(from:String) -> void:
	if not DirAccess.dir_exists_absolute(from): return
	var dirs := DirAccess.get_directories_at(from)

	for dir in dirs:
		var files := DirAccess.get_files_at(from+dir)
		for file in files:
			DirAccess.remove_absolute(from+dir+"/"+file)
		DeleteDirectory(from+dir+"/")
	DirAccess.remove_absolute(from)
	
func _pressed() -> void:
	if DirAccess.dir_exists_absolute("res://save/"):
		DeleteDirectory("res://save/")
	
	get_tree().change_scene_to_file("res://src/entities/chunk.tscn")
