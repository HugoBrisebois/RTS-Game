class_name Unit
extends CharacterBody2D

var is_selected: bool = false
var target_pos = null

# move speed variable
@export var move_speed: float = 200.0 
@export var unit_name: String = "Generic Unit"
@export var max_health: float = 200.0

var current_health: int = 100

# visual indicator sprite color change
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	# configure safely radius or updates if needed
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

func set_selected(selected: bool) -> void:
	is_selected = selected
	if is_selected:
		sprite.modulate = Color(0.2, 1.0, 0.2)
	else:
		sprite.modulate = Color(1.0, 1.0, 1.0)

func _physics_process(delta: float) -> void:
	# if target position has been set yet by a move command, dont try to navigate
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	# get the next path point calculated by the navigation server
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	# steer toward the next path point
	var direction = current_agent_position.direction_to(next_path_position)
	velocity = direction * move_speed
	
	move_and_slide()
	
func move_to(destination: Vector2) -> void:
	nav_agent.target_position = destination
