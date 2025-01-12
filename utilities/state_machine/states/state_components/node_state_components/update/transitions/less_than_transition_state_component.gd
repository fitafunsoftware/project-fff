@tool
@icon("uid://5014s1nljlfy")
class_name LessThanTransitionStateComponent
extends NodeStateComponent
## Calls a state change if return value is less than value.

## Next state to change to.
@export var next_state : String
## Function to call.
@export var function : String
## Arguments to pass to the function.
@export var args : Array
## Value to compare return value with.
## [br]Only the 0th index is checked to maintain parity with the others.
@export var less_than : Array


func update(_delta: float):
	if node.callv(function, args) < less_than[0]:
		finished.call(next_state)
