@tool
extends Node2D

signal player_entered()
signal player_exited()

const HEIGHT: int = 100
const MAX_RANGE: int = 320

@export_category("Player Attributes")
@export var size: int = 80:
	set(value):
		size = value
		_set_size()
@export var base_speed: int = 100
@export var sprint_ratio: float = 1.5

@export_category("Movement Logic")
@export var max_rest_duration: float = 2.0
@export var sprint_probability: float = 0.2

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


func start_move() -> void:
	_next_move()


func _next_move() -> void:
	var next_position: int = _get_new_position()
	var goal_position: int = int(position.x)
	var distance: int = abs(next_position - goal_position)
	var duration: float = float(distance) / base_speed
	
	direction = signi(next_position - goal_position)
	is_sprinting = randf() < sprint_probability
	await get_tree().create_timer(duration).timeout
	
	var rest_duration: float = \
			clampf(randfn(max_rest_duration*3.0/4.0, 1.0), 0.0, max_rest_duration)
	direction = 0
	is_sprinting = false
	await get_tree().create_timer(rest_duration).timeout
	
	_next_move()


func _get_new_position() -> int:
	return (randi() % (MAX_RANGE*2)) - MAX_RANGE


func _move(delta: float) -> void:
	var current_speed: float = \
			(sprint_ratio if is_sprinting else 1.0)*base_speed
	
	position.x += current_speed * direction * delta


func _clamp_position() -> void:
	var x_position: float = position.x
	x_position = clampf(x_position, -MAX_RANGE, MAX_RANGE)
	position.x = x_position


func _on_player_enter(area: Area2D) -> void:
	if Engine.is_editor_hint():
		return
	if area.is_in_group("Player"):
		player_entered.emit()


func _on_player_exit(area: Area2D) -> void:
	if Engine.is_editor_hint():
		return
	if area.is_in_group("Player"):
		player_exited.emit()
