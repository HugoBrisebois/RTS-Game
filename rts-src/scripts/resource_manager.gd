class_name ResourceManagerClass
extends Node

# dictionary to hold the player resources
var resources: Dictionary = {
	"gold": 100,
	"wood": 150,
	"meat": 50,
}
const STARTING_RESOURCES: Dictionary = {
	"gold": 150,
	"wood": 250,
	"meat": 0,
}

signal resources_changed(resources_name: String, new_amount: int)

func reset() -> void:
	resources = STARTING_RESOURCES.duplicate()
	for resource_name in resources:
		resources_changed.emit(resource_name, resources[resource_name])

func add_resource(resource_name: String, amount: int) -> void:
	if resources.has(resource_name) and amount > 0:
		resources[resource_name] += amount
		resources_changed.emit(resource_name, resources[resource_name])

func deduct_resource(resource_name: String, amount: int) -> bool:
	if amount >= 0 and resources.has(resource_name) and resources[resource_name] >= amount:
		resources[resource_name] -= amount
		resources_changed.emit(resource_name, resources[resource_name])
		return true
	return false
