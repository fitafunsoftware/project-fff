@tool
@icon("res://addons/state_machine/icons/state_components/released_transition_state_component.png")
extends StateComponent
class_name ReleasedTransitionStateComponent

@export var action : String
@export var next_state : String


func handle_input(event: InputEvent):
	if event.is_action_released(action):
		state.finished(next_state)
