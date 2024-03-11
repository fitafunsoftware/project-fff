extends InputHandler
class_name PlayerInputHandler
## The player's InputHandler.
##
## Basic InputHandler for player entities.

## Signal for events emitted by the InputHandler.
signal input_event(event : InputEvent)


func _unhandled_input(event):
	if event.is_action_pressed("a"):
		var jump := InputEventAction.new()
		jump.action = "jump"
		jump.pressed = true
		jump.strength = 1.0
		input_event.emit(jump)


func get_input_direction() -> Vector2:
	return Input.get_vector("leftxn", "leftxp", "leftyn", "leftyp")
