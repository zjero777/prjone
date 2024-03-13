extends Control


var select_tile = null

#var UI_Info
var UI_Cursor

var Ground: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	UI_Cursor = get_node("/root/Main/UI/Cursor/")

	
func _draw():
	if select_tile:
		UI_Cursor.position = Vector2(select_tile.x*64,  select_tile.y*64)
		UI_Cursor.size = Vector2(64,64)

func _gui_input(event):
	print_debug(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if select_tile:
		pass
#		var select_posi = floor(select_pos / 4)
		#var cell = World.Cells[select_pos.x][select_pos.y]
		#lb_coord.text = "("+str(select_pos.x)+","+str(select_pos.y)+")"	
		#lb_water.text = str(snapped(cell.water,0.001))
		#lb_mineral.text = str(snapped(cell.mineral,0.001))
		#lb_air.text = str(snapped(cell.air,0.001))
		#lb_organic.text = str(snapped(cell.organic,0.001))
		#lb_mass.text = str(snapped(cell.mass,1))


#func _ui_input(event):
	#print_debug(event.as_text())
	#pass
	#
#func _shortcut_input(event):
	#print_debug(event.as_text())
	#pass
