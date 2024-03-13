class_name Bot
extends CharacterBody2D

signal bot_add(bot: Bot)

var type: String = ""
var coord: Vector2i = Vector2i.ZERO
var name_bot = ""
var astar: AStarGrid2D
var ground: TileMap
var path: PackedVector2Array

func setup(_type: int, _coord: Vector2i):
	#generate name
	name_bot = "bot%05d" % randi_range(0, 9999)
	coord = _coord
	type = str(_type)
	
	
	#var data = Data.get_by_id("factory_type", type)


# Called when the node enters the scene tree for the first time.
func _ready():
	#var factories = get_node("..")
	astar = get_node("/root/Main/Cells_data").astar
	ground = get_node("/root/Main/Ground")
	emit_signal("bot_add", self)
	

func _process(delta):
	if path.is_empty(): return
	var target_pos = ground.map_to_local(path[0])
	global_position = global_position.move_toward(target_pos, 3)
	if global_position==target_pos:
		path.remove_at(0)
		coord = ground.local_to_map(target_pos)
	pass

func move(to_coord: Vector2i):
	path = astar.get_id_path(coord, to_coord).slice(1)
	pass
