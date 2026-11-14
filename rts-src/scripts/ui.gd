extends CanvasLayer
class_name UI

@onready var gold_label: Label = $ResourceManager/HBoxContainer/Gold
@onready var wood_label: Label = $ResourceManager/HBoxContainer/Wood
@onready var building_menu: VBoxContainer = $control_panel/BuildMenu
@onready var unit_menu: VBoxContainer = $control_panel/unitMenu

signal train_worker
signal build_barracks_requested
signal attack_mode_requested
signal gather_mode_requested
signal stop_requested
signal restart_requested
signal quit_requested

var _status_label: Label

func _ready() -> void:
	building_menu.visible = false
	unit_menu.visible = false
	var cancel_button := get_node_or_null("control_panel/BuildMenu/Cancel Unit") as Button
	if cancel_button:
		cancel_button.visible = false
	var train_button := get_node_or_null("control_panel/BuildMenu/train Unit") as Button
	if train_button:
		train_button.text = "Train Worker"
	var gather_button := get_node_or_null("control_panel/unitMenu/castle") as Button
	if gather_button:
		gather_button.text = "Gather"
	var barracks_button := get_node_or_null("control_panel/unitMenu/barracks") as Button
	if barracks_button:
		barracks_button.text = "Build Barracks"
	ResourceManager.resources_changed.connect(_on_resources_changed)
	_connect_button("control_panel/BuildMenu/train Unit", _on_train_worker_pressed)
	_connect_button("control_panel/unitMenu/Attack", _on_attack_pressed)
	_connect_button("control_panel/unitMenu/Stop", _on_stop_pressed)
	_connect_button("control_panel/unitMenu/castle", _on_gather_pressed)
	_connect_button("control_panel/unitMenu/barracks", _on_build_barracks_pressed)
	_add_hud_controls()
	_update_display()

func _process(_delta: float) -> void:
	if _status_label and _status_label.visible and _status_label.has_meta("temporary"):
		var remaining: float = _status_label.get_meta("temporary")
		remaining -= _delta
		if remaining <= 0.0:
			_status_label.visible = false
			_status_label.remove_meta("temporary")
		else:
			_status_label.set_meta("temporary", remaining)

func _connect_button(path: String, callback: Callable) -> void:
	var button := get_node_or_null(path) as Button
	if button and not button.pressed.is_connected(callback):
		button.pressed.connect(callback)

func _add_hud_controls() -> void:
	var resource_row := $ResourceManager/HBoxContainer as HBoxContainer
	var meat_label := Label.new()
	meat_label.name = "Meat"
	resource_row.add_child(meat_label)

	_status_label = Label.new()
	_status_label.position = Vector2(12.0, 76.0)
	_status_label.add_theme_color_override("font_color", Color.WHITE)
	_status_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	_status_label.add_theme_constant_override("shadow_offset_x", 2)
	_status_label.add_theme_constant_override("shadow_offset_y", 2)
	_status_label.visible = false
	$control_panel.add_child(_status_label)

	var help_label := Label.new()
	help_label.text = "Select: left-click / drag   Move, gather, attack: right-click   Camera: WASD / edge / middle-drag   Zoom: wheel"
	help_label.position = Vector2(12.0, 612.0)
	help_label.add_theme_color_override("font_color", Color.WHITE)
	help_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	help_label.add_theme_constant_override("shadow_offset_x", 2)
	help_label.add_theme_constant_override("shadow_offset_y", 2)
	$control_panel.add_child(help_label)

	var restart_button := Button.new()
	restart_button.name = "Restart"
	restart_button.text = "Restart"
	restart_button.position = Vector2(1020.0, 12.0)
	restart_button.pressed.connect(func() -> void: restart_requested.emit())
	$control_panel.add_child(restart_button)

	var quit_button := Button.new()
	quit_button.text = "Quit"
	quit_button.position = Vector2(1090.0, 12.0)
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	$control_panel.add_child(quit_button)

func _update_display() -> void:
	gold_label.text = "Gold: " + str(ResourceManager.resources.get("gold", 0))
	wood_label.text = "Wood: " + str(ResourceManager.resources.get("wood", 0))
	var meat_label := get_node_or_null("ResourceManager/HBoxContainer/Meat") as Label
	if meat_label:
		meat_label.text = "Meat: " + str(ResourceManager.resources.get("meat", 0))

func _on_resources_changed(_resource_name: String, _new_amount: int) -> void:
	_update_display()

func show_building_menu(building: Building) -> void:
	building_menu.visible = building is Castle and not building.is_enemy
	unit_menu.visible = false

func show_unit_hud(unit: Unit) -> void:
	unit_menu.visible = not unit.is_enemy
	building_menu.visible = false
	var build_button := get_node_or_null("control_panel/unitMenu/barracks") as Button
	if build_button:
		build_button.visible = not unit.is_enemy

func hide_building_menu() -> void:
	building_menu.visible = false

func hide_unit_menu() -> void:
	unit_menu.visible = false

func show_message(message: String, duration: float = 3.0) -> void:
	_status_label.text = message
	_status_label.visible = true
	if duration > 0.0:
		_status_label.set_meta("temporary", duration)
	elif _status_label.has_meta("temporary"):
		_status_label.remove_meta("temporary")

func show_match_result(message: String) -> void:
	show_message(message, 0.0)
	building_menu.visible = false
	unit_menu.visible = false
	$control_panel.get_node("Restart").grab_focus()

func _on_train_worker_pressed() -> void:
	train_worker.emit()

func _on_build_barracks_pressed() -> void:
	build_barracks_requested.emit()

func _on_attack_pressed() -> void:
	attack_mode_requested.emit()

func _on_gather_pressed() -> void:
	gather_mode_requested.emit()

func _on_stop_pressed() -> void:
	stop_requested.emit()
