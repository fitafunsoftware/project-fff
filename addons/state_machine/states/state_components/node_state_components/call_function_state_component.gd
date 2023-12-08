@tool
@icon("res://addons/state_machine/icons/state_components/fun.png")
extends NodeStateComponent
class_name CallFunctionStateComponent

@export var function : String
@export var args : Array
@export var deferred : bool = false


func call_function():
	if deferred:
		node.callv.call_deferred(function, args)
	else:
		node.callv(function, args)
