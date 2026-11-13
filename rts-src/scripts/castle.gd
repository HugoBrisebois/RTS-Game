class_name Castle
extends Building

@export var trained_unit_scene: PackedScene

signal train_worker()
signal cancel()

func trigger_interaction() -> void:
	print("opening castle menu")
	# TODO: make ui functionality for castle
