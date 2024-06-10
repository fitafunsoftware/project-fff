@tool
@icon("action_button.png")
extends Control
class_name ActionButton
## Touch screen button for virtual action events.
##
## Generic button that is meant to be pressed with touch screen inputs. Fires an
## InputEventAction when pressed and released.

## Signal for action button pressed.
signal action_pressed
## Signal for action button released.
signal action_released

## Action to be pressed or released.
@export var action : StringName
## Device to emulate.
@export_range(-1, 7, 1) var device : int = -1

@export_category("Visuals")
## Size of button relative to Viewport.
@export_range(0.0, 1.0, 0.01, "hide_slider") var radius : float = 0.1:
	set(value):
		radius = value
		_set_button_sizes()
## Released color. Make transparent to hide.
@export var released_color : Color = Color("f0ffff70")
## Pressed color. Make transparent to hide.
@export var pressed_color : Color = Color("b2222270")

# Private variables needed for keeping track of events to send.
var _pressed : bool = false
var _index : int = -1
var _radius : float
var _center : Vector2


func _ready():
	_set_button_sizes.call_deferred()
	get_viewport().size_changed.connect(_set_button_sizes)


func _draw():
	_draw_button()


func _gui_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if not _pressed:
			if event.is_pressed():
				_pressed = true
				_index = event.index
				_redraw_and_update_input()
		else:
			if event.is_released() and _index == event.index:
				_pressed = false
				_index = -1
				_redraw_and_update_input()


# Helper functions
func _redraw_and_update_input():
	accept_event()
	queue_redraw()
	_parse_input_event()


func _parse_input_event():
	var input : InputEventAction = InputEventAction.new()
	input.device = device
	input.action = action
	input.pressed = _pressed
	input.event_index = GlobalTouchScreen.get_event_index(action)
	if _pressed:
		Input.action_press(action)
		action_pressed.emit()
	else:
		Input.action_release(action)
		action_released.emit()
	Input.parse_input_event(input)


func _draw_button():
	var button_color : Color = pressed_color if _pressed else released_color
	draw_circle(_center, _radius, button_color)


func _set_button_sizes():
	if not is_inside_tree():
		return
	var viewport_size : Vector2 = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height")) \
			if Engine.is_editor_hint() else get_viewport_rect().size
	_radius = radius * minf(viewport_size.x, viewport_size.y)
	_set_control_size()


func _set_control_size():
	var new_size : Vector2 = Vector2(_radius, _radius) * 2.0
	var ratio : Vector2 = new_size/size
	var new_begin : Vector2 = get_begin() * ratio
	var new_end : Vector2 = get_end() * ratio
	size = new_size
	set_begin(new_begin)
	set_end(new_end)
	_center = size/2.0
