class_name EntityFunctionCall
## Resource for describing functions to call on a spawned entity.
##
## Can't use Callables because they require the Object to call the function on make.

## The function to call.
var function: StringName
## Arguments to pass to the function.
var arguments: Array


@warning_ignore_start("SHADOWED_VARIABLE")
func _init(function: StringName, arguments: Array = Array()):
	self.function = function
	self.arguments = arguments


## Returns an EntityFunctionCall created from a Callable. Use a dummy Object to create the
## Callable. The dummy object is not referenced in the EntityFunctionCall.
static func create_from_callable(callable: Callable) -> EntityFunctionCall:
	var function: StringName = callable.get_method()
	var arguments: Array = callable.get_bound_arguments()
	var entity_function_call := EntityFunctionCall.new(function, arguments)
	
	return entity_function_call


## Returns an Array of EntityFunctionCalls created from an Array of Callables. Helper function for
## creating arguments for EntitySpawnRequest.
static func create_array_from_callables(callables: Array[Callable]) -> Array[EntityFunctionCall]:
	var array: Array[EntityFunctionCall]
	
	for callable: Callable in callables:
		array.append(create_from_callable(callable))
	
	return array
