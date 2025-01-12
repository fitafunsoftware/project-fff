@tool
@icon("uid://bco5hpfodn8n6")
class_name EqualsTransitionStateComponent
extends NodeStateComponent
## Call a state change if return value equals a value.

## Next state to change to.
@export var next_state : String
## Function to call.
@export var function : String
## Arguments to pass to the function.
@export var args : Array
## Value to compare return value with.
## [br]Only the 0th index is checked to maintain parity with the others.
@export var equals : Array


func update(_delta: float):
	if node.callv(function, args) == equals[0]:
		finished.call(next_state)
