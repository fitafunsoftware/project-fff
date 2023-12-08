@tool
extends StateComponent
class_name NestingStateComponent

@export var components : Array[StateComponent]


func ready():
	_ready_components()


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


func _ready_components():
	for component in components:
		component.state = state
		component.dependencies = dependencies
		component.dependencies_changed.connect(emit_signal.bind("dependencies_changed"))
		component.ready()


func _call_component_func(function_name: String, arguments: Array = []):
	for component in components:
		if component.active:
			component.callv(function_name, arguments)
