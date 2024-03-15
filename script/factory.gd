class_name Factory
extends Node

signal factory_add(factory: Factory)

var type: String = ""
var coord: Vector2i = Vector2i.ZERO
var name_building = ""
var demolition: int
var efficiency: float
var recipe: Recipe = Recipe.new()


func setup(_type: int, _coord: Vector2i):
	coord = _coord
	type = str(_type)
	var data = Data.get_by_id("factory_type", type)
	#generate name
	name_building = data.name+"%05d" % randi_range(0, 9999)
	demolition = data.demolition
	efficiency = data.efficiency
	#set recept
	recipe.select(data.use_recipes.selected_id)


# Called when the node enters the scene tree for the first time.
func _ready():
	#var factories = get_node("..")
	emit_signal("factory_add", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
