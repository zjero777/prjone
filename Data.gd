extends Node

var data

func _init():
	var file = FileAccess.open("res://data/data.json", FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		data = json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
	
func get_id_by_type(type):
	for i in range(data.keys().size()):
		if data.keys()[i]==type: 
			return i
	return -1
	
func get_id_by_name(type, name_res):
	for i in data[type]:
		var item = data[type][i]
		#print_debug(item)
		if item.name == name_res: return int(i)
	return(-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_terrain_by_id(id: int):
	return data["terrain_type"][id]

#func get_texture_by_name(type, name_res):
	#var id = get_id_by_name(type, name_res)
	#return(get_texture_by_id(type, id))
#
#func get_texture_by_id(type, id):
	#var item = data[type][str(id)]
	#var type_id = get_id_by_type(type)
	#var dir = Global.img_directory[type_id]
	#var file = dir+"/"+item.pic
	#var pic: Image = Image.new()
	#var image_texture = ImageTexture.new()
	#pic = pic.load_from_file(file)
	#image_texture = pic.image_texture.create_from_image(pic)
	#return(image_texture)
	
func get_by_id(type, id):
	return data[type][str(id)]

func get_by_name(type, name_res):
	var id = get_id_by_name(type, name_res)
	return get_by_id(type, id)

