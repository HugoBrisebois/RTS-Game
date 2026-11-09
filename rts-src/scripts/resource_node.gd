class_name ResourceNode
extends StaticBody2D

@export var resource_type: String = "gold" # "gold", "wood", "stone"
@export var remaining_amount: int = 500

@onready var interaction_area: Area2D = $InteractionArea

func harvest(amount: int) -> int:
	var harvested = min(amount, remaining_amount)
	remaining_amount -= harvested
	
	if remaining_amount <= 0:
		print("resource depleted")
		queue_free()
	
	return harvested
