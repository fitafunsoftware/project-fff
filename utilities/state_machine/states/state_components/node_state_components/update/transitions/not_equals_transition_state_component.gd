@tool
@icon("uid://bxjed68wcrc6p")
class_name NotEqualsTransitionStateComponent
extends NodeStateComponent
## Calls a state change if return value is not equal the value.

## Next state to change to.
@export var next_state : String
## Function to call.
@export var function : String
## Arguments to pass to the function.
@export var args : Array
## Value to compare return value with.
## [br]Only the 0th index is checked to maintain parity with the others.
@export var not_equals : Array


func update(_delta: float):
	if node.callv(function, args) != not_equals[0]:
		finished.call(next_state)
