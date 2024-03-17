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

func verify_reserve_items(reserve_operation, recept_items: Array) -> Error:
	# резерв на прибывание ресурса
	if reserve_operation==Global.inc_reserve_operation:
		pass

	# резерв на убывание ресурса
	if reserve_operation==Global.dec_reserve_operation:
		# найти предмет в нужной ячейке	
		for recept_item in recept_items:
			if cells.has(recept_item.resource.id): 
				continue
			else: 
				return(ERR_CANT_ACQUIRE_RESOURCE)
		return(OK)
		
	pass
	return(OK)
	pass

func set_reserve_items(reserve_operation, recept_items: Array, source: Vector2i, destination: Vector2i):
	# резерв на прибывание ресурса
	if reserve_operation==Global.inc_reserve_operation:
		for recept_item: Item in recept_items:
			if not cells.has(recept_item.resource.id):
				cells[recept_item.resource.id] = _empty_cell.duplicate()
				cells[recept_item.resource.id].resource = recept_item.resource
			cells[recept_item.resource.id].reserve = Reserve.new(recept_item, source, destination)
		pass

	# резерв на убывание ресурса
	if reserve_operation==Global.dec_reserve_operation:
	# уменьшить его на количество предметов
	# создать объект резерв в этой ячейке
		pass

	pass	
	

#func get_reserve_items(reserve_operation, items: Array, source: Vector2i, destination: Vector2i):
#
	## резерв на прибывание ресурса
	#if reserve_operation==Global.inc_reserve_operation:
		#pass
#
	## резерв на убывание ресурса
	#if reserve_operation==Global.dec_reserve_operation:
		#pass
	
func cancel_reserve(reserve_operation, source: Vector2i, destination: Vector2i):
	## отмена резерва на прибывание ресурса. item фактически удаляется из склада
	if reserve_operation==Global.inc_reserve_operation:
		var items = 1
		for item: Item in items:
			if not cells.has(item.resource.id):
				cells[item.resource.id].reserve.queue_free()
		pass
#
	## отмена резерва на убывание ресурса, item фактически появляется на складе
	if reserve_operation==Global.dec_reserve_operation:
	
		for cell in cells:
			var reserve = cells[cell].reserve
			var key = reserve.get_key(source, destination)
			
			if reserve.dictonary.has(key):
				var res_item = reserve.dictonary[key]
				if cells[cell].available:
					cells[cell].available.count += res_item.count
				else:
					var item = Item.new()
					item.create(res_item.resource.id, res_item.count)
					cells[cell].available = item
				cells[cell].reserve.free()
				pass
			
		#for item: Item in items:
			#if not cells.has(item.resource.id):
				#cells[item.resource.id] = _empty_cell.duplicate()
			#cells[item.resource.id].reserve = Reserve.new(item, source, destination)		
		pass


	pass

	
func remove_reserve(source: Vector2i, destination: Vector2i):
	cancel_reserve(Global.inc_reserve_operation, source, destination)
	
func create_items_from_reserve(source: Vector2i, destination: Vector2i):
	cancel_reserve(Global.dec_reserve_operation, source, destination)
