@tool
extends StateComponent
class_name NestingStateComponent
## A StateComponent that holds other StateComponents.

var _components : Array[StateComponent]


func _ready():
	_populate_components()


func _populate_components():
	_components.clear()
	_components.assign(_get_state_components(self))


func _get_state_components(node: Node) -> Array:
	var array : Array = Array()
	for child in node.get_children():
		if child is StateComponent:
			array.append(child)
		if child.get_child_count() > 0:
			array.append_array(_get_state_components(child))
	return array
