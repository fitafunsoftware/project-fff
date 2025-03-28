@tool
@icon("uid://cx55wakhwkkw2")
class_name LookDirectionEnterStateComponent
extends EntityStateComponent
## State component for setting look direction on enter.

## Key for LookDirection node.
@export var look_key: StringName = &"look_key"
## Key for InputHandler node.
@export var input_key: StringName = &"input_key"

var look_direction: LookDirection:
	get:
		return dependencies.get(look_key)
var input_handler: InputHandler:
	get:
		return dependencies.get(input_key)


func enter():
	look_direction.set_look_from_input(input_handler.get_input_direction())


func get_dependencies() -> Array[StringName]:
	var array: Array[StringName] = super()
	array.append_array([look_key, input_key])
	return array
