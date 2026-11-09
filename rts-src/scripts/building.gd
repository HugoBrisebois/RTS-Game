class_name Building
extends StaticBody2D

@export var building_name: String = "Castle"
var is_interacted: bool = false

# export slots to assign the specialized scenes in the inspector
@export var warrior_scene: PackedScene
@export var worker_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func trigger_interaction() -> void:
	print("building used: ", building_name)
	print("Opening training menu for: ", building_name)
	
	# TODO: add building functionality here
	# ex: open ui menus 
	
func train_worker() -> void:
	_spawn_unit(worker_scene, "Worker")


func _spawn_unit(scene_to_spawn: PackedScene, type_name: String) -> void:
	if not scene_to_spawn:
		printerr("ERROR: scene not assigned for ", type_name)
		return
	
	var new_unit = scene_to_spawn.instaniate() as Unit
	
	# find the units container or add to the current scee root
	var units_container = get_tree().current_scene.get_node_or_null("Unit_container")
	if units_container:
		units_container.add_child(new_unit)
	else:
		get_tree().current_scene.add_child(new_unit)
	
	# spawn slightly offset from the building
	new_unit.global_position = global_position + Vector2(60,60)
	print("Successfully trained and spawned a: ", type_name)
