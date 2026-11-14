class_name Barracks
extends Building

@export var defense_range: float = 450.0
@export var defense_damage: int = 18
@export var defense_cooldown: float = 1.2

var _attack_timer: float = 0.0

func _process(delta: float) -> void:
	_attack_timer -= delta
	if _attack_timer > 0.0:
		return
	var target := _find_target()
	if not target:
		return
	_attack_timer = defense_cooldown
	target.call("take_damage", defense_damage)

func _find_target() -> Node2D:
	var nearest: Node2D
	var nearest_distance := defense_range * defense_range
	for group_name in ["Unit", "Building"]:
		for candidate in get_tree().get_nodes_in_group(group_name):
			if candidate == self or not is_instance_valid(candidate):
				continue
			var candidate_is_enemy := false
			if candidate is Unit:
				candidate_is_enemy = (candidate as Unit).is_enemy
			elif candidate is Building:
				candidate_is_enemy = (candidate as Building).is_enemy
			if candidate_is_enemy == is_enemy or not candidate.has_method("take_damage"):
				continue
			var distance := global_position.distance_squared_to(candidate.global_position)
			if distance < nearest_distance:
				nearest = candidate
				nearest_distance = distance
	return nearest

# make warrior units
@export var trained_warrior_scene: PackedScene
@export var warrior_gold_cost: int = 100
@export var warrior_wood_cost: int = 50
@export var warrior_meat_cost: int = 20

signal train_warrior()
signal cancel()

func trigger_interaction() -> void:
	print("opening barracks menu")
	# TODO: make ui functionality for castle
	emit_signal("train_warrior")
