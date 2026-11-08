extends Node2D

@onready var camera: RTSCamera = $Camera2D
@onready var units_container: Node2D = $UnitsContainer
@onready var buildings_container: Node2D = $BuildingsContainer

# Ensure these match your actual folder structure (e.g., res://unit.tscn or res://scenes/unit.tscn)
const UNIT_SCENE = preload("res://scenes/Unit.tscn")
const BUILDING_SCENE = preload("res://scenes/Building.tscn")

func _ready() -> void:
	if camera:
		camera.selection_completed.connect(_on_camera_selection_completed)
	else:
		printerr("Error: RTSCamera node could not be found at $Camera2D!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_command_selected_units_to_move()

	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_spawn_unit_at_mouse()

	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		_spawn_building_at_mouse()

func _spawn_unit_at_mouse() -> void:
	var new_unit = UNIT_SCENE.instantiate() as Unit
	if not new_unit:
		return

	var xform = camera.get_canvas_transform().affine_inverse()
	var spawn_pos = xform * camera.get_viewport().get_mouse_position()
	
	if units_container:
		units_container.add_child(new_unit)
	else:
		get_tree().current_scene.add_child(new_unit)
		
	new_unit.global_position = spawn_pos

func _spawn_building_at_mouse() -> void:
	var new_building = BUILDING_SCENE.instantiate()
	if not new_building:
		return

	var xform = camera.get_canvas_transform().affine_inverse()
	var spawn_pos = xform * camera.get_viewport().get_mouse_position()
	
	if buildings_container:
		buildings_container.add_child(new_building)
	else:
		get_tree().current_scene.add_child(new_building)
		
	new_building.global_position = spawn_pos

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	for unit_node in get_tree().get_nodes_in_group("Unit"):
		if unit_node is Unit:
			if world_rect.has_point(unit_node.global_position):
				unit_node.set_selected(true)
			else:
				unit_node.set_selected(false)

func _command_selected_units_to_move() -> void:
	var xform = camera.get_canvas_transform().affine_inverse()
	var click_world_pos = xform * camera.get_viewport().get_mouse_position()

	# Point query to check if a building was clicked
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = click_world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = space_state.intersect_point(query)
	var target_building = null
	
	for result in results:
		var collider = result.collider
		if collider is Building:
			target_building = collider
			break
		elif collider.owner is Building:
			target_building = collider.owner
			break

	if target_building:
		for unit_node in get_tree().get_nodes_in_group("Unit"):
			if unit_node is Unit and unit_node.is_selected:
				unit_node.move_to(target_building.global_position)
	else:
		for unit_node in get_tree().get_nodes_in_group("Unit"):
			if unit_node is Unit and unit_node.is_selected:
				unit_node.move_to(click_world_pos)
