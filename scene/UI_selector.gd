extends ReferenceRect

var selection
var hover

@onready var info =  $"../CanvasLayer/Info"

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	var Ground = $/root/Main/Ground
	Ground.connect("update_select_info", _on_update_select_info)
	Ground.connect("update_hover_info", _on_update_hover_info)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hover:
		if hover.Buildings:
			info.update_building_info(hover)
	
	if not selection: return
	
	if selection.Buildings:
		info.update_building_info(selection)
	
	pass

func _on_update_hover_info(mouse_hover_tile, cell):
	if visible: 
		hover = null
		return
	hover = cell
	

func _on_update_select_info(tilemap, cell):
	if not cell:
		if visible:
			hide()
			selection = null
		return

	
	var select_pos = Vector2i(tilemap.map_to_local(cell.Buildings.coord))-Vector2i(Global.tile_size/2)
	var select_size = cell.Buildings.size*Global.tile_size
	set_position(select_pos)
	set_size(select_size)
	show()
	selection = cell
	
