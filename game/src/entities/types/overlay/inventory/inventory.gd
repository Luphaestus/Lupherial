extends Node2D
class_name Inventory

@export var slot_path : String
@export var grid : GridContainer
@export var grid_size : Control
@export var slot_size = 18
@export var number_of_slots = 4
@export var columns:= 2

var slots = []

var dragging = false

func id_slot(slot):
	return slots.find(slot)

func _ready() -> void:
	var size_per_cell = grid_size.init(columns, number_of_slots, slot_size) - Vector2i(grid.get_theme_constant("h_separation"), grid.get_theme_constant("v_separation"))
	
	grid.columns = columns
	for i in range(number_of_slots):
		var slot = load(slot_path).instantiate()
		slot.init(size_per_cell)
		grid.add_child(slot)
		slots.append(slot)

func add(path, amount):
	for slot in slots:
		if slot.item_data == {}:
			slot.add({"path": path, "quantity":str(amount)})
			return true
		elif path == slot.item_data["path"] and (amount + int(slot.item_data["quantity"]) <= slot.item.stack_size):
			slot.add({"path": path, "quantity":str(amount)})
			return true
	return false
