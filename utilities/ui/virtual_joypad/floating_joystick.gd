@tool
@icon("floating_joystick.png")
extends VirtualJoystick
class_name FloatingJoystick
## Floating Joystick for touch inputs.
##
## Node for adding a floating joystick to the scene. A floating joystick is a joystick
## that has no fixed position in its area. Pressing anywhere in the area makes that
## position the center of the joystick. You then need to drag across the area to move
## the joystick in that direction.

## Signal for when the center of the floating joystick changes.
signal center_changed(center: Vector2)


func _gui_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if not _pressed and event.is_pressed():
			_center = event.position
			center_changed.emit(_center)
	
	super(event)


func _draw_base():
	if _pressed:
		super()


func _draw_stick():
	if _pressed:
		super()
