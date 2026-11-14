class_name Castle
extends Building

@export var trained_unit_scene: PackedScene
@export var worker_gold_cost: int = 50
@export var worker_wood_cost: int = 25
@export var worker_meat_cost: int = 10

signal train_worker()
signal cancel()

func trigger_interaction() -> void:
	print("opening castle menu")
	# TODO: make ui functionality for castle
	emit_signal("train_worker")
