class_name ResourceManagerClass
extends Node

# dictionary to hold the player resources
var resources: Dictionary = {
	"gold": 100,
	"wood": 150,
	"meat": 50,
}

signal resources_changed(resources_name: String, new_amount: int)

func add_resource(resource_name: String, amount: int) -> void:
	if resources.has(resource_name):
		resources[resource_name] += amount
		resources_changed.emit(resource_name, resources[resource_name])
		print("Added ", amount, " ", resource_name, ". Total: ", resources[resource_name])
		

func deduct_resource(resource_name: String, amount: int) -> bool:
	if resources.has(resource_name) and resources[resource_name] >= amount:
		resources[resource_name] -= amount
		resources_changed.emit(resource_name, resources[resource_name])
		return true
	print("Not enough ", resource_name)
	return false
