@tool
@icon("node_state_component.png")
extends StateComponent
class_name NodeStateComponent
## Base StateComponent for components that interact with a node.

## Key for the node dependency.
@export var node_key : StringName = &"node_key"

var node : Node :
	get:
		return dependencies.get(node_key)


func get_dependencies() -> Array[StringName]:
	var array : Array[StringName] = super()
	array.append(node_key)
	return array
