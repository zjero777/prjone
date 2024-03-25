class_name Factory
extends Node

signal factory_add(factory: Factory)

var type: String = ""
var coord: Vector2i = Vector2i.ZERO
var name_building = ""
var demolition: int
var efficiency: float
var recipe: Recipe = Recipe.new()
var port_in: Store
var port_out: Store
#var is_working: bool #factory process work state, overwise idle state
var labor: Labor

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
	labor = Labor.new(self)
	if recipe.res_in.size()>0:
		port_in = Store.new(recipe.res_in.size())
		
	if recipe.res_out.size()>0:
		port_out = Store.new(recipe.res_out.size())
	


# Called when the node enters the scene tree for the first time.
func _ready():
	#var factories = get_node("..")
	emit_signal("factory_add", self)


func _physics_process(delta):
	if labor.work: return
	if labor.idle:
		#reserve in res
		var result = labor.set_res_items(recipe.res_in, recipe.res_out)
		if result == OK:
			labor.start()
			#emit_signal("store_update", self)
		if result == ERR_CANT_ACQUIRE_RESOURCE:
			#set request (coord, res)
			#push_error("no_in_res", recipe.res_in)
			pass
		if result == ERR_LOCKED:
			#push_error("no_out_space", recipe.res_out)
			pass
	if labor.complete:
		# set provider (coord, res)
		labor.get_res_items(recipe.res_in, recipe.res_out)
		#emit_signal("store_update", self)
		labor.stop()
	pass
