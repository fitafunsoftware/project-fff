@tool
@icon("res://addons/state_machine/icons/state_components/not_equals_transition.png")
extends NodeStateComponent
class_name NotEqualsTransitionStateComponent

@export var next_state : String
@export var function : String
@export var args : Array
@export var not_equals : Array


func update(_delta: float):
	if node.callv(function, args) != not_equals[0]:
		state.finished(next_state)
