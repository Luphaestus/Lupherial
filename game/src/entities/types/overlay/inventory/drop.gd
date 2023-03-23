extends Panel

@export var root : Inventory

var items = []

var savedata
var savepos

func _can_drop_data(at_position: Vector2, data) -> bool:
	return true

func _drop_data(at_position: Vector2, data) -> void:
	var item = load(data["path"]).instantiate()
	item.position = at_position+Vector2(-(root.size_per_cell.x/2), -(root.size_per_cell.x/2))
	item.init(root.size_per_cell)
	add_child(item)
	items.append([item, at_position, data])

func _get_drag_data(_at_position: Vector2):
	for item in items:
		if item[1].x < _at_position.x and _at_position.x < item[1].x+root.size_per_cell.x:
			if item[1].y < _at_position.y and _at_position.y < item[1].y+root.size_per_cell.y:
				var data = item[2]
				var preview = load(data["path"]).instantiate()
				preview.init(root.size_per_cell)
				var previewScene = load("res://src/entities/types/overlay/inventory/preview.tscn").instantiate()
				previewScene.node.add_child(preview)
				previewScene.node.position = Vector2(-(root.size_per_cell.x/2), -(root.size_per_cell.x/2))
				set_drag_preview(previewScene)
				remove_child(item[0])
				savedata = data
				savepos = item[1]
				items.erase(item)
				
				return data
func _process(delta: float) -> void:
	if Input.is_action_just_released("UI_click") and savedata:

		if not is_drag_successful():
			_drop_data(savepos, savedata)
		savepos = null
		savedata = null

