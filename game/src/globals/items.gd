extends Node

func create_entity(pos : Vector2i, type:String):
	var itemJson = get_tree().get_nodes_in_group("engine")[0].ReadEntityJsonFile("res://src/entities/types/item/world/types/"+type+"/"+type+".json") 
	itemJson["general_propoties"]["posx"] = pos.x
	itemJson["general_propoties"]["posy"] = pos.y
	var itemObject : Entity = load(itemJson["constants"]["general_propoties"]["scriptLocation"]).instantiate()
	itemObject.DATA = itemJson
	get_parent().call_deferred("add_child", itemObject)
	
