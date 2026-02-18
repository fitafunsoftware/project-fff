@tool
extends Node2D

const MAX_RANGE: int = 320
const MAX_DURATION: float = 1.0
const STOP_PROBABILITY: float = 0.1
const SPRINT_PROBABILITY: float = 0.2
const CONT_PROBABILITY: float = 0.4

@export var time_to_start: float = 1.0

@export_category("Goal Properties")
@export var size: int = 80:
	set(value):
		size = clampi(value, 2, 640)
		if _goal:
			_goal.size = size
@export var base_speed: int = 128
@export var sprint_ratio: float = 1.5

@onready var _goal: Node2D = $Goal
@onready var _scoreboard: Control = $Scoreboard


func _ready() -> void:
	if _goal:
		_goal.size = size
	
	if Engine.is_editor_hint():
		return
	
	if _goal:
		_goal.base_speed = base_speed
		_goal.sprint_ratio = sprint_ratio
	
	_start()


func _start() -> void:
	await get_tree().create_timer(time_to_start).timeout
	_next_move()


func _next_move() -> void:
	var duration: float = clampf(randfn(MAX_DURATION*3.0/4.0, 1.0), 0.0, MAX_DURATION)
	if randf() > CONT_PROBABILITY:
		_set_new_movement()
	
	await get_tree().create_timer(duration).timeout
	_next_move()


func _set_new_movement() -> void:
	var move: bool = randf() > STOP_PROBABILITY
	var direction: int = _get_weighted_direction() if move else 0
	var sprint: bool = randf() < SPRINT_PROBABILITY if move else false
	
	if _goal:
		_goal.direction = direction
		_goal.is_sprinting = sprint


func _get_weighted_direction() -> int:
	if not _goal:
		return 0
	
	var x_pos: float = _goal.position.x
	var x_sign: int = signi(x_pos)
	if x_sign == 0:
		x_sign = 1
	var cutoff: float = 0.2 + (absf(x_pos)/MAX_RANGE*0.5)
	
	if randf() > cutoff:
		return x_sign
	else:
		return -x_sign


func _player_entered() -> void:
	_scoreboard.is_in_range = true


func _player_exited() -> void:
	_scoreboard.is_in_range = false
