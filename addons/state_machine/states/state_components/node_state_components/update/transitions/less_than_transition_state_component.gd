@tool
@icon("res://addons/state_machine/icons/state_components/less_than_transition.png")
extends NodeStateComponent
class_name LessThanTransitionStateComponent

@export var next_state : String
@export var function : String
@export var args : Array
@export var less_than : Array


func update(_delta: float):
	if node.callv(function, args) < less_than[0]:
		state.finished(next_state)
