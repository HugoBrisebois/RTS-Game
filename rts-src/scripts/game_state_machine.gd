extends Node2D

@onready var camera: RTSCamera = $UI/Camera2D 

func _ready() -> void:
	# Connect the signal emitted from the camera script
	camera.selection_completed.connect(_on_camera_selection_completed)

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	# Clear previous selections if shift isn't held (optional)
	var selected_units = []

	# Loop through all nodes in the "units" group
	for node in get_tree().get_nodes_in_group("units"):
		if node is Unit:
			# Check if the unit's global position falls inside the selection Rect2
			if world_rect.has_point(node.global_position):
				node.set_selected(true)
				selected_units.append(node)
			else:
				node.set_selected(false)
				
	print("Selected units count: ", selected_units.size())
