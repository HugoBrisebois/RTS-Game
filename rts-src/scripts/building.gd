class_name Building
extends StaticBody2D

@export var building_name: String = "Castle"
@export var max_health: int = 500
var current_health: int = max_health

@onready var sprite: Sprite2D= $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

func _ready() -> void:
	current_health = max_health
	
# virtual function overridden by specific builldings
func trigger_interaction() -> void:
	print("Interacted with base building:", building_name)
