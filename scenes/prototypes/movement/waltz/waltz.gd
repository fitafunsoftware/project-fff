@tool
extends Node2D

const MAX_RANGE: int = 320
const MAX_DURATION: float = 2.0
const SPRINT_PROBABILITY: float = 0.2

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
	var next_position: int = _get_new_position()
	var goal_position: int = int(_goal.position.x)
	var distance: int = abs(next_position - goal_position)
	var direction: int = signi(next_position - goal_position)
	var duration: float = float(distance) / base_speed
	var sprint: bool = randf() < SPRINT_PROBABILITY
	
	_goal.direction = direction
	_goal.is_sprinting = sprint
	await get_tree().create_timer(duration).timeout
	
	var stop_duration: float = clampf(randfn(MAX_DURATION*3.0/4.0, 1.0), 0.0, MAX_DURATION)
	_goal.direction = 0
	_goal.is_sprinting = false
	await get_tree().create_timer(stop_duration).timeout
	
	_next_move()


func _get_new_position() -> int:
	return (randi() % (MAX_RANGE*2)) - MAX_RANGE


func _player_entered() -> void:
	_scoreboard.is_in_range = true


func _player_exited() -> void:
	_scoreboard.is_in_range = false
