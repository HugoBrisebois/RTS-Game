class_name Building
extends StaticBody2D

@export var building_name: String = "Castle"
@export var max_health: int = 500
@export var is_enemy: bool = false
@export var gold_cost: int = 0
@export var wood_cost: int = 0
var current_health: int

signal destroyed(building: Building, was_enemy: bool)

@onready var sprite: Sprite2D= $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

func _ready() -> void:
	add_to_group("Building")
	current_health = max_health
	_create_health_bar()
	if is_enemy and sprite:
		sprite.modulate = Color(1.0, 0.45, 0.45)

func take_damage(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return
	current_health = maxi(current_health - amount, 0)
	var health_bar := get_node_or_null("HealthBar") as ProgressBar
	if health_bar:
		health_bar.value = current_health
	if current_health <= 0:
		destroyed.emit(self, is_enemy)
		queue_free()

# virtual function overridden by specific builldings
func trigger_interaction() -> void:
	print("Interacted with base building:", building_name)

func _create_health_bar() -> void:
	var health_bar := ProgressBar.new()
	health_bar.name = "HealthBar"
	health_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_bar.show_percentage = false
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.position = Vector2(-60.0, -120.0)
	health_bar.size = Vector2(120.0, 8.0)
	add_child(health_bar)
