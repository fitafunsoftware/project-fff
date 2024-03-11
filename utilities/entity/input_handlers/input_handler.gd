@icon("input_handler.png")
extends Node
class_name InputHandler
## Base class for InputHandlers.
##
## Meant to act as an interface.


## Input direction for movement.
func get_input_direction() -> Vector2:
	return Vector2()
