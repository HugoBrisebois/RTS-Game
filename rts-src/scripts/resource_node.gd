class_name ResourceNode
extends StaticBody2D

const GOLD_TEXTURE: Texture2D = preload("res://Assets/Terrain/Resources/Gold/Gold Resource/Gold_Resource.png")
const WOOD_TEXTURE: Texture2D = preload("res://Assets/Terrain/Resources/Wood/Wood Resource/Wood Resource.png")

@export_enum("gold", "wood") var resource_type: String = "gold"
@export var remaining_amount: int = 500

signal depleted(resource_node: ResourceNode)

@onready var interaction_area: Area2D = $InteractionArea
var _sprite: Sprite2D

func _ready() -> void:
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if not _sprite:
		_sprite = Sprite2D.new()
		_sprite.name = "Sprite2D"
		add_child(_sprite)
	refresh_visual()

func refresh_visual() -> void:
	if not is_instance_valid(_sprite):
		return
	_sprite.texture = GOLD_TEXTURE if resource_type == "gold" else WOOD_TEXTURE
	_sprite.position.y = -24.0
	_sprite.z_index = 1

func harvest(amount: int) -> int:
	if amount <= 0 or remaining_amount <= 0:
		return 0
	var harvested := mini(amount, remaining_amount)
	remaining_amount -= harvested

	if remaining_amount <= 0:
		print("Resource depleted: ", resource_type)
		depleted.emit(self)
		queue_free()

	return harvested
