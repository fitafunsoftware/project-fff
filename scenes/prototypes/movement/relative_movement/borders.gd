extends Node2D

@warning_ignore_start("integer_division")
var width: int = 640:
	set(value):
		width = clampi(value, 0, 640)
		if not [_top, _bottom, _left, _right].has(null):
			_recalculate_borders()

const ASPECT_RATIO: Vector2 = Vector2(16, 9)

@onready var _top: Node2D = $Top
@onready var _bottom: Node2D = $Bottom
@onready var _left: Node2D = $Left
@onready var _right: Node2D = $Right


func _ready() -> void:
	_recalculate_borders()


func _recalculate_borders() -> void:
	var height: int = int(width/ASPECT_RATIO.x * ASPECT_RATIO.y)
	var half_width: int = width/2
	
	_left.position.x = -half_width
	_right.position.x = half_width + (width%2)
	_top.position.y = -height
