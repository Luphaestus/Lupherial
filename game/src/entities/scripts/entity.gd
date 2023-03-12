extends Node2D

class_name Entity

var DATA : Dictionary = {}
var CHUNK = null

func _ready():
	
	
	if DATA["constants"]["saving"]["do_save"]:
		add_to_group("entity_save")

	if DATA["constants"]["general_propoties"]["loadChunks"] != -1:
		get_tree().get_nodes_in_group("core")[0].CHUNK_LOADING_ENTITES.append(DATA.duplicate())

func _process(_delta):
	var currentChunk =  Vector2i(floor(DATA["general_propoties"]["posx"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE), floor(DATA["general_propoties"]["posy"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE))
	if currentChunk != CHUNK:
		if CHUNK and is_in_group("entity:"+str(CHUNK.x) + "-" + str(CHUNK.y)):
			if DATA["constants"]["general_propoties"]["loadChunks"] == -1:
				remove_from_group("entity:"+str(CHUNK.x) + "-" + str(CHUNK.y))
				add_to_group("entity:"+str(currentChunk.x) + "-" + str(currentChunk.y))

			if DATA["constants"]["saving"]["do_save"] and DATA["constants"]["saving"]["save_with_chunk"]:
				remove_from_group("entity_save:"+str(CHUNK.x) + "-" + str(CHUNK.y))
				add_to_group("entity_save:"+str(currentChunk.x) + "-" + str(currentChunk.y))
		CHUNK = currentChunk
		
