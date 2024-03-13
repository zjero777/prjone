class_name Recept
extends Node

var id: int
var recept_name: String
var pic: Texture2D
var res_in = []
var res_out = []
var work_time: int

func select(_id: int):
	id = _id
	var data = Data.get_by_id("recipes", id)
	recept_name = data.name
	pic = load(Global.img_recept_directory+data.pic)
	if data.has("in"):
		res_in = _deserialize_item_array(data.in)
	if data.has("out"):
		res_out = _deserialize_item_array(data.out)
	work_time = data.time
	
func _deserialize_item_array(item_list):
	var result = []
	for i in item_list:
		var item = Item.new()
		item.create(i.id, i.count)
		result.append(item)
	return result

	
	

