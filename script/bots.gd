extends Node

signal bot_add(bot: Bot)


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
	#print_debug(cells.get_cell(_coord))
	if cells.get_cell(_coord).Buildings: 
		push_warning("Не могу установить бота, не помещается")
		return
	var bot = preload("res://scene/bot.tscn").instantiate()
	#var bot: Bot = Bot.new()
	bot.setup(_type, _coord)
	bot.connect("bot_add", _on_bot_add)	
	add_child(bot)
	
	
	pass

func _on_bot_add(bot):
	emit_signal("bot_add", bot)
	#print_debug(factory)

func order(bot_id: int, command, data):
	var bot = get_child(bot_id)
	if command=="move":
		bot.move(data)
		pass
	pass
