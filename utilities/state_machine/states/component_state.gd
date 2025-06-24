@tool
@icon("uid://cq18ibuhn8vbj")
class_name ComponentState
extends State
## A State built using components.
##
## A State that you can build in-editor using StateComponents by attaching them
## them to this node as a descendent.

## Button to reload dependencies.
@export_tool_button("Reload Dependencies", "Callable")
var reload_dependencies: Callable = _reload_dependencies
## Dependendencies needed by the StateComponents of this state.[br]You have to
## assign the proper values yourself, while reloading dependencies populates the
## dictionary with the dependencies required. NodePaths refer to the proper Nodes
## when the game is running.
@export var dependencies: Dictionary[StringName, Variant]

var _components: Array[StateComponent]


func _ready():
	_populate_components()
	_connect_components()
	
	if Engine.is_editor_hint():
		_load_dependencies()
	
	_call_component_func("ready")


func _reload_dependencies():
	_populate_components()
	_load_dependencies()
	notify_property_list_changed()


func _populate_components():
	_components.clear()
	_components.assign(_get_state_components(self))


func _get_state_components(node: Node) -> Array:
	var array: Array = Array()
	for child in node.get_children():
		if child is StateComponent:
			array.append(child)
		if child.get_child_count() > 0:
			array.append_array(_get_state_components(child))
	return array


func _connect_components():
	if not Engine.is_editor_hint():
		for key: StringName in dependencies.keys():
			if dependencies[key] is NodePath:
				dependencies[key] = get_node(dependencies[key])
	
	for component: StateComponent in _components:
		component.finished = finished
		component.dependencies = dependencies


func enter():
	_call_component_func("enter")


func resume():
	_call_component_func("resume")


func exit():
	_call_component_func("exit")


func seek(seconds: float):
	_call_component_func("seek", [seconds])


func handle_input(event: InputEvent):
	_call_component_func("handle_input", [event])


func update(delta: float):
	_call_component_func("update", [delta])


func on_animation_finished(animation: StringName):
	_call_component_func("on_animation_finished", [animation])


func _call_component_func(function_name: String, arguments: Array = []):
	if Engine.is_editor_hint():
		return
	
	for component: StateComponent in _components:
		if component.active:
			component.callv(function_name, arguments)


func _load_dependencies():
	var keys_to_add: Array[StringName]
	keys_to_add.assign(Array())
	for component: StateComponent in _components:
		keys_to_add.append_array(component.get_dependencies())
	
	var previous_dependencies: Dictionary[StringName, Variant]
	previous_dependencies.assign(dependencies.duplicate())
	dependencies.clear()
	for key: StringName in keys_to_add:
		dependencies[key] = previous_dependencies.get(key, null)
