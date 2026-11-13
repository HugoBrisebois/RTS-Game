extends CanvasLayer

# declare the locations for the resource and general ui elements
@onready var gold_label: Label = $ResourceManager/HBoxContainer/Gold
@onready var wood_label: Label = $ResourceManager/HBoxContainer/Wood

# declare the command slection ui elements
@onready var building_menu: VBoxContainer = $control_panel/BuildMenu
@onready var unit_menu: VBoxContainer = $control_panel/unitMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# hide the unit and building menus
	building_menu.visible = false
	unit_menu.visible = false
	
	# connect to the globalResource manager signals
	ResourceManager.resources_changed.connect(_on_resources_changed)
	_update_display()

func _update_display() -> void:
	gold_label.text = "Gold: " + str(ResourceManager.resources["gold"])
	wood_label.text = "wood: " + str(ResourceManager.resources["wood"])
	

func _on_resources_changed(resource_name: String, _new_amount: int) -> void:
	_update_display()

func show_building_menu(building: Building) -> void:
	building_menu.visible = true
	unit_menu.visible = false
	# TODO: map button signals here

func show_unit_hud(unit: Unit) -> void:
	unit_menu.visible = true
	building_menu.visible = false
	# TODO: add button signals for actions
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> parent of f719ec9 (made the ui menu for the building display)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
>>>>>>> parent of f719ec9 (made the ui menu for the building display)
