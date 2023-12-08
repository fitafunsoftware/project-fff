@tool
@icon("res://addons/state_machine/icons/state_components/transition_component.png")
extends StateComponent
class_name TransitionStateComponent

@export var next_state : String


func update(_delta: float):
	state.finished(next_state)
