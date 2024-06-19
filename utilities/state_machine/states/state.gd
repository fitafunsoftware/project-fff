@icon("state.png")
extends Node
class_name State
## Base class for StateMachine states.
##
## An interface meant to be extended for use of making states for the StateMachine.

## Signal to request for a state change.[br]Instead of emitting this signal, call
## the finished function.
signal change_state(requestor: StringName, next_state: StringName)

## The name of this state.[br]Note: The StringName "previous" is not allowed as 
## state name.
@export var state_name : StringName = &"state_name":
	set(value):
		if value == &"previous":
			state_name = &"previous_not_allowed_as_name"
		else:
			state_name = value
## Is the state a push down state.[br]A push down state adds itself to the top
## of the stack. A non-push down state ignores and clears the state stack.
@export var push_down : bool = false
## Is the state an overwrite state.[br]An overwrite state only works in the
## context of push down states. Instead of just adding itself to the top of the
## stack, it also pops the top of the stack, thus overwriting the previous top
## state.
@export var overwrite : bool = false


## Hook for when the StateMachine enters this state.
func enter():
	pass


## Hook for when the StateMachine resumes to this state, i.e. when "previous"
## causes the StateMachine to go back to this state.
func resume():
	pass


## Hook for when the StateMachine exits this state.
func exit():
	pass


## Hook for seeking to a specific time in this state.
func seek(_seconds: float):
	pass


## Hook for inputs received by the StateMachine.[br]Note that this is different
## from the virtual input functions nodes have.
func handle_input(_event: InputEvent):
	pass


## Hook for when the StateMachine runs updates.[br]Note that this is different
## from the virtual update functions that nodes have.
func update(_delta: float):
	pass


## Hook for when the StateMachine is informed of an animation finishing.[br]Note:
## Will look into generalizing this function for any signal hooked up to the
## StateMachine.
func on_animation_finished(_animation: StringName):
	pass


## Function to call when this state is finished and wants to change the StateMachine's
## state.
func finished(next_state: StringName):
	change_state.emit(state_name, next_state)
