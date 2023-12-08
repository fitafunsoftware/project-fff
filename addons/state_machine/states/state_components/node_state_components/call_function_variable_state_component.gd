@tool
@icon("res://addons/state_machine/icons/state_components/funv.png")
extends NodeStateComponent
class_name CallFunctionVariableStateComponent

@export var function : String
@export var variables : Array[String] :
	set(value):
		variables = value
		dependencies_changed.emit()
@export var deferred : bool = false


func call_function():
	var args : Array = Array()
	for variable in variables:
		args.append(dependencies[variable])
	
	if deferred:
		node.callv.call_deferred(function, args)
	else:
		node.callv(function, args)


func get_dependencies() -> Array[String]:
	var array : Array[String] = super()
	array.append_array(variables)
	return array
