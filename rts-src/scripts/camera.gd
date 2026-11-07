class_name RTSCamera
extends Camera2D

signal selection_completed(world_rect: Rect2)

@export_category("Movement Settings")
@export var move_speed: float = 600.0
@export var edge_margin: float = 20.0
@export var enable_edge_scrolling: bool = true

@export_category("Zoom Settings")
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.5
@export var zoom_speed: float = 0.1
@export var zoom_smoothness: float = 10.0

@export_category("Selection Box Styling")
@export var box_fill_color: Color = Color(0.2, 0.6, 1.0, 0.25)
@export var box_border_color: Color = Color(0.2, 0.6, 1.0, 0.9)
@export var box_border_width: float = 2.0
@export var drag_threshold: float = 5.0

var target_zoom: Vector2 = Vector2.ONE
var is_drag_selecting: bool = false
var drag_start_screen: Vector2 = Vector2.ZERO
var drag_current_screen: Vector2 = Vector2.ZERO
var is_panning: bool = false
var pan_start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	target_zoom = zoom

func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_zoom(delta)

func _unhandled_input(event: InputEvent) -> void:
	_handle_panning_input(event)
	_handle_zoom_input(event)
	_handle_selection_input(event)

# --- Drawing Logic (Using Canvas Transform for accurate screen-to-world rendering) ---
func _draw() -> void:
	if not is_drag_selecting:
		return

	if drag_start_screen.distance_to(drag_current_screen) < drag_threshold:
		return

	# Convert screen drag points to local camera/canvas space
	var xform = get_canvas_transform().affine_inverse()
	var local_start = xform * drag_start_screen
	var local_current = xform * drag_current_screen

	var top_left: Vector2 = Vector2(min(local_start.x, local_current.x), min(local_start.y, local_current.y))
	var size: Vector2 = (local_start - local_current).abs()
	var rect: Rect2 = Rect2(top_left, size)

	draw_rect(rect, box_fill_color, true)
	draw_rect(rect, box_border_color, false, box_border_width)

# --- Selection Handling ---
func _handle_selection_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_drag_selecting = true
			drag_start_screen = event.position
			drag_current_screen = event.position
			queue_redraw()
		else:
			if is_drag_selecting:
				is_drag_selecting = false
				queue_redraw()
				if drag_start_screen.distance_to(drag_current_screen) >= drag_threshold:
					_emit_selection_completed()

	elif event is InputEventMouseMotion and is_drag_selecting:
		drag_current_screen = event.position
		queue_redraw()

func _emit_selection_completed() -> void:
	var xform = get_canvas_transform().affine_inverse()
	var world_start: Vector2 = xform * drag_start_screen
	var world_current: Vector2 = xform * drag_current_screen

	var top_left: Vector2 = Vector2(min(world_start.x, world_current.x), min(world_start.y, world_current.y))
	var size: Vector2 = (world_start - world_current).abs()

	selection_completed.emit(Rect2(top_left, size))

# --- Camera Movement & Panning ---
func _handle_movement(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		input_vector.x += 1.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		input_vector.x -= 1.0
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		input_vector.y += 1.0
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		input_vector.y -= 1.0

	if enable_edge_scrolling and not is_panning:
		var viewport_rect: Rect2 = get_viewport().get_visible_rect()
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()

		if mouse_pos.x >= viewport_rect.size.x - edge_margin:
			input_vector.x += 1.0
		elif mouse_pos.x <= edge_margin:
			input_vector.x -= 1.0

		if mouse_pos.y >= viewport_rect.size.y - edge_margin:
			input_vector.y += 1.0
		elif mouse_pos.y <= edge_margin:
			input_vector.y -= 1.0

	position += input_vector.normalized() * (move_speed / zoom.x) * delta

func _handle_panning_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed:
			is_panning = true
			pan_start_position = event.position
		else:
			is_panning = false

	elif event is InputEventMouseMotion and is_panning:
		var delta: Vector2 = (pan_start_position - event.position) / zoom.x
		position += delta
		pan_start_position = event.position

func _handle_zoom_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = (target_zoom + Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = (target_zoom - Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func _handle_zoom(delta: float) -> void:
	zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)
