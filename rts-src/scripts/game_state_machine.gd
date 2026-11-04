extends Node2D

var dragging := false
var start_pos := Vector2.ZERO # screen coordinates for drawing
var end_pos := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	# Left click selection
	if event.is_action_pressed("select"):
		dragging = true
		start_pos = get_viewport().get_mouse_position()
		end_pos = start_pos
		
	if event is InputEventMouseMotion and dragging:
		end_pos = get_viewport().get_mouse_position()
		queue_redraw() # tells Godot to run the _draw function
	if event.is_action_released("select") and dragging:
		dragging = false
		queue_redraw()
		determine_selection()
	
	# Right Click command to move units
	if event.is_action_pressed("right_click"):
		var target_destination := get_global_mouse_position()
		print("commanding units to move to world coordinates: ", target_destination)
		
		# TODO: add unit movement
		
		

func _draw() -> void:
	# draws slection box on screen relative to the camea
	if dragging:
		# Must account for the camera position
		var cam_offset := get_viewport().get_camera_2d().get_screen_center_position() - (get_viewport().get_visible_rect().size / 2)
		var box_start := start_pos + cam_offset
		var box_end := end_pos + cam_offset
		
		draw_rect(Rect2(box_start, box_end - box_start), Color(0, 1, 0, 0.15), true)
		draw_rect(Rect2(box_start, box_end - box_start), Color(0, 1, 0, 0.8), false,1.5)

func determine_selection() -> void:
	var start_world := get_global_mouse_position()
	if start_pos.distance_to(end_pos) <5 :
		print("single unit clicked at world coordinates: ", start_world)
		# TODO: add a full unit selection method
	else:
		print("Box selection released")
