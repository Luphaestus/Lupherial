extends Entity

var CHUNKSIZE := 32
var LOADED_CHUNKS = []
var CHUNK_LOADING_ENTITES = []
var CALL_EVERY_CHUNK = []
var SEED = 0

var TIME_SCALE = 2
var TIME = 12

func local_to_chunk(coord : Vector2i) -> Vector2i:
	return Vector2i(coord/CHUNKSIZE)

func _ready() -> void:
	add_to_group("globals")
	add_to_group("core")
	super._ready()
	
func _process(delta: float) -> void:
	super._process(delta)
	TIME += delta*TIME_SCALE
	if TIME >= 24: TIME = 0
