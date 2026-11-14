class_name Unit
extends CharacterBody2D

signal died(unit: Unit, was_enemy: bool)

@export var move_speed: float = 200.0
@export var unit_name: String = "Generic Unit"
@export var max_health: float = 200.0
@export var attack_damage: int = 20
@export var attack_range: float = 64.0
@export var attack_cooldown: float = 0.8
@export var is_enemy: bool = false

var is_selected: bool = false
var current_health: float
var destination: Vector2 = Vector2.ZERO
var has_move_order: bool = false
var attack_target: Node2D
var _attack_timer: float = 0.0
var _enemy_scan_timer: float = 0.0
var _next_attack_animation: StringName = &"attack"

@onready var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var nav_agent: NavigationAgent2D = get_node_or_null("NavigationAgent2D")
var _health_bar: ProgressBar

func _ready() -> void:
	add_to_group("Unit")
	current_health = max_health
	_create_health_bar()
	_update_tint()
	if nav_agent:
		nav_agent.path_desired_distance = 4.0
		nav_agent.target_desired_distance = 8.0
		if nav_agent.avoidance_enabled:
			nav_agent.radius = 34.0
			nav_agent.neighbor_distance = 120.0
			nav_agent.max_neighbors = 12
			nav_agent.velocity_computed.connect(_on_navigation_velocity_computed)

func _physics_process(delta: float) -> void:
	if is_enemy:
		_enemy_scan_timer -= delta
		if _enemy_scan_timer <= 0.0:
			_enemy_scan_timer = 1.0
			if not is_instance_valid(attack_target):
				attack_target = _find_nearest_opponent()

	if is_instance_valid(attack_target):
		_process_attack(delta)
	elif has_move_order:
		_move_toward(destination)
	else:
		_apply_movement_velocity(Vector2.ZERO)
	_update_combat_animation()

func set_selected(selected: bool) -> void:
	is_selected = selected
	_update_tint()

func move_to(target_position: Vector2) -> void:
	if has_move_order and destination.is_equal_approx(target_position) and not is_instance_valid(attack_target):
		return
	attack_target = null
	has_move_order = true
	destination = target_position

func attack(target: Node2D) -> void:
	if not is_instance_valid(target) or not target.has_method("take_damage"):
		return
	attack_target = target
	has_move_order = false

func stop() -> void:
	attack_target = null
	has_move_order = false
	velocity = Vector2.ZERO

func take_damage(amount: int) -> void:
	if amount <= 0 or current_health <= 0.0:
		return
	current_health = maxf(current_health - amount, 0.0)
	if _health_bar:
		_health_bar.value = current_health
	if current_health <= 0.0:
		died.emit(self, is_enemy)
		queue_free()

func _process_attack(delta: float) -> void:
	if not is_instance_valid(attack_target) or not attack_target.has_method("take_damage"):
		attack_target = null
		return

	var attack_position := attack_target.global_position
	var effective_range := attack_range
	if attack_target is Building:
		effective_range += 130.0
	if global_position.distance_to(attack_position) > effective_range:
		_move_toward(attack_position)
		return

	has_move_order = false
	_apply_movement_velocity(Vector2.ZERO)
	_attack_timer -= delta
	if _attack_timer <= 0.0:
		_attack_timer = attack_cooldown
		_play_attack_animation()
		attack_target.take_damage(attack_damage)

func _move_toward(target_position: Vector2) -> void:
	if global_position.distance_to(target_position) <= 8.0:
		has_move_order = false
		_apply_movement_velocity(Vector2.ZERO)
		return

	var next_position := target_position
	if nav_agent:
		nav_agent.target_position = target_position
		if not nav_agent.is_navigation_finished():
			next_position = nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)
	if direction.is_zero_approx():
		direction = global_position.direction_to(target_position)
	_apply_movement_velocity(direction * move_speed)

func _apply_movement_velocity(desired_velocity: Vector2) -> void:
	if nav_agent and nav_agent.avoidance_enabled:
		nav_agent.velocity = desired_velocity
		return
	velocity = desired_velocity
	move_and_slide()

func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _update_combat_animation() -> void:
	if not sprite or not sprite.sprite_frames or not sprite.sprite_frames.has_animation(&"attack"):
		return

	if has_move_order or _is_approaching_attack_target():
		_play_unit_animation(&"run")
	elif is_instance_valid(attack_target):
		if sprite.animation != &"attack" and sprite.animation != &"attack2" or not sprite.is_playing():
			_play_unit_animation(&"guard")
	elif sprite.animation != &"attack" and sprite.animation != &"attack2" or not sprite.is_playing():
		_play_unit_animation(&"idle")

func _is_approaching_attack_target() -> bool:
	if not is_instance_valid(attack_target):
		return false
	var effective_range := attack_range + (130.0 if attack_target is Building else 0.0)
	return global_position.distance_to(attack_target.global_position) > effective_range

func _play_attack_animation() -> void:
	if not sprite or not sprite.sprite_frames:
		return
	var animation_name := _next_attack_animation
	_next_attack_animation = &"attack2" if animation_name == &"attack" else &"attack"
	_play_unit_animation(animation_name)

func _play_unit_animation(animation_name: StringName) -> void:
	if sprite and sprite.sprite_frames.has_animation(animation_name) and sprite.animation != animation_name:
		sprite.play(animation_name)

func _find_nearest_opponent() -> Node2D:
	var nearest: Node2D
	var nearest_distance := INF
	for group_name in ["Unit", "Building"]:
		for candidate in get_tree().get_nodes_in_group(group_name):
			if candidate == self or not is_instance_valid(candidate):
				continue
			var candidate_is_enemy := false
			if candidate is Unit or candidate is Building:
				candidate_is_enemy = candidate.is_enemy
			if candidate_is_enemy == is_enemy:
				continue
			var distance := global_position.distance_squared_to(candidate.global_position)
			if distance < nearest_distance:
				nearest = candidate
				nearest_distance = distance
	return nearest

func _create_health_bar() -> void:
	_health_bar = ProgressBar.new()
	_health_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_health_bar.show_percentage = false
	_health_bar.max_value = max_health
	_health_bar.value = current_health
	_health_bar.position = Vector2(-24.0, -42.0)
	_health_bar.size = Vector2(48.0, 6.0)
	add_child(_health_bar)

func _update_tint() -> void:
	if not sprite:
		return
	if is_selected:
		sprite.modulate = Color(0.2, 1.0, 0.2)
	elif is_enemy:
		sprite.modulate = Color(1.0, 0.45, 0.45)
	else:
		sprite.modulate = Color.WHITE
