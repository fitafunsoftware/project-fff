@tool
@icon("if.png")
extends ActivationStateComponent
class_name FunctionActivationStateComponent
## StateComponent that activates or deactivates descendents based on a function.
##
## Calls the function on the node and compares it with equals. Activates or
## deactivates based on if the return value is equal.

## Key for th node dependency.
@export var node_key: StringName = &"node_key"
## Function to call on the node.
@export var function: StringName
## Arguments to pass through the function.
@export var args: Array
## Values to compare the return value with. Can be multiple values to compare with.
@export var equals: Array

var node: Node:
	get:
		return dependencies.get(node_key)


func enter():
	_check_and_activate()


func resume():
	_check_and_activate()


func update(_delta: float):
	_check_and_activate()


func get_dependencies() -> Array[StringName]:
	var array: Array[StringName] = super()
	array.append(node_key)
	return array


func _check_and_activate():
	var value = activate if _function_equals() else not activate
	set_activated(value)


func _function_equals() -> bool:
	return equals.has(node.callv(function, args))
