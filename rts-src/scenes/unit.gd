class_name Unit
extends CharacterBody2D

var is_selected: bool = false

# visual indicator sprite color change
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func set_selected(selected: bool) -> void:
	is_selected = selected
	if is_selected:
		sprite.modulate = Color(0.2, 1.0, 0.2)
	else:
		sprite.modulate = Color(1.0, 1.0, 1.0)
