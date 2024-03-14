extends Camera2D

# control
@export var SPEED = 30.0
@export var ZOOM_SPEED = 40.0
@export var ZOOM_MARGIN = 0.1
@export var ZOOM_MIN = 1
@export var ZOOM_MAX = 3

var zoom_pos = Vector2()
var zoom_factor = 1.0

var mouse_start_pos 
var screen_start_position
var dragging


# Called when the node enters the scene tree for the first time.
func _ready():
	#position = Vector2(Global.world_w*16 / 2, Global.world_h*16 / 2)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_x = int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"))
	var input_y = int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
	position.x = lerp(position.x, position.x+input_x*SPEED/zoom.x, SPEED*delta)
	position.y = lerp(position.y, position.y+input_y*SPEED/zoom.y, SPEED*delta)
	
	zoom.x = lerp(zoom.x, zoom.x*zoom_factor, ZOOM_SPEED*delta)
	zoom.y = lerp(zoom.y, zoom.y*zoom_factor, ZOOM_SPEED*delta)
	zoom.x = clamp(zoom.x, ZOOM_MIN, ZOOM_MAX)
	zoom.y = clamp(zoom.y, ZOOM_MIN, ZOOM_MAX)

	if abs(zoom_pos.x - get_global_mouse_position().x) > ZOOM_MARGIN:
		zoom_factor = 1.0
	if abs(zoom_pos.y - get_global_mouse_position().y) > ZOOM_MARGIN:
		zoom_factor = 1.0
	
func _input(event):
	
	if event.is_action_pressed("Zoom+"):
		zoom_factor += 0.1
		zoom_pos = get_global_mouse_position()
	
	if event.is_action_pressed("Zoom-"):
		zoom_factor -= 0.1
		zoom_pos = get_global_mouse_position()
			
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = (1.0/zoom.x) * (mouse_start_pos - event.position) + screen_start_position 

