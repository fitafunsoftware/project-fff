@tool
@icon("fun.png")
extends NodeStateComponent
class_name CallFunctionStateComponent
## NodeStateComponent that calls the function on the node with the args as 
## arguments to the function.

## Function to call.
@export var function : StringName
## Arguments to pass to the function. Set the values yourself.
@export var args : Array
## Is the function call deferred?
@export var deferred : bool = false


## Call the function.
func call_function():
	if deferred:
		node.callv.call_deferred(function, args)
	else:
		node.callv(function, args)
