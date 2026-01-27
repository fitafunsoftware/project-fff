extends Sprite2D

var max_range: int = 0
var speed: float = 0.0
var attack_duration: float = 0.0

var enemy_speed: float = 0.0

@onready var _attack_sprite: Sprite2D = $Attack
@onready var _towards: Sprite2D = $Towards
@onready var _away: Sprite2D = $Away
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D

var _direction: int = 0
var _is_attacking: bool = false


func _ready() -> void:
	_attack_sprite.hide()
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
		_attack_sprite.show()
		_towards.hide()
		_away.hide()
		return
	
	if _direction < 0:
		_attack_sprite.hide()
		_towards.show()
		_away.hide()
	elif _direction > 0:
		_attack_sprite.hide()
		_towards.hide()
		_away.show()
	else:
		_attack_sprite.hide()
		_towards.hide()
		_away.hide()


func _move(delta: float) -> void:
	var player_speed: float = speed * _direction if not _is_attacking else 0.0
	var current_speed: float = \
			enemy_speed + player_speed
	
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
