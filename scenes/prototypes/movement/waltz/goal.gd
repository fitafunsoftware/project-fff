@tool
extends Node2D

const HEIGHT: int = 100

@export var size: int = 64:
	set(value):
		size = clampi(value, 2, 640)
		_set_size()

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
