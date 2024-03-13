class_name Cells_data

extends Node

#{terrain - tile_info, resource: Resource; block - tile_info, count; building - tile_info, building: Building}


var dict
var cell_data_null = {}
var astar = AStarGrid2D.new()

func get_cell(key: Vector2i): 
	if dict.has(key):
		return dict[key]
	else: 
		return cell_data_null.duplicate()
	

func _init():
	dict = {}
	for i in Global.tile_layers:
		cell_data_null.merge({i: null})
	cell_data_null.merge({"Bots": null})
	
	
	astar.region = Rect2i(Vector2i.ZERO, Global.world_size)
	astar.cell_size = Global.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	return
	
	
func inspect(coord: Vector2i):
	#print_debug(Vector2i(0,0))
	if dict.has(coord):
		return(dict[coord])
	else: 
		return cell_data_null
	

func update(tile_map: TileMap):
	for layer in Global.tile_layers:
		var used_cells = tile_map.get_used_cells(Global.tile_layers[layer])
		var cell_data = {}
		for cell in used_cells:
			cell_data = get_cell(cell)
			# get info from tile and save
			var tile_info: TileData = tile_map.get_cell_tile_data(Global.tile_layers[layer], cell)
			#var atlas_cell_id: Vector2i = tile_map.get_cell_atlas_coords(Global.tile_layers[layer], cell)
			var data
			if Global.tile_layers[layer]==Global.tile_layers.Terrain:
				data = {"tile_info": tile_info, "resource": {"id": -1 , "count": 0}}
				var terrain_id: int = int(data.tile_info.get_custom_data("id"))
				if terrain_id==0 or terrain_id==1 or terrain_id==3 or \
				terrain_id==5 or terrain_id==6:
					astar.set_point_solid(cell)
			if Global.tile_layers[layer]==Global.tile_layers.Blocks:
				data = {"tile_info": tile_info, "count": 1}
			if Global.tile_layers[layer]==Global.tile_layers.Buildings:
				_add_building(tile_map, layer, cell)
				
			if data:
				cell_data[layer] = data.duplicate()
				dict[cell] = cell_data
				
				


func _add_building(tile_map, layer, cell, building=null):
	var cell_data = get_cell(cell)
	var tile_info: TileData = tile_map.get_cell_tile_data(Global.tile_layers[layer], cell)
	var tile_source_id: int = tile_map.get_cell_source_id(Global.tile_layers[layer], cell)
	var tile_source: TileSetAtlasSource = tile_map.tile_set.get_source(tile_source_id)
	var atlas_cell_id: Vector2i = tile_map.get_cell_atlas_coords(Global.tile_layers[layer], cell)
	#add_on_size(cell, data)
	var size: Vector2i = tile_source.get_tile_size_in_atlas(atlas_cell_id)
	#var building = find(cell)
	var data = {
		"tile_info": tile_info, 
		"building": building, 
		"id": atlas_cell_id, 
		"coord": cell,
		"size": size
	}
	for y in range(size.y):
		for x in range(size.x):
			if x==0 and y==0: continue
			var new_cell = Vector2i(cell.x+x, cell.y+y)
			cell_data = get_cell(new_cell)
			cell_data[layer] = data.duplicate()
			dict[new_cell] = cell_data
			astar.set_point_solid(new_cell)
	
	cell_data[layer] = data.duplicate()
	dict[cell] = cell_data
	astar.set_point_solid(cell)

func _add_bot(tile_map: TileMap, bot: Bot):
	var local_coord = tile_map.map_to_local(bot.coord)
	bot.position = local_coord
	
	var cell_data = get_cell(bot.coord)
	var data = {
		"bot": bot
		#"local_coord": local_coord
	}
	cell_data.Bots = data.duplicate()
	dict[bot.coord] = cell_data
	
	

