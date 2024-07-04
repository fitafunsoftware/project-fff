@tool
@icon("transition_component.png")
class_name TransitionStateComponent
extends StateComponent
## StateComponent that calls for a state change in update.

@export var next_state : StringName


func update(_delta: float):
	finished.call(next_state)
