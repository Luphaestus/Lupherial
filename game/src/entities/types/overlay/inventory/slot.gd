extends MarginContainer

@export var quantity_label : Label
var real_size 

var item_data = {}
var item : Object
var itemDataSave = {}
var preview_slot = false
func init(new_size):
	real_size = new_size

func has_item() -> bool:
	return item_data != {}

func add(data):
	quantity_label.global_position = global_position
	if item_data == {} or data["path"] != item_data["path"]:
		var item_data_before = item_data
		item_data = data
		item = load(data["path"]).instantiate()
		item.init(real_size)
		add_child(item)
		quantity_label.text = item_data["quantity"]
		return item_data_before
	else:
		if int(data["quantity"]) + int(item_data["quantity"]) <= item.stack_size:
			item_data["quantity"] = str(int(item_data["quantity"])+int(data["quantity"]))
			quantity_label.text = item_data["quantity"]
			return {}
		
func remove():
	quantity_label.text = ""
	remove_child(item)
	item = null
	var data = item_data.duplicate(true)
	item_data = {}
	return data

func _get_drag_data(_at_position: Vector2):
	if item_data != {}:
		var data = remove()
		var preview = load(data["path"]).instantiate()
		preview.init(real_size/2)
		set_drag_preview(preview)

		itemDataSave = data
		return data
		
func _can_drop_data(_at_position: Vector2, data) -> bool:
	if not preview_slot:
		preview_slot = load(data["path"]).instantiate()
		preview_slot.init(real_size)
		add_child(preview_slot)
		preview_slot.modulate = Color("ffffff8f")
	if item_data == {}:
		return true
	elif item_data["path"] == data["path"] and int(data["quantity"]) + int(item_data["quantity"]) <= item.stack_size:
		return true
	else:
		preview_slot.modulate = Color("ff00008b")
		return false

func _drop_data(_at_position: Vector2, data) -> void:
	add(data)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("UI_click") and itemDataSave != {}:
		if not is_drag_successful():
			add(itemDataSave)
		itemDataSave = {}
	if preview_slot:
		var mpos = get_global_mouse_position()
		var spos = global_position
		if spos.x > mpos.x or mpos.x > spos.x+size.x:
			preview_slot.queue_free()
			preview_slot = false
		elif spos.y > mpos.y or mpos.y > spos.y+size.y:
			preview_slot.queue_free()
			preview_slot = false
	if item:
		if item.get_item_size() != Vector2(0, 0):
			item.init(real_size)

