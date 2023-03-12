extends Label


func _ready():
	#warning-ignore:integer_division
	var offset = CORE_GLOBALS.CHUNKSIZE/32.*1.6
	position = Vector2(get_parent().DATA["general_propoties"]["posx"]+offset, get_parent().DATA["general_propoties"]["posy"])
	size = Vector2(CORE_GLOBALS.CHUNKSIZE, CORE_GLOBALS.CHUNKSIZE)
	text = str(Vector2i(floor(get_parent().DATA["general_propoties"]["posx"]/CORE_GLOBALS.CHUNKSIZE), floor(get_parent().DATA["general_propoties"]["posy"]/CORE_GLOBALS.CHUNKSIZE)))
	
