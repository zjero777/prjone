class_name Store

var cells = {}
var count: int
const _empty_cell = {"available": null, "reserve": null}

func _init(_cell_count: int):
	#for i in cell_count:
		#var item = Item.new()
		#var reserve = Reserve.new()
	cells = {}
	count = _cell_count
	pass

func verify_reserve_items(reserve_operation, items: Array) -> Error:
	# резерв на прибывание ресурса
	if reserve_operation==Global.inc_reserve_operation:
		pass

	# резерв на убывание ресурса
	if reserve_operation==Global.dec_reserve_operation:
		# найти предмет в нужной ячейке	
		for item in items:
			if cells.has(item.resource.id): 
				continue
			else: 
				return(ERR_CANT_ACQUIRE_RESOURCE)
		return(OK)
		
	pass
	return(OK)
	pass

func set_reserve_items(reserve_operation, items: Array, source: Vector2i, destination: Vector2i):
	# резерв на прибывание ресурса
	if reserve_operation==Global.inc_reserve_operation:
		for item: Item in items:
			if not cells.has(item.resource.id):
				cells[item.resource.id] = _empty_cell.duplicate()
			cells[item.resource.id].reserve = Reserve.new(item, source, destination)
		pass

	# резерв на убывание ресурса
	if reserve_operation==Global.dec_reserve_operation:
	# уменьшить его на количество предметов
	# создать объект резерв в этой ячейке
		pass

	pass	
	
	
func cancel_reserve(item: Item, source: Vector2i, destination: Vector2i):
	pass
	
func remove_reserve(item: Item, source: Vector2i, destination: Vector2i):
	pass
	

