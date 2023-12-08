@tool
@icon("res://addons/state_machine/icons/state_components/equals_transition.png")
extends NodeStateComponent
class_name EqualsTransitionStateComponent

@export var next_state : String
@export var function : String
@export var args : Array
@export var equals : Array


func update(_delta: float):
	if node.callv(function, args) == equals[0]:
		state.finished(next_state)
