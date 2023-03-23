extends character
@export var tool : Tool
@export var inventory : Inventory
@export var chatacterbody : CharacterBody2D

var mousemode 

func _ready():
	add_to_group("player")

	super._ready()
	
	animationTree = $CharacterBody2D/AnimationTree
	idleAnim = "parameters/idle/blend_position"
	walkAnim = "parameters/walk/blend_position"
	
	movement = func movement() -> Array: 
		var direction = Input.get_vector("left", "right", "up", "down") 
		return [direction, 1]
	get_damage = func get_damage() -> int: return 1



func add_item(item_object:Object):
	
	if item_object.DATA["constants"]["item"].has("is_tool"):
		tool.changeTool(item_object.DATA["constants"]["item"]["is_tool"])
	if item_object.DATA["constants"]["item"].has("inventory_path"):
		return inventory.add({"path": item_object.DATA["constants"]["item"]["inventory_path"], "quantity": "1"})
	return true

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory.visible = not inventory.visible
		if inventory.visible:
			mousemode =  Input.get_mouse_mode()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			tool.set_process_mode(Node.PROCESS_MODE_DISABLED)
		else:
			Input.set_mouse_mode(mousemode)
			tool.set_process_mode(Node.PROCESS_MODE_INHERIT)

 
