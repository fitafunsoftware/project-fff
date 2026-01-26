extends Sprite2D

var speed: float = 0.0
var max_range: int = 0

var enemy_speed: float = 0.0
var enemy_direction: int = 0

@onready var _towards: Sprite2D = $Towards
@onready var _away: Sprite2D = $Away

var _direction: int = 0


func _ready() -> void:
	_towards.hide()
	_away.hide()


func _physics_process(delta: float) -> void:
	_set_direction()
	_move(delta)
	_clamp_position()


func _set_direction() -> void:
	var input: float = round(
		Input.get_axis(&"leftxn", &"leftxp") + Input.get_axis(&"dpleft", &"dpright")
		)
	_direction = int(input)
	
	if _direction < 0:
		_towards.show()
	elif _direction > 0:
		_away.show()
	else:
		_towards.hide()
		_away.hide()


func _move(delta: float) -> void:
	var current_speed: float = \
			enemy_speed * enemy_direction + \
			speed * _direction
	
	position.x += current_speed * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, 0.0, max_range)
	position.x = x_position
