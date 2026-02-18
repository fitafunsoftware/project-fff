@tool
extends Node2D

signal player_entered()
signal player_exited()

const HEIGHT: int = 100
const MAX_RANGE: int = 320

var size: int = 80:
	set(value):
		size = value
		_set_size()

var base_speed: int = 128
var sprint_ratio: float = 1.5
var direction: int = 0
var is_sprinting: bool = false

@onready var _sprite: ColorRect = $Sprite
@onready var _hitbox_shape: CollisionShape2D = $Hitbox/Shape


func _ready() -> void:
	_set_size()


func _set_size() -> void:
	if not _sprite or not _hitbox_shape:
		return
	
	_sprite.size = Vector2(size, HEIGHT)
	_sprite.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
	
	_hitbox_shape.position.y = -HEIGHT/2.0
	var shape: RectangleShape2D = _hitbox_shape.shape
	shape.size = Vector2(size, HEIGHT)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	_move(delta)
	_clamp_position()


func _move(delta: float) -> void:
	var current_speed: float = \
			(sprint_ratio if is_sprinting else 1.0)*base_speed
	
	position.x += current_speed * direction * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, -MAX_RANGE, MAX_RANGE)
	position.x = x_position


func _on_player_enter(_area: Area2D) -> void:
	player_entered.emit()


func _on_player_exit(_area: Area2D) -> void:
	player_exited.emit()
