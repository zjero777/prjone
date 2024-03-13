extends Node

enum tile_type {Terrain, Blocks, Buildings}
enum tile_layers {Terrain, Blocks, Buildings}
enum source_tile {Terrain, Blocks, Buildings}

const img_directory = ["res://img/terrains", "res://img/blocks", "res://img/buildings"]
const SAVE_FILE_PATH = "res://save/save.dat"
const img_recept_directory = "res://img/recipes/"
const img_block_directory = "res://img/blocks/"

const world_size: Vector2i = Vector2i(100, 100)
const tile_size: Vector2i = Vector2i(64, 64)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_expected_res_list(item):
	if item.has("dig"):
		return item.dig.loot
	else:
		return []




