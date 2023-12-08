@tool
@icon("res://addons/state_machine/icons/state_components/greater_than_transition.png")
extends NodeStateComponent
class_name GreaterThanTransitionStateComponent

@export var next_state : String
@export var function : String
@export var args : Array
@export var greater_than : Array


func update(_delta: float):
	if node.callv(function, args) > greater_than[0]:
		state.finished(next_state)
