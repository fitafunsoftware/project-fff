@tool
@icon("res://addons/state_machine/icons/state_components/if.png")
extends ActivationStateComponent
class_name FunctionActivationStateComponent

@export var node_key : String :
	set(value):
		node_key = value
		dependencies_changed.emit()
@export var function : String
@export var args: Array
@export var equals: Array

var node : Node :
	set(_value):
		pass
	get:
		return dependencies[node_key]


func enter():
	_check_and_activate()
	super()


func resume():
	_check_and_activate()
	super()


func update(delta: float):
	_check_and_activate()
	super(delta)


func get_dependencies() -> Array[String]:
	var array : Array[String] = super()
	array.append(node_key)
	return array


func _check_and_activate():
	var value = activate if _function_equals() else not activate
	set_activated(value)


func _function_equals() -> bool:
	return equals.has(node.callv(function, args))
