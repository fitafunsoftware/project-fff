@tool
class_name VirtualJoystick
extends Control
## Base class for touch screen joysticks.
##
## Base class for touch screen joysticks. As such, don't use this node. Instead,
## use either the StaticJoystick or FloatingJoystick nodes.

## Signal for when the joystick vector changes value.
signal input_vector_changed(input_vector: Vector2)

## Device to emulate.
@export_range(-1, 7, 1) var device: int = -1
## Should the joystick snap to cardinal positions.
@export var _snapped: bool = false
## Threshold before joystick snaps to a cardinal position.
@export_range(0.0, 1.0) var snapped_dead_zone: float = 0.3

@export_category("Actions")
## Negative X Action.
@export var negative_x: StringName
## Positive X Action.
@export var positive_x: StringName
## Negative Y Action.[br]Note: Negative Y for joysticks are usually the up direction.
@export var negative_y: StringName
## Positive Y Action.[br]Note: Positive Y for joysticks are usually the down direction.
@export var positive_y: StringName

@export_category("Visuals")
## Active area of the joystick relative to viewport size.
@export var area: Vector2 = Vector2(0.5, 0.5):
	set(value):
		value = clamp(value, Vector2.ZERO, Vector2.ONE)
		area = value
		_set_joystick_sizes()
		queue_redraw()
## Color of the active area. Make transparent to hide.
@export var area_color: Color = Color("ffffff0f"):
	set(value):
		area_color = value
		queue_redraw()

## Radius of the base of the joystick relative to the minimum length of the area.
@export_range(0.1, 1.0, 0.01, "hide_slider") var base_radius: float = 0.5:
	set(value):
		base_radius = value
		_set_joystick_sizes()
		queue_redraw()
## Color of the joystick base. Make transparent to hide.
@export var base_color: Color = Color(Color.GHOST_WHITE, 0.1):
	set(value):
		base_color = value
		queue_redraw()

## Radius of the stick of the joystick relative to the base radius.
@export_range(0.1, 1.0, 0.01, "hide_slider") var stick_radius: float = 0.3:
	set(value):
		stick_radius = value
		_set_joystick_sizes()
		queue_redraw()
## Color of the joystick stick. Make transparent to hide.
@export var stick_color: Color = Color.BEIGE:
	set(value):
		stick_color = value
		queue_redraw()

# Helper values.
@onready var _center: Vector2 = area/2.0
var _input_vector := Vector2.ZERO
var _pressed: bool = false
var _index: int = -1
var _position: Vector2

var _base_radius: float
var _stick_radius: float
var _area: Vector2


func _ready():
	_set_joystick_sizes.call_deferred()
	get_viewport().size_changed.connect(_set_joystick_sizes)


func _draw():
	_draw_area()
	_draw_base()
	_draw_stick()


func _gui_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if _pressed:
			if event.index == _index:
				if event.is_released():
					_pressed = false
					_index = -1
				_redraw_and_update_input()
		else:
			if event.is_pressed():
				_pressed = true
				_index = event.index
				_position = event.position
				_redraw_and_update_input()
	
	if event is InputEventScreenDrag:
		if _pressed and event.index == _index:
			_position = event.position
			_redraw_and_update_input()


## Returns the local center position of the joystick.
func get_center() -> Vector2:
	return _center


## Returns the Vector2 that describes the joystick's position.[br]
## Non-snapped joysticks return normalized vectors. Snapped joysticks return
## non-normalized vectors.
func get_input_vector() -> Vector2:
	return _input_vector


# Helper functions.
func _redraw_and_update_input():
	accept_event()
	queue_redraw()
	_input_vector = _get_input_vector()
	_parse_input_events()
	input_vector_changed.emit(_input_vector)


func _get_input_vector() -> Vector2:
	var input_vector := Vector2.ZERO
	var distance: float = _center.distance_to(_position)
	
	if not _pressed:
		return input_vector
	
	if not _snapped:
		var direction: Vector2 = _center.direction_to(_position)
		distance = clampf(distance, 0.0, _base_radius)
		var strength: float = distance/_base_radius
		input_vector = strength * direction
	else:
		var angle: float = rad_to_deg(_center.angle_to_point(_position))
		var strength := int(distance > snapped_dead_zone*_base_radius)
		var x_value := int(absf(angle) < 67.5) - int(absf(angle) > 112.5)
		var y_value := int(signf(angle)) \
				* int(absf(angle) > 22.5 and absf(angle) < 157.5)
		input_vector = strength * Vector2(x_value, y_value)
	
	return input_vector


# To make sure the event is both recorded in Input and passed through _inputs, 
# we need to use both the Input.action_* function and Input.parse_input_event function.
func _parse_input_events():
	var nx_strength: float = clampf(-1*_input_vector.x, 0.0, 1.0)
	var px_strength: float = clampf(_input_vector.x, 0.0, 1.0)
	var ny_strength: float = clampf(-1*_input_vector.y, 0.0, 1.0)
	var py_strength: float = clampf(_input_vector.y, 0.0, 1.0)
	var strengths: Array = [nx_strength, px_strength, ny_strength, py_strength]
	var actions: Array = [negative_x, positive_x, negative_y, positive_y]
	
	for index: int in actions.size():
		var action: StringName = actions[index]
		var strength: float = strengths[index]
		var input_event := InputEventAction.new()
		input_event.device = device
		input_event.action = action
		input_event.strength = strength
		input_event.event_index = GlobalTouchScreen.get_event_index(action)
		if _pressed:
			if not is_zero_approx(strength) \
					and strength > InputMap.action_get_deadzone(action):
				input_event.pressed = true
				var was_pressed: bool = Input.is_action_pressed(action)
				Input.action_press(actions[index], strength)
				if was_pressed:
					continue
			else:
				if Input.is_action_pressed(action):
					input_event.pressed = false
					Input.action_release(action)
				else:
					continue
		else:
			if Input.is_action_pressed(action):
				input_event.pressed = false
				Input.action_release(actions[index])
			else:
				continue
		Input.parse_input_event(input_event)


func _draw_area():
	draw_rect(Rect2(Vector2.ZERO, _area), area_color)


func _draw_base():
	draw_circle(_center, _base_radius, base_color)


func _draw_stick():
	var stick_position: Vector2 = _center
	
	if _pressed:
		var input_vector = _input_vector
		if input_vector.length() > 1.0:
			input_vector = input_vector.normalized()
		
		stick_position += input_vector * _base_radius
	
	draw_circle(stick_position, _stick_radius, stick_color)


func _set_joystick_sizes():
	if not is_inside_tree():
		return
	var viewport_size: Vector2 = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height")) \
			if Engine.is_editor_hint() else get_viewport_rect().size
	_area = viewport_size*area
	_base_radius = minf(_area.x, _area.y) * base_radius * 0.5
	_stick_radius = _base_radius * stick_radius
	_set_control_size()


func _set_control_size():
	var ratio: Vector2 = _area/size
	var new_begin: Vector2 = get_begin() * ratio
	var new_end: Vector2 = get_end() * ratio
	size = _area
	set_begin(new_begin)
	set_end(new_end)
	_center = size/2.0
