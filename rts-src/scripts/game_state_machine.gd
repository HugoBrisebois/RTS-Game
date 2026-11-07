extends Node2D

@onready var camera: RTSCamera = $Camera2D

func _ready() -> void:
	if camera:
		camera.selection_completed.connect(_on_camera_selection_completed)
		print("RTSCamera successfully connected under $UI/Camera2D!")
	else:
		printerr("Error: RTSCamera node could not be found at path $UI/Camera2D!")

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	var selected_units = []
	
	for node in get_tree().get_nodes_in_group("Unit"):
		if node is Unit:
			if world_rect.has_point(node.global_position):
				node.set_selected(true)
				selected_units.append(node)
			else:
				node.set_selected(false)
				
	print("Selected units count: ", selected_units.size())

func _process(delta: float) -> void:
	pass
