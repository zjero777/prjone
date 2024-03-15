extends Node2D

var Ground: TileMap
@onready var factories = $Factories
@onready var bots = $Bots

func _init():
	Ground = TileMap.new()
	Ground.name = "Ground"
	var ground_script = load("res://script/ground.gd")
	Ground.set_script(ground_script)
	add_child(Ground)
	
func create_new_map():
	randomize()
	# generate terrain
	
	# test set factory
	factories.add(18, Vector2i(10,10))
	factories.add(4, Vector2i(4,3))
	factories.add(1, Vector2i(1,6))
	factories.add(1, Vector2i(3,6))
	
	bots.add(1, Vector2i(0,0))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	create_new_map()
	pass # Replace with function body.

	
func _shortcut_input(event):
	if event.is_action_pressed("save"): 
		save_game()
		
		
	if event.is_action("load"):
		load_game()


func save_game():
	#Ground
	#ResourceSaver.save(Ground, "tile_map.tres")
	pass
	
func load_game():
	pass
