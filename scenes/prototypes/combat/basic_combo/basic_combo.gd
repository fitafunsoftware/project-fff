extends Node2D

const CD_COLOR := Color(1.0, 0.0, 0.0, 1.0)
const LOCKED_COLOR := Color(0.5, 0.0, 0.5, 1.0)

@export var cooldown_time: float = 0.5
@export var swings: Array[_SwingStats]

@onready var _player := $Stage/Player

@onready var _base_color: Color = $Stage/Player.color

@onready var _up_swing := $Stage/Attacks/UpSwing
@onready var _down_swing := $Stage/Attacks/DownSwing
@onready var _current_swing := $Stage/Attacks/UpSwing

var _is_attacking: bool = false
var _current_swing_index: int = 0
var _locked: bool = false
var _chain_attack: bool = false
var _on_cooldown: bool = false

func _ready() -> void:
	_reset.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("a") or event.is_action_pressed("b"):
		if swings.size() == 0:
			return
		if _on_cooldown:
			return
		
		if _is_attacking:
			if _chain_attack:
				return
			if not _locked and _current_swing.is_chainable():
				_chain_attack = true
			else:
				_player.color = LOCKED_COLOR
				_locked = true
		else:
			_current_swing.start()
			_is_attacking = true


func _set_current_swing() -> void:
	if swings.is_empty():
		return
	
	var swing := swings[_current_swing_index]
	_current_swing = _up_swing if swing.up_swing else _down_swing
	_current_swing.swing_time = swing.swing_time
	_current_swing.pause_time = swing.pause_time
	_current_swing.coyote_time = swing.coyote_time


func _reset() -> void:
	_current_swing_index = 0
	_set_current_swing()
	_is_attacking = false
	_on_cooldown = false
	_locked = false
	_chain_attack = false


func _cooldown() -> void:
	var locked := _locked or not _current_swing_index == swings.size() - 1
	_reset()
	_on_cooldown = true
	_player.color = LOCKED_COLOR if locked else CD_COLOR
	create_tween().tween_property(_player, "color", _base_color, 0.0)\
			.set_delay(cooldown_time)
	create_tween().tween_property(self, "_on_cooldown", false, 0.0)\
			.set_delay(cooldown_time)


func _on_swing_done() -> void:
	if _chain_attack and _current_swing_index < swings.size() - 1:
		_current_swing_index += 1
		_set_current_swing()
		_current_swing.start()
		_chain_attack = false
		return
	
	_cooldown()
