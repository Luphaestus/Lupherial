extends Node2D

func ReadJsonFile(file_path)->Dictionary:
	var content_as_text := FileAccess.open(file_path, FileAccess.READ).get_as_text()
	var data := JSON.new()
	data.parse(content_as_text)
	return data.data
	
func ReadEntityJsonFile(file_path)->Dictionary:
	var data := ReadJsonFile(file_path).duplicate(true)
	var const_json := ReadJsonFile(data["constants_path"]).duplicate(true)
	data["constants"] = const_json
	return data	
func ReadDelete(path)->Dictionary:
	var data := ReadEntityJsonFile(path)
	DirAccess.remove_absolute(path)
	return data	
func LoadChunk(x=null, y=null, alwaysLoad:=false, compileName:="")->void:

	var folder = SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION
	if alwaysLoad:
		folder += "always-load/"
	else:
		if x == null:
			var split_index = compileName.rfind("-") - (1 if compileName.find("--") != -1 else 0)
			x = int(compileName.substr(0, split_index))
			y = int(compileName.substr(split_index+1, len(compileName)-split_index-1))

		for path in DirAccess.get_files_at(folder+"every-chunk"):

			var json_data := ReadEntityJsonFile(folder+"every-chunk/"+path)
			json_data["general_propoties"]["posx"] = get_tree().get_nodes_in_group("core")[0].CHUNKSIZE * x
			json_data["general_propoties"]["posy"] = get_tree().get_nodes_in_group("core")[0].CHUNKSIZE * y 
			var enitity : Entity = load(json_data["constants"]["general_propoties"]["scriptLocation"]).instantiate()
			enitity.DATA = json_data
			add_child(enitity)

		if compileName == "": compileName = str(x) + "-" + str(y)
		if compileName in get_tree().get_nodes_in_group("core")[0].LOADED_CHUNKS: return 
		get_tree().get_nodes_in_group("core")[0].LOADED_CHUNKS.append(compileName)
		
		
		folder += compileName + "/"
	
	if compileName != "":
		var generatedBefore = compileName in get_tree().get_nodes_in_group("core")[0].DATA["generated-chunks"]
		for function in get_tree().get_nodes_in_group("core")[0].CALL_EVERY_CHUNK:
			function.call(Vector2i(x, y), generatedBefore)
		if not generatedBefore: get_tree().get_nodes_in_group("core")[0].DATA["generated-chunks"].append(compileName)
	
	if not DirAccess.dir_exists_absolute(folder):
		return

	for path in DirAccess.get_files_at(folder):
		var jsonData := ReadDelete(folder+path)
		var enitity : Object = load(jsonData["constants"]["general_propoties"]["scriptLocation"]).instantiate()
		enitity.DATA = jsonData
		add_child(enitity)


		
func AutoLoadSave()->void:
	if get_tree().get_nodes_in_group("core")[0].CHUNK_LOADING_ENTITES == []:
		return
	var chunks_to_load := []
	for entity_data in get_tree().get_nodes_in_group("core")[0].CHUNK_LOADING_ENTITES:
		var size = entity_data["constants"]["general_propoties"]["loadChunks"]
		var pos = Vector2i(floor(entity_data["general_propoties"]["posx"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE), 
			floor(entity_data["general_propoties"]["posy"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE))
		var origin = Vector2i(pos.x-size, pos.y-size)
		
		for x in range(2*size+1):
			for y in range(2*size+1):
				chunks_to_load.append(str(x+origin.x) + "-" + str(y+origin.y))
	
	var chunks_to_unload = get_tree().get_nodes_in_group("core")[0].LOADED_CHUNKS.duplicate() 

	for chunk in get_tree().get_nodes_in_group("core")[0].LOADED_CHUNKS:
		if chunk in chunks_to_load:
			chunks_to_load.erase(chunk)
			chunks_to_unload.erase(chunk)

	for chunk in chunks_to_load:
		LoadChunk(null, null, false, chunk)

	for chunk in chunks_to_unload:
		UnloadChunk(0, 0, chunk)

func SaveEntity(save_location:String, entity:Entity)->void:
	#make chunk directory
	var save_data = entity.DATA.duplicate(true)
		
	var file_path := save_location
	if not save_data["constants"]["saving"]["save_with_chunk"]:
		file_path += "always-load/"
	else:
		var x_chunk := floori(save_data["general_propoties"]["posx"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE)
		var y_chunk := floori(save_data["general_propoties"]["posy"]/get_tree().get_nodes_in_group("core")[0].CHUNKSIZE)
		file_path += str(x_chunk) + "-" + str(y_chunk) + "/"
	DirAccess.make_dir_absolute(file_path)
	
	#save
	var file_name := str(entity)+str(Time.get_unix_time_from_system())
	for c in [">", "<", "@", "#", ".", ":"]:
		file_name = file_name.replace(c,"")
	file_path += file_name +".json"
	var Savefile := FileAccess.open(file_path, FileAccess.WRITE)
	save_data.erase("constants")
	Savefile.store_string(JSON.stringify(save_data))
func SaveAll()->void:
	var entities := get_tree().get_nodes_in_group("entity_save")
	for entity in entities:
		SaveEntity(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION,entity)
func SaveChunk(x:int, y:int, compileName)->void:
	if compileName == "": compileName = str(x) + "-" + str(y)
	var entities := get_tree().get_nodes_in_group("entity_save:"+compileName)
	for entity in entities:
		SaveEntity(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION,entity)
func UnloadChunk(x:=0, y:=0, compileName := "")->void:
	if compileName == "": compileName = str(x) + "-" + str(y)
	var entities := get_tree().get_nodes_in_group("entity:"+compileName)
	SaveChunk(0, 0, compileName)
	for entity in entities:
		entity.queue_free()
	get_tree().get_nodes_in_group("core")[0].LOADED_CHUNKS.erase(compileName)

func CopyDirectory(from:String, to:String) -> void:
	var dirs := DirAccess.get_directories_at(from)

	for dir in dirs:
		DirAccess.make_dir_recursive_absolute(to+dir)
		var files := DirAccess.get_files_at(from+dir)
		
		for file in files:
			var from_path := from+dir+"/"+file
			var to_path := to+dir+"/"+file
			
			DirAccess.copy_absolute(from_path, to_path)
		
		CopyDirectory(from+dir+"/", to+dir+"/")
func DeleteDirectory(from:String) -> void:
	if not DirAccess.dir_exists_absolute(from): return
	var dirs := DirAccess.get_directories_at(from)

	for dir in dirs:
		var files := DirAccess.get_files_at(from+dir)
		for file in files:
			DirAccess.remove_absolute(from+dir+"/"+file)
		DeleteDirectory(from+dir+"/")
	DirAccess.remove_absolute(from)


	
func CreateSaveDirectory() -> void:
	var saveTemplate = "res://src/save/"
	if not DirAccess.dir_exists_absolute(SAVE_GLOBALS.SAVE_LOCATION):
		CopyDirectory(saveTemplate, SAVE_GLOBALS.SAVE_LOCATION)
		
func StartAutoSave(delay:float = .1)->void:
	var timer := Timer.new()

	timer.set_wait_time(delay)

	timer.set_one_shot(false)

	timer.connect("timeout", AutoLoadSave)

	add_child(timer)

	timer.start()
func _notification(what):
	if (what == NOTIFICATION_WM_CLOSE_REQUEST):
		SaveAll()
		DeleteDirectory(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.PERMANENT_LOCATION)
		CopyDirectory(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION, SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.PERMANENT_LOCATION)
		DeleteDirectory(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION)

func _ready(): 
	CreateSaveDirectory()
	

	add_to_group("engine")
	DeleteDirectory(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION)
	CopyDirectory(SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.PERMANENT_LOCATION, SAVE_GLOBALS.SAVE_LOCATION+SAVE_GLOBALS.ACTIVE_LOCATION)	
	LoadChunk(null, null, true) #call autoLoad
	StartAutoSave()


