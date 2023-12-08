@tool
@icon("res://addons/state_machine/icons/component_state.png")
extends State
class_name ComponentState

@export var components : Array[StateComponent] :
	set(value):
		components = value
		_connect_components()
@export var dependencies : Dictionary


func _ready():
	_connect_components()
	
	if Engine.is_editor_hint():
		_load_dependencies()
	
	for component in components:
		if not component:
			continue
		component.ready()


func _connect_components():
	for component in components:
		if not component:
			continue
		component.state = self
		component.dependencies = dependencies
		component.dependencies_changed.connect(_load_dependencies)


func enter():
	_call_component_func("enter")


func resume():
	_call_component_func("resume")


func exit():
	_call_component_func("exit")


func handle_input(event: InputEvent):
	_call_component_func("handle_input", [event])


func update(delta: float):
	_call_component_func("update", [delta])


func on_animation_finished(animation: String):
	_call_component_func("on_animation_finished", [animation])


func reload_dependencies():
	_load_dependencies()


func _call_component_func(function_name: String, arguments: Array = []):
	for component in components:
		if component.active:
			component.callv(function_name, arguments)


func _load_dependencies():
	var keys_to_add : Array[String]
	keys_to_add.assign(Array())
	for component in components:
		if not component:
			continue
		var component_dependencies : Array[String] = component.get_dependencies()
		keys_to_add.append_array(component_dependencies)
	
	var previous_dependencies : Dictionary = dependencies.duplicate()
	dependencies.clear()
	for key in keys_to_add:
		dependencies[key] = previous_dependencies.get(key, null)


func save():
	pass
