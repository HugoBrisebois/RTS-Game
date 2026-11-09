class_name WorkerUnit
extends Unit

@export var carry_capacity: int = 2
var carried_resources: int = 0

func _ready() -> void:
	unit_name = "Worker"
	move_speed = 220.0
	max_health = 80
	super._ready()
