@tool
@icon("uid://c7ygp8h6xjx46")
@abstract
class_name NodeStateComponent
extends StateComponent
## Abstract class for a StateComponent that interacts with a node.

## Key for the node dependency.
@export var node_key: StringName = &"node_key"

var node: Node:
	get:
		return dependencies.get(node_key)


func get_dependencies() -> Array[StringName]:
	var array: Array[StringName] = super()
	array.append(node_key)
	return array
