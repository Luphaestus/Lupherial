extends character

@export var health : Node2D
@export var tool : Node2D
@export var pos : CharacterBody2D

func create_entity(pos : Vector2i, type:String):
	var itemJson = get_tree().get_nodes_in_group("engine")[0].ReadEntityJsonFile("res://src/entities/types/item/world/types/"+type+"/"+type+".json") 
	itemJson["general_propoties"]["posx"] = pos.x
	itemJson["general_propoties"]["posy"] = pos.y
	var itemObject : Entity = load(itemJson["constants"]["general_propoties"]["scriptLocation"]).instantiate()
	itemObject.DATA = itemJson
	get_parent().call_deferred("add_child", itemObject)
	
func _ready() -> void:
	health.start(int(DATA["constants"]["character"]["max_health"]), int(DATA["character"]["health"]), .05)
	if randi_range(0, 10) == 0:
		super._ready()
	else: queue_free()
	
	animationPlayer = $CharacterBody2D/AnimationPlayer2
	hurtAnim = "hurt"
	
	movement = func movement() -> Array:
		var pointTowards = get_tree().get_nodes_in_group("player")[0].get_child(0).global_position
		var direction = (pointTowards-get_child(0).global_position).normalized()

		return [direction, .5]
		
	tool.changeTool(tool.tool.keys()[randi_range(0, len(tool.tool.keys())-1)])
	
	death = func death() -> void:
		create_entity(pos.position, tool.tool_type)
		

func damage(area: Area2D) -> void:
	apply_damage(area.get_damage())
	health.change_value(DATA["character"]["health"])
	
