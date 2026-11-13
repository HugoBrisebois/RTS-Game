extends Node2D

@onready var camera: RTSCamera = $Camera2D
<<<<<<< HEAD
@onready var units_container: Node = $Unit_container
@onready var buildings_container: Node = $building_container
@onready var HUD: CanvasLayer = $UI
=======
@onready var units_container: Node2D = $UnitsContainer
@onready var buildings_container: Node2D = $BuildingsContainer
<<<<<<< HEAD
>>>>>>> parent of f719ec9 (made the ui menu for the building display)
=======
>>>>>>> parent of f719ec9 (made the ui menu for the building display)

# expose variables so that in the inspector so i can drag and drop the building placeholder scene and same for the placeholder unit scene
@export var unit_scene: PackedScene
@export var building_scene: PackedScene

func _ready() -> void:
	if camera:
		camera.selection_completed.connect(_on_camera_selection_completed)
		print("GameStateManager: Camera connected successfully.")
	else:
		printerr("Error: RTSCamera node could not be found at $Camera2D!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_command_selected_units_to_move()

	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_E:
			print("Key E pressed: Attempting to spawn unit...")
			_spawn_unit_at_mouse()
		elif event.physical_keycode == KEY_B:
			print("Key B pressed: Attempting to spawn building...")
			_spawn_building_at_mouse()

func _spawn_unit_at_mouse() -> void:
	if not unit_scene:
		printerr("CRITICAL ERROR: unit_scene is not assigned in the inspector!")
		return
	
	var new_unit = unit_scene.instantiate() as Unit
	if not new_unit:
		printerr("ERROR: Failed to instantiate unit scene")
		return
	
	var xform = camera.get_canvas_transform().affine_inverse()
	var spawn_pos = xform * camera.get_viewport().get_mouse_position()
	
	if units_container:
		units_container.add_child(new_unit)
	else:
		get_tree().current_scene.add_child(new_unit)

	new_unit.global_position = spawn_pos
	print("Success: Unit spawned at world position: ", spawn_pos)


func _spawn_building_at_mouse() -> void:
	if not building_scene:
		printerr("CRITICAL ERROR: building_scene is ot assigned in the inspector")
		return
	
	var new_building = building_scene.instantiate()
	if not new_building:
		printerr("ERROR: failed to instantiate building scene")
		return
	
	var xform = camera.get_canvas_transform().affine_inverse()
	var spawn_pos = xform * camera.get_viewport().get_mouse_position()
	
	if buildings_container:
		buildings_container.add_child(new_building)
	else:
		get_tree().current_scene.add_child(new_building)


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
<<<<<<< HEAD
<<<<<<< HEAD

func _check_building_click() -> void:
	var xform = camera.get_canvas_transform().affine_inverse()
	var click_world_pos = xform * camera.get_viewport().get_mouse_position()

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = click_world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = space_state.intersect_point(query)
	var clicked_building = null
	
	if camera.is_drag_selecting:
		return
	
	for result in results:
		var collider = result.collider
		if collider is Building:
			clicked_building = collider
			break
		elif collider.owner is Building:
			clicked_building = collider.owner
			break

	if clicked_building:
		selected_building = clicked_building
		print("Selected building: ", selected_building.building_name)
		
		# TODO: Open your UI building menu here
		HUD.show_building_menu(selected_building)
		
	else:
		# If the player clicked empty ground, optionally deselect the building
		if selected_building:
			print("Deselected building.")
			selected_building = null
=======
>>>>>>> parent of f719ec9 (made the ui menu for the building display)
=======
>>>>>>> parent of f719ec9 (made the ui menu for the building display)
