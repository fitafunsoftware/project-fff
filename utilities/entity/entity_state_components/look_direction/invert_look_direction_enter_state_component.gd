@tool
@icon("invert_look_direction_enter.png")
extends EntityStateComponent
class_name InvertLookDirectionEnterStateComponent
## State component for inverting look direction on enter.

## Key for LookDirection node.
@export var look_key : StringName = "look_key"

var look_direction : LookDirection :
	get:
		return dependencies.get(look_key)


func enter():
	look_direction.look_direction = -look_direction.look_direction


func get_dependencies() -> Array[StringName]:
	var array : Array[StringName] = super()
	array.append(look_key)
	return array
