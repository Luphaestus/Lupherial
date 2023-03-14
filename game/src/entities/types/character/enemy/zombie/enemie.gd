extends character

@export var health : Node2D
@export var tool : Node2D

func _ready() -> void:
	health.start(int(DATA["constants"]["character"]["max_health"]), int(DATA["character"]["health"]))
	if randi_range(0, 1) == 0:
		super._ready()
	else: queue_free()
	
	animationPlayer = $CharacterBody2D/AnimationPlayer2
	hurtAnim = "hurt"
	
	movement = func movement() -> Array:
		var pointTowards = get_tree().get_nodes_in_group("player")[0].get_child(0).global_position
		var direction = (pointTowards-get_child(0).global_position).normalized()

		return [direction, .5]
		
	tool.changeTool(tool.tool.keys()[randi_range(0, len(tool.tool.keys())-1)])
	


func damage(area: Area2D) -> void:
	apply_damage(area.get_damage())
	health.change_value(DATA["character"]["health"])
	
