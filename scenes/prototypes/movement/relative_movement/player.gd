extends Node2D

var size: int = 20:
	set(value):
		size = clampi(value, 2, 128)
		_set_size()

var max_range: int = 320
var base_speed: float = 4.0
var sprint_speed: float = 8.0

@onready var _sprite: ColorRect = $Sprite

var _direction: int = 0
var _is_sprinting: bool = false


func _ready() -> void:
	_set_size()


func _set_size() -> void:
	if not _sprite:
		return
	
	_sprite.size = Vector2(size, size)
	_sprite.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("sprint"):
		if event.is_echo():
			return
		
		if event.is_pressed():
			_is_sprinting = true
		elif event.is_released():
			_is_sprinting = false


func _physics_process(delta: float) -> void:
	_set_direction()
	_move(delta)
	_clamp_position()


func _set_direction() -> void:
	var input: float = round(
		Input.get_axis(&"leftxn", &"leftxp") + Input.get_axis(&"dpleft", &"dpright")
		)
	if _direction != int(input):
		_direction = int(input)


func _move(delta: float) -> void:
	var current_speed: float = \
			(sprint_speed if _is_sprinting else base_speed)*size
	
	position.x += current_speed * _direction * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, -max_range, max_range)
	position.x = x_position
