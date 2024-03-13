class_name Prod_resource
extends Node

var id: int
var name_resource: String
var pic: Texture2D

func add(_id: int):
	id = _id
	var data = Data.get_by_id("block_type", id)
	name_resource = data.name
	pic = load(Global.img_block_directory+data.pic)
	


