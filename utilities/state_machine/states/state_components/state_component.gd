@tool
@icon("uid://s0np8whnlvb2")
@abstract
class_name StateComponent
extends Node
## Abstract class for a component of a ComponentState.
##
## The interface for components that make up a ComponentState. Child components of a
## ComponentState make up the logic for that ComponentState.

## Is this component active?
@export var active := true: set = _set_active

## The finished Callable this component should call to request a state change.
var finished: Callable
## The dependencies shared by all components in this state.
var dependencies: Dictionary[StringName, Variant]


## A ready function for StateComponents.[br]Different from the virtual ready function
## all nodes have. Is called when the ComponentState is ready, and after finished and 
## dependencies are set.
func ready():
	pass


## Hook into the enter function of the ComponentState.
func enter():
	pass


## Hook into the resume function of the ComponentState.
func resume():
	pass


## Hook into the exit function of the ComponentState.
func exit():
	pass


## Hook into the seek function of the ComponentState.
func seek(_seconds: float):
	pass


## Hook into the handle_input function of the ComponentState.[br]Different from
## the virtual input functions of nodes.
func handle_input(_event: InputEvent):
	pass


## Hook into the update function of the ComponentState.[br]Different from the 
## virtual update functions of nodes.
func update(_delta: float):
	pass


## Hook into the on_animation_finished function of the ComponentState.
func on_animation_finished(_animation: StringName):
	pass


## Retrieve the dependencies of this component.
func get_dependencies() -> Array[StringName]:
	var empty_array: Array[StringName]
	return empty_array


func _set_active(value: bool):
	active = value
