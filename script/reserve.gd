class_name Reserve
extends Object

var dictonary = {}
# "source:dest" - key
# 

func _init(item: Item, s_coord: Vector2i, d_coord: Vector2i):
	var key = get_key(s_coord, d_coord)
	dictonary[key] = item

func get_key(s_coord: Vector2i, d_coord: Vector2i) -> String:
	return str(s_coord)+":"+str(d_coord)

