extends Node2D

const MAX_RANGE: int = 320
@export var base_speed: int = 128
@export var sprint_ratio: float = 1.5

var _direction: int = 0
var _is_sprinting: bool = false


func _ready() -> void:
	_register_hitbox()


func _register_hitbox() -> void:
	var hitbox: Area2D = $Hitbox
	hitbox.add_to_group("Player")


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
			(sprint_ratio if _is_sprinting else 1.0)*base_speed
	
	position.x += current_speed * _direction * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, -MAX_RANGE, MAX_RANGE)
	position.x = x_position
