@tool
@icon("res://addons/state_machine/icons/state_components/pressed_transition_state_component.png")
extends StateComponent
class_name PressedTransitionStateComponent

@export var action : String
@export var next_state : String


func handle_input(event: InputEvent):
	if event.is_action_pressed(action):
		state.finished(next_state)
