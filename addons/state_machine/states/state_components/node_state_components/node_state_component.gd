@tool
@icon("res://addons/state_machine/icons/state_components/node_state_component.png")
extends StateComponent
class_name NodeStateComponent

@export var node_key : String = "node_key" :
	set(value):
		node_key = value
		dependencies_changed.emit()

var node : Node :
	set(_value):
		pass
	get:
		return dependencies[node_key]


func get_dependencies() -> Array[String]:
	var array = super()
	array.append(node_key)
	return array
