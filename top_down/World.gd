extends Node2D

export var CHUNK_SIZE = 16
export var SCALE = 2
export var READ_POS = Vector2(-2, 0)
export var NOISNESS : = 1

onready var FLOOR = $Floor
onready var FOLIAG = $YSort/Foliage
onready var PLAYER = $YSort/Player

var SEED
var OPEN_SIMPLEX_NOISE = OpenSimplexNoise.new()
var GRAPH = []



func Generate_map(per, oct, possition, noise_seed):
	OPEN_SIMPLEX_NOISE.seed = noise_seed
	OPEN_SIMPLEX_NOISE.period = per
	OPEN_SIMPLEX_NOISE.octaves = oct
	var grdName = {}
	for x in CHUNK_SIZE/SCALE:
		for y in CHUNK_SIZE/SCALE:
			var rand := NOISNESS*(abs(OPEN_SIMPLEX_NOISE.get_noise_2d(x+possition.x, y+possition.y)))
			grdName[Vector2(x, y)] = rand
	return grdName

func _input(event: InputEvent) -> void:
	var playerPos = PLAYER.global_position
	for y in range(-2, 2):
		y *= 16 * 16
		for x in range(-2, 2):
			x *= 16*16
			#print(playerX)
			generate_chunk(Vector2(PLAYER.global_position.x + x, PLAYER.global_position.y + y))
	if event.is_action_pressed("ui_accept"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if Input.is_action_pressed("click"):
		var mousePos = FLOOR.get_local_mouse_position()
		
		generate_chunk(mousePos)

#-----------------	

func load_graph(start_read_pos, x_direction=1, y_direction=1): #Get Temperature Moisture Graphs
	var graph = [[]] #Graph (result) 
	var read_pos = start_read_pos #Pos of tile being read
	var graph_loaded = false #If whole map loaded
	while not graph_loaded: #Loop until whole graph read
		var rows = len(graph) #Number of rows of graph loaded
		if FLOOR.get_cellv(read_pos) == -1: #If end of row/collumn
			read_pos = Vector2(-2, start_read_pos.y + (rows * y_direction)) #Set pos to new row
			if FLOOR.get_cellv(read_pos) != -1: #If not the last row
				graph.append([]) #Add new row to result graph
			else: #If the last row
				graph_loaded = true #Whole map loaded
		else: #If more in row
			graph[rows-1].append(FLOOR.get_cellv(read_pos)) #Load tile
			read_pos.x += x_direction #Set read pos to nex tile
	return graph #return graph (result) 
func get_gog(start_read_pos, spacing): #Get graph of graphs 
	var graph = [] #Graph (Result) 
	var read_pos = READ_POS #Pos of tile being read
	var graph_loaded = false #If whole map loaded
	while not graph_loaded: #Loop until whole graph read
		if FLOOR.get_cellv(read_pos) == -1: #If no more graphs
			graph_loaded = true #Whole map loaded
		else: #If more graphs
			graph.append(load_graph(read_pos, -1)) #read graph
			if spacing.x > 0: #change rea pos to next graph
				read_pos.x += len(graph[0]) + spacing.x
			if spacing.y > 0: #change rea pos to next graph
				read_pos.y += len(graph[0]) + spacing.y
	return graph #return graph (result) 

func set_floor(graph, dimentions, altitude, temperature, moisture, position):
	for x in dimentions.x/SCALE:
		for y in dimentions.y/SCALE:

			var pos = Vector2(x, y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			var altGraph = graph[clamp(alt, 0, .999) * len(graph)]
			var tempGraph = altGraph[clamp(temp, 0, .999) * len(altGraph)]
			var tile = tempGraph[clamp(moist, 0, .999) * len(tempGraph)]
			
			pos = Vector2(pos.x*SCALE + position.x, pos.y*SCALE + position.y)
			for scaleOffsetY in range(SCALE):
				for scaleOffsetX in range(SCALE):
					FLOOR.set_cellv(Vector2(pos.x+scaleOffsetX, pos.y+scaleOffsetY), tile)

func generate_chunk(pos):
	var snapped_pos = Vector2(
		floor(pos.x/16 / CHUNK_SIZE) * CHUNK_SIZE,
		floor(pos.y/16 / CHUNK_SIZE) * CHUNK_SIZE
	)
	if FLOOR.get_cellv(snapped_pos) == -1:
		print(pos, " + ", snapped_pos)
		var altitude = Generate_map(159, 9, snapped_pos, SEED)
		var temperature = Generate_map(500, 9, snapped_pos, SEED)
		var moisture = Generate_map(300, 9, snapped_pos, SEED)

		if GRAPH == []:
			GRAPH = get_gog(READ_POS, Vector2(0, 1))
			FLOOR.clear()
		set_floor(GRAPH, Vector2(CHUNK_SIZE, CHUNK_SIZE), altitude, temperature, moisture, snapped_pos)
		FLOOR.update_bitmask_region(snapped_pos, Vector2(snapped_pos.x+CHUNK_SIZE, snapped_pos.y+CHUNK_SIZE))
	
func _ready():
	SEED = randi()
	generate_chunk(Vector2(0, 0))
	generate_chunk(Vector2(16*16, 0))
	
	


