class_name Labor
extends Object


var factory: Factory
var idle: bool
var work: bool: 
	get:
		
		if work and Time.get_ticks_msec()-start_time>factory.recipe.work_time*1000:
			complete = true
			work = false
		return work
		
var complete: bool

var time
var start_time

func _init(_factory: Factory):
	factory = _factory 
	
	idle = true
	work = false
	complete = false
	pass

func start():
	idle = false
	work = true
	start_time = Time.get_ticks_msec()
	pass
	
func stop():
	complete = false
	idle = true
	pass

func set_res_items(recipe) -> Error:
	#var res_in = _res_in.duplicate(true)
	#var res_out = _res_out.duplicate(true)
	var in_result
	var out_result
	if recipe.res_in.size()==0: 
		in_result=OK
	else:
		in_result = factory.port_in.verify_reserve_items(Global.dec_reserve_operation, recipe.res_in)
	if recipe.res_out.size()==0: 
		out_result=OK
	else:
		out_result = factory.port_out.verify_reserve_items(Global.inc_reserve_operation, recipe.res_out)

	if in_result != OK: return(in_result)
	if out_result != OK: return(out_result)
	
	if factory.port_in:
		factory.port_in.set_reserve_items(Global.dec_reserve_operation, recipe.res_in, factory.coord, factory.coord)
		
	if factory.port_out:
		factory.port_out.set_reserve_items(Global.inc_reserve_operation, recipe.res_out, factory.coord, factory.coord)

	return(OK)
	
func get_res_items():
	if factory.port_in:
		factory.port_in.remove_reserve(factory.coord, factory.coord)
		
	if factory.port_out:
		factory.port_out.create_items_from_reserve(factory.coord, factory.coord)
	
	pass
	


