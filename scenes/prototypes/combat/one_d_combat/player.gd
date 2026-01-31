extends Sprite2D

var max_range: int = 0
var base_speed: float = 0.0
var sprint_speed: float = 0.0
var attack_duration: float = 0.0

var enemy_speed: float = 0.0

@onready var _attack_sprite: Sprite2D = $Attack
@onready var _towards: Node2D = $Towards
@onready var _away: Node2D = $Away
@onready var _base_sprites: Array[Sprite2D] = [$Towards/Base, $Away/Base]
@onready var _sprint_sprites: Array[Sprite2D] = [$Towards/Sprint, $Away/Sprint]
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D

var _direction: int = 0
var _is_sprinting: bool = false
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
	if _direction != int(input):
		_direction = int(input)
		_set_indicators()


func _move(delta: float) -> void:
	var speed_to_use: float = sprint_speed if _is_sprinting else base_speed
	var player_speed: float = speed_to_use * _direction if not _is_attacking \
			else 0.0
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
	
	if event.is_action("sprint"):
		if event.is_echo():
			return
		
		if event.is_pressed():
			_is_sprinting = true
		elif event.is_released():
			_is_sprinting = false
		
		_set_sprinting_indicators()


func _attack() -> void:
	if _is_attacking:
		return
	
	_is_attacking = true
	hitbox.disabled = false
	_set_indicators()
	
	await get_tree().create_timer(attack_duration).timeout
	
	_is_attacking = false
	hitbox.disabled = true
	_set_indicators()


func _set_indicators() -> void:
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


func _set_sprinting_indicators():
	if _is_sprinting:
		for sprite in _base_sprites:
			sprite.hide()
		for sprite in _sprint_sprites:
			sprite.show()
	else:
		for sprite in _base_sprites:
			sprite.show()
		for sprite in _sprint_sprites:
			sprite.hide()
