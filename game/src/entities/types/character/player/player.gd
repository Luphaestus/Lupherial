extends character
@export var tool : Node2D

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
	if item_object.info.has("is_tool"):
		tool.changeTool(item_object.info["is_tool"])
	return true

