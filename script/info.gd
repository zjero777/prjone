extends PanelContainer

var Ground: TileMap
var cells_data: Cells_data

var UI_terrain
var UI_terrain_view
var UI_terrain_expected
var UI_terrain_working

var UI_terrain_pic
var UI_terrain_name
var UI_coord
var UI_terrain_res_bar
var UI_terrain_working_count


var UI_block
var UI_block_view
var UI_block_expected
var UI_block_working

var UI_block_pic
var UI_block_name
var UI_block_res_bar
var UI_block_working_count

var UI_building
var UI_building_view
var UI_building_pic
var UI_building_name
var UI_building_demolition
var UI_building_eff

var UI_recipe
var UI_recipe_name
var UI_recipe_pic
var UI_in_res
var UI_out_res

var last_coord: Vector2i = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Ground = $/root/Main/Ground
	cells_data = $/root/Main/Cells_data
	
	UI_terrain = find_child("Terrain")
	UI_terrain_view = find_child("Terraon_View")
	UI_terrain_pic = find_child("t_pic")
	UI_terrain_name = find_child("t_name")
	UI_coord = find_child("coord")
	UI_terrain_expected = find_child("Expected") 
	UI_terrain_res_bar = find_child("UI_Res_bar")
	UI_terrain_working = find_child("Working")
	UI_terrain_working_count = find_child("t_count")

	UI_block = find_child("Block")
	UI_block_view = find_child("Block_View")
	UI_block_pic = find_child("b_pic")
	UI_block_name = find_child("b_name")
	UI_block_expected = find_child("Expected") 
	#UI_block_res_bar = find_child("UI_Res_bar")
	#UI_block_working = find_child("Working")
	#UI_block_working_count = find_child("t_count")

	UI_building = find_child("Building")
	UI_building_view = find_child("Building_View")
	UI_building_pic = find_child("bl_pic")
	UI_building_name = find_child("bl_name")
	UI_building_eff = find_child("bl_eff")
	UI_building_demolition = find_child("bl_count")

	UI_recipe = find_child("Recipe")
	UI_recipe_name = find_child("recipe_name")
	UI_recipe_pic = find_child("recipe_pic") 
	UI_in_res = find_child("UI_in_res")
	UI_out_res = find_child("UI_out_res")
	
	#get_node("/root/Main/UI/CanvasLayer/UI_Ground")
	Ground.connect("update_hover_info", _on_update_hover_info)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func hide_info():
	UI_terrain.hide()
	UI_block.hide()
	UI_building.hide()
	UI_recipe.hide()
	

func  _unhandled_key_input(event):
	if event.is_action("down") or event.is_action("left") or event.is_action("right") or event.is_action("up"):
		hide_info()
func _gui_input(event):
	#print_debug(_event)
	hide_info()	

func _shortcut_input(event):
	#print_debug(event)
	
	#if event.is_action("down") or event.is_action("left") or event.is_action("right") or event.is_action("up"):
		#get_tree().get_root().set_input_as_handled()
	pass
func set_info_view(rootUI: Control, mode):
# rootUI:set node, mode: (0-all cildren view 1-root only 3-hide)
	rootUI.show()
	if mode==0:
		for node in rootUI.get_children():
			node.show()
	elif mode==1:
		rootUI.get_children()[0].show()
		for node_i in range(1,rootUI.get_child_count()):
			rootUI.get_children()[node_i].hide()
	else:
		rootUI.hide()

func _on_update_hover_info(mouse_hover_tile, cell):
	
	if Vector2i(mouse_hover_tile)==last_coord: return
	last_coord = mouse_hover_tile
	#print_debug(get_rect(), get_global_mouse_position(), get_rect().has_point(get_global_mouse_position()))
	#if get_rect().has_point(get_global_mouse_position()):
		#UI_terrain.hide()
		#return
	var tile
	
	#print_debug(cell)
	if cell.Bots:
		
		pass
	
	if cell.Buildings:
		
		set_info_view(UI_building,0)
		tile = cell.Buildings.tile_info
		var id = tile.get_custom_data("id")
		var building: Factory = cell.Buildings.building
		
		UI_building_name.text = building.name_building
		UI_building_pic.texture = tile.get_custom_data("texture")
		UI_building_demolition.text = str(building.demolition) + " сек."
		UI_building_eff.text = str(building.efficiency)
		
		if building.recipe:
			UI_recipe.show()
			var recipe: Recipe = building.recipe
			UI_recipe_name.text = recipe.recipe_name
			UI_recipe_pic.texture = recipe.pic
			if recipe.res_in.size()>0:
				generate_res_info_obj(UI_in_res, recipe.res_in)
				UI_in_res.show()
			else:
				UI_in_res.hide()
			if recipe.res_out.size()>0:
				generate_res_info_obj(UI_out_res, recipe.res_out)
				UI_out_res.show()
			else:
				UI_out_res.hide()
		else:
			UI_recipe.hide()

		
	else:
		set_info_view(UI_building,2)


	if cell.Blocks:
		
		if 	cell.Buildings:
			set_info_view(UI_block,1)
		else:
			set_info_view(UI_block,0)

		tile = cell.Blocks.tile_info
		var _type = "block_type"
		UI_block_name.text = tile.get_custom_data("name")
		UI_block_pic.texture = tile.get_custom_data("texture") 
	else:
		set_info_view(UI_block,2)



	if cell.Terrain:
		if 	cell.Blocks:
			set_info_view(UI_terrain,1)
		else:
			set_info_view(UI_terrain,0)
		
		tile = cell.Terrain.tile_info
		var id = tile.get_custom_data("id")
		var type = "terrain_type"
		var data = Data.get_by_id(type, id)
		
		UI_terrain_name.text = tile.get_custom_data("name")
		UI_terrain_pic.texture = tile.get_custom_data("texture") #Data.get_texture_by_name(type, terrain_name)
		UI_coord.text = type_convert(mouse_hover_tile, TYPE_STRING)
		var item_list = Global.get_expected_res_list(data)
		if item_list.size(): 
			Ground.generate_expected_res_info(UI_terrain_res_bar, item_list)
			UI_terrain_working_count.text = str(data.dig.time)+" сек."
		else:
			UI_terrain_expected.hide()
			UI_terrain_working.hide()
	else:
		UI_terrain_name.text = "hyperspace"
		UI_terrain_pic.texture = Ground.get_texture_by_name("terrain_type", "hyperspace")
		UI_coord.text = "(???, ???)"
		UI_terrain.show()
		UI_terrain_expected.hide()
		UI_terrain_working.hide()

func generate_res_info_obj(UI_Container, items: Array):
	# create and hide info scene piture game ressource (pic+text)
	if UI_Container.get_child_count()<items.size():
		for i in range(items.size()):
			var res16 = preload("res://scene/pic16.tscn").instantiate()
			res16.hide()
			UI_Container.add_child(res16)
		pass
	
	for ui_pic in UI_Container.get_children():
		ui_pic.hide()
	
	for i in items.size():
		var ui_pic = UI_Container.get_child(i)
		ui_pic.texture = items[i].resource.pic
		var ui_label: Label = ui_pic.get_child(0)
		ui_label.text = str(items[i].count)
		ui_pic.show()

