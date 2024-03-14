@tool
@icon("funv.png")
extends NodeStateComponent
class_name CallFunctionVariableStateComponent
## NodeStateComponent that calls the function on the node with dependencies as 
## the arguments to the function.

## Function to call.
@export var function : StringName
## Keys for the dependencies to pass as arguments.
@export var variables : Array[StringName]
## Defer the function call?
@export var deferred : bool = false


## Call the function.
func call_function():
	var args : Array = Array()
	for variable in variables:
		args.append(dependencies[variable])
	
	if deferred:
		node.callv.call_deferred(function, args)
	else:
		node.callv(function, args)


func get_dependencies() -> Array[StringName]:
	var array : Array[StringName] = super()
	array.append_array(variables)
	return array