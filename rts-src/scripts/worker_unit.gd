class_name WorkerUnit
extends Unit

@export var carry_capacity: int = 10
@export var harvest_amount: int = 5
@export var harvest_interval: float = 0.8

var carried_resources: int = 0
var _resource_target: ResourceNode
var _home_building: Castle
var _resource_type: String = "wood"
var _harvest_timer: float = 0.0
var _returning_to_base: bool = false

func _ready() -> void:
	unit_name = "Worker"
	move_speed = 220.0
	max_health = 80.0
	attack_damage = 8
	super._ready()

func _process(delta: float) -> void:
	if not is_instance_valid(_resource_target):
		if carried_resources > 0 and is_instance_valid(_home_building):
			_returning_to_base = true
		else:
			return

	if _returning_to_base:
		if not is_instance_valid(_home_building):
			_stop_gathering()
			return
		move_to(_home_building.global_position)
		if global_position.distance_to(_home_building.global_position) <= 190.0:
			ResourceManager.add_resource(_resource_type, carried_resources)
			carried_resources = 0
			_returning_to_base = false
			if is_instance_valid(_resource_target):
				move_to(_resource_target.global_position)
			else:
				_stop_gathering()
		return

	if not is_instance_valid(_resource_target):
		return

	if global_position.distance_to(_resource_target.global_position) > 48.0:
		move_to(_resource_target.global_position)
		return

	stop()
	_harvest_timer -= delta
	if _harvest_timer <= 0.0:
		_harvest_timer = harvest_interval
		var gathered := _resource_target.harvest(mini(harvest_amount, carry_capacity - carried_resources))
		carried_resources += gathered
		if carried_resources >= carry_capacity or _resource_target.remaining_amount <= 0:
			_returning_to_base = true
		if carried_resources == 0 and _returning_to_base:
			_stop_gathering()

func gather_from(resource: ResourceNode, home: Castle) -> void:
	if is_enemy or not is_instance_valid(resource) or not is_instance_valid(home):
		return
	_resource_target = resource
	_home_building = home
	_resource_type = resource.resource_type
	_returning_to_base = false
	_harvest_timer = 0.0
	move_to(resource.global_position)

func cancel_gathering() -> void:
	_stop_gathering()

func _stop_gathering() -> void:
	_resource_target = null
	_home_building = null
	_returning_to_base = false
	super.stop()
