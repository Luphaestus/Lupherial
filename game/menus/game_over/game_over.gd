extends PanelContainer

@export var animation : AnimationPlayer
var out = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func DeleteDirectory(from:String) -> void:
	if not DirAccess.dir_exists_absolute(from): return
	var dirs := DirAccess.get_directories_at(from)

	for dir in dirs:
		var files := DirAccess.get_files_at(from+dir)
		for file in files:
			DirAccess.remove_absolute(from+dir+"/"+file)
		DeleteDirectory(from+dir+"/")
	DirAccess.remove_absolute(from)
	
func _ready() -> void:
	if DirAccess.dir_exists_absolute("res://save/"):
		DeleteDirectory("res://save/")
	






func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_click") or Input.is_action_just_pressed("ui_accept"):
		animation.play("transition")
		out = true

	if out and not animation.is_playing():
		get_tree().change_scene_to_file("res://menus/title/title_screen.tscn")
