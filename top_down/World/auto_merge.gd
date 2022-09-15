tool
extends TileSet


var binds =  {
	#ocean tiles
	9 : [10, 11, 12],
	10 : [9, 11, 12],
	11 : [9, 10, 12],
	12 : [9, 10, 11],
	
	#Transition tiles
	#orange
	13 : [1, 14, 27, 9, 25, 19], #dark green
	14 : [1, 13, 27, 9, 25, 19], #light green
	27 : [1, 13, 14, 9, 25, 19], #brown
	#pink
	15 : [8, 16, 25, 26], #dark green
	16 : [8, 15, 25, 26], #light green
	25 : [8, 15, 16, 26], #orange
	#light green
	17 : [2, 18, 22], #orange
	18 : [2, 17, 22], #dark green
	#dark green
	19 : [7, 20, 23, 21, 18], #orange
	20 : [7, 19, 23, 21, 18], #light green
	#white
	21 : [3, 4, 5, 22], #dark green
	22 : [3, 4, 5, 21], #light green
	#brown
	23 : [6, 24, 26, 27], #dark green
	24 : [6, 23, 26, 27], #light green
	26 : [6, 23, 24, 27], #pink
		
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
