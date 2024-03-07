@tool
@icon("pressed_transition_state_component.png")
extends StateComponent
class_name PressedTransitionStateComponent
## StateComponent that calls for a state change when an action is pressed.

@export var action : StringName
@export var next_state : StringName


func handle_input(event: InputEvent):
	if event.is_action_pressed(action):
		finished.call(next_state)
