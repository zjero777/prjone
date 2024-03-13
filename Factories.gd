extends Node

signal factory_add(factory: Factory)

var count: int:
	get:
		return(get_child_count())
	set(val):
		return
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add(_type: int, _coord: Vector2i):
	var cells = get_node("../Cells_data")
	print_debug(cells.get_cell(_coord))
	if cells.get_cell(_coord).Buildings: 
		push_warning("Не могу установить здание, не помещается")
		return
	var factory: Factory = Factory.new()
	factory.setup(_type, _coord)
	factory.connect("factory_add", _on_factory_add)	
	add_child(factory)
	
	
	pass

func _on_factory_add(factory):
	emit_signal("factory_add", factory)
	#print_debug(factory)
