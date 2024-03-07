@tool
@icon("transition_component.png")
extends StateComponent
class_name TransitionStateComponent
## StateComponent that calls for a state change in update.

@export var next_state : StringName


func update(_delta: float):
	finished.call(next_state)
