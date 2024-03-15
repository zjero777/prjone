extends TileMap

signal update_hover_info(coord, cell_data)

var s_building = Global.source_tile.Buildings 
var s_blocl = Global.source_tile.Blocks 
var s_terrain = Global.source_tile.Terrain

var l_building = Global.tile_layers.Buildings 
var l_blocl = Global.tile_layers.Blocks 
var l_terrain = Global.tile_layers.Terrain 

var mouse_hover_tile = null
var cells: Cells_data
@onready var factories = get_node("/root/Main/Factories")
@onready var bots = get_node("/root/Main/Bots")


func _init():
	#create layers
	remove_layer(0)
	for layer in Global.tile_layers:
		add_layer(Global.tile_layers[layer])
		set_layer_name(Global.tile_layers[layer], layer)
	# create atlas from files
	tile_set = TileSet.new()
	tile_set.tile_size = Vector2i(64,64)

	# create custom data layer
	tile_set.add_custom_data_layer()
	tile_set.add_custom_data_layer()
	tile_set.add_custom_data_layer()
	tile_set.set_custom_data_layer_name(0, "name")
	tile_set.set_custom_data_layer_type(0, TYPE_STRING) 
	tile_set.set_custom_data_layer_name(1, "id")
	tile_set.set_custom_data_layer_type(1, TYPE_INT) 
	tile_set.set_custom_data_layer_name(2, "texture")
	tile_set.set_custom_data_layer_type(2, TYPE_OBJECT) 

	#generate sources by data
	#id_source, data_key, path to images

	

func _ready():
	add_to_tileset(0, Data.data.terrain_type, "res://img/terrains")
	add_to_tileset(1, Data.data.block_type, "res://img/blocks")
	add_to_tileset(2, Data.data.factory_type, "res://img/buildings")

		
	for i in range(Global.world_size.x):
		for j in range(Global.world_size.y):
			set_cell(l_terrain, Vector2i(i,j), s_terrain, Vector2i(2,0))
		
	var count: int
# space
	count = roundi(Global.world_size.y*Global.world_size.y / 200.0)
	for i in range(count):
		var rand_x = randi_range(0, Global.world_size.x-1)
		var rand_y = randi_range(0, Global.world_size.y-1)
		set_cell(l_terrain,Vector2i(rand_x,rand_y), s_terrain, Vector2i(0,0))

# sand
	count = roundi(Global.world_size.y*Global.world_size.y / 7.0) #67
	for i in range(count):
		var rand_x = randi_range(0, Global.world_size.x-1)
		var rand_y = randi_range(0, Global.world_size.y-1)
		set_cell(l_terrain,Vector2i(rand_x,rand_y), s_terrain, Vector2i(4,0))

# water
	count = roundi(Global.world_size.y*Global.world_size.y / 50.0)
	for i in range(count):
		var rand_x = randi_range(0, Global.world_size.x-1)
		var rand_y = randi_range(0, Global.world_size.y-1)
		set_cell(l_terrain,Vector2i(rand_x,rand_y), s_terrain, Vector2i(6,0))
		
# stone
	count = roundi(Global.world_size.y*Global.world_size.y / 400.0)
	for i in range(count):
		var rand_x = randi_range(0, Global.world_size.x-1)
		var rand_y = randi_range(0, Global.world_size.y-1)
		set_cell(Global.tile_layers.Blocks,Vector2i(rand_x,rand_y), Global.source_tile.Blocks, Vector2i(6,0))
#
	set_cell(Global.tile_layers.Blocks, Vector2i(0,0), Global.source_tile.Blocks, Vector2i(6,0))
	
	var res_id = Data.get_id_by_name("terrain_type", "pit")
	set_cell(l_terrain,Vector2i(1,0), s_terrain, Vector2i(int(res_id),0))
	
	cells = get_node("/root/Main/Cells_data")
	cells.update(self)
	
	factories.connect("factory_add", _on_factory_add)
	bots.connect("bot_add", _on_bot_add)
	
	pass
	
	
func get_tile(source_id, tile_custom_id: int):
	var tile_source = tile_set.get_source(source_id)
	return tile_source.get_tile_id(tile_custom_id)

func _unhandled_input(event):
	#print_debug("tile", event.as_text())

	if event is InputEventMouse:
		mouse_hover_tile = floor(get_global_mouse_position() / 64)
		#{terrain - tile_info, resource: Resource; block - tile_info, count; building - tile_info, building: Building}
		#print_debug(mouse_hover_tile)
		var cell = cells.inspect(mouse_hover_tile) 
		#if cell:
		emit_signal("update_hover_info", mouse_hover_tile, cell)
		
	

	if event.is_action_pressed("select"):
		#print_debug(mouse_hover_tile)
		bots.order(0, "move", mouse_hover_tile)
		pass
		
	if event.is_action_pressed("clear_selection"):
		pass
	
	
func get_texture_by_id(type, id: int):
	var layer = Data.get_id_by_type(type)
	var tile_source: TileSetAtlasSource = tile_set.get_source(layer)
	var tile = tile_source.get_tile_id(id)
	var tile_data: TileData = tile_source.get_tile_data(tile, 0)
	return tile_data.get_custom_data("texture")
	
	
func get_texture_by_name(type, name_res):
	var res_id = Data.get_id_by_name(type, name_res)
	return get_texture_by_id(type, res_id)

func generate_expected_res_info(UI_Container, item_list):
	# create and hide info scene piture game ressource (pic+text)
	if UI_Container.get_child_count()<item_list.size():
		for i in range(item_list.size()):
			var res16 = preload("res://scene/pic16.tscn").instantiate()
			res16.visible = false
			UI_Container.add_child(res16)
	
	for ui_pic in UI_Container.get_children():
		ui_pic.visible = false
	
	#var i = 0
	for i in item_list.size():
		var ui_pic = UI_Container.get_child(i)
		var loot_texture = get_texture_by_id("block_type", item_list[i].id)
		ui_pic.texture = loot_texture
		var ui_label: Label = ui_pic.get_child(0)
		ui_label.text = str(item_list[i].count)
		ui_pic.show()
		#i += 1

func add_size_left(size_square, new_add_square):
	return(Vector2i(size_square.x+new_add_square.x, max(size_square.y, new_add_square.y)))

func add_to_tileset(source_id, list, dir):
#tile_set, id source, data_key, directory	
	
	#var tile_source: TileSetAtlasSource = tile_set.get_source(source_id)

	var tile_source: TileSetAtlasSource = TileSetAtlasSource.new()
	tile_set.add_source(tile_source, source_id)
	#tile_source.resource_name = datakey

	# create image from files directory
	var dynImage: Image = Image.create(64,64,false,Image.FORMAT_RGBA8)
	var tile_position = Vector2i(0, 0)
	var item
	var dim: Vector2i
	var dim_temp
	
	var atlas = {"tile_size": Vector2i(0,0), "items": []}
	# add pic to texture
	for i in list:
		#calc atlas texure and pos
		item = list[i]
		dim_temp = item.get("dim")
		if dim_temp:
			dim = Vector2i(dim_temp.w, dim_temp.h)
		else:
			dim = Vector2i(1,1)
		
		atlas.tile_size = add_size_left(atlas.tile_size, dim)
		atlas.items.append({"pos": tile_position, "dim_tile": dim, "texture": null})
		tile_position = Vector2i(tile_position.x + dim.x, tile_position.y)
		pass
	
	dynImage.crop(atlas.tile_size.x*64, atlas.tile_size.y*64)
	for i in list:
		item = list[i]
		#prepare texture from file 
		var file = dir+"/"+item.pic
		var pic: Texture2D = load(file)
		var image = pic.get_image()
		image.convert(Image.FORMAT_RGBA8)
		atlas.items[int(i)].texture = ImageTexture.create_from_image(image)
		dynImage.blit_rect(image, Rect2i(Vector2i.ZERO, atlas.items[int(i)].dim_tile*64), atlas.items[int(i)].pos*64)
		 
	tile_source.texture = ImageTexture.create_from_image(dynImage)
	tile_source.texture_region_size = Vector2i(64,64)

	var tile_size: Vector2i
	for i in list:
		item = list[i]

		tile_position = atlas.items[int(i)].pos
		tile_size = atlas.items[int(i)].dim_tile
		tile_source.create_tile(tile_position, tile_size)
		
		
		var tile_data: TileData = tile_source.get_tile_data(tile_position, 0)
		tile_data.texture_origin = Vector2i((1-tile_size.x)*32, (1-tile_size.y)*32)

		tile_data.set_custom_data("name", item.name)
		tile_data.set_custom_data("id", i)
		tile_data.set_custom_data("texture", atlas.items[int(i)].texture)

func save():
	
	
	
	var file = FileAccess.open(Global.SAVE_FILE_PATH, FileAccess.WRITE)
	if not file: 
		print_debug("Ошибка записи")
		return
		
	for layer in Global.tile_layers:
		var layer_id = Global.tile_layers[layer]
		var source_id = Global.source_tile[layer]
		var _tile_source = tile_set.get_source(source_id)
		var used_cells: Array[Vector2i] = get_used_cells(layer_id)
		for cell: Vector2i in used_cells:
			var tile_data = get_cell_tile_data(layer_id, cell)
			if tile_data:
				var custom_data = tile_data.get_custom_data("id")
				file.store_16(cell.x)
				file.store_16(cell.y)
				file.store_8(custom_data as int)
	file.close()

func load():
	pass
	
	
func _on_factory_add(factory: Factory):
	#print_debug(factory)
	set_cell(Global.tile_layers.Buildings, 
		factory.coord, 
		Global.source_tile.Buildings, 
		get_tile(Global.source_tile.Buildings, int(factory.type)))
	cells._add_building(self, "Buildings", factory.coord, factory)
	pass

func _on_bot_add(bot: Bot):
	#print_debug(factory)
	#set_cell(Global.tile_layers.Buildings, 
		#factory.coord, 
		#Global.source_tile.Buildings, 
		#get_tile(Global.source_tile.Buildings, int(factory.type)))
	
	cells._add_bot(self, bot)
	pass
