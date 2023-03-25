extends Panel

class_name drop_inventory
@export var root : Inventory

var items = []

var savedata
var savepos


var wood = 0
var coal = 0
var win = 0

func create_entity(pos : Vector2i, type:String):
	var itemJson = get_tree().get_nodes_in_group("engine")[0].ReadEntityJsonFile("res://src/entities/types/item/world/types/"+type+"/"+type+".json") 
	itemJson["general_propoties"]["posx"] = pos.x
	itemJson["general_propoties"]["posy"] = pos.y
	var itemObject : Entity = load(itemJson["constants"]["general_propoties"]["scriptLocation"]).instantiate()
	itemObject.global_position = pos
	itemObject.DATA = itemJson
	get_tree().get_nodes_in_group("engine")[0].call_deferred("add_child", itemObject)
	
func _can_drop_data(at_position: Vector2, data) -> bool:
	return true

func _drop_data(at_position: Vector2, data) -> void:
	var item = load(data["path"]).instantiate()
	item.set_values() 
	item.position = at_position+Vector2(-(root.size_per_cell.x/2), -(root.size_per_cell.x/2))- Vector2(data["offset"]*root.size_per_cell)
	item.init(root.size_per_cell)
	add_child(item)
	
	if item.world_entity == "wood":
		wood += 1 
	else:
		coal += 1
	items.append([item, at_position, data])
	
	if wood >= 4 and coal >= 2:
		var woodtemp = 0
		var coaltemp = 0    
		var to_remove = []
		for itemInfo in items:
			if woodtemp < 4:
				woodtemp += 1
				to_remove.append(itemInfo)
			if coaltemp < 2:
				coaltemp += 1
				to_remove.append(itemInfo)
		wood = 0    
		coal = 0   
		for itemInfo in to_remove:
			itemInfo[0].queue_free()
			items.erase(itemInfo)
		
		win += 1
		get_tree().get_nodes_in_group("player")[0].wins.text = str(win)+"/"+"3"
		if win == 3:
			get_tree().change_scene_to_file("res://menus/win/win.tscn")
				
func _get_drag_data(_at_position: Vector2):
	for item in items:
		for geomy in range(len(item[0].geometry)):
			for geomx in range(len(item[0].geometry[0])):
				if item[0].geometry[geomy][geomx] == 1:
					if item[1].x+geomx*root.size_per_cell.x < _at_position.x and _at_position.x < item[1].x+root.size_per_cell.x+geomx*root.size_per_cell.x:
						if item[1].y+geomy*root.size_per_cell.y < _at_position.y and _at_position.y < item[1].y+root.size_per_cell.y+geomy*root.size_per_cell.y:
							var data = item[2]
							var preview = load(data["path"]).instantiate()
							preview.set_values()
							preview.init(root.size_per_cell)

							set_drag_preview(preview)
							item[0].queue_free()
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

func drop(pos):
	for item in items:
		create_entity(pos, item[0].world_entity)
		item[0].queue_free()
	items = []
