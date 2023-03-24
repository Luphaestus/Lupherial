extends Node2D
class_name Inventory

@export var slot_path : String
@export var grid : GridContainer
@export var grid_size : Control
@export var slot_size = 18
@export var number_of_slots = 4
@export var columns:= 2

var size_per_cell
var rows

var slots : Array[InventorySlot] = []

var dragging = false

func id_slot(slot):
	return slots.find(slot)
	

func index_to_coords(index:int) -> Vector2i:
		return Vector2i(index%columns, floor(index*columns)/columns/columns)
func coords_to_index(coords:Vector2i):
	return coords.x + coords.y*columns

func can_add(geometry, slot, rotate, path) -> bool:
	var coords := index_to_coords(slot)
	var first_one = -1
	for y in range(len(geometry)):
		for x in range(len(geometry[0])):
			if geometry[y][x] == 1:
				var currentCoords := Vector2i(coords.x+x, coords.y+y)
				if currentCoords.x < 0 or currentCoords.y < 0: return false
				if currentCoords.x >= columns or currentCoords.y >= rows:
					return false

				var slot_instance = slots[coords_to_index(currentCoords)]
				if first_one != -1:
					first_one = coords_to_index(currentCoords)
					if slot_instance.slot_pointer != -1:
						return false
					if slot_instance.item.rotate != rotate:
						return false
					if slot_instance.item_data != {}:
						return false
				else:
					if slot_instance.slot_pointer != first_one or slot_instance.item_data != {}:
						return false
	return true
func add(data, slot=0) -> bool:
	var item = load(data["path"]).instantiate()
	item.set_values()
	if not can_add(item.geometry, slot, item.rotate, data["path"]): return false
	
	var coords := index_to_coords(slot)
	var first = -1
	
	var origin = -1
	for y in range(len(item.geometry)):
		for x in range(len(item.geometry[0])):
			if origin == -1:
				var currentCoords := Vector2i(coords.x+x, coords.y+y)		
				origin = coords_to_index(currentCoords)
			if item.geometry[y][x] == 1:
				var currentCoords := Vector2i(coords.x+x, coords.y+y)
				if first == -1:
					first = coords_to_index(currentCoords)
					slots[coords_to_index(currentCoords)].item_origin_pointer = origin
					slots[coords_to_index(currentCoords)].add_item(data, item)
				slots[coords_to_index(currentCoords)].add_pointer(first)
				slots[coords_to_index(currentCoords)].item_origin_pointer = origin
	return true

func remove(origin_index, root_index):
	var itemg = slots[root_index].item.geometry
	for y in range(len(itemg)):
		for x in range(len(itemg[0])):
			var currentCoords := Vector2i(index_to_coords(origin_index).x+x, index_to_coords(origin_index).y+y)
			if slots[coords_to_index(currentCoords)].item_origin_pointer == origin_index:
				slots[coords_to_index(currentCoords)].remove()
func _ready() -> void:
	visible = false
	size_per_cell = grid_size.init(columns, number_of_slots, slot_size) - Vector2i(grid.get_theme_constant("h_separation"), grid.get_theme_constant("v_separation"))
	rows = ceil(number_of_slots / float(columns))
	grid.columns = columns
	for i in range(number_of_slots):
		var slot = load(slot_path).instantiate()
		slot.init(size_per_cell, self)
		grid.add_child(slot)
		slots.append(slot)
