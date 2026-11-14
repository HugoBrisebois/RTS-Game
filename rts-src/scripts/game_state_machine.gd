extends Node2D

const PLAYER_CASTLE_POSITION := Vector2(420.0, 340.0)
const ENEMY_CASTLE_POSITION := Vector2(11400.0, 4000.0)
const WORLD_BOUNDS := Rect2(-1200.0, -1300.0, 13700.0, 6700.0)
const BARRACKS_GOLD_COST := 25
const BARRACKS_WOOD_COST := 80

@onready var camera: RTSCamera = $Camera2D
@onready var units_container: Node2D = $UnitsContainer
@onready var buildings_container: Node2D = $BuildingsContainer
@onready var resources_container: Node = $Resource_container
@onready var HUD: UI = $UI

@export var unit_scene: PackedScene
@export var building_scene: PackedScene
@export var barracks_scene: PackedScene
@export var resource_node_scene: PackedScene

var selected_building: Building
var selected_units: Array[Unit] = []
var player_castle: Castle
var _placement_preview: Building
var _placement_mode: bool = false
var _attack_mode: bool = false
var _gather_mode: bool = false
var _match_over: bool = false
var _worker_spawn_index: int = 0

func _ready() -> void:
	ResourceManager.reset()
	HUD.train_worker.connect(_on_train_worker_requested)
	HUD.build_barracks_requested.connect(_start_barracks_placement)
	HUD.attack_mode_requested.connect(_start_attack_mode)
	HUD.gather_mode_requested.connect(_start_gather_mode)
	HUD.stop_requested.connect(_stop_selected_units)
	HUD.restart_requested.connect(_restart_match)
	HUD.quit_requested.connect(_quit_match)
	camera.selection_completed.connect(_on_camera_selection_completed)
	camera.world_bounds = WORLD_BOUNDS
	_start_match()

func _process(_delta: float) -> void:
	if _placement_mode and is_instance_valid(_placement_preview):
		var position := _mouse_world_position()
		_placement_preview.global_position = position
		var valid := _is_build_site_valid(position)
		_placement_preview.modulate = Color(0.45, 1.0, 0.45, 0.6) if valid else Color(1.0, 0.35, 0.35, 0.6)

func _unhandled_input(event: InputEvent) -> void:
	if _match_over:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if _placement_mode:
				_cancel_barracks_placement()
			else:
				_command_selected_units()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if _placement_mode:
				_place_barracks()
			else:
				_select_object_at_mouse()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if _placement_mode:
			_cancel_barracks_placement()
		elif _attack_mode or _gather_mode:
			_attack_mode = false
			_gather_mode = false
			HUD.show_message("Command canceled.")

func _start_match() -> void:
	var player_building := _spawn_building(building_scene, PLAYER_CASTLE_POSITION, false) as Castle
	if not player_building:
		HUD.show_message("Could not create the player's castle.")
		return
	player_castle = player_building
	player_castle.building_name = "Castle"

	var enemy_castle := _spawn_building(building_scene, ENEMY_CASTLE_POSITION, true)
	if not enemy_castle:
		HUD.show_message("Could not create the enemy base.")
		return
	enemy_castle.building_name = "Enemy Castle"
	enemy_castle.max_health = 500
	enemy_castle.current_health = enemy_castle.max_health
	var enemy_health_bar := enemy_castle.get_node_or_null("HealthBar") as ProgressBar
	if enemy_health_bar:
		enemy_health_bar.max_value = enemy_castle.max_health
		enemy_health_bar.value = enemy_castle.current_health

	_spawn_unit(unit_scene, PLAYER_CASTLE_POSITION + Vector2(-220.0, 100.0), false)
	_spawn_unit(unit_scene, PLAYER_CASTLE_POSITION + Vector2(-200.0, -150.0), false)
	_spawn_unit(unit_scene, ENEMY_CASTLE_POSITION + Vector2(220.0, 180.0), true)

	_spawn_resource("gold", Vector2(200.0, 540.0), 600)
	_spawn_resource("wood", Vector2(680.0, 450.0), 800)
	_spawn_resource("wood", Vector2(1000.0, 260.0), 800)
	HUD.show_message("Gather resources, train workers, build a barracks, and destroy the enemy castle.", 8.0)

func _spawn_building(scene: PackedScene, position: Vector2, enemy: bool) -> Building:
	if not scene:
		printerr("A building scene is not assigned.")
		return null
	var building := scene.instantiate() as Building
	if not building:
		printerr("The configured building scene is not a Building.")
		return null
	building.is_enemy = enemy
	buildings_container.add_child(building)
	building.global_position = position
	building.destroyed.connect(_on_building_destroyed)
	return building

func _spawn_unit(scene: PackedScene, position: Vector2, enemy: bool) -> Unit:
	if not scene:
		printerr("A unit scene is not assigned.")
		return null
	var unit := scene.instantiate() as Unit
	if not unit:
		printerr("The configured unit scene is not a Unit.")
		return null
	unit.is_enemy = enemy
	units_container.add_child(unit)
	unit.global_position = position
	unit.died.connect(_on_unit_died)
	return unit

func _spawn_resource(resource_type: String, position: Vector2, amount: int) -> void:
	if not resource_node_scene:
		printerr("A resource node scene is not assigned.")
		return
	var resource := resource_node_scene.instantiate() as ResourceNode
	if not resource:
		printerr("The configured resource scene is not a ResourceNode.")
		return
	resource.resource_type = resource_type
	resource.remaining_amount = amount
	resources_container.add_child(resource)
	resource.global_position = position
	resource.depleted.connect(_on_resource_depleted)

func _on_resource_depleted(resource: ResourceNode) -> void:
	HUD.show_message(resource.resource_type.capitalize() + " node depleted.")

func _select_object_at_mouse() -> void:
	var object := _get_object_at(_mouse_world_position())
	if object is Unit:
		var unit := object as Unit
		if unit.is_enemy:
			_clear_selection()
			HUD.show_message("Enemy units cannot be selected.")
			return
		_clear_selection()
		unit.set_selected(true)
		selected_units.append(unit)
		selected_building = null
		HUD.show_unit_hud(unit)
	elif object is Building:
		_clear_selection()
		selected_building = object as Building
		HUD.show_building_menu(selected_building)
		if selected_building.is_enemy:
			HUD.show_message("Enemy building — right-click with selected units to attack.")
	elif object is ResourceNode:
		_clear_selection()
	else:
		_clear_selection()

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	if _match_over or _placement_mode:
		return
	_clear_selection()
	for unit_node in get_tree().get_nodes_in_group("Unit"):
		var unit := unit_node as Unit
		if unit and not unit.is_enemy and world_rect.has_point(unit.global_position):
			unit.set_selected(true)
			selected_units.append(unit)
	selected_building = null
	if selected_units.size() == 1:
		HUD.show_unit_hud(selected_units[0])
	elif not selected_units.is_empty():
		HUD.hide_building_menu()
		HUD.hide_unit_menu()

func _clear_selection() -> void:
	for unit in selected_units:
		if is_instance_valid(unit):
			unit.set_selected(false)
	selected_units.clear()
	selected_building = null
	HUD.hide_building_menu()
	HUD.hide_unit_menu()

func _command_selected_units() -> void:
	if selected_units.is_empty():
		return
	var target := _get_object_at(_mouse_world_position())
	if target is ResourceNode:
		var workers_sent := 0
		for unit in selected_units:
			if unit is WorkerUnit and player_castle:
				(unit as WorkerUnit).gather_from(target as ResourceNode, player_castle)
				workers_sent += 1
		if workers_sent == 0:
			HUD.show_message("Select a worker to gather resources.")
		else:
			HUD.show_message("Workers gathering " + (target as ResourceNode).resource_type + ".")
		_gather_mode = false
		_attack_mode = false
		return

	if target is Unit or target is Building:
		var target_is_enemy := _is_enemy_object(target)
		if target_is_enemy:
			for unit in selected_units:
				unit.attack(target as Node2D)
			HUD.show_message("Attack order issued.")
			_attack_mode = false
			_gather_mode = false
			return

	var movement_bounds := WORLD_BOUNDS.grow(-32.0)
	var mouse_position := _mouse_world_position()
	var destination := Vector2(
		clampf(mouse_position.x, movement_bounds.position.x, movement_bounds.end.x),
		clampf(mouse_position.y, movement_bounds.position.y, movement_bounds.end.y)
	)
	for unit in selected_units:
		if unit is WorkerUnit:
			(unit as WorkerUnit).cancel_gathering()
		unit.move_to(destination)
	_attack_mode = false
	_gather_mode = false

func _get_object_at(world_position: Vector2) -> Node:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_position
	query.collide_with_areas = true
	query.collide_with_bodies = true
	for result in get_world_2d().direct_space_state.intersect_point(query, 32):
		var candidate := result["collider"] as Node
		while candidate:
			if candidate is Unit or candidate is Building or candidate is ResourceNode:
				return candidate
			candidate = candidate.get_parent()
	return null

func _is_enemy_object(object: Node) -> bool:
	if object is Unit:
		return (object as Unit).is_enemy
	if object is Building:
		return (object as Building).is_enemy
	return false

func _start_barracks_placement() -> void:
	if _match_over:
		return
	if selected_units.is_empty():
		HUD.show_message("Select a worker or unit before building.")
		return
	if ResourceManager.resources["gold"] < BARRACKS_GOLD_COST or ResourceManager.resources["wood"] < BARRACKS_WOOD_COST:
		HUD.show_message("A barracks costs %d gold and %d wood." % [BARRACKS_GOLD_COST, BARRACKS_WOOD_COST])
		return
	if not barracks_scene:
		HUD.show_message("The barracks scene is not configured.")
		return
	_cancel_barracks_placement()
	_placement_preview = barracks_scene.instantiate() as Building
	if not _placement_preview:
		HUD.show_message("The configured barracks scene is invalid.")
		return
	_placement_preview.is_enemy = false
	_placement_preview.modulate = Color(0.45, 1.0, 0.45, 0.6)
	buildings_container.add_child(_placement_preview)
	_placement_preview.set_process(false)
	_placement_preview.set_physics_process(false)
	_placement_preview.remove_from_group("Building")
	_set_collision_enabled(_placement_preview, false)
	_placement_mode = true
	HUD.show_message("Choose a clear, walkable location. Left-click to place; right-click or Esc to cancel.", 0.0)

func _cancel_barracks_placement() -> void:
	_placement_mode = false
	if is_instance_valid(_placement_preview):
		_placement_preview.queue_free()
	_placement_preview = null

func _place_barracks() -> void:
	var position := _mouse_world_position()
	if not _is_build_site_valid(position):
		HUD.show_message("That location is blocked or outside the playable map.")
		return
	if not ResourceManager.deduct_resource("gold", BARRACKS_GOLD_COST):
		HUD.show_message("Not enough gold to build a barracks.")
		return
	if not ResourceManager.deduct_resource("wood", BARRACKS_WOOD_COST):
		ResourceManager.add_resource("gold", BARRACKS_GOLD_COST)
		HUD.show_message("Not enough wood to build a barracks.")
		return
	var barracks := barracks_scene.instantiate() as Building
	if not barracks:
		ResourceManager.add_resource("gold", BARRACKS_GOLD_COST)
		ResourceManager.add_resource("wood", BARRACKS_WOOD_COST)
		HUD.show_message("Could not create the barracks.")
		_cancel_barracks_placement()
		return
	barracks.is_enemy = false
	buildings_container.add_child(barracks)
	barracks.global_position = position
	barracks.destroyed.connect(_on_building_destroyed)
	_cancel_barracks_placement()
	HUD.show_message("Barracks built.")

func _is_build_site_valid(position: Vector2) -> bool:
	if not WORLD_BOUNDS.has_point(position):
		return false
	if not is_instance_valid(_placement_preview):
		return false
	var collision := _placement_preview.get_node_or_null("CollisionShape2D2") as CollisionShape2D
	if not collision or not collision.shape:
		return false

	var half_size := Vector2(155.5, 104.0)
	var nav_map := get_world_2d().navigation_map
	if nav_map.is_valid():
		var offsets: Array[Vector2] = [
			Vector2.ZERO,
			Vector2(-half_size.x + 16.0, -half_size.y + 16.0),
			Vector2(half_size.x - 16.0, -half_size.y + 16.0),
			Vector2(-half_size.x + 16.0, half_size.y - 16.0),
			Vector2(half_size.x - 16.0, half_size.y - 16.0),
		]
		for offset in offsets:
			var point: Vector2 = position + offset
			if NavigationServer2D.map_get_closest_point(nav_map, point).distance_to(point) > 24.0:
				return false

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = collision.shape
	query.transform = Transform2D(0.0, position + collision.position)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	return get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty()

func _set_collision_enabled(node: Node, enabled: bool) -> void:
	if node is CollisionShape2D or node is CollisionPolygon2D:
		node.set_deferred("disabled", not enabled)
	elif node is CollisionObject2D:
		node.collision_layer = 1 if enabled else 0
		node.collision_mask = 1 if enabled else 0
	for child in node.get_children():
		_set_collision_enabled(child, enabled)

func _on_train_worker_requested() -> void:
	if _match_over:
		return
	var castle := selected_building as Castle
	if not castle or castle.is_enemy:
		HUD.show_message("Select your castle to train a worker.")
		return
	if not castle.trained_unit_scene:
		HUD.show_message("The castle has no worker scene assigned.")
		return
	if ResourceManager.resources["gold"] < castle.worker_gold_cost or ResourceManager.resources["wood"] < castle.worker_wood_cost:
		HUD.show_message("A worker costs %d gold and %d wood." % [castle.worker_gold_cost, castle.worker_wood_cost])
		return
	if not ResourceManager.deduct_resource("gold", castle.worker_gold_cost):
		return
	if not ResourceManager.deduct_resource("wood", castle.worker_wood_cost):
		ResourceManager.add_resource("gold", castle.worker_gold_cost)
		return
	var spawn_offset := Vector2(220.0, -110.0 + float(_worker_spawn_index % 5) * 48.0)
	_worker_spawn_index += 1
	var worker := _spawn_unit(castle.trained_unit_scene, castle.global_position + spawn_offset, false)
	if not worker:
		ResourceManager.add_resource("gold", castle.worker_gold_cost)
		ResourceManager.add_resource("wood", castle.worker_wood_cost)
		HUD.show_message("Could not train a worker.")
		return
	HUD.show_message("Worker trained.")

func _start_attack_mode() -> void:
	if selected_units.is_empty():
		HUD.show_message("Select units before issuing an attack order.")
		return
	_attack_mode = true
	_gather_mode = false
	HUD.show_message("Right-click an enemy to attack. Esc cancels.", 0.0)

func _start_gather_mode() -> void:
	if selected_units.is_empty():
		HUD.show_message("Select workers before gathering.")
		return
	_gather_mode = true
	_attack_mode = false
	HUD.show_message("Right-click a resource node to gather. Esc cancels.", 0.0)

func _stop_selected_units() -> void:
	for unit in selected_units:
		if unit is WorkerUnit:
			(unit as WorkerUnit).cancel_gathering()
		else:
			unit.stop()
	HUD.show_message("Selected units stopped.")

func _on_building_destroyed(building: Building, was_enemy: bool) -> void:
	if _match_over:
		return
	if selected_building == building:
		selected_building = null
		HUD.hide_building_menu()
	if was_enemy:
		_finish_match("Victory! The enemy castle has been destroyed.")
	elif building == player_castle:
		_finish_match("Defeat! Your castle has been destroyed.")

func _on_unit_died(unit: Unit, _was_enemy: bool) -> void:
	selected_units.erase(unit)
	if selected_units.is_empty():
		HUD.hide_unit_menu()

func _finish_match(message: String) -> void:
	_match_over = true
	_cancel_barracks_placement()
	HUD.show_match_result(message)

func _restart_match() -> void:
	get_tree().reload_current_scene()

func _quit_match() -> void:
	get_tree().quit()

func _mouse_world_position() -> Vector2:
	return camera.get_canvas_transform().affine_inverse() * camera.get_viewport().get_mouse_position()
