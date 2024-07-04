class_name PlayerInputHandler
extends InputHandler
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
	var input_direction : Vector2 = \
			Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var angle : float = rad_to_deg(input_direction.angle())
	input_direction.x = int(absf(angle) < 67.5) - int(absf(angle) > 112.5) \
			if not is_zero_approx(input_direction.length_squared()) else 0
	input_direction.y = int(signf(angle)) \
			* int(absf(angle) > 22.5 and absf(angle) < 157.5)
	return input_direction.normalized()
