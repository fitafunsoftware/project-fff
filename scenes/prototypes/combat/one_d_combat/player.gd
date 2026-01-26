extends Sprite2D

var max_range: int = 0
var speed: float = 0.0
var attack_duration: float = 0.0

var enemy_speed: float = 0.0
var enemy_direction: int = 0

@onready var _towards: Sprite2D = $Towards
@onready var _away: Sprite2D = $Away
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D

var _direction: int = 0
var _is_attacking: bool = false


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
	
	if _is_attacking:
		_towards.hide()
		_away.hide()
		return
	
	if _direction < 0:
		_towards.show()
	elif _direction > 0:
		_away.show()
	else:
		_towards.hide()
		_away.hide()


func _move(delta: float) -> void:
	var player_speed: float = speed * _direction if not _is_attacking else 0.0
	var current_speed: float = \
			enemy_speed * enemy_direction + \
			player_speed
	
	position.x += current_speed * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, 0.0, max_range)
	position.x = x_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("x"):
		_attack()


func _attack() -> void:
	if _is_attacking:
		return
	
	_is_attacking = true
	hitbox.disabled = false
	
	await get_tree().create_timer(attack_duration).timeout
	
	_is_attacking = false
	hitbox.disabled = true
