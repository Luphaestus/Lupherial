extends character
@export var tool : Tool
@export var inventory : Inventory
@export var chatacterbody : CharacterBody2D
@export var health : Health

@export var wins : Label
@export var time : Label

var mousemode 

func _ready():
	add_to_group("player")

	super._ready()
	
	animationTree = $CharacterBody2D/AnimationTree
	idleAnim = "parameters/idle/blend_position"
	walkAnim = "parameters/walk/blend_position"
	
	movement = func movement() -> Array: 
		var direction = Input.get_vector("left", "right", "up", "down") 
		if direction!=Vector2.ZERO:
			DATA["character"]["health"] -= .1
			health.change_value(DATA["character"]["health"])
		return [direction, 1]
	get_damage = func get_damage() -> int: return 1

	health.start(DATA["constants"]["character"]["max_health"], DATA["character"]["health"], .05)

	
	time.set_time(DATA["time"], self)
	

func add_item(item_object:Object):
	
	if item_object.DATA["constants"]["item"].has("is_tool"):
		tool.changeTool(item_object.DATA["constants"]["item"]["is_tool"])
	if item_object.DATA["constants"]["item"].has("inventory_path"):
		return inventory.add({"path": item_object.DATA["constants"]["item"]["inventory_path"], "quantity": "1"})
	return true

func _process(delta: float) -> void:
	super._process(delta)
	DATA["character"]["health"] -= .1
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory.visible = not inventory.visible
		if inventory.visible:
			mousemode =  Input.get_mouse_mode()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			tool.set_process_mode(Node.PROCESS_MODE_DISABLED)
		else:
			inventory.drop(chatacterbody.global_position)
			Input.set_mouse_mode(mousemode)
			tool.set_process_mode(Node.PROCESS_MODE_INHERIT)
			
	if DATA["character"]["health"] <= 0 or DATA["character"]["health"] >= DATA["constants"]["character"]["max_health"]:
		get_tree().change_scene_to_file("res://menus/game_over/game_over.tscn")
	
	DATA["character"]["health"] += len(current_intesections)/1.5
	health.change_value(DATA["character"]["health"])
	
func _input(event: InputEvent) -> void:
	if event.as_text().find("Mouse motion") == 0:
		DATA["character"]["health"] -= .1
		health.change_value(DATA["character"]["health"])

 

var current_intesections = []

func damage(area: Area2D) -> void:
	current_intesections.append(area)


func _on_hurtbox_area_exited(area: Area2D) -> void:
	current_intesections.erase(area)
