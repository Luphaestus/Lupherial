extends Control

var actualSize

func init(num_columns, num_slots, slot_size) -> Vector2i:	
	custom_minimum_size = Vector2i(num_columns, ceil(num_slots / float(num_columns)))*slot_size
	return Vector2(custom_minimum_size.x/num_columns, custom_minimum_size.y/ceil(num_slots / float(num_columns)))
	
