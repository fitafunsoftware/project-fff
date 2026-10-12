extends Node2D

signal done()

const START_POSITION: float = 70.0

@export var up_swing: bool = true
var swing_time: float = 0.0
var pause_time: float = 0.0
var coyote_time: float = 0.0

@onready var hitbox := $Color
@onready var flash := $Flash

var _tween: Tween
var _is_running: bool = false
var _can_chain: bool = false


func _ready() -> void:
	_reset()


func start() -> void:
	if _tween:
		_tween.kill()
		_reset()
	
	_tween = create_tween()
	_tween.tween_property(self, "_is_running", true, 0.0)
	_tween.tween_callback(hitbox.show)
	_tween.tween_property(hitbox, "position", Vector2(hitbox.position.x, 0.0), swing_time)\
			.set_trans(Tween.TRANS_EXPO)
	_tween.parallel().tween_property(self, "_can_chain", true, 0.0)\
			.set_delay(swing_time - coyote_time)
	_tween.tween_callback(flash.show)
	_tween.tween_interval(pause_time)
	_tween.tween_callback(done.emit)
	_tween.tween_callback(_reset)


func is_chainable() -> bool:
	return _can_chain


func is_running() -> bool:
	return _is_running


func _reset() -> void:
	_is_running = false
	_can_chain = false
	hitbox.position.y = START_POSITION if up_swing else -START_POSITION
	hitbox.hide()
	flash.hide()
