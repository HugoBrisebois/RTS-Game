extends Node2D

@onready var camera: RTSCamera = $UI/Camera2D 

func _ready() -> void:
	if camera.has_signal("selection_completed"):
		camera.selection_completed.connect(_on_camera_selection_completed)
	else:
		print("Error: RTSCamera selection_completed signal not found!")

func _on_camera_selection_completed(world_rect: Rect2) -> void:
	var selected_units = []
	for node in get_tree().get_nodes_in_group("units"):
		if node is Unit:
			if world_rect.has_point(node.global_position):
				node.set_selected(true)
			else:
				node.set_selected(false)
				
	print("Selected units count: ", selected_units.size())
