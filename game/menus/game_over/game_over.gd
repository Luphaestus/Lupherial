extends PanelContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_click") or Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://menus/title/title_screen.tscn")

