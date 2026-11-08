extends Node2D

@onready var camera: RTSCamera = $Camera2D

# preload the pawn unit scene
const UNIT_SCENE = preload("res://scenes/unit.tscn")

func _ready() -> void:
	if camera:
		camera.selection_completed.connect(_on_camera_selection_completed)
		print("RTSCamera successfully connected at root path!")
	else:
		printerr("Error: RTSCamera node could not be found at $Camera2D!")

func _unhandled_input(event: InputEvent) -> void:
	# Listen for right-click to command selected units to move
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_command_selected_units_to_move()

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	var selected_units = []
	
	for node in get_tree().get_nodes_in_group("Unit"):
		if node is Unit:
			if world_rect.has_point(node.global_position):
				node.set_selected(true)
				selected_units.append(node)
			else:
				node.set_selected(false)
				
	print("Selected units count: ", selected_units.size())

func _command_selected_units_to_move() -> void:
	# Convert current mouse screen position into world space using the camera's canvas transform
	var xform = camera.get_canvas_transform().affine_inverse()
	var click_world_pos = xform * camera.get_viewport().get_mouse_position()

	var moving_count = 0
	for node in get_tree().get_nodes_in_group("Unit"):
		if node is Unit and node.is_selected:
			node.move_to(click_world_pos)
			moving_count += 1
			
	if moving_count > 0:
		print("Commanded ", moving_count, " unit(s) to move to: ", click_world_pos)

func _process(delta: float) -> void:
	pass
