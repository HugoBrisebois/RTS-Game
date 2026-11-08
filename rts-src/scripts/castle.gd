class_name Building
extends StaticBody2D

@export var building_name: String = "castle"
var is_interacted: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func trigger_interaction() -> void:
	print("building used: ", building_name)
	
	# TODO: add building functionality here
	# ex: open ui menus 
