extends MarginContainer

class_name  InventorySlot
var real_size 

var item_data = {}
var slot_pointer : int = -1
var item_origin_pointer : int = -1
var if_drag_failes #[{}, -1]

var item : Object
var root : Inventory

var preview_slot
var can_add = false

func init(new_size, r):
	real_size = new_size
	root = r

func has_item() -> bool:
	return item_data != {}

func add_pointer(pointer:int):
	slot_pointer = pointer

func add_item(data, item_to_add):
	item_data = data
	item=item_to_add

	add_child(item)
	item.init(real_size)
	item.top_level = true
	item.global_position = global_position
	item.global_position.x -= (root.slots.find(self)-item_origin_pointer)*real_size.x


func remove():
	slot_pointer = -1
	item_origin_pointer = -1
	if item_data != {}:
		remove_child(item)
		item = null
		item_data = {}

func _get_drag_data(_at_position: Vector2):
	if item_origin_pointer != -1:
		var data 
		var relIndex

		relIndex = root.index_to_coords(root.slots.find(self))  - root.index_to_coords(item_origin_pointer)
		data =root.slots[slot_pointer].item_data.duplicate(true)
		if_drag_failes = [data, item_origin_pointer]
		root.remove(item_origin_pointer, slot_pointer)
	
		
		var preview = load(data["path"]).instantiate()
		preview.set_values()
		preview.init(real_size)
		preview.top_level = true
		data["offset"] = relIndex
		preview.global_position = Vector2(-(real_size.x/2)+relIndex.x*real_size.x, -(real_size.x/2)*real_size.y+relIndex.y*real_size.y)
		set_drag_preview(preview)
		return data

func _can_drop_data(_at_position: Vector2, data) -> bool:
	if not preview_slot:
		preview_slot = load(data["path"]).instantiate()
		preview_slot.set_values()
		preview_slot.init(real_size)
		preview_slot.top_level = true

		preview_slot.global_position = global_position-Vector2(data["offset"])*Vector2(real_size)
		add_child(preview_slot)
		

		can_add = root.can_add(preview_slot.geometry, root.coords_to_index(root.index_to_coords(root.slots.find(self))-Vector2i(data["offset"])), preview_slot.rotate, data["path"])
		
		if can_add:
			preview_slot.modulate = Color("ffffff8f")
		else:
			preview_slot.modulate = Color("c30016b8")
	return can_add


func _drop_data(_at_position: Vector2, data) -> void:
	root.add(data, root.coords_to_index(root.index_to_coords(root.slots.find(self))-Vector2i(data["offset"])))

func _process(_delta: float) -> void:
	if Input.is_action_just_released("UI_click") and if_drag_failes:
		if not is_drag_successful():
			root.add(if_drag_failes[0], if_drag_failes[1])
		if_drag_failes = null
	if preview_slot:
		var mpos = get_global_mouse_position()
		var spos = global_position
		if spos.x > mpos.x or mpos.x > spos.x+size.x:
			preview_slot.queue_free()
			preview_slot = false
		elif spos.y > mpos.y or mpos.y > spos.y+size.y:
			preview_slot.queue_free()
			preview_slot = false
		elif Input.is_action_just_released("UI_click"):
			preview_slot.queue_free()
			preview_slot = false
	if item:
		if item.get_item_size() != Vector2(0, 0):
			item.init(real_size)

