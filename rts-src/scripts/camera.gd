extends Camera2D

@export var scroll_speed: float = 500.0
@export var edge_margin: float = 20.0 

func _process(delta: float) -> void:
	var move_dir := Vector2.ZERO

	# 1. Handle Arrow Ke
	move_dir = Input.get_vector("move_camera_left","move_camera_right","move_camera_up","move_camera_down")

	#Handle Mouse Edge-Scrolling Input
	if move_dir == Vector2.ZERO:
		var mouse_pos := get_viewport().get_mouse_position()
		var screen_size := get_viewport().get_visible_rect().size

		if mouse_pos.x < edge_margin:
			move_dir.x = -1
		elif mouse_pos.x > screen_size.x - edge_margin:
			move_dir.x = 1

		if mouse_pos.y < edge_margin:
			move_dir.y = -1
		elif mouse_pos.y > screen_size.y - edge_margin:
			move_dir.y = 1
			
		# Normalize the mouse direction vector so diagonal edge scrolling isn't faster
		move_dir = move_dir.normalized()

	# 3. Apply the movement to the camera position
	global_position += move_dir * scroll_speed * delta
