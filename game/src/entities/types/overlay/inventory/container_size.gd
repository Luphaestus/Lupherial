extends Control

func init(num_columns, num_slots, slot_size) -> Vector2i:	
	size = Vector2i(num_columns, ceil(num_slots / float(num_columns)))*slot_size

	return Vector2(size.x/num_columns, size.y/ceil(num_slots / float(num_columns)))
	
	
