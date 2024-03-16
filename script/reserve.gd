class_name Reserve
extends Object

var dicronary = {}
# "source:dest" - key
# 

func _init(item: Item, s_coord: Vector2i, d_coord: Vector2i):
	var key = str(s_coord)+":"+str(d_coord)
	dicronary[key] = item

