@icon("uid://cjacmexstsri8")
class_name LookDirection
extends Node
## Entity component to handle look direction of entity.

## Possible look directions.
enum Direction {LEFT = -1, RIGHT = 1}
 
## Signal for look direction changing.[br]Does not emit if look direction does
## not actually switch from one direction to the other.
signal look_direction_changed(look_direction: int)

## Look direction variable itself.
var look_direction: int = Direction.RIGHT:
	set(value):
		if Direction.values().has(value):
			if value == look_direction:
				return
			look_direction = value
			look_direction_changed.emit(look_direction)


## Set the look direction using input direction as argument.
func set_look_from_input(input_direction: Vector2):
	look_direction = int(sign(input_direction.x))
