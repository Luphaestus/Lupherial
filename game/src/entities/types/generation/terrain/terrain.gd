extends TileMap


@export var resourcePath : String

var Temperature : FastNoiseLite
var Moisture : FastNoiseLite

var rdm = RandomNumberGenerator.new()


func unique (k1, k2):
	return (1./2*(k1 + k2)*(k1 + k2 + 1) + (k1*k2))

func generate(pos1, generatedBefore):
	
	var compiled := {}
	pos1=local_to_map(pos1*get_tree().get_nodes_in_group("core")[0].CHUNKSIZE)
	var size=local_to_map(Vector2i(get_tree().get_nodes_in_group("core")[0].CHUNKSIZE, get_tree().get_nodes_in_group("core")[0].CHUNKSIZE))

	if get_cell_source_id(0, pos1+size/2) != -1: return
	
	for y in range(pos1.y, pos1.y+size.y):
		for x in range(pos1.x, pos1.x+size.x):
			var moistureVal = (Moisture.get_noise_2d(x, y)+1)/2
			var termperatureVAl = (Temperature.get_noise_2d(x, y)+1)/2
			var moistureRounded : float = floor(moistureVal*len(Terrain_lookup.chart))
			var termperatureRounded : float = floor(termperatureVAl*len(Terrain_lookup.chart[0]))

			if not compiled.has(Terrain_lookup.chart[moistureRounded][termperatureRounded]):
				compiled[Terrain_lookup.chart[moistureRounded][termperatureRounded]] = []
			compiled[Terrain_lookup.chart[moistureRounded][termperatureRounded]].append(Vector2i(x, y))

	var tilemap : TileMap = get_tree().get_nodes_in_group("tilemap")[0]

	for type in compiled:
		for pos in compiled[type]:
			var posId = unique(pos.x, pos.y)
			rdm.seed = posId+get_tree().get_nodes_in_group("core")[0].SEED
			rdm.randi()
			var object = Terrain_lookup.terrain[type]["enviroment"][rdm.randi_range(0, len(Terrain_lookup.terrain[type]["enviroment"])-1)]
			if object != "":
				var resource_lookup = Terrain_lookup.terrain_enviroment[type][object]
			
				if not generatedBefore:
					var resource_json = get_tree().get_nodes_in_group("engine")[0].ReadEntityJsonFile(resourcePath)
					resource_json["general_propoties"]["posx"] = tilemap.map_to_local(pos).x
					resource_json["general_propoties"]["posy"] = tilemap.map_to_local(pos).y
					resource_json["resource"]["sourceImg"] = resource_lookup["source_img"]
					resource_json["resource"]["atlasCoords"] = resource_lookup["atlas_coords"]
					resource_json["resource"]["id"] = posId
					resource_json["resource"]["type"] = object
					var resource : Object = load(resource_json["constants"]["general_propoties"]["scriptLocation"]).instantiate()
					resource.DATA = resource_json
					get_parent().add_child(resource)
		for testpos in compiled[type]:
			tilemap.set_cells_terrain_connect(0, [testpos], 0, Terrain_lookup.terrain[type]["terrain_id"], false)	
		await get_tree().process_frame 
	

func _ready() -> void:
	#for both noises
	add_to_group("tilemap")
	get_tree().get_nodes_in_group("core")[0].CALL_EVERY_CHUNK.append(generate)
	
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.01
	
	#duplicate
	Temperature = noise.duplicate(true)
	Moisture = noise.duplicate(true)
	
	#assign seed
	rdm.seed = get_tree().get_nodes_in_group("core")[0].SEED
	Temperature.seed = rdm.randi()
	Moisture.seed = rdm.randi()
	
	
	


	

