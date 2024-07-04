@tool
@icon("released_transition_state_component.png")
class_name ReleasedTransitionStateComponent
extends StateComponent
## StateComponent that calls for a state change when an action is released.

@export var action : StringName
@export var next_state : StringName


func handle_input(event: InputEvent):
	if event.is_action_released(action):
		finished.call(next_state)
