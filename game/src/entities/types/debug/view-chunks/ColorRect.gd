extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = int(get_tree().get_nodes_in_group("core")[0].CHUNKSIZE/32.)
	position = Vector2(get_parent().DATA["general_propoties"]["posx"], get_parent().DATA["general_propoties"]["posy"])
	var generator = RandomNumberGenerator.new()
	generator.seed = hash(position)
	color = Color(generator.randf(), generator.randf(), generator.randf(), 0.3)
	size = Vector2(get_tree().get_nodes_in_group("core")[0].CHUNKSIZE-offset, get_tree().get_nodes_in_group("core")[0].CHUNKSIZE-offset)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
