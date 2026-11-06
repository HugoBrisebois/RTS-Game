extends Camera2D

var mouse_position = Vector2.ZERO
var global_mouse_position = Vector2.ZERO

var start = Vector2.ZERO
var start_v = Vector2.ZERO
var end = Vector2.ZERO
var end_v = Vector2.ZERO
var is_dragging = false

func _draw_area():
	var panel = get_node("Panel")
	var size = Vector2(abs(start.x - end.x), abs(start.y - end.y))
	var position = Vector2(min(start.x, end.x), min(start.y, end.y))
	panel.size = size
	panel.position = position
	panel.visible = is_dragging

func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		global_mouse_position = get_global_mouse_position()

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		start = mouse_position
		start_v = mouse_position
		is_dragging = true

	if Input.is_action_just_released("left_click"):
		end = mouse_position
		is_dragging = false
		if start_v.distance_to(mouse_position) > 20:
			# Logic for selecting area goes here later
			pass
	else:
		_draw_area() # Pass false later to hide

	if is_dragging:
		end = mouse_position
		_draw_area()
