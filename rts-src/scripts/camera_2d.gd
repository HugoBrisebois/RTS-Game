extends Camera2D

@export var speed: float = 400.0  # Pixels per second

func _process(delta: float) -> void:
	# get direction vector
	var direction = Input.get_vector("move_camera_left", "move_camera_right", "move_camera_up", "move_camera_down")
	
	# move the camera accordingly
	position += direction * speed * delta
