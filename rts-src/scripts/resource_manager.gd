class_name ResourceManagerClass
extends Node

const STARTING_RESOURCES: Dictionary = {
	"gold": 150,
	"wood": 250,
	"meat": 100,
}

var resources: Dictionary = {}

signal resources_changed(resources_name: String, new_amount: int)

func reset() -> void:
	resources = STARTING_RESOURCES.duplicate()
	for resource_name in resources:
		resources_changed.emit(resource_name, resources[resource_name])

func can_afford(costs: Dictionary) -> bool:
	for resource_name in costs:
		var amount: Variant = costs[resource_name]
		if not resources.has(resource_name) or not (amount is int) or amount < 0:
			return false
		if resources[resource_name] < amount:
			return false
	return true

func try_spend(costs: Dictionary) -> bool:
	if costs.is_empty() or not can_afford(costs):
		return false
	for resource_name in costs:
		resources[resource_name] -= costs[resource_name]
	for resource_name in costs:
		resources_changed.emit(resource_name, resources[resource_name])
	return true

func add_resources(amounts: Dictionary) -> bool:
	for resource_name in amounts:
		var amount: Variant = amounts[resource_name]
		if not resources.has(resource_name) or not (amount is int) or amount < 0:
			return false
	for resource_name in amounts:
		resources[resource_name] += amounts[resource_name]
	for resource_name in amounts:
		resources_changed.emit(resource_name, resources[resource_name])
	return true

func add_resource(resource_name: String, amount: int) -> void:
	if resources.has(resource_name) and amount > 0:
		resources[resource_name] += amount
		resources_changed.emit(resource_name, resources[resource_name])

func deduct_resource(resource_name: String, amount: int) -> bool:
	return amount > 0 and try_spend({resource_name: amount})
